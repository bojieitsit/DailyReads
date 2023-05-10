//
//  ViewController.swift
//  NewsApp
//
//  Created by Andrey on 05.05.2023.
//

import UIKit

class NewsViewController: UIViewController {
    
    @IBOutlet weak var newsTableView: UITableView!
    
    var networking = NetworkManager()
    var posts: [Post] = []
    var chosenUrl: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
}


//MARK: - TableView DataSource Methods
extension NewsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        cell.idLabel.text = String(posts[indexPath.row].points)
        cell.newsLabel.text = posts[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
}

//MARK: - TableView Delegate Method

extension NewsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //perform segue
        chosenUrl = posts[indexPath.row].url
        performSegue(withIdentifier: "goToWeb", sender: self)
    }
}













