//
//  ViewController.swift
//  Todoey
//
//  Created by Thiago Andrade on 12/22/17.
//  Copyright © 2017 Andrade. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         print(dataFilePath)
        
         loadItem()
        
    }

    
    //MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        // Ternary operator ==>
        // Value = condition ? ValueIfTrue : ValueIfFalse
        cell.accessoryType = item.done == true ? .checkmark : .none
        // if item.done == true {
        // cell.accessoryType = .checkmark
        //  } else {
        // cell.accessoryType = .none
        // }
        return cell
    }
    
    //MARK - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        context.delete(itemArray[indexPath.row])
        itemArray.remove(at: indexPath.row)
        
        //itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add New Items
    
    
    @IBAction func addButtomPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoye Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once  the user press Add Item buttom on our UIAlert
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            self.itemArray.append(newItem)
            
            self.saveItems()
            
        }
        
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
         
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
        
    }
    
    //MARK - Model Manipulations Methods
    
    func saveItems() {
        
        do {
          try context.save()
        } catch {
            print("error saving context: \(error) ")
        }
        
        self.tableView.reloadData()
        
    }
    
    func loadItem() {
        
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        do {
          itemArray = try context.fetch(request)
        } catch {
            print("error loading conext: \(error)")
        }
    }
    
    
}














