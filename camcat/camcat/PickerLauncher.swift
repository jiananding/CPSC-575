//
//  PickerLauncher.swift
//  Currency_exchange
//
//  Created by stephen on 2019-11-23.
//  Copyright © 2019 Stephen. All rights reserved.
//

// Reference: youtube.com/watch?v=2kwCfFG5fDA

import Foundation
import UIKit

struct CellData {
    //let image: UIImage?
    //let country_name: String?
    let currency_code: String?
}

class PickerLauncher: NSObject{
    
    var main_view = UIView()
    let blackView = UIView()
    
    let menu = UIView()

    func showPicker(own_view: UIView) {
        self.main_view = own_view
        blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
        
        main_view.addSubview(blackView)
        main_view.addSubview(menu)
        
        let height: CGFloat = 500
        let y: CGFloat = main_view.frame.height - height
        menu.frame = CGRect(x: 0, y: main_view.frame.height, width: main_view.frame.width, height: 500)
        
        
        blackView.frame = main_view.frame
        blackView.alpha = 0
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.blackView.alpha = 1
            self.menu.frame = CGRect(x: 0, y: y, width: self.menu.frame.width, height: self.menu.frame.height)
        }, completion: nil)
    }
    
    // react to the gesture for black view to dismiss the black view
    @objc func handleDismiss() {
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 0
            
            self.menu.frame = CGRect(x: 0.0, y: self.main_view.frame.height, width: self.menu.frame.width, height: self.menu.frame.height)
        }
    }
    
  
    override init() {
        super.init()
    }
}
