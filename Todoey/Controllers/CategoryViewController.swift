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
//MARK: - starting
class CategoryViewController: SwipeTableViewController {
    let realm = try! Realm()
    var categories : Results<Category>?
    //MARK: - load
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        guard let navBar = navigationController?.navigationBar else{
            fatalError("navigation controller does not exist")
        }
        navigationController?.navigationBar.backgroundColor = UIColor(hexString: "007AFF")
    }
    //MARK: - didSelectRowAt
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    //MARK: - prapare
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectCategory = categories?[indexPath.row]
        }
    }
    //MARK: - NumberOfRowInSection
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    //MARK: - cellForRowAt
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let category = categories?[indexPath.row]{
            cell.textLabel?.text = category.name
            guard let categoryColor = UIColor(hexString: category.colour) else{ fatalError()}
            cell.backgroundColor = categoryColor
            cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
        }
        return cell
    }
    //MARK: - updateModel
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
    //MARK: - save
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
    //MARK: - loadCategories
    func loadCategories(){
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    //MARK: - addbuttonPressed
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        var textfield = UITextField()
        let action = UIAlertAction(title: "Add", style: .default) { UIAlertAction in
            let newCategory = Category()
            newCategory.name = textfield.text!
            newCategory.colour = UIColor.randomFlat().hexValue()
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

