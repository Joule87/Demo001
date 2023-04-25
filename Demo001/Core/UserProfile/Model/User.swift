//
//  User.swift
//  Demo001
//
//  Created by Julio Collado Perez on 4/25/23.
//

import Foundation

struct User: Codable {
    let id: Int
    let firstName: String
    let lastName: String
    let userName: String
    let email: String
    let gender: String
    let imageStringURL: String
    let phone: String
    let birthday: String
    let twitterHandle: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName
        case lastName
        case userName = "username"
        case email
        case gender
        case imageStringURL = "pictureURL"
        case phone
        case birthday
        case twitterHandle
    }
}
