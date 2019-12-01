//
//  ViewController.swift
//  test
//
//  Created by Zilin Ye on 2019-11-26.
//  Copyright © 2019 Zilin Ye. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {

    @IBOutlet var inputField: UITextField!
    @IBOutlet var resultLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    @objc @IBAction func updateResult(_ sender: Any) {
        if let inputString = inputField.text{
            if let result = ExpressionEvaluator.getValue(inputString){
                self.resultLabel.text = String(result as! Double)
            }else{
                self.resultLabel.text = "Error"
            }
        }
    }
}
