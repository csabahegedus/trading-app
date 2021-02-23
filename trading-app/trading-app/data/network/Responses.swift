//
//  Responses.swift
//  trading-app
//
//  Created by Hegedűs Csaba on 2021. 02. 19..
//

import UIKit

struct FinnResponse: Codable {
    var data: [ResponseData]
    var type: String
    
}

struct ResponseData: Codable, Hashable, Equatable {
    
    static func ==(lhs: ResponseData, rhs: ResponseData) -> Bool {
        return lhs.symbol == rhs.symbol
    }
    
    var ca: [String]
    var price: Double
    var symbol: String
    var time: Double
    var value: Int
    
    private enum CodingKeys: String, CodingKey {
        case ca = "c"
        case price = "p"
        case symbol = "s"
        case time = "t"
        case value = "v"
    }
    
    var rateColor: UIColor {
        return UIColor.green
    }
}

struct CompanyResponse: Decodable {
    let name: String
    let country: String
    let logo: String
    let ticker: String
}
