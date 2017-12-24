//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Thiago Andrade on 12/23/17.
//  Copyright © 2017 Andrade. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    // Initialize
    let realm = try! Realm()
    
    var categories: Results<Category>?    //Collestion type of Category Objects
    
  
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategory()


    }

    //MARK: - Table View DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories?.count ?? 1  // Nil Coalescing Operator
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No category add yet"
        
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
