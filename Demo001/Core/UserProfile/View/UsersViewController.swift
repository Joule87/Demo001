//
//  UsersViewController.swift
//  Demo001
//
//  Created by Julio Collado Perez on 4/25/23.
//

import UIKit

class UsersViewController: UIViewController {
    
    @IBOutlet weak var usersTableView: UITableView! {
        didSet {
            usersTableView.delegate = self
            usersTableView.dataSource = self
            usersTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        }
    }
    
    private let cellIdentifier: String = "UITableViewCellId"
    var presenter: UsersPresenterInterface?

    override func viewDidLoad() {
        super.viewDidLoad()
        setPresenter()
    }
    
    private func setPresenter() {
        presenter = UsersPresenter(networkManager: NetworkManager())
        presenter?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.getUsers()
    }

}

//MARK: - UsersPresenterDelegate
extension UsersViewController: UsersPresenterDelegate {
    func succeed() {
        guard let presenter = presenter else {
            return
        }
        print("did get users \(presenter.users)")
        usersTableView.reloadData()
    }
    
    func failed(errorDescription: String) {
        print("❌ \(errorDescription)")
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension UsersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.users.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier),
            let presenter = presenter else {
            preconditionFailure()
        }
        let user =  presenter.users[indexPath.row]
        cell.textLabel?.text = "\(user.firstName) \(user.lastName)"
        return cell
    }
    
}
