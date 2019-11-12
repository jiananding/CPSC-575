//
//  Networking.swift
//  Currency_exchange
//
//  Created by stephen on 2019-11-12.
//  Copyright © 2019 Stephen. All rights reserved.
//

import Foundation

struct rates: Decodable {
    var data: String
    var base: String
    var rates: [String: Double]
}

enum Result {
    case failure
    case success(rates)
}

let urlString = "https://api.exchangeratesapi.io/lates"

func getLatest(completion: @escaping (Result) -> Void) {
    guard let url = URL(string: urlString) else {completion(.failure); return}
    
    URLSession.shared.dataTask(with: url) {(data, response, error) in
        guard error == nil, let urlResponse = response as? HTTPURLResponse, urlResponse.statusCode == 200, let data = data else {completion(.failure); return}
    
    do {
        let exchangeRate = try JSONDecoder().decode(rates.self, from: data)
        completion(.success(exchangeRate))
    }
    catch {
        completion(.failure)
    }
    
    }
}
