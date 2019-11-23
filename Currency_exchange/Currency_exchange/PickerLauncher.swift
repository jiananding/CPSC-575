//
//  PickerLauncher.swift
//  Currency_exchange
//
//  Created by stephen on 2019-11-23.
//  Copyright © 2019 Stephen. All rights reserved.
//

import Foundation
import UIKit

class PickerLauncher: NSObject {
    var main_view = UIView()
    let blackView = UIView()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.white
        return cv
    }()
    

    func showPicker(own_view: UIView) {
        self.main_view = own_view
        blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
        
        main_view.addSubview(blackView)
        main_view.addSubview(collectionView)
        
        let height: CGFloat = 500
        let y: CGFloat = main_view.frame.height - height
        collectionView.frame = CGRect(x: 0, y: main_view.frame.height, width: main_view.frame.width, height: 500)
        
        
        blackView.frame = main_view.frame
        blackView.alpha = 0
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.blackView.alpha = 1
            self.collectionView.frame = CGRect(x: 0, y: y, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
        }, completion: nil)
    }
    
    // react to the gesture for black view to dismiss the black view
    @objc func handleDismiss() {
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 0
            
            self.collectionView.frame = CGRect(x: 0.0, y: self.main_view.frame.height, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
        }
    }
    
    override init() {
        super.init()
    }
}
