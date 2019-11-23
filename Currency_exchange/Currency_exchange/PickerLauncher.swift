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

class PickerLauncher: NSObject, UICollectionViewDelegate, UICollectionViewDataSource{
    
    var main_view = UIView()
    let blackView = UIView()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.white
        return cv
    }()
    
    let cellId = "cellId"
    
    var selection: [String] =
        ["AUD", "BGN", "BRL", "CAD", "CHF", "CNY", "CZK", "DKK", "GBP", "HKD", "HRK", "HUF", "IDR", "ILS",
         "INR", "ISK", "JPY", "KRW", "MXN", "MYR", "NOK", "NZD", "PHP", "PLN", "RON", "RUB", "SEK", "SGD",
         "THB", "TRY", "USD", "ZAR"]
    
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selection.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        return cell
    }
    
    override init() {
        super.init()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
    }
}
