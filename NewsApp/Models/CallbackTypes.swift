//
//  CallbackTypes.swift
//  NewsApp
//
//  Created by Andrey on 05.05.2023.
//

import Foundation

typealias NewsCallback = (Result<Array<Post>, Error>) -> Void
