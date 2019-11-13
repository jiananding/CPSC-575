//
//  ViewController.swift
//  UnitConverter
//
//  Created by stephen on 2019-11-12.
//  Copyright © 2019 Stephen. All rights reserved.
//
// Reference: hackingwithswift.com/example-code/system/how-to-convert-units-using-unit-and-measurement
//            developer.apple.com/documentation/foundation/unitconverter
//            Oreilly - iOS 11 Swift Programming Cookbook

// Unit:
import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let heightFeet = Measurement(value: 6, unit: UnitLength.feet)
        let heightInches = heightFeet.converted(to: UnitLength.inches)
        let heightSensible = heightFeet.converted(to: UnitLength.meters)
        let heightAUS = heightFeet.converted(to: UnitLength.astronomicalUnits)
        // Base idea once user set the input data unit then
        // case 1: get all the related unit, when user select and unit, then pull up the data
        // case 2: when user decice which unit to convert to, then do the operation
        
    }
}

// time convertion
extension Double {
    var hours: Measurement<UnitDuration>{
        return Measurement(value: self, unit: UnitDuration.hours)
    }
    var minutes: Measurement<UnitDuration>{
        return Measurement(value: self, unit: UnitDuration.minutes)
    }
    var seconds: Measurement<UnitDuration>{
        return Measurement(value: self, unit: UnitDuration.seconds)
    }
}

//
