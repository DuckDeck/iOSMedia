//
//  PorcessVideoViewController.swift
//  iOSDemo
//
//  Created by Stan Hu on 2019/9/26.
//  Copyright © 2019 Stan Hu. All rights reserved.
//

import UIKit
import SwiftUI
class PorcessVideoViewController: UIViewController {
    let imgView = UIImageView()
    let imgViewOrigin = UIImageView()
    let path = Bundle.main.path(forResource: "cxh", ofType: "mp4")!
    override func viewDidLoad() {
        super.viewDidLoad()
       imgViewOrigin.contentMode = .scaleAspectFit
       imgViewOrigin.addTo(view: view).snp.makeConstraints { (m) in
         m.left.right.equalTo(0)
          m.top.equalTo(0)
          m.height.equalTo(ScreenHeight / 2 - 50)
      }
        imgView.contentMode = .scaleAspectFit
        imgView.addTo(view: view).snp.makeConstraints { (m) in
            m.left.right.equalTo(0)
            m.top.equalTo(imgViewOrigin.snp.bottom).offset(10)
            m.height.equalTo(ScreenHeight / 2-100)
       }
       
        Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(setPreviewImage), userInfo: nil, repeats: true)

    }
    
    @objc func setPreviewImage()  {
        guard let images = opencvTool.getVideoImage(path) as? [UIImage] else{
            return
        }
        
        if images.count <= 0 {
            return
        }
        imgViewOrigin.image = images[0]
          imgView.image = images[1]
    }
   
}


struct ProcessVideoDemo:UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> PorcessVideoViewController {
        return PorcessVideoViewController()
    }
    
    func updateUIViewController(_ uiViewController: PorcessVideoViewController, context: Context) {
        
    }
    
    
    
    
    typealias UIViewControllerType = PorcessVideoViewController

}
