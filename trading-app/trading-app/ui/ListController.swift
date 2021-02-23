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
    
    private lazy var list: [ResponseData] = Settings.shared.load() ?? [] {
        didSet {
            Settings.shared.save(list: list)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        Communicator.shared.newData.subscribe(onNext: {[unowned self] (map: [Int: ResponseData]) in
            //print("new data map - \(map)")
            map.keys.forEach { key in
                let lastPrice = self.list[key].price
                self.list[key] = map[key]!
                self.list[key].lastPrice = lastPrice
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
        
        cell.nameLabel.text = " \(item.symbol) "
        
        cell.priceLabel.text = "\(item.price.rounded(toPlaces: 2)) $"
        
        // todo calc correct rate
        cell.rateLabel.text = " \(item.rate) "
        cell.rateLabel.backgroundColor = item.rateColor
        cell.rateLabel.font = UIFont.systemFont(ofSize: 14)
        cell.rateLabel.layer.cornerRadius = 10
        cell.rateLabel.clipsToBounds = true
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let stockViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StockViewController") as! StockViewController
        stockViewController.data = list[indexPath.row]
        
        Communicator.shared.fetchData(for: list[indexPath.row].symbol) { [unowned self] company in
            if let company = company {
                stockViewController.company = company
            }
            self.navigationController?.present(stockViewController, animated: true, completion: {
                tableView.deselectRow(at: indexPath, animated: true)
            })
        }
    }
    
}

