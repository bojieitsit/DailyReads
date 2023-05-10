//
//  ViewController.swift
//  NewsApp
//
//  Created by Andrey on 05.05.2023.
//

import UIKit
import SwipeCellKit
import RealmSwift
import UIOnboarding

class NewsViewController: UIViewController {
    

    
    let realm = try! Realm()
    var items: List<FavouriteItem>?
    
    @IBOutlet weak var newsTableView: UITableView!
    
    var networking = NetworkManager()
    var posts: [Post] = []
    var chosenUrl: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let onboardingController: UIOnboardingViewController = .init(withConfiguration: .setUp())
        onboardingController.delegate = self
        navigationController?.present(onboardingController, animated: false)
        navigationItem.title = "News"
        newsTableView.delegate = self
        newsTableView.dataSource = self
        newsTableView.rowHeight = 70.0
        networking.fetchData() { result in
            switch result {
            case .failure(_):
                return
            case .success(let newsArray):
                print("data fetched")
                self.posts = newsArray
                self.newsTableView.reloadData()
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? WebViewController {
            destinationVC.currentUrl = chosenUrl
        }
    }
    
    //MARK: - Data Manipulation Methods
    func save(item: FavouriteItem) {
        do {
            try realm.write {
                realm.add(item)
            }
        } catch {
            print("Error saving item \(error)")
        }
    }
}




//MARK: - TableView DataSource Methods
extension NewsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        cell.textLabel?.text = posts[indexPath.row].title
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
}

//MARK: - TableView Delegate Method

extension NewsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenUrl = posts[indexPath.row].url
        performSegue(withIdentifier: "goToWeb", sender: self)
    }
    
    
}


//MARK: - SwipeCell Delegate Method
extension NewsViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let favoutitesAction = SwipeAction(style: .destructive, title: "Favourite") { action, indexPath in
            // handle action by updating model with deletion
            print("Added to favoutites")
            action.hidesWhenSelected = true
            
            let newFavouriteItem = FavouriteItem()
            newFavouriteItem.title = self.posts[indexPath.row].title
            newFavouriteItem.url = self.posts[indexPath.row].url ?? "google.com"
            
            print(newFavouriteItem.title)
            
            self.items?.append(newFavouriteItem)
            self.save(item: newFavouriteItem)
        }
        
        favoutitesAction.image = UIImage(named: "Flag-Icon")
        
        return [favoutitesAction]
    }
}

//MARK: - Onboarding Setup

extension NewsViewController: UIOnboardingViewControllerDelegate {
    func didFinishOnboarding(onboardingViewController: UIOnboardingViewController) {
        onboardingViewController.modalTransitionStyle = .crossDissolve
        onboardingViewController.dismiss(animated: true, completion: nil)
    }
}

extension UIOnboardingViewConfiguration {
    // UIOnboardingViewController init
    static func setUp() -> UIOnboardingViewConfiguration {
        return .init(appIcon: UIOnboardingHelper.setUpIcon(),
                     firstTitleLine: UIOnboardingHelper.setUpFirstTitleLine(),
                     secondTitleLine: UIOnboardingHelper.setUpSecondTitleLine(),
                     features: UIOnboardingHelper.setUpFeatures(),
                     textViewConfiguration: UIOnboardingHelper.setUpNotice(),
                     buttonConfiguration: UIOnboardingHelper.setUpButton())
    }
}



