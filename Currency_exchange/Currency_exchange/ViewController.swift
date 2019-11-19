//
//  ViewController.swift
//  Currency_exchange
//
//  Created by stephen on 2019-11-18.
//  Copyright © 2019 Stephen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var base: String = "CAD"
    var date: String = ""
    var exchangeRates: [String: Double] =
        ["AUD": 0.0,
         "BGN": 0.0,
         "BRL": 0.0,
         "CAD": 0.0,
         "CHF": 0.0,
         "CNY": 0.0,
         "CZK": 0.0,
         "DKK": 0.0,
         "GBP": 0.0,
         "HKD": 0.0,
         "HRK": 0.0,
         "HUF": 0.0,
         "IDR": 0.0,
         "ILS": 0.0,
         "INR": 0.0,
         "ISK": 0.0,
         "JPY": 0.0,
         "KRW": 0.0,
         "MXN": 0.0,
         "MYR": 0.0,
         "NOK": 0.0,
         "NZD": 0.0,
         "PHP": 0.0,
         "PLN": 0.0,
         "RON": 0.0,
         "RUB": 0.0,
         "SEK": 0.0,
         "SGD": 0.0,
         "THB": 0.0,
         "TRY": 0.0,
         "USD": 0.0,
         "ZAR": 0.0
        ]
    
    @IBOutlet weak var converted_value: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getLatest()
    }

    func getLatest() {
        let apiEndPoint = "https://api.exchangeratesapi.io/latest?base=CNY"
        
        guard let url = URL(string: apiEndPoint) else {return}
        
        let task = URLSession.shared.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            guard error == nil else {return}
            
            if let httpResponse = response as? HTTPURLResponse {
                guard httpResponse.statusCode == 200 else {return}
                print("Everything is ok")
            }
            
            guard let data = data else {return}
                
            do {
                guard let dict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] else {return}
                print(dict.description)
                guard let rates = dict["rates"] as? [String: Double], let base = dict["base"] as? String, let date = dict["date"] as? String else {return}
                let currencies = rates.keys.sorted()
                for currency in currencies {
                    let rate = rates[currency]
                    self.exchangeRates.updateValue(rate!, forKey: currency)
                }
                OperationQueue.main.addOperation({
                    //self.navigationController?.navigationBar.topItem?.title = "updated on \(date)"
                    self.date = date
                    self.base = base
                })
            }
            catch {
                print("Some error")
            }
        }
        task.resume()
    }
}

