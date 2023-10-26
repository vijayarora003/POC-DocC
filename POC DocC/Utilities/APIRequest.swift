//
//  APIRequest.swift
//  Assignment
//
//  Created by Vijay Arora on 20-10-2023.
//  Copyright © 2023 Vijay Arora. All rights reserved.
//

import UIKit

/// This class is desinged to send API Reqeust
class APIRequest {

    /// Service URL
    private let url: URL
    
    init(url: URL) {
        self.url = url
    }

    /// Perform API Request
    /// - Parameter completion: Response callback
    func perform<T: Decodable>(with completion: @escaping (T?, String?) -> Void) {
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: .main)
        let task = session.dataTask(with: url) { (data, _, serverError) in
            guard let data = data else {
                completion(nil, serverError?.localizedDescription)
                return
            }
            do {
                let decoder = JSONDecoder()
                completion(try decoder.decode(T.self, from: data), nil)
            } catch {
                completion(nil, error.localizedDescription)
            }
        }
        task.resume()
    }
}
