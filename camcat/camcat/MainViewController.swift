//
//  MainViewController.swift
//  camcat
//
//  Created by Zilin Ye on 2019-11-01.
//  Copyright © 2019 Sophia Zhu. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    var imgData:UIImage!
    var imgView:UIImageView!
    
    //var expressionBar:UITextView!
    var operatorBarItem:[UIButton]! //Order: 0.Plus, 1.Minus, 2.Multiply, 3.Divide, 4.Undo
    var addButton:UIButton!
    var subButton:UIButton!
    var multiButton:UIButton!
    var divButton:UIButton!
    var undoButton:UIButton!
    var equalSign:UILabel!
    var resultLabel:UILabel!
    // Add a new textField
//    var extendText:UISwitch!
//    var expressionExtendBar:UITextField!
    
    let expressionBar = UITextView()
    
    var backend = BackEnd()
    var pickerLauncher = PickerLauncher()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
        prepareGestureRecog()
        
        backend.read()
        imgView.image = drawRectangleOnImage(image: imgData)
//        create_num_stack()

    }
    
    func prepareView(){
        let pickedImage = PickedImage.instance.get()
        imgData = pickedImage.data
        drawImageView()
        drawOperatorBar()
        drawExpressionBar()
    }
    
    
    func drawImageView(){
        imgView = UIImageView(image: imgData)
        imgView.contentMode = UIView.ContentMode.scaleAspectFit
        imgView.frame = CGRect(x: 0, y: 20, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - 200)
        view.addSubview(imgView)
    }
    
    func drawOperatorBar(){
        addButton = getOperator(title: "+", x: 10, y: UIScreen.main.bounds.size.height - 130, width: UIScreen.main.bounds.size.width/5 - 20, height: 50)
        addButton.addTarget(self, action: #selector(signButtonAction), for: .touchDown)
        view.addSubview(addButton)
        
        subButton = getOperator(title: "-", x: UIScreen.main.bounds.size.width/5 + 10, y: UIScreen.main.bounds.size.height - 130, width: UIScreen.main.bounds.size.width/5 - 20, height: 50)
        subButton.addTarget(self, action: #selector(signButtonAction), for: .touchDown)
        view.addSubview(subButton)
        
        multiButton = getOperator(title: "\u{00D7}", x: UIScreen.main.bounds.size.width/5*2 + 10, y: UIScreen.main.bounds.size.height - 130, width: UIScreen.main.bounds.size.width/5 - 20, height: 50)
        multiButton.addTarget(self, action: #selector(signButtonAction), for: .touchDown)
        view.addSubview(multiButton)
        
        divButton = getOperator(title: "÷", x: UIScreen.main.bounds.size.width/5*3 + 10,
                                y: UIScreen.main.bounds.size.height - 130, width: UIScreen.main.bounds.size.width/5 - 20, height: 50)
        divButton.addTarget(self, action: #selector(signButtonAction), for: .touchDown)
        view.addSubview(divButton)
        
        undoButton = getOperator(title: "←", x: UIScreen.main.bounds.size.width/5*4 + 10, y: UIScreen.main.bounds.size.height - 130, width: UIScreen.main.bounds.size.width/5 - 20, height: 50)
        undoButton.addTarget(self, action: #selector(undoButtonAction(sender:)), for: .touchDown)
        view.addSubview(undoButton)
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
    
    func drawExpressionBar(){
        equalSign = UILabel(frame: CGRect(x: (view.frame.size.width-CGFloat(50)-100), y: 35, width: 40, height: 30))
        equalSign.text = "     ="
        equalSign.backgroundColor = .systemBackground
        self.view.addSubview(equalSign)

        expressionBar.frame = CGRect(x: 0, y: 0, width: view.frame.size.width-CGFloat(50) - 100, height: 30)
        expressionBar.keyboardType = UIKeyboardType.decimalPad
        expressionBar.center = CGPoint(x: (view.frame.size.width-CGFloat(50)-100)/2 + 20, y: 50)
        expressionBar.layer.cornerRadius=10
        expressionBar.layer.borderWidth=1
        expressionBar.layer.borderColor=UIColor.darkGray.cgColor
        expressionBar.backgroundColor = .yellow
        expressionBar.textAlignment = .center
        expressionBar.text = ""
        
//        expressionBar.isHidden = false
        
        self.view.addSubview(expressionBar)
        
        
        
//        textView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width-CGFloat(50) - 100, height: 80)
//        textView.keyboardType = UIKeyboardType.decimalPad
//        textView.center = CGPoint(x: (view.frame.size.width-CGFloat(50)-100)/2 + 20, y: 50)
//        textView.layer.cornerRadius=10
//        expressionBar.layer.borderWidth=1
//        expressionBar.layer.borderColor=UIColor.darkGray.cgColor
//        expressionBar.backgroundColor = .yellow
//        expressionBar.textAlignment = .center
//        expressionBar.text = ""
//        self.view.addSubview(textView)
        
//        expressionExtendBar = UITextField(frame: CGRect(x: 0, y: 0, width: view.frame.size.width-CGFloat(50) - 100, height: 80))
//        expressionExtendBar.keyboardType = UIKeyboardType.decimalPad
//        expressionExtendBar.center = CGPoint(x: (view.frame.size.width-CGFloat(50)-100)/2 + 20, y: 50+25)
//        expressionExtendBar.layer.cornerRadius=10
//        expressionExtendBar.layer.borderWidth=1
//        expressionExtendBar.layer.borderColor=UIColor.darkGray.cgColor
//        expressionExtendBar.backgroundColor = .systemBackground
//        expressionExtendBar.textAlignment = .center
//        expressionExtendBar.text = ""
//
//        expressionExtendBar.isHidden = true
//
//        self.view.addSubview(expressionExtendBar)
        
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 30))
        doneToolbar.barStyle = .default

        let emptySpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        let leftBracket: UIBarButtonItem = UIBarButtonItem(title: "(", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.leftBracket))
        let rightBracket: UIBarButtonItem = UIBarButtonItem(title: ")", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.rightBracket))
        
        let items = [emptySpace, leftBracket, emptySpace, rightBracket, emptySpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()

        expressionBar.inputAccessoryView = doneToolbar
        expressionBar.addTarget(self, action: #selector(self.floatOperationBar), for: .editingDidBegin)
        expressionBar.addTarget(self, action: #selector(self.updateExpressionBar), for: .editingChanged)
        
        resultLabel = UILabel(frame: CGRect(x: (view.frame.size.width-CGFloat(50)-60), y: 35, width: (view.frame.size.width - (view.frame.size.width-CGFloat(50)-30)), height: 30))
        resultLabel.text = "0"
        resultLabel.backgroundColor = .systemBackground
        self.view.addSubview(resultLabel)
    }
    
    func updateResult() {
        resultLabel.text = backend.result
    }
    
    @objc func updateExpressionBar(){
        backend.calculation(expressionBar.text!)
        updateResult()
    }
    
    @objc func doneButtonAction() {
        expressionBar.resignFirstResponder()
//        expressionBar.text!.append(" ")
        backend.calculation(expressionBar.text!)
//        expressionExtendBar.resignFirstResponder()
//        expressionExtendBar.text!.append(" ")
//        backend.calculation(expressionExtendBar.text!)
        updateResult()
        addButton.frame = CGRect(x: 10, y: UIScreen.main.bounds.size.height - 130, width: UIScreen.main.bounds.size.width/5 - 20, height: 50)
        subButton.frame = CGRect(x: UIScreen.main.bounds.size.width/5 + 10, y: UIScreen.main.bounds.size.height - 130, width: UIScreen.main.bounds.size.width/5 - 20, height: 50)
        multiButton.frame = CGRect(x: UIScreen.main.bounds.size.width/5*2 + 10, y: UIScreen.main.bounds.size.height - 130, width: UIScreen.main.bounds.size.width/5 - 20, height: 50)
        divButton.frame = CGRect(x: UIScreen.main.bounds.size.width/5*3 + 10, y: UIScreen.main.bounds.size.height - 130, width: UIScreen.main.bounds.size.width/5 - 20, height: 50)
        undoButton.frame = CGRect(x: UIScreen.main.bounds.size.width/5*4 + 10, y: UIScreen.main.bounds.size.height - 130, width: UIScreen.main.bounds.size.width/5 - 20, height: 50)
    }
    
    @objc func leftBracket(sender: UIBarButtonItem){
        expressionBar.text?.append(sender.title! + " ")
        backend.calculation(expressionBar.text!)
//        expressionExtendBar.text?.append(sender.title! + " ")
//        backend.calculation(expressionExtendBar.text!)
        updateResult()
    }
    
    @objc func rightBracket(sender: UIBarButtonItem){
        expressionBar.text?.append(" " + sender.title!)
        backend.calculation(expressionBar.text!)
        updateResult()
    }
    
    @objc func floatOperationBar(){
        addButton.frame = CGRect(x: 10, y: UIScreen.main.bounds.size.height - 400, width: UIScreen.main.bounds.size.width/5 - 20, height: 50)
        subButton.frame = CGRect(x: UIScreen.main.bounds.size.width/5 + 10, y: UIScreen.main.bounds.size.height - 400, width: UIScreen.main.bounds.size.width/5 - 20, height: 50)
        multiButton.frame = CGRect(x: UIScreen.main.bounds.size.width/5*2 + 10, y: UIScreen.main.bounds.size.height - 400, width: UIScreen.main.bounds.size.width/5 - 20, height: 50)
        divButton.frame = CGRect(x: UIScreen.main.bounds.size.width/5*3 + 10, y: UIScreen.main.bounds.size.height - 400, width: UIScreen.main.bounds.size.width/5 - 20, height: 50)
        undoButton.frame = CGRect(x: UIScreen.main.bounds.size.width/5*4 + 10, y: UIScreen.main.bounds.size.height - 400, width: UIScreen.main.bounds.size.width/5 - 20, height: 50)
    }
    
    func prepareGestureRecog() {
//        print("prepareGestureRecog Called")
        imgView.isUserInteractionEnabled = true
        let pinchMethod = UIPinchGestureRecognizer(target: self, action: #selector(pinchImage(sender:)))    //Zoom in/out
        let panMethod = UIPanGestureRecognizer(target: self, action: #selector(handlePan(sender:)))         //Move img with two fingers
        let tapMethod = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))         //Tap to select boxes
        panMethod.minimumNumberOfTouches = 2       //Two finger! Not one
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
            point = getTappedPointOnImg(tappedPoint: point)
            backend.deal_with_box()
            expressionBar.text = backend.chcek_box(pts: point, equation: expressionBar.text!)
            backend.calculation(expressionBar.text!)
//            expressionExtendBar.text = backend.chcek_box(pts: point, equation: expressionExtendBar.text!)
//            backend.calculation(expressionExtendBar.text!)
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
            pickerLauncher.showPicker(own_view: view)
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
            
            UIColor.cyan.setStroke()
            drawPath.lineWidth = 5.0
            drawPath.stroke()
        }
        let newImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    //---End of Draw Function---
    
    @objc func signButtonAction(sender: UIButton!) {
        expressionBar.text?.append(" " + sender.titleLabel!.text! + " ")
        backend.calculation(expressionBar.text!)
//        expressionExtendBar.text?.append(sender.titleLabel!.text! + " ")
//        backend.calculation(expressionExtendBar.text!)
        updateResult()
    }
    
    @objc func undoButtonAction(sender: UIButton!) {
        var text = expressionBar.text?.split(separator: " ")
        if text!.count >= 1 {
            text?.removeLast()
            var full_text1 = text?.joined(separator: " ")
            full_text?.append(" ")
            expressionBar.text = full_text
            backend.calculation(expressionBar.text!)
            updateResult()
        }
    }
    //---End Num Button Action---
}
