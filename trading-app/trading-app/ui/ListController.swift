//
//  ViewController.swift
//  trading-app
//
//  Created by Hegedűs Csaba on 2021. 02. 18..
//

import UIKit
import Starscream
import RxSwift
import RxStarscream


class ListController: UIViewController {
    
    
    private let disposeBag = DisposeBag()
    
    @IBOutlet var tableView: UITableView!
    
    private var list1: [ResponseData] = [
        ResponseData(ca: [], price: 0.0, id: "AMZN", time: 0.0, value: 1)
    ]
    
    private lazy var list: [ResponseData] = Settings.shared.load() ?? [] {
        didSet {
            Settings.shared.save(list: list)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        Communicator.shared.newData.subscribe(onNext: {[unowned self] (map: [Int: ResponseData]) in
            print("new data map - \(map)")
            map.keys.forEach { key in
                // todo refresh constant symbol changes
                if !self.list.isEmpty {
                    self.list[key] = map[key]!
                }
                
            }
            self.tableView.reloadData()
        })
        .disposed(by: disposeBag)
        
    }

    private func setupUI() {
        title = "Stocks"
    }

}


extension ListController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StockTableViewCell", for: indexPath) as! StockTableViewCell
        let item = list[indexPath.row]
        cell.nameLabel.text = "\(item.id) \(item.price) $"
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let stockViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StockViewController") as! StockViewController
        stockViewController.data = list[indexPath.row]
        
        Communicator.shared.fetchData(for: list[indexPath.row].id) { [unowned self] company in
            if let company = company {
                stockViewController.company = company
            }
            self.navigationController?.present(stockViewController, animated: true, completion: {
                tableView.deselectRow(at: indexPath, animated: true)
            })
        }
    }
    
}

struct FinnResponse: Codable {
    var data: [ResponseData]
    var type: String
    
}

struct ResponseData: Codable, Hashable {
    
    var ca: [String]
    var price: Float
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


