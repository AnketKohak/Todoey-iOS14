//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//
//MARK: - starting
import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController{
    @IBOutlet weak var searchBar: UISearchBar!
    
    var todoItem :Results<Item>?
    let realm = try! Realm()

    var selectCategory : Category?{
        didSet{
            loadItem()
        }
    }
    //MARK: - onload
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80.0
        
    }
    //MARK: - viewWillApeear
    override func viewWillAppear(_ animated: Bool) {
        if let colourHex = selectCategory?.colour{
            title = selectCategory!.name
            
            guard let navBar = navigationController?.navigationBar else{
                fatalError("navigation controller does not exist")
            }
            if let navBarColour = UIColor(hexString: colourHex) {
                navBar.backgroundColor = navBarColour
                
                navBar.tintColor = ContrastColorOf(navBarColour, returnFlat: true)
                
                navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ContrastColorOf(navBarColour, returnFlat: true)]
                
                searchBar.barTintColor = navBarColour
            }
        }
    }
    //MARK: - Number of Selection
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItem?.count ?? 1
    }
    
    //MARK: - cellForRowAt
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = todoItem?[indexPath.row] {
            cell.textLabel?.text = item.title
            if let color = UIColor(hexString: selectCategory!.colour)?.darken(byPercentage: CGFloat(indexPath.row)/CGFloat(todoItem!.count)){
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
            cell.accessoryType = item.done ? .checkmark : .none
            
        }else{
            cell.textLabel?.text = "No item added yet "
            
        }
        return cell
    }
    //MARK: - updateModel
    override func upadateModel(at indexPath: IndexPath) {
       if let item = todoItem?[indexPath.row] {
            do{
                try realm.write{
                    realm.delete(item)
                }
            }catch{
                print("error in deleting item")
            }
        }
    }
    
    //MARK: - didSelectRowAt
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItem?[indexPath.row] {
            do{
              try realm.write{
                  item.done = !item.done
                }
            }catch{
                print("Error Saving done status,\(error)")
            }
        }
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - addButtonPressed
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Todey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { UIAlertAction in
            if let currentCategory = self.selectCategory{
                do{
                    try self.realm.write{
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                }catch{
                    print("Error saving new item,\(error)")
                }
            }
            self.tableView.reloadData()
        }
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new Item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    
    //MARK: - loadItem
    func loadItem(){
        todoItem = selectCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
}
//MARK: - searchbar

extension TodoListViewController : UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
      
        todoItem = todoItem?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItem()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }else{

        }
    }
}
