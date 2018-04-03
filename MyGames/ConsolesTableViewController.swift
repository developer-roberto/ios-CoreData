//
//  ConsolesTableViewController.swift
//  MyGames
//
//  Created by Roberto Oliveira on 02/04/18.
//  Copyright © 2018 RobertoOliveira. All rights reserved.
//

import UIKit

class ConsolesTableViewController: UITableViewController {
    
    
    // MARK: - Properties
    private var consolesManager:ConsolesManager = ConsolesManager.shared
    private let emptyLabel:UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.text = "No items found"
        lbl.textColor = UIColor.lightGray
        lbl.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.bold)
        return lbl
    }()
    
    
    
    
    
    // MARK: - IBActions
    @IBAction func addAction(_ sender: UIBarButtonItem) {
        self.showAlert(with: nil)
    }
    
    
    
    
    
    // MARK: - Methods
    private func loadConsoles() {
        self.consolesManager.loadConsoles(with: self.context)
        self.tableView.reloadData()
    }
    
    private func showAlert(with console: Console?) {
        let title = (console == nil) ? "Create" : "Edit"
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alert.addTextField { (txf:UITextField) in
            txf.placeholder = "Console Name"
            txf.text = console?.title
        }
        alert.addAction(UIAlertAction(title: title, style: .default, handler: { (_) in
            let console = console ?? Console(context: self.context)
            console.title = alert.textFields?.first?.text
            do {
                try self.context.save()
                self.loadConsoles()
            } catch {
                print("Something went wrong: ", error.localizedDescription)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.view.tintColor = UIColor(named: "second")
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    // MARK: - Super Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadConsoles()
    }
    
    
    
    // MARK: - TableView stack
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.consolesManager.consoles.count
        self.tableView.backgroundView = (count == 0) ? self.emptyLabel : nil
        return count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let item = self.consolesManager.consoles[indexPath.row]
        cell.textLabel?.text = item.title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = self.consolesManager.consoles[indexPath.row]
        self.showAlert(with: item)
        self.tableView.selectRow(at: nil, animated: true, scrollPosition: .none)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.consolesManager.deleteConsole(index: indexPath.row, context: self.context)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

}



