//
//  WhisperRepository.swift
//  WhisperChallenge
//
//  Created by Efrén Pérez Bernabe on 6/10/19.
//  Copyright © 2019 Efrén Pérez Bernabe. All rights reserved.
//

import Foundation
import UIKit

class WhisperRepository {
    
    /// Perform a GET request, handling errors and response.
    /// - Note: The data retrive must to be a JSON to perform the decode.
    ///
    /// - Parameters:
    ///   - url: URL to perform the request.
    ///   - wid: Use for retrieve replies for a specific whisper.
    ///   - _: Model to decode the data retrived.
    ///   - completion: Closure that returns a Model for the request.
    ///   - model: Model retrieve from the request.
    func execute<T: Codable>(request: WhisperRequest,
                             forWid: String? = nil,
                             _: T.Type,
                             completion: @escaping (_ model: Result<T, Error>) -> Void) {
        
        var urlString = Constants.apiURL
        
        switch request {
        case .popularWhispers:
            urlString.append("popular?limit=50")
        case .replies:
            urlString.append("replies?limit=200&wid=\(forWid ?? "")")
        }
        
        guard let url = URL(string: urlString) else { return }
        let urlRequest = URLRequest(url: url)

        URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
            if let error = error {
                completion(Result.failure(error))
                return
            }
            guard let data = data else {
                completion(Result.failure(RepositoryError.dataIsNil))
                return
            }
            
            do {
                let modelData = try JSONDecoder().decode(T.self, from: data)
                completion(Result.success(modelData))
            } catch {
                completion(Result.failure(RepositoryError.failedParsing))
                return
            }
        }.resume()
        return
    }
    
}
