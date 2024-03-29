//
//  MainViewController.swift
//  camcat
//
//  Created by Zilin Ye on 2019-11-01.
//  Copyright © 2019 Sophia Zhu. All rights reserved.

//  Reference: stackoverflow.com/questions/28338981/how-to-add-done-button-to-numpad-in-ios-8-using-swift
//

import UIKit

class MainViewController: UIViewController, UITextFieldDelegate {
    
    var imgData:UIImage!
    var imgView:UIImageView!
    
    var operatorBarItem:[UIButton]! //Order: 0.Plus, 1.Minus, 2.Multiply, 3.Divide, 4.Undo
    var addButton:UIButton!
    var subButton:UIButton!
    var multiButton:UIButton!
    var divButton:UIButton!
    var undoButton:UIButton!
    
    var tipButton:UIButton!
    var taxButton:UIButton!
    
    
    var coverTop:UILabel!   //Cover the top
    var equalSign:UILabel!
    var resultLabel:UILabel!
    var expressionBar:UITextField!
    
    var hintLabel:UILabel!
    
    var backend = BackEnd()
    var main_menu = MainMenu()
    
    let distanceToBottom:CGFloat = 80
    var keyboardHeight:CGFloat = 320
    

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
        prepareGestureRecog()
        
        backend.read()
        imgView.image = drawRectangleOnImage(image: imgData)

    }
    
    func prepareView(){
        let pickedImage = PickedImage.instance.get()
        imgData = pickedImage.data
        drawImageView()
        drawOperatorBar()
        drawExpressionBar()
        drawHintLabel()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        if let rect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardHeight = rect.height
        }
    }
    
    func drawImageView(){
        imgView = UIImageView(image: imgData)
        imgView.contentMode = UIView.ContentMode.scaleAspectFit
        imgView.frame = CGRect(x: 0, y: 20, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - 200)
        view.addSubview(imgView)
    }
    
    func drawOperatorBar(){
        addButton = getOperator(title: "+", x: 10, y: UIScreen.main.bounds.size.height - distanceToBottom, width: UIScreen.main.bounds.size.width/5 - 20, height: 50)
        addButton.addTarget(self, action: #selector(signButtonAction), for: .touchDown)
        view.addSubview(addButton)
        
        subButton = getOperator(title: "-", x: UIScreen.main.bounds.size.width/5 + 10, y: UIScreen.main.bounds.size.height - distanceToBottom, width: UIScreen.main.bounds.size.width/5 - 20, height: 50)
        subButton.addTarget(self, action: #selector(signButtonAction), for: .touchDown)
        view.addSubview(subButton)
        
        multiButton = getOperator(title: "\u{00D7}", x: UIScreen.main.bounds.size.width/5*2 + 10, y: UIScreen.main.bounds.size.height - distanceToBottom, width: UIScreen.main.bounds.size.width/5 - 20, height: 50)
        multiButton.addTarget(self, action: #selector(signButtonAction), for: .touchDown)
        view.addSubview(multiButton)
        
        divButton = getOperator(title: "÷", x: UIScreen.main.bounds.size.width/5*3 + 10,
                                y: UIScreen.main.bounds.size.height - distanceToBottom, width: UIScreen.main.bounds.size.width/5 - 20, height: 50)
        divButton.addTarget(self, action: #selector(signButtonAction), for: .touchDown)
        view.addSubview(divButton)
        
        undoButton = getOperator(title: "←", x: UIScreen.main.bounds.size.width/5*4 + 10, y: UIScreen.main.bounds.size.height - distanceToBottom, width: UIScreen.main.bounds.size.width/5 - 20, height: 50)
        undoButton.addTarget(self, action: #selector(undoButtonAction(sender:)), for: .touchDown)
        undoButton.backgroundColor = UIColor.darkGray
        view.addSubview(undoButton)
        
        checkMode()
        
        // Add the tip and tax button
        tipButton = getOperator(title: "tip", x: view.frame.size.width-CGFloat(50) - 50, y: 44 + 35, width: (view.frame.size.width - (view.frame.size.width-CGFloat(50)-10)), height: 30)
        tipButton.addTarget(self, action: #selector(tipButtonAction(sender:)), for: .touchDown)
        view.addSubview(tipButton)
        tipButton.backgroundColor = UIColor.darkGray
        tipButton.isHidden = true
        
    }
    
    func drawHintLabel(){
        let sizeWidth:CGFloat = 100, sizeHeight:CGFloat = 50
        hintLabel = UILabel(frame: CGRect(x: (view.frame.size.width / 2 - sizeWidth / 2), y: (view.frame.size.height / 2 - sizeHeight / 2), width: sizeWidth, height: sizeHeight))
        hintLabel.isHidden = true
        hintLabel.textAlignment = .center
        hintLabel.font = UIFont(name: "System", size: 20)
        hintLabel.backgroundColor = UIColor.systemBackground
        view.addSubview(hintLabel)
    }
    
    func getOperator(title:String, x:CGFloat, y:CGFloat, width:CGFloat, height:CGFloat) -> UIButton{
        let btn:UIButton = UIButton(frame: CGRect(x: x, y: y, width: width, height: height))
        btn.setTitle(title, for: UIControl.State.normal)
        btn.setTitleColor(UIColor.white, for: UIControl.State.normal)
        btn.titleLabel!.font = UIFont(name: "System", size: 500)
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius = 10
        btn.layer.borderColor = UIColor.gray.cgColor
        btn.backgroundColor = UIColor.lightGray
        return btn
    }
    
    func drawCoverTop(){
        coverTop = UILabel()
        coverTop.backgroundColor = UIColor.systemBackground
        coverTop.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 75)
        view.addSubview(coverTop)
    }
    
    func drawExpressionBar(){
        drawCoverTop()
        equalSign = UILabel(frame: CGRect(x: (view.frame.size.width-CGFloat(50)-90), y: 44, width: 40, height: 30))
        equalSign.text = "     ="
        equalSign.backgroundColor = .systemBackground
        self.view.addSubview(equalSign)

        expressionBar = UITextField(frame: CGRect(x: 0, y: 0, width: view.frame.size.width-CGFloat(50) - 100, height: 30))
        expressionBar.keyboardType = UIKeyboardType.decimalPad
        expressionBar.center = CGPoint(x: (view.frame.size.width-CGFloat(50)-100)/2 + 20, y: 59)
        expressionBar.layer.borderWidth=0
        expressionBar.layer.borderColor=UIColor.darkGray.cgColor
        expressionBar.backgroundColor = .systemBackground
        expressionBar.textAlignment = .right
        expressionBar.text = ""
        expressionBar.font = UIFont(name: "NameOfTheFont", size: 20)
        
        self.view.addSubview(expressionBar)
        
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 30))
        doneToolbar.barStyle = .default

        let emptySpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        let leftBracket: UIBarButtonItem = UIBarButtonItem(title: "(", style: UIBarButtonItem.Style.plain, target: self, action: #selector(bracket))
        let rightBracket: UIBarButtonItem = UIBarButtonItem(title: ")", style: UIBarButtonItem.Style.plain, target: self, action: #selector(bracket))
        
        let items = [emptySpace, leftBracket, emptySpace, rightBracket, emptySpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()

        expressionBar.inputAccessoryView = doneToolbar
        expressionBar.addTarget(self, action: #selector(self.floatOperationBar), for: .editingDidBegin)
        expressionBar.addTarget(self, action: #selector(self.updateExpressionBar), for: .editingChanged)
        
        resultLabel = UILabel(frame: CGRect(x: (view.frame.size.width-CGFloat(50)-50), y: 44, width: (view.frame.size.width - (view.frame.size.width-CGFloat(50)-30)), height: 30))
        resultLabel.text = "0"
        resultLabel.backgroundColor = .systemBackground
        self.view.addSubview(resultLabel)
    }
    
    func updateResult() {
        resultLabel.text = backend.result
        
        if Double(backend.result) == 0 {
            tipButton.isHidden = true
        }else{
            tipButton.isHidden = false
        }
    }
    
    @objc func updateExpressionBar(){
    //func textViewDidChange(_ textView: UITextView) {
        backend.calculation(expressionBar.text!)
        updateResult()
    }
    
    @objc func doneButtonAction(){
        
        expressionBar.resignFirstResponder()
        backend.calculation(expressionBar.text!)
        
        updateResult()
        addButton.frame = CGRect(x: 10, y: UIScreen.main.bounds.size.height - distanceToBottom, width: UIScreen.main.bounds.size.width/5 - 20, height: 50)
        subButton.frame = CGRect(x: UIScreen.main.bounds.size.width/5 + 10, y: UIScreen.main.bounds.size.height - distanceToBottom, width: UIScreen.main.bounds.size.width/5 - 20, height: 50)
        multiButton.frame = CGRect(x: UIScreen.main.bounds.size.width/5*2 + 10, y: UIScreen.main.bounds.size.height - distanceToBottom, width: UIScreen.main.bounds.size.width/5 - 20, height: 50)
        divButton.frame = CGRect(x: UIScreen.main.bounds.size.width/5*3 + 10, y: UIScreen.main.bounds.size.height - distanceToBottom, width: UIScreen.main.bounds.size.width/5 - 20, height: 50)
        undoButton.frame = CGRect(x: UIScreen.main.bounds.size.width/5*4 + 10, y: UIScreen.main.bounds.size.height - distanceToBottom, width: UIScreen.main.bounds.size.width/5 - 20, height: 50)
    }
    
    @objc func bracket(sender: UIBarButtonItem){
        expressionBar.insertText(sender.title!)
        updateResult()
    }

    
    @objc func floatOperationBar(){
        addButton.frame = CGRect(x: 10, y: UIScreen.main.bounds.size.height - keyboardHeight - distanceToBottom, width: UIScreen.main.bounds.size.width/5 - 20, height: 50)
        subButton.frame = CGRect(x: UIScreen.main.bounds.size.width/5 + 10, y: UIScreen.main.bounds.size.height - keyboardHeight - distanceToBottom, width: UIScreen.main.bounds.size.width/5 - 20, height: 50)
        multiButton.frame = CGRect(x: UIScreen.main.bounds.size.width/5*2 + 10, y: UIScreen.main.bounds.size.height - keyboardHeight - distanceToBottom, width: UIScreen.main.bounds.size.width/5 - 20, height: 50)
        divButton.frame = CGRect(x: UIScreen.main.bounds.size.width/5*3 + 10, y: UIScreen.main.bounds.size.height - keyboardHeight - distanceToBottom, width: UIScreen.main.bounds.size.width/5 - 20, height: 50)
        undoButton.frame = CGRect(x: UIScreen.main.bounds.size.width/5*4 + 10, y: UIScreen.main.bounds.size.height - keyboardHeight - distanceToBottom, width: UIScreen.main.bounds.size.width/5 - 20, height: 50)
    }
    
    func prepareGestureRecog() {
//        print("prepareGestureRecog Called")
        imgView.isUserInteractionEnabled = true
        let pinchMethod = UIPinchGestureRecognizer(target: self, action: #selector(pinchImage(sender:)))    //Zoom in/out
        let panMethod = UIPanGestureRecognizer(target: self, action: #selector(handlePan(sender:)))         //Move img with two fingers
        let tapMethod = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))         //Tap to select boxes
        panMethod.minimumNumberOfTouches = 1       // Changed to single finger for better user experience
        imgView.addGestureRecognizer(pinchMethod)
        imgView.addGestureRecognizer(panMethod)
        imgView.addGestureRecognizer(tapMethod)

        let leftEdgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(screenEdgeSwipedLeft))   //Swipe Screenedge to pop Mainview
        leftEdgePan.edges = .left
        let rightEdgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(screenEdgeSwipedRight))
        rightEdgePan.edges = .right
        view.addGestureRecognizer(leftEdgePan)
        view.addGestureRecognizer(rightEdgePan)
    }
    
    //---Gesture Recognition Methods Start---
    @objc func pinchImage(sender: UIPinchGestureRecognizer) {                                                //Zoom in / out
        if let scale = (sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale)) {
//            print("Pinch Detected")
//            print("The size of imgView is \(imgView.frame.size)")
            guard scale.a > 1.0 else {return}
            guard scale.d > 1.0 else {return}
            sender.view?.transform = scale
            sender.scale = 1.0
        }
    }
    
    @objc func handlePan(sender: UIPanGestureRecognizer) {                                                     //Move image with two fingers
//        print("2-finger Pan Detedted")
//        print("The center of imgView is \(imgView.center)")
//        print("The coordinator of imgView is \(imgView.frame.origin)")
        let gview = sender.view
        if sender.state == .began || sender.state == .changed {
            let translation = sender.translation(in: gview?.superview)
            gview?.center = CGPoint(x: (gview?.center.x)! + translation.x, y: (gview?.center.y)! + translation.y)
            sender.setTranslation(CGPoint.zero, in: gview?.superview)
        }
    }
    
    @objc func handleTap(sender: UIPanGestureRecognizer) {                                                     //Tap to select boxes
        guard sender.view != nil else { return }
        if sender.state == .ended {
//            print("Tap Detected")
//            print("You are tapping \(sender.location(in: self.view))")
//            print("You are tapping \(getTappedPointOnImg(tappedPoint: sender.location(in: self.view)))")
            var point: CGPoint = sender.location(in: self.view)
            let xLoc = point.x, yLoc = point.y
            point = getTappedPointOnImg(tappedPoint: point)
            let result = backend.check_box(pts: point)
            if (result != "") {
                displayHint(result, xLoc, yLoc)
                if (expressionBar.isEditing) {
                    if (!expressionBar.text!.isEmpty) {
                        let cursorPosition = expressionBar.offset(from: expressionBar.beginningOfDocument, to: expressionBar.selectedTextRange!.start)
                        let text = expressionBar.text!
                        let index = expressionBar.text!.index(expressionBar.text!.startIndex, offsetBy: cursorPosition-1)
                        if (text[index] != "(") {
                            expressionBar.insertText(backend.mode)
                        }
                    }
                    expressionBar.insertText(backend.check_box(pts: point))
                } else {
                    if (!expressionBar.text!.isEmpty) {
                        let temp_text = expressionBar.text!
                        let index = expressionBar.text!.index(before: temp_text.endIndex)
                        if (temp_text[index] != "(") {
                            var text = expressionBar.text!.map{String($0)}
                            text.insert(backend.mode, at: expressionBar.text!.count)
                            expressionBar.text! = text.joined()
                        }
                    }
                    var text = expressionBar.text!.map{String($0)}
                    text.insert(backend.check_box(pts: point), at: expressionBar.text!.count)
                    expressionBar.text! = text.joined()
                }
            }
            backend.calculation(expressionBar.text!)
            updateResult()
        }
    }
    
    @objc func screenEdgeSwipedLeft(_ recognizer: UIScreenEdgePanGestureRecognizer) {
//        print("Screenedge-swipe left Detected")
        if recognizer.state == .recognized {
            self.navigationController?.popViewController(animated: true) //Pop current page
            backend.box_position.removeAll()
        }
    }
    
    @objc func screenEdgeSwipedRight(_ recognizer: UIScreenEdgePanGestureRecognizer) {
//        print("Screenedge-swipe right Detected")
        if recognizer.state == .recognized {
            main_menu.initNaviController(NaviController: self.navigationController!)
            main_menu.showPicker(own_view: view)
        }
    }
    
    func getTappedPointOnImg(tappedPoint: CGPoint) -> CGPoint{  //Get the coordinates of tapped point on image
        var x,y :CGFloat
        if (imgView.frame.size.height/imgView.frame.size.width > imgData.size.height/imgData.size.width){
            let imgX = imgView.frame.origin.x
            let imgY = imgView.frame.origin.y + 0.50*(imgView.frame.height - ((imgView.frame.width / imgData.size.width)*imgData.size.height))
            let imgWidth = imgView.frame.width
            let imgHeight = (imgView.frame.width/imgData.size.width)*imgData.size.height
            x = imgData.size.width*(tappedPoint.x - imgX)/imgWidth
            y = imgData.size.height*(tappedPoint.y - imgY)/imgHeight
        }
        else{
            let imgX = imgView.frame.origin.x + 0.5*(imgView.frame.width - ((imgView.frame.height / imgData.size.height)*imgData.size.width))
            let imgY = imgView.frame.origin.y
            let imgWidth = (imgView.frame.height/imgData.size.height)*imgData.size.width
            let imgHeight = imgView.frame.height
            x = imgData.size.width*(tappedPoint.x - imgX)/imgWidth
            y = imgData.size.height*(tappedPoint.y - imgY)/imgHeight
        }
        let tapped = CGPoint(x: x, y: y)
        return tapped
    }
    //---Gesture Recognition Methods End---

    //---Draw Box For Text Recognion---
    func drawRectangleOnImage(image: UIImage) -> UIImage {
        let imageSize = image.size
        let scale: CGFloat = 0
        UIGraphicsBeginImageContextWithOptions(imageSize, false, scale)
        image.draw(at: CGPoint.zero)
        for box in backend.box_position {
            let drawPath = UIBezierPath()
            // Starting point (left-up corner)
            let leftUp = CGPoint(x: box.position.origin.x * imageSize.width, y: (CGFloat(1.0) - box.position.origin.y) * imageSize.height - box.position.height * imageSize.height)
            // Right-up corner
            let rightUp = CGPoint(x: box.position.origin.x * imageSize.width + imageSize.width * box.position.width, y: (CGFloat(1.0) - box.position.origin.y) * imageSize.height - box.position.height * imageSize.height)
            // Right-down corner
            let rightDown = CGPoint(x: box.position.origin.x * imageSize.width + imageSize.width * box.position.width, y: (CGFloat(1.0) - box.position.origin.y) * imageSize.height - box.position.height * imageSize.height + box.position.height * imageSize.height)
            // Ending point (left-down corner)
            let leftDown = CGPoint(x: box.position.origin.x * imageSize.width, y: (CGFloat(1.0) - box.position.origin.y) * imageSize.height - box.position.height * imageSize.height + box.position.height * imageSize.height)
            
            drawPath.move(to: leftUp)
            drawPath.addLine(to: rightUp)
            drawPath.addLine(to: rightDown)
            drawPath.addLine(to: leftDown)
            drawPath.addLine(to: leftUp)
            
            UIColor.orange.setStroke()
            drawPath.lineWidth = 5.0
            drawPath.stroke()
        }
        let newImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    //---End of Draw Function---
    
    @objc func signButtonAction(sender: UIButton!) {
        addButton.backgroundColor = .lightGray
        subButton.backgroundColor = .lightGray
        multiButton.backgroundColor = .lightGray
        divButton.backgroundColor = .lightGray

        backend.mode = sender.titleLabel!.text!
        sender.backgroundColor = UIColor.init(red: 255.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1)
        
        if (expressionBar.isEditing) {
            expressionBar.insertText(sender.titleLabel!.text!)
        }
        backend.calculation(expressionBar.text!)
    }
    
    @objc func undoButtonAction(sender: UIButton!) {
        var text = expressionBar.text
        if !text!.isEmpty {
            while (!["+", "-", "\u{00D7}", "÷", "(", ")"].contains(text?.last)) {
                if (text!.isEmpty) {
                    break
                }
                text?.removeLast()
            }
            if (!text!.isEmpty && text!.last! != "(") {
                text?.removeLast()
            }
            if (text! == expressionBar.text! && text!.last! == "(") {
                text?.removeLast()
            }
            expressionBar.text = text
            backend.calculation(expressionBar.text!)
            updateResult()
        }
    }
    //---End Num Button Action---
    
    func checkMode() {
        let highlightColor = UIColor.init(red: 255.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1)
        switch backend.mode {
        case "+":
            addButton.backgroundColor = highlightColor
        case "-":
            addButton.backgroundColor = highlightColor
        case "\u{00D7}":
            addButton.backgroundColor = highlightColor
        case "÷":
            addButton.backgroundColor = highlightColor
        case "←":
            addButton.backgroundColor = highlightColor
        default:
            return
        }
    }
    
    @objc func tipButtonAction(sender: UIButton!) {
        let text = resultLabel.text!
        
        let alert = UIAlertController(title: "Add tip", message: "Please choose how much you want to pay for tips", preferredStyle: UIAlertController.Style.alert)
        
        let noTip_Action = UIAlertAction(title: "No Tip", style: UIAlertAction.Style.default)
        
        let _10_Action = UIAlertAction(title: "10%", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction!) in
            var result_10 = Double(text)
            result_10 = result_10! * 1.1
            self.showTotalAddingTip(Double(result_10!))
        })
        
        let _15_Action = UIAlertAction(title: "15%", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction!) in
            var result_15 = Double(text)
            result_15 = result_15! * 1.15
            self.showTotalAddingTip(Double(result_15!))
        })
        
        let otherAction = UIAlertAction(title: "Others", style: UIAlertAction.Style.default, handler: {(action: UIAlertAction!) in
            let result_other = Double(text)
            self.calculateTip(result_other!)
        })
        
        alert.addAction(noTip_Action)
        alert.addAction(_10_Action)
        alert.addAction(_15_Action)
        alert.addAction(otherAction)
        alert.preferredAction = noTip_Action
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func displayHint(_ hint:String, _ x:CGFloat, _ y:CGFloat){
        hintLabel.frame.origin.x = x - 50
        hintLabel.frame.origin.y = y - 75
        hintLabel.text = hint
        hintLabel.isHidden = false
        let seconds = 0.35
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            self.hintLabel.isHidden = true
        }
    }
    
    // Show the total money (adding tips)
    func showTotalAddingTip(_ result:Double) {
        let myResult = String(format: "%.2f", result)
        let alertResult = UIAlertController(title: "Total", message: "You need to pay " + myResult, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alertResult.addAction(okAction)
        alertResult.preferredAction = okAction
        self.present(alertResult, animated: true, completion: nil)
    }
    
    // Individual tip
    func calculateTip(_ result:Double) {
        let alertResult = UIAlertController(title: "Tips", message: "Enter tips in percentages", preferredStyle: UIAlertController.Style.alert)
        alertResult.addTextField { (textField) -> Void in
                    textField.keyboardType = UIKeyboardType.numberPad
                    textField.placeholder = "Tips"
        //            textField.secureTextEntry = true
                }
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action: UIAlertAction!) in
            if (alertResult.textFields![0].text != "") {
                let tip = alertResult.textFields![0].text!
                let resultFinal = result * (1 + Double(tip)! / 100)
                self.showTotalAddingTip(resultFinal)
            }
        })
        alertResult.addAction(okAction)
        alertResult.preferredAction = okAction
        self.present(alertResult, animated: true, completion: nil)
    }
    
}
