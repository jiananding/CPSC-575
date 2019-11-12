//
//  ExchangeRateTableViewController.swift
//  Currency_exchange
//
//  Created by stephen on 2019-11-12.
//  Copyright © 2019 Stephen. All rights reserved.
//
// Reference: "youtube.com/watch?v=QbRHzZnNsoc"
import UIKit

class ExchangeRateTableViewController: UITableViewController {

    var exchangeRates = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //let apiEndPoint = "http://data.fixer.io/api/latest?access_key=bce1f176074f68e8eb9b4422a825656d"
        //Using api from fixer.io (free account)
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
                    if let rate = rates[currency] {
                        self.exchangeRates.append("1 \(base) = \(rate) \(currency)")
                    }
                }
                OperationQueue.main.addOperation({
                    self.navigationController?.navigationBar.topItem?.title = "updated on \(date)"
                    self.tableView.reloadData()
                })
            }
            catch {
                print("Some error")
            }
        }
        
        task.resume()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return exchangeRates.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rates", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = exchangeRates[indexPath.row]
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
