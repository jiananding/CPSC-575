//
//  ViewController.swift
//  Currency_exchange
//
//  Created by stephen on 2019-11-18.
//  Copyright © 2019 Stephen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var base_button: UIButton!
    @IBOutlet weak var target_button: UIButton!
    
    @IBOutlet weak var init_value: UITextField!
    @IBOutlet weak var converted_value: UILabel!
    
    @IBOutlet weak var base_picker: UIScrollView!
    @IBOutlet weak var target_picker: UIScrollView!
        
    var date: String = ""

    var exchangeRates: [String: Double] =
        ["AUD": 0.0, "BGN": 0.0, "BRL": 0.0, "CAD": 0.0, "CHF": 0.0, "CNY": 0.0, "CZK": 0.0,
         "DKK": 0.0, "GBP": 0.0, "HKD": 0.0, "HRK": 0.0, "HUF": 0.0, "IDR": 0.0, "ILS": 0.0,
         "INR": 0.0, "ISK": 0.0, "JPY": 0.0, "KRW": 0.0, "MXN": 0.0, "MYR": 0.0, "NOK": 0.0,
         "NZD": 0.0, "PHP": 0.0, "PLN": 0.0, "RON": 0.0, "RUB": 0.0, "SEK": 0.0, "SGD": 0.0,
         "THB": 0.0, "TRY": 0.0, "USD": 0.0, "ZAR": 0.0]

    var selection: [String] =
        ["AUD", "BGN", "BRL", "CAD", "CHF", "CNY", "CZK", "DKK", "GBP", "HKD", "HRK", "HUF", "IDR", "ILS",
         "INR", "ISK", "JPY", "KRW", "MXN", "MYR", "NOK", "NZD", "PHP", "PLN", "RON", "RUB", "SEK", "SGD",
         "THB", "TRY", "USD", "ZAR"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // converted value change while textfield text editing changed
        // handleMore()

        init_value.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        //creacte_picker1()
        //creacte_picker2()
        getLatest()

        
    }

    func getLatest() {
        let apiEndPoint = "https://api.exchangeratesapi.io/latest?base=\(base_button.titleLabel!.text!)"
        guard let url = URL(string: apiEndPoint) else {return}
        
        let task = URLSession.shared.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            guard error == nil else {return}
            
            if let httpResponse = response as? HTTPURLResponse {
                guard httpResponse.statusCode == 200 else {return}
                print("HTTP status code: 200 OK")
            }
            
            guard let data = data else {return}
                
            do {
                guard let dict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] else {return}
                // print(dict.description)
                guard let rates = dict["rates"] as? [String: Double], let base = dict["base"] as? String, let date = dict["date"] as? String else {return}
                let currencies = rates.keys.sorted()
                for currency in currencies {
                    let rate = rates[currency]
                    self.exchangeRates.updateValue(rate!, forKey: currency)
                }
                OperationQueue.main.addOperation({
                    self.calculate(init_val: 1.0)
                    self.date = date
                })
            }
            catch {
                // Some error
            }
        }
        task.resume()
    }
    
    func calculate(init_val: Double) {
        let rate = exchangeRates[target_button.titleLabel!.text!]
        converted_value.text = String(format: "%.4f", init_val * rate!)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let val = Double(textField.text!) {
            calculate(init_val: val)
        }
        else {
            calculate(init_val: 1.0)
        }
    }
//
//    func creacte_picker1() {
//        base_picker.sizeToFit()
//        base_picker.layoutIfNeeded()
//        base_picker.backgroundColor = .darkGray
//        var contentWidth: CGFloat = 0.0
//
//        let length = selection.count
//        let width = (base_picker.frame.width / CGFloat(5.0))
//        for i in 0..<length {
//            contentWidth += width
//            let currency_button = UIButton(type: .system)
//            currency_button.tag = i
//            currency_button.frame = CGRect(x: width * CGFloat(i) , y: 0, width: width, height: 50)
//            currency_button.setTitle(String(selection[i]), for: .normal)
//            currency_button.addTarget(self, action: #selector(buttonAction1), for: .touchDown)
//            currency_button.backgroundColor = UIColor.darkGray
//            base_picker.addSubview(currency_button)
//        }
//        base_picker.contentSize = CGSize(width: contentWidth, height: 50)
//    }
//
//    func creacte_picker2() {
//        target_picker.sizeToFit()
//        target_picker.layoutIfNeeded()
//        target_picker.backgroundColor = .darkGray
//        var contentWidth: CGFloat = 0.0
//
//        let length = selection.count
//        let width = (target_picker.frame.width / CGFloat(5.0))
//        for i in 0..<length {
//            contentWidth += width
//            let currency_button = UIButton(type: .system)
//            currency_button.tag = i
//            currency_button.frame = CGRect(x: width * CGFloat(i) , y: 0, width: width, height: 50)
//            currency_button.setTitle(String(selection[i]), for: .normal)
//            currency_button.addTarget(self, action: #selector(buttonAction2), for: .touchDown)
//            currency_button.backgroundColor = UIColor.darkGray
//            target_picker.addSubview(currency_button)
//        }
//        target_picker.contentSize = CGSize(width: contentWidth, height: 50)
//    }
//
//    @objc func buttonAction1(sender: UIButton!) {
//        base_label.text = sender.titleLabel?.text
//        getLatest()
//    }
//
//    @objc func buttonAction2(sender: UIButton!) {
//        target_label.text = sender.titleLabel?.text
//        self.calculate(init_val: 1.0)
//    }
    
    
    let pickerLauncher = PickerLauncher()
    
    @IBAction func base_button_label(_ sender: Any) {
        pickerLauncher.showPicker(own_view: view)
    }
    
    @IBAction func target_button_label(_ sender: Any) {
        pickerLauncher.showPicker(own_view: view)
    }
}

