//
//  StockViewController.swift
//  trading-app
//
//  Created by Hegedűs Csaba on 2021. 02. 19..
//

import UIKit
import RxSwift
import Kingfisher

class StockViewController: UIViewController {
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var dismissButton: UIButton!
    
    private let disposeBag = DisposeBag()
    
    var data: ResponseData?
    var company: CompanyResponse?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI() {
            
        logoImageView.kf.setImage(
            with: URL(string: company?.logo ?? ""),
            placeholder: UIImage(systemName: "questionmark.circle")?.withRenderingMode(.alwaysTemplate)
        )
        logoImageView.tintColor = UIColor.gray
        logoImageView.layer.cornerRadius = 10
        logoImageView.clipsToBounds = true
        
        nameLabel.attributedText = NSMutableAttributedString()
            .bold("\(company?.name ?? "")\n\n")
            .blackHighlight(" \(company?.ticker ?? "") \n")
            .small(" symbol ")
            
        nameLabel.backgroundColor = UIColor.lightGray
        nameLabel.layer.cornerRadius = 10
        nameLabel.layer.shadowColor = UIColor.black.cgColor
        nameLabel.layer.shadowRadius = 3.0
        nameLabel.layer.shadowOpacity = 1.0
        nameLabel.layer.shadowOffset = CGSize(width: 4, height: 4)
        nameLabel.layer.masksToBounds = true
        
        priceLabel.attributedText = NSMutableAttributedString()
            .gray(" snapshot \n")
            .normal("price:  ")
            .blackHighlight(" \(data?.price.rounded(toPlaces: 2) ?? 0.0) $ ")
            
        dismissButton.setTitle("DISMISS", for: .normal)
        dismissButton.setTitleColor(UIColor.white, for: .normal)
        dismissButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        dismissButton.backgroundColor = UIColor.gray
        dismissButton.layer.cornerRadius = 10
        dismissButton.rx.tap.subscribe(onNext: { [unowned self] in
            self.dismiss(animated: true, completion: nil)
        }).disposed(by: disposeBag)
    }
}
