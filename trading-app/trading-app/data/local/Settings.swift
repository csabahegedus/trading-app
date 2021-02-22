//
//  Settings.swift
//  trading-app
//
//  Created by Hegedűs Csaba on 2021. 02. 19..
//

import Foundation

class Settings: NSObject {
    static let shared = Settings()
    
    var userDefaults: UserDefaults {
        return UserDefaults.init(suiteName: "group.com.interviewtask.trading-app") ?? UserDefaults.standard
    }
    
    func save(list: [ResponseData]) {
        let data = try! JSONEncoder().encode(list)
        userDefaults.setValue(data, forKey: "data")
    }
    
    func load() -> [ResponseData]? {
        guard let data = userDefaults.value(forKey: "data") as? Data else {
            var newList = [ResponseData]()
            Constants.Symbols.forEach { symbol in
                newList.append(
                    ResponseData(ca: [], price: 0.0, id: symbol, time: 0.0, value: 0)
                )
            }
            return newList
        }
        let list = try! JSONDecoder().decode([ResponseData].self, from: data)
        return list
    }
}
