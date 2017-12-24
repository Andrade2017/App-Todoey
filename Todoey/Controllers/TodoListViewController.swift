//
//  ViewController.swift
//  Todoey
//
//  Created by Thiago Andrade on 12/22/17.
//  Copyright © 2017 Andrade. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: UITableViewController {

    var todoItems: Results<Item>?
    let realm = try! Realm()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var selectedCategory: Category? {
        didSet {
            loadItem()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        tableView.separatorStyle = .none
        
        tableView.rowHeight = 80
        
    }
    
    //MARK: - Navigation Bar
    override func viewWillAppear(_ animated: Bool) {
        
            title = selectedCategory?.name
        
            guard let colourHex = selectedCategory?.colour  else { fatalError() }

            updateNavBar(withHexCode: colourHex)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        
        updateNavBar(withHexCode: "1D9BF6")
    }

    
    func updateNavBar(withHexCode colourHexCode: String) {
        
         guard let navBar = navigationController?.navigationBar else {fatalError("Navigation Controller does not exist")}
        
        
        guard let navBarColour = UIColor(hexString: colourHexCode) else  { fatalError()}
        
        navBar.barTintColor = navBarColour
        
        navBar.tintColor = ContrastColorOf(navBarColour, returnFlat: true)
        
        searchBar.tintColor = navBarColour
        
        navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : ContrastColorOf(navBarColour, returnFlat: true)]
        
    }
    
//MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return todoItems?.count ?? 1
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            
           cell.textLabel?.text = item.title
            
       
            
            if let colour = UIColor(hexString: selectedCategory!.colour)?.darken(byPercentage: CGFloat(indexPath.row)/CGFloat(todoItems!.count) ){
                    cell.backgroundColor = colour
                    cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
            }
            
        
           
           cell.accessoryType = item.done == true ? .checkmark : .none
            
        } else {
            cell.textLabel?.text = "No items added"
        }
        
    
        return cell
    }
    
//MARK: - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do{
            try realm.write {
                item.done = !item.done
            }
            } catch {
                print("Error saving done status: \(error)")
            }
        }
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
//MARK: - Add New Items
    
    
    @IBAction func addButtomPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoye Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once  the user press Add Item buttom on our UIAlert
            
            if let currentCategory = self.selectedCategory {
                
                do {
                try self.realm.write {
                    let newItem = Item()
                    newItem.title = textField.text!
                    newItem.dateCreated = Date()
                    currentCategory.items.append(newItem)
                }
                } catch {
                    print("Error adding item: \(error)")
                }
            }
            
            self.tableView.reloadData()
            
        }
        
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
         
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
        
    }
    
    
//MARK: - Model Manipulations Methods
    
    
    func loadItem() {
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
    

    
}

// MARK: - SearchBar Methods

extension TodoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()

    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchBar.text?.count == 0 {
            loadItem()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }

}














