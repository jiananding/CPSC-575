//
//  BackEnd.swift
//  camcat
//
//  Created by stephen on 2019-11-03.
//  Copyright © 2019 Sophia Zhu. All rights reserved.
//

import UIKit
import Foundation
import Vision

struct Box {
    var position: CGRect
    var nums: [Double]
}

class BackEnd {
    var box_position: [Box] = []
    var real_box_position: [Box] = []
    var value: [Double] = []
    var result: String = ""
    
    let pickedImage = PickedImage.instance.get().data
    
    func read() {
        let requestHandler = VNImageRequestHandler(data: pickedImage!.pngData()!, options: [:])
        let request = VNRecognizeTextRequest { (request, error) in
            guard let results = request.results as? [VNRecognizedTextObservation] else {return}
                 
            for visionReasult in results {
                let maximumCanadiates = 1
                guard let candidate = visionReasult.topCandidates(maximumCanadiates).first else {
                    continue
                }
                print(candidate.string)
                
                var arr: [Double] = []
                let strArr = candidate.string.split(separator: " ")
                let len = strArr.count
                for i in 0..<len {
                    if ((String(strArr[i])).isDouble()) {
                        let k: Double! = Double(strArr[i])
                        arr.append(k)
                    }
                }
                let temp_box = Box(position: visionReasult.boundingBox, nums: arr)
                self.box_position.append(temp_box)
            }
        }
        request.recognitionLevel = .accurate
        request.customWords = []
        request.minimumTextHeight = 0.0 // scale relate to image height
        request.revision = VNRecognizeTextRequestRevision1

        try? requestHandler.perform([request])
     }
    
    func calculation(_ equation: String) {
        if checkRight(equation) {
            let numericExpression = equation
            let expression = NSExpression(format: numericExpression)
            let expression_result = expression.expressionValue(with: nil, context: nil) as! NSNumber
            result = expression_result.stringValue
        } else {
            result = "Error"
        }
    }
    
    func checkRight(_ expression: String) -> Bool {
        let arr = expression.split(separator: " ")
        let le = arr.count
        // the first place cannot be the operator except minus operator and the last place cannot be the operator either.
        if (le == 0) {
            return false
        } else if (le == 1) {
            if (arr[0] == "*" || arr[0] == "/" || arr[0] == "+" ) {
                return false
            }
        } else if (le == 2) { //the first place must be minus operator
            if (arr[0] == "-"){
                if (arr[le - 1] == "*" || arr[le - 1] == "/" || arr[le - 1] == "-" || arr[le - 1] == "+") {
                    return false
                }
            } else {
                return false
            }
        } else if (le >= 3) {
            if (arr[le - 1] == "+" || arr[le - 1] == "-" || arr[le - 1] == "*" || arr[le - 1] == "/") {
                return false
            }
            if (arr[0] == "+" || arr[0] == "*" || arr[0] == "/") {
                return false
            }
            for i in 1..<(le-1) {
                if (arr[i] == "*" || arr[i] == "/" || arr[i] == "+" || arr[i] == "-") {
                    if (arr[i-1] == "*" || arr[i-1] == "/" || arr[i-1] == "+" || arr[i-1] == "-" || arr[i+1] == "*" || arr[i+1] == "/" || arr[i+1] == "+" || arr[i+1] == "-") {
                        return false
                    }
                } else {
                    if ((arr[i-1] != "*" && arr[i-1] != "/" && arr[i-1] != "+" && arr[i-1] != "-") || (arr[i+1] != "*" && arr[i+1] != "/" && arr[i+1] != "+" && arr[i+1] != "-")) {
                        return false
                    }
                }
            }
        }
        return true
    }
    
    func chcek_box(pts: CGPoint, equation: String) -> String{
        if real_box_position.isEmpty {
            deal_with_box()
        }
        var result = equation

        for box in real_box_position {
            if box.position.contains(pts) && !box.nums.isEmpty {
                result.append("\(box.nums[0]) ")
                return result
            }
        }
        return result
    }
    
    
    func deal_with_box() {
        let imageSize = PickedImage.instance.get().data?.size

        for box in box_position {
            let rectangle = CGRect(x: box.position.origin.x * imageSize!.width, y: (CGFloat(1.0) - box.position.origin.y) * imageSize!.height - box.position.height * imageSize!.height , width: box.position.width * imageSize!.width, height: box.position.height * imageSize!.height)
            real_box_position.append(Box(position: rectangle, nums: box.nums))
        }
    }
}

extension String {
    func isDouble() -> Bool {
        return (Double(self) != nil)
    }
}
