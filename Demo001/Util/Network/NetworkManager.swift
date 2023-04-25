//
//  NetworkManager.swift
//  Demo001
//
//  Created by Julio Collado Perez on 4/25/23.
//

import Foundation

enum NetworkError: Error {
    case invalidResponse
    case invalidURL
    case noDataFound
    case error(description: String)
    case unkhown
}

protocol NetworkManagerInterface {
    func getUsers(completion: @escaping (Result<[User], Error>) -> Void )
}

struct NetworkManager: NetworkManagerInterface {
    func getUsers(completion: @escaping (Result<[User], Error>) -> Void) {
        let urlString = "https://jserver-api.herokuapp.com/users"
        guard let url =  URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        let urlRequest = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(NetworkError.error(description: error.localizedDescription)))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noDataFound))
                return
            }
            
            do {
                let users = try JSONDecoder().decode([User].self, from: data)
                completion(.success(users))
                return
            } catch {
                completion(.failure(NetworkError.error(description: error.localizedDescription)))
                return
            }
        }
        .resume()
    }
}
