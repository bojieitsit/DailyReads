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
    
    @IBOutlet weak var newsTableView: UITableView!
    
    let defaults = UserDefaults.standard
    let realm = try! Realm()
    var items: List<FavouriteItem>?
    var networking = NetworkManager()
    var posts: [Post] = []
    var chosenUrl: String?
    
    override func viewDidLoad() {
        print(Realm.Configuration.defaultConfiguration.fileURL ?? "")
        super.viewDidLoad()
        if !defaults.bool(forKey: "hasCompletedOnboarding") {
            showOnboarding()
        }
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
    
    //MARK: - Present Welcome Screen
    func showOnboarding() {
        let onboardingController: UIOnboardingViewController = .init(withConfiguration: .setUp())
        onboardingController.delegate = self
        navigationController?.present(onboardingController, animated: false)
    }
    
    //MARK: - Move To Web Page
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
        chosenUrl = posts[indexPath.row].url  ?? "https://www.google.com/"
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
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
        
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
