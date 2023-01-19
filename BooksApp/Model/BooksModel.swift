//
//  BooksModel.swift
//  BooksApp
//
//  Created by Zeynep Özdemir Açıkgöz on 13.01.2023.
//

import Foundation


// MARK: - Welcome
struct TrendBooks: Codable {
    var success: Bool?
    var result: [Book]?
}

// MARK: - Result
struct Book: Codable {
    var url, indirim, fiyat, yayın: String?
    var yazar, title, image: String?
}
