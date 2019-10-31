//
//  picViewController.swift
//  camcat
//
//  Created by Sophia Zhu on 2019-10-30.
//  Copyright © 2019 Sophia Zhu. All rights reserved.
//

import UIKit

class picViewController: UIViewController {

    @IBOutlet var photoTaken: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        if UserDefaults.standard.value(forKey: "user photo data") == nil{
//            _ = navigationController?.popViewController(animated: true)
//        } else {
//            photoTaken.image = UIImage(data: (UserDefaults.standard.value(forKey: "user photo data") as? Data)!)
//        }
         photoTaken.image = UIImage(data: (UserDefaults.standard.value(forKey: "photo data") as? Data)!)

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
