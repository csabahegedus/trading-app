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
            let newList = createList(from: Constants.Symbols)
            return newList
        }
        var list = try! JSONDecoder().decode([ResponseData].self, from: data)
        
        list.update(symbols: Constants.Symbols, creator: createList(from:))
        return list
    }
    
    private func createList(from symbols: [String]) -> [ResponseData] {
        var list = [ResponseData]()
        Constants.Symbols.forEach { symbol in
            list.append(
                ResponseData(ca: [], price: 0.0, symbol: symbol, time: 0.0, value: 0)
            )
        }
        return list
    }
}

fileprivate extension Array where Element == ResponseData {
    mutating func update(symbols: [String], creator: (([String])->[ResponseData])? = nil) {
        if (self.count == 0) {
            self = creator!(Constants.Symbols)
            return
        }
        
        var list = creator!(Constants.Symbols)
        for (index, stock) in list.enumerated() {
            if let firstIndex = self.firstIndex(of: stock) {
                list[index] = self[firstIndex]
            }
        }
        self = list
    }
}
