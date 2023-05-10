//
//  NetworkManager.swift
//  NewsApp
//
//  Created by Andrey on 05.05.2023.
//

import Foundation

class NetworkManager {
    
    func fetchData(callback: @escaping NewsCallback) {
        if let url = URL(string: "https://hn.algolia.com/api/v1/search?tags=front_page") {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error == nil {
                    let decoder = JSONDecoder()
                    if let safeData = data {
                        do {
                            let results = try decoder.decode(Results.self, from: safeData)
                            DispatchQueue.main.async {
                                let mapped = results.hits.map { news in
                                    Post(objectID: news.objectID,
                                         points: news.points,
                                         title: news.title,
                                         url: news.url)
                                }
                                callback(.success(mapped))
                            }
                        } catch {
                            print(error)
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
}
