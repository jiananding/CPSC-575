//
//  ViewController.swift
//  Currency_exchange
//
//  Created by stephen on 2019-11-18.
//  Copyright © 2019 Stephen. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    var base_button = UIButton()
    var target_button = UIButton()
    
    @IBOutlet weak var init_value: UITextField!
    @IBOutlet weak var converted_value: UILabel!
        
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
        init_value.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        base_button.frame = CGRect(x: 50, y: 180, width: 150, height: 50)
        base_button.setTitle("CAD", for: .normal)
        base_button.backgroundColor = .darkGray
        base_button.addTarget(self, action: #selector(base_button_label), for: .touchDown)
        

        target_button.frame = CGRect(x: 50, y: 250, width: 150, height: 50)
        target_button.backgroundColor = .darkGray
        target_button.addTarget(self, action: #selector(target_button_label), for: .touchDown)
        target_button.setTitle("USD", for: .normal)
        
        view.addSubview(base_button)
        view.addSubview(target_button)
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
                    //self.calculate(init_val: 1.0)
                    let val = Double(self.init_value.text!)
                    self.calculate(init_val: val!)
                    //self.date = date
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
    
    let menu = UITableView()
    var blackView = UIView()

    @IBAction func base_button_label(_ sender: UIButton) {
        showPicker(own_view: view, sender: sender)
    }
    
    @IBAction func target_button_label(_ sender: UIButton) {
        showPicker(own_view: view, sender: sender)
    }
    
    func showPicker(own_view: UIView, sender: UIButton) {
        blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
        
        own_view.addSubview(blackView)
        own_view.addSubview(menu)
        
        let height: CGFloat = 500
        let y: CGFloat = own_view.frame.height - height
        menu.frame = CGRect(x: 0, y: own_view.frame.height, width: own_view.frame.width, height: height)
        menu.dataSource = self
        menu.delegate = self
        menu.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        menu.tag = sender == base_button ? 1 : 2    // 1: base_button, 2: target_button
        
        blackView.frame = own_view.frame
        blackView.alpha = 0
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.blackView.alpha = 1
            self.menu.frame = CGRect(x: 0, y: y, width: self.menu.frame.width, height: self.menu.frame.height)
        }, completion: nil)
    }
    
    // react to the gesture for black view to dismiss the black view
    @objc func handleDismiss() {
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 0
            
            self.menu.frame = CGRect(x: 0.0, y: self.view.frame.height, width: self.menu.frame.width, height: self.menu.frame.height)
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
        if (tableView.tag == 1) {
            // base_button
            base_button.setTitle(selection[indexPath.row], for: .normal)
//            let val = Double(init_value.text!)
//            calculate(init_val: val!)
        }
        else {
            // target_button
            target_button.setTitle(selection[indexPath.row], for: .normal)
//
        }
        getLatest()
        //handleDismiss()

    }
}

