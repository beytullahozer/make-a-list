//
//  ViewController.swift
//  make-a-list
//
//  Created by Beytullah Özer on 17.04.2022.
//

import UIKit

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var model = [List]()

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Make A List"
        view.backgroundColor = UIColor(red: 0.01, green: 0.28, blue: 0.36, alpha: 1.00)
        getAllItems()
        setup()
    }
    
    func setup(){
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor(red: 0.01, green: 0.28, blue: 0.36, alpha: 1.00)
        tableView.frame = CGRect(x: 0.0, y: 150.0, width: 428, height: 775.0)
        
        view.addSubview(tableView)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(clickedAddButton))
    }
    
    @objc func clickedAddButton(){
        
        let alert = UIAlertController(title: "Add to List", message: "", preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)

        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak self] _ in
            
            guard let field = alert.textFields?.first,
                  let text = field.text,
                  !text.isEmpty else {
                return
            }
            
            self?.createItem(name: text)
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        
        present(alert, animated: true)

    }
    
    func getAllItems(){
        do {
            model = try context.fetch(List.fetchRequest())
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        catch{
            print("Item Fetch Error!!")
        }
        
    }
    
    func createItem(name: String){
        
        let newItem = List(context: context)
        newItem.name = name
        newItem.created = Date()
        
        do{
            try context.save()
            getAllItems()
        }
        catch{
            print("Context didn't save!")
        }
        
    }
    
    func deleteItem(item: List){
        
        context.delete(item)
        
        do{
            try context.save()
            getAllItems()
        }
        catch{
            print("Context didn't delete!")
        }
        
    }
    
    func updateItem(item: List, newName: String){
        
        item.name = newName
        
        do{
            try context.save()
            getAllItems()
        }
        catch{
            print("Context didn't save!")
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = model[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.backgroundColor = UIColor(red: 0.01, green: 0.28, blue: 0.36, alpha: 1.00)
        cell.textLabel?.text = model.name
//        cell.textLabel?.text = "\(model.name) - \(model.created)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = model[indexPath.row]
        
        let sheet = UIAlertController(title: "Make a List", message: "You will update your list information !", preferredStyle: .actionSheet)
        
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        sheet.addAction(UIAlertAction(title: "Edit", style: .default, handler: { _ in

            let alert = UIAlertController(title: "Edit Item", message: "", preferredStyle: .alert)
            alert.addTextField(configurationHandler: nil)
            alert.textFields?.first?.text = item.name
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak self] _ in

                guard let field = alert.textFields?.first,
                      let newName = field.text,
                      !newName.isEmpty else {
                    return
                }

                self?.updateItem(item: item, newName: newName)

            }))

            self.present(alert, animated: true)
        }))
        
        present(sheet, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let item = model[indexPath.row]
        
//        let edit = UIContextualAction(style: .normal, title: "Edit") { [weak self] (action, view, completionHandler) in
//
//        let alert = UIAlertController(title: "Edit Item", message: "", preferredStyle: .alert)
//        alert.addTextField(configurationHandler: nil)
//        alert.textFields?.first?.text = item.name
//        alert.addAction(UIAlertAction(title: "Save", style: .cancel, handler: { [weak self] _ in
//
//            guard let field = alert.textFields?.first,
//                  let newName = field.text,
//                  !newName.isEmpty else {
//                return
//            }
//
//            self?.updateItem(item: item, newName: newName)
//
//        }))
//
//        self?.present(alert, animated: true)
//        completionHandler(true)
//        }
//        edit.backgroundColor = .systemBlue


        let delete = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, completionHandler) in
        self?.deleteItem(item: item)
        completionHandler(true)
        }
        delete.backgroundColor = .systemRed

        
        let configuration = UISwipeActionsConfiguration(actions: [delete])
        return configuration
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    


}

