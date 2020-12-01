//
//  Country.swift
//  Countries
//
//  Created by Yair Shlomo on 01/12/2020.
//

import Foundation

// Data of Country
struct Country: Codable {
    let name : String
    let nativeName: String
    let borders: [String]
    let area: Double?
}
