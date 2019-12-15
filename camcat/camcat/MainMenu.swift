//
//  PickerLauncher.swift
//  Currency_exchange
//
//  Created by stephen on 2019-11-23.
//  Copyright © 2019 Stephen. All rights reserved.
//

// Reference:
// youtube.com/watch?v=2kwCfFG5fDA

import Foundation
import UIKit

class MainMenu: NSObject, UITableViewDelegate, UITableViewDataSource{
    var main_view = UIView()
    let blackView = UIView()
    
    let menu = UITableView()
    
    let selection: [String] = ["Currency Exchange"]

    var currentNavigationController: UINavigationController!
    
    func showPicker(own_view: UIView) {
        self.main_view = own_view
        let swip = UISwipeGestureRecognizer(target: self, action: #selector(handleDismiss))
        swip.direction = .right
        menu.addGestureRecognizer(swip)
        blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
        
        main_view.addSubview(blackView)
        main_view.addSubview(menu)
        
        let width: CGFloat = 200
        let x: CGFloat = main_view.frame.width - width
        menu.backgroundColor = UIColor.white
        menu.frame = CGRect(x: main_view.frame.width, y: 0, width: 200, height: main_view.frame.height)
        menu.dataSource = self
        menu.delegate = self
        menu.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        blackView.frame = main_view.frame
        blackView.alpha = 0
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.blackView.alpha = 1
            self.menu.frame = CGRect(x: x, y: 0, width: self.menu.frame.width, height: self.menu.frame.height)
        }, completion: nil)
    }
    
    // react to the gesture for black view to dismiss the black view
    @objc func handleDismiss() {
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 0
            
            self.menu.frame = CGRect(x: self.main_view.frame.width, y: 0, width: self.menu.frame.width, height: self.menu.frame.height)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selection.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = selection[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.row == 0) {
            // go to currency exchange
            let currencyView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "currencyExchange") as! Currency_exchange
            currentNavigationController?.pushViewController(currencyView, animated: true)
        } else if (indexPath.row == 1){
            // go to unit exchange
        }
    }
    
    func initNaviController(NaviController: UINavigationController){
        currentNavigationController = NaviController
    }
    override init() {
        super.init()
    }
}
