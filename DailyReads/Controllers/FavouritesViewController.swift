//
//  FavouritesViewController.swift
//  NewsApp
//
//  Created by Andrey on 10.05.2023.
//

import UIKit
import SwipeCellKit
import RealmSwift


class FavouritesViewController: UIViewController {
    
    @IBOutlet weak var favouritesTableView: UITableView!
    
    let realm = try! Realm()
    var items: RealmSwift.Results<FavouriteItem>?
    var chosenUrl: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favouritesTableView.delegate = self
        favouritesTableView.dataSource = self
        favouritesTableView.rowHeight = 70.0
        loadItems()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        favouritesTableView.reloadData()
    }
    
    //MARK: - Load Items From Realm
    func loadItems() {
        items = realm.objects(FavouriteItem.self)
        items = items?.distinct(by: ["title"])
        favouritesTableView.reloadData()
    }
    
    //MARK: - Delete Items From Realm
    func deleteItems(at indexPath: IndexPath) {
        if let itemForDeletion = items?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(itemForDeletion)
                }
            } catch {
                print("Error deleting item \(error)")
            }
        }
    }
    
    //MARK: - Move To Web Page
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? WebViewController {
            destinationVC.currentUrl = chosenUrl
        }
    }
    
}



//MARK: - TableView DataSource Methods
extension FavouritesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        
        if let item = items?[indexPath.row] {
            cell.textLabel?.text = item.title
        } else {
            cell.textLabel?.text = "You have no favourites"
        }
        
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1
    }
}

//MARK: - TableView Delegate Method
extension FavouritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenUrl = items?[indexPath.row].url ?? "https://www.google.com/"
        performSegue(withIdentifier: "goToWeb", sender: self)
    }
}


//MARK: - SwipeCell Delegate Method
extension FavouritesViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Favourite") { action, indexPath in
            // handle action by updating model with deletion
            print("Deleted")
            if let itemToDelete = self.items?[indexPath.row] {
                do {
                    try self.realm.write {
                        self.realm.delete(itemToDelete)
                    }
                } catch {
                    print("Error deleting item \(error)")
                }
            }
            self.favouritesTableView.reloadData()
            
            
        }
        
        deleteAction.image = UIImage(named: "Trash-Icon")
        favouritesTableView.deselectRow(at: indexPath, animated: true)
        
        return [deleteAction]
    }
}

