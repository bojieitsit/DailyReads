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
    
    let realm = try! Realm()
    var items: RealmSwift.Results<FavouriteItem>?
    
    @IBOutlet weak var favouritesTableView: UITableView!
    
    
    var posts: [Post] = []
    var chosenUrl: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        favouritesTableView.delegate = self
        favouritesTableView.dataSource = self
        favouritesTableView.rowHeight = 70.0
        loadItems()
    }
    
    func loadItems() {
        items = realm.objects(FavouriteItem.self)
        favouritesTableView.reloadData()
    }
    
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
        //        cell.idLabel.text = String(posts[indexPath.row].points)
        
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
        //perform segue
        chosenUrl = items?[indexPath.row].url ?? "google.com"
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
            action.hidesWhenSelected = true
            self.deleteItems(at: indexPath)
            
            
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "Trash-Icon")
        favouritesTableView.deselectRow(at: indexPath, animated: true)
        
        return [deleteAction]
    }
}

