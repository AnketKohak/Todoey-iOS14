//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Anket Kohak on 16/08/24.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit
class CategoryViewController: UITableViewController {
    let realm = try! Realm()
    var categories : Results<Category>?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80.0
        loadCategories()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! SwipeTableViewCell
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Category added yet"
        cell.delegate = self
        return cell
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

extension CategoryViewController:SwipeTableViewCellDelegate{
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
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
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "deleteIcon")
        
        return [deleteAction]
    }
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
}

