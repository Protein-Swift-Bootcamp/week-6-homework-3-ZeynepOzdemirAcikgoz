//
//  APICaller.swift
//  BooksApp
//
//  Created by Zeynep Özdemir Açıkgöz on 13.01.2023.
//

import Foundation

struct Constants{
    
    static let API_KEY = "725732a1ed6b356f9e7828525690997a"
    static let baseURL = "https://api.collectapi.com/book/"

//    GET /seasons HTTP/1.1
//    X-Rapidapi-Key: 12f5e87d0dmsh86643cd41366d2cp174faajsn562cbef3da05
//    X-Rapidapi-Host: api-nba-v1.p.rapidapi.com
//    Host: api-nba-v1.p.rapidapi.com
}

enum APIError: Error{

case failedTogetData
}

class APICaller {
static let shared = APICaller()

func getTrendingBooks(completion: @escaping (Result<[Book], Error >) -> Void){

guard let url = URL(string: "https://api.collectapi.com/book/newBook") else {return}
        
        var request = URLRequest(url: url)

        request.httpMethod = "GET"
        request.setValue("apikey 7fQULnOFAfxSwMm11hgjmM:56jPvRAnDpjnbJMFgXaZDD", forHTTPHeaderField: "authorization")
        request.setValue("application/json", forHTTPHeaderField: "content-type")

let task = URLSession.shared.dataTask(with: request) { data, _, error in
    guard let data = data , error == nil else{
        return
    }
    do{
        let results = try JSONDecoder().decode(TrendBooks.self, from: data)
        print("Books: \(String(describing: results.result?.count))")
        //print(results)
        completion(.success(results.result!))
        
    }catch {
        completion(.failure(APIError.failedTogetData))
    }
}
task.resume()
}
}
