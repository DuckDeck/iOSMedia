//
//  ViewController.swift
//  iOSMedia
//
//  Created by Stan Hu on 2020/3/20.
//  Copyright © 2020 Stan Hu. All rights reserved.
//

import UIKit
import SwiftUI
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "UI", style: .plain, target: self, action: #selector(toNext))
        
    }
    
    @objc func toNext() {
        let vc = UIHostingController(rootView: Home())
        navigationController?.pushViewController(vc, animated: true)
    }


}

