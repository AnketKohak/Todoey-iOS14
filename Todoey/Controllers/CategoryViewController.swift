//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Anket Kohak on 16/08/24.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework
class CategoryViewController: SwipeTableViewController {
    let realm = try! Realm()
    var categories : Results<Category>?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        loadCategories()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let navBar = navigationController?.navigationBar else{
            fatalError("navigation controller does not exist")
        }
        navigationController?.navigationBar.backgroundColor = UIColor(hexString: "007AFF")
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectCategory = categories?[indexPath.row]
        }
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let category = categories?[indexPath.row]{
            cell.textLabel?.text = category.name
            guard let categoryColor = UIColor(hexString: category.colour) else{fatalError()}
            cell.backgroundColor = categoryColor
            
            cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)

        }
       
        return cell
    }
    override func upadateModel(at indexPath: IndexPath) {
        
        if let categorycellDelecting = self.categories?[indexPath.row] {
            do{
                try self.realm.write{
                    self.realm.delete(categorycellDelecting)

                }
            }catch{
                print("error in deleting row")
            }


        }
    }
    

    func save(category : Category){
        do{
            try realm.write {
                realm.add(category)
            }
        }catch{
            print("error saving category\(error)")
        }
        tableView.reloadData()
    }
    func loadCategories(){
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        var textfield = UITextField()
        let action = UIAlertAction(title: "Add", style: .default) { UIAlertAction in
            let newCategory = Category()
            newCategory.name = textfield.text!
            newCategory.colour = UIColor.randomFlat().hexValue()
            //
            self.save(category: newCategory)
            
        }
        alert.addAction(action)
        alert.addTextField { field in
            textfield = field
            textfield.placeholder = "Add a New category"
            
            
        }
        present(alert, animated: true, completion: nil)
    }
    
}

