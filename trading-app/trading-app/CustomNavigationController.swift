//
//  CustomNavigationController.swift
//  trading-app
//
//  Created by Hegedűs Csaba on 2021. 02. 18..
//

import UIKit

class CustomNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.prefersLargeTitles = true
    }
}
