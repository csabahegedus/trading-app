//
//  Responses.swift
//  trading-app
//
//  Created by Hegedűs Csaba on 2021. 02. 19..
//

import Foundation

struct FinnResponse: Codable {
    var data: [ResponseData]
    var type: String
    
}

struct ResponseData: Codable, Hashable {
    
    var ca: [String]
    var price: Double
    var id: String
    var time: Double
    var value: Int
    
    private enum CodingKeys: String, CodingKey {
        case ca = "c"
        case price = "p"
        case id = "s"
        case time = "t"
        case value = "v"
    }
}

struct CompanyResponse: Decodable {
    let name: String
    let country: String
    let logo: String
    let ticker: String
}
