//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Thiago Andrade on 12/23/17.
//  Copyright © 2017 Andrade. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit
import ChameleonFramework

class CategoryViewController: UITableViewController {
    
    // Initialize
    let realm = try! Realm()
    
    var categories: Results<Category>?    //Collestion type of Category Objects
    
  
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategory()
        
        tableView.separatorStyle = .none
        
        tableView.rowHeight = 80
        
        


    }

    //MARK: - Table View DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories?.count ?? 1  // Nil Coalescing Operator
    }
    
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SwipeTableViewCell
//        cell.delegate = self
//        return cell
//    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! SwipeTableViewCell
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No category add yet"
        
        cell.delegate = self
        
        cell.backgroundColor = UIColor(hexString: categories?[indexPath.row].colour ?? "1D9BF6")
        
        
        
        return cell
    }
    
    //MARK: - Table View Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    
    //MARK: - Data Manipulation Methods
    
    func save(category: Category) {
        
        do {
            try realm.write {
                realm.add(category)
            }
        } catch  {
            print("Error saving Category: \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    func loadCategory() {
        
       categories = realm.objects(Category.self)
    
       tableView.reloadData()
        
    }
    //MARK: - Add New categories
    
    @IBAction func addButtomPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new category", message: "" , preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.colour = UIColor.randomFlat.hexValue()
           
            
            self.save(category: newCategory)
            
            
        }
    
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
        
    }
    
}

//MARK: - Swipe Delegate Methods

extension CategoryViewController: SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
    guard orientation == .right else { return nil }
    
    let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
    // handle action by updating model with deletion
        
        
        if let categoriesForDeletion = self.categories?[indexPath.row] {
            
            do {
                try self.realm.write {
                 self.realm.delete(categoriesForDeletion)
                }
            } catch {
                print("Erros deleting category: \(error)")
            }
            
//            tableView.reloadData()
        }
    
    }
    
    // customize the action appearance
    deleteAction.image = UIImage(named: "delete-icon")
    
    return [deleteAction]
        
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        options.expansionStyle = .destructive
        return options
    }
    
    
}
