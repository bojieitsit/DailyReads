//
//  FavouriteItem.swift
//  NewsApp
//
//  Created by Andrey on 10.05.2023.
//

import Foundation
import RealmSwift

class FavouriteItem: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var url: String = ""

}
