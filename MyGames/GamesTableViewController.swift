//
//  GamesTableViewController.swift
//  MyGames
//
//  Created by Roberto Oliveira on 02/04/18.
//  Copyright © 2018 RobertoOliveira. All rights reserved.
//

import UIKit
import CoreData

class GamesTableViewController: UITableViewController {
    
    // MARK: - Properties
    private var fetchedResultsController:NSFetchedResultsController<Game>!
    private let emptyLabel:UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.text = "No items found"
        lbl.textColor = UIColor.lightGray
        lbl.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.bold)
        return lbl
    }()
    private lazy var searchController:UISearchController = {
        let vw = UISearchController(searchResultsController: nil)
        vw.searchResultsUpdater = self
        vw.dimsBackgroundDuringPresentation = false
        vw.searchBar.tintColor = UIColor.white
        vw.searchBar.barTintColor = UIColor.white
        vw.searchBar.delegate = self
        return vw
    }()
    
    
    
    
    
    
    
    // MARK: - Methods
    private func loadGames(search:String? = nil) {
        // NSFetchRequest makes data fetch
        let fetchRequest:NSFetchRequest<Game> = Game.fetchRequest()
        // Sort
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        // Filter (if needed)
        if let searchText = search {
            let predicate = NSPredicate(format: "title contains [c] %@", searchText)
            fetchRequest.predicate = predicate
        }
        // Prepare Fetch Results Controller
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.context, sectionNameKeyPath: nil, cacheName: nil)
        self.fetchedResultsController.delegate = self
        
        // Perform Fetch
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            print("Something went wrong: ", error.localizedDescription)
        }
    }
    
    
    
    
    
    // MARK: - Super Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadGames()
        self.navigationItem.searchController = self.searchController
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gameSegue" {
            let vc = segue.destination as! GameViewController
            let index = self.tableView.indexPathForSelectedRow?.row ?? 0
            vc.game = self.fetchedResultsController.fetchedObjects?[index]
        }
    }
    
    
    
    
    

    // MARK: - TableView stack
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.fetchedResultsController.fetchedObjects?.count ?? 0
        self.tableView.backgroundView = (count == 0) ? self.emptyLabel : nil
        return count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GameTableViewCell
        guard let item = self.fetchedResultsController.fetchedObjects?[indexPath.row] else {return cell}
        cell.updateContent(item: item)
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let game = self.fetchedResultsController.fetchedObjects?[indexPath.row] else {return}
            self.context.delete(game)
        }
    }

}





extension GamesTableViewController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
        default: self.tableView.reloadData()
        }
    }
    
}




extension GamesTableViewController: UISearchResultsUpdating, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        //
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.loadGames()
        self.tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.loadGames(search: searchBar.text)
        self.tableView.reloadData()
    }
    
}











