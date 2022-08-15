//
//  Award.swift
//  iProject
//
//  Created by Yurii on 15.08.2022.
//

import Foundation

struct Award: Codable, Identifiable {
    var id: String { name }
    let name: String
    let description: String
    let color: String
    let criterion: String
    let value: Int
    let image: String
    
    static let allAwards = Bundle.main.decode([Award].self, from: "Awards.json")
    static let example = allAwards[0]
}
