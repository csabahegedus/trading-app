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
    var lastPrice: Double = 0
    
    private enum CodingKeys: String, CodingKey {
        case ca = "c"
        case price = "p"
        case symbol = "s"
        case time = "t"
        case value = "v"
    }
}

extension ResponseData {
    var rate: String {
        if (lastPrice == 0) {
            return " - "
        }
        let rate = price - lastPrice
        return (rate >= 0) ? "+\(rate.rounded(toPlaces: 2))" : "\(rate.rounded(toPlaces: 2))"
    }
    
    var rateColor: UIColor {
        if (lastPrice == 0) {
            return UIColor.systemGray
        }
        return ((price - lastPrice) >= 0) ? UIColor.systemGreen : UIColor.systemRed
    }
}

struct CompanyResponse: Decodable {
    let name: String
    let country: String
    let logo: String
    let ticker: String
}
