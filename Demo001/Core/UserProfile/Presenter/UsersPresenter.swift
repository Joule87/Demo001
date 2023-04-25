//
//  UsersPresenter.swift
//  Demo001
//
//  Created by Julio Collado Perez on 4/25/23.
//

import Foundation

protocol UsersPresenterDelegate: AnyObject {
    func succeed()
    func failed(errorDescription: String)
}

protocol UsersPresenterInterface {
    var users: [User] { get set }
    var delegate: UsersPresenterDelegate? { get set }
    init(networkManager: NetworkManagerInterface)
    func getUsers()
}

final class UsersPresenter: UsersPresenterInterface {
    var users: [User] = []
    weak var delegate: UsersPresenterDelegate?
    let networkManager: NetworkManagerInterface
    
    init(networkManager: NetworkManagerInterface) {
        self.networkManager = networkManager
    }
    
    func getUsers() {
        networkManager.getUsers { [weak self] result in
            guard let self = self else {
                return
            }
            DispatchQueue.main.async {
                switch result {
                case .success(let users):
                    self.users = users
                    self.delegate?.succeed()
                case .failure(let error):
                    self.delegate?.failed(errorDescription: error.localizedDescription)
                }
            }
        }
    }
    
}
