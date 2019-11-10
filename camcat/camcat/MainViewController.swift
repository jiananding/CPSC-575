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
    
    var expressionBar:UITextField!
    var operatorBarItem:[UIButton]! //Order: 0.Plus, 1.Minus, 2.Multiply, 3.Divide, 4.Undo
    var addButton:UIButton!
    var subButton:UIButton!
    var multiButton:UIButton!
    var divButton:UIButton!
    var undoButton:UIButton!
    var equalSign:UILabel!
    var resultLabel:UILabel!
    var num_stack: UIScrollView!
    var backGround:UILabel!
        
    var backend = BackEnd()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
        prepareGestureRecog()
        
        backend.read()
        imgView.image = drawRectangleOnImage(image: imgData)
        create_num_stack()
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
        
        multiButton = getOperator(title: "*", x: UIScreen.main.bounds.size.width/5*2 + 10, y: UIScreen.main.bounds.size.height - 130, width: UIScreen.main.bounds.size.width/5 - 20, height: 50)
        multiButton.addTarget(self, action: #selector(signButtonAction), for: .touchDown)
        view.addSubview(multiButton)
        
        divButton = getOperator(title: "/", x: UIScreen.main.bounds.size.width/5*3 + 10,
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
//        backGround = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.size.width-CGFloat(50), height: 30))
//        backGround.backgroundColor = .systemBackground
//        backGround.text = "abc"
//        self.view.addSubview(backGround)
        equalSign = UILabel(frame: CGRect(x: (view.frame.size.width-CGFloat(50)-100), y: 35, width: 40, height: 30))
        equalSign.text = "     ="
        equalSign.backgroundColor = .systemBackground
        self.view.addSubview(equalSign)

        expressionBar = UITextField(frame: CGRect(x: 0, y: 0, width: view.frame.size.width-CGFloat(50) - 100, height: 30))
        expressionBar.keyboardType = UIKeyboardType.decimalPad
        expressionBar.center = CGPoint(x: (view.frame.size.width-CGFloat(50)-100)/2 + 20, y: 50)
        expressionBar.layer.cornerRadius=10
        expressionBar.layer.borderWidth=1
        expressionBar.layer.borderColor=UIColor.darkGray.cgColor
        expressionBar.backgroundColor = .systemBackground
        expressionBar.textAlignment = .center
        expressionBar.text = ""
        self.view.addSubview(expressionBar)
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 30))
        doneToolbar.barStyle = .default

        let emptySpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))

        let items = [emptySpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()

        expressionBar.inputAccessoryView = doneToolbar
        
        
        resultLabel = UILabel(frame: CGRect(x: (view.frame.size.width-CGFloat(50)-60), y: 35, width: (view.frame.size.width - (view.frame.size.width-CGFloat(50)-30)), height: 30))
        resultLabel.text = "0"
        resultLabel.backgroundColor = .systemBackground
        self.view.addSubview(resultLabel)
    }
    
    func updateResult() {
        resultLabel.text = backend.result
    }
    
    @objc func doneButtonAction() {
        expressionBar.resignFirstResponder()
        expressionBar.text!.append(" ")
        backend.calculation(expressionBar.text!)
        updateResult()
    }
    
    func prepareGestureRecog() {
        print("prepareGestureRecog Called")
        imgView.isUserInteractionEnabled = true
        let pinchMethod = UIPinchGestureRecognizer(target: self, action: #selector(pinchImage(sender:)))    //Zoom in/out
        let panMethod = UIPanGestureRecognizer(target: self, action: #selector(handlePan(sender:)))         //Move img with two fingers
        let tapMethod = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))         //Tap to select boxes
        panMethod.minimumNumberOfTouches = 2       //Two finger! Not one
        imgView.addGestureRecognizer(pinchMethod)
        imgView.addGestureRecognizer(panMethod)
        imgView.addGestureRecognizer(tapMethod)

        let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(screenEdgeSwiped))   //Swipe Screenedge to pop Mainview
        edgePan.edges = .left
        view.addGestureRecognizer(edgePan)
    }
    
    //---Gesture Recognition Methods Start---
    @objc func pinchImage(sender: UIPinchGestureRecognizer) {                                                //Zoom in / out
        if let scale = (sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale)) {
            print("Pinch Detected")
            print("The size of imgView is \(imgView.frame.size)")
            guard scale.a > 1.0 else {return}
            guard scale.d > 1.0 else {return}
            sender.view?.transform = scale
            sender.scale = 1.0
        }
    }
    
    @objc func handlePan(sender: UIPanGestureRecognizer) {                                                     //Move image with two fingers
        print("2-finger Pan Detedted")
        print("The center of imgView is \(imgView.center)")
        print("The coordinator of imgView is \(imgView.frame.origin)")
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
            print("Tap Detected")
            print("You are tapping \(sender.location(in: self.view))")
        }
    }
    
    @objc func screenEdgeSwiped(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        print("Screenedge-swipe Detected")
        if recognizer.state == .recognized {
            self.navigationController?.popViewController(animated: true) //Pop current page
            backend.box_position.removeAll()
        }
    }
    
    //---Gesture Recognition Methods End---

    //---Draw Box For Text Recognion---
    func drawRectangleOnImage(image: UIImage) -> UIImage {
        let imageSize = image.size
        let scale: CGFloat = 0
        UIGraphicsBeginImageContextWithOptions(imageSize, false, scale)
        image.draw(at: CGPoint.zero)
        for position in backend.box_position {
            let drawPath = UIBezierPath()
            // Starting point (left-up corner)
            let leftUp = CGPoint(x: position.origin.x * imageSize.width, y: (CGFloat(1.0) - position.origin.y) * imageSize.height - position.height * imageSize.height)
            // Right-up corner
            let rightUp = CGPoint(x: position.origin.x * imageSize.width + imageSize.width * position.width, y: (CGFloat(1.0) - position.origin.y) * imageSize.height - position.height * imageSize.height)
            // Right-down corner
            let rightDown = CGPoint(x: position.origin.x * imageSize.width + imageSize.width * position.width, y: (CGFloat(1.0) - position.origin.y) * imageSize.height - position.height * imageSize.height + position.height * imageSize.height)
            // Ending point (left-down corner)
            let leftDown = CGPoint(x: position.origin.x * imageSize.width, y: (CGFloat(1.0) - position.origin.y) * imageSize.height - position.height * imageSize.height + position.height * imageSize.height)
            
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

    //---Add Num Button Action---
    func create_num_stack() {
        num_stack = UIScrollView(frame: CGRect(x: 0, y: view.frame.height * 0.75, width: UIScreen.main.bounds.size.width, height: 50))
        num_stack.sizeToFit()
        num_stack.layoutIfNeeded()
        num_stack.backgroundColor = .systemBackground
        var contentWidth: CGFloat = 0.0
        
        let length = backend.value.count
        let width = (num_stack.frame.width / CGFloat(5.0))
        for i in 0..<length {
            contentWidth += width
            let num_button = UIButton(type: .system)
            num_button.tag = i
            num_button.frame = CGRect(x: width * CGFloat(i) , y: 0, width: width, height: 50)
            num_button.setTitle(String(backend.value[i]), for: .normal)
            num_button.addTarget(self, action: #selector(buttonAction), for: .touchDown)
//            num_button.backgroundColor = UIColor.darkGray
            num_stack.addSubview(num_button)
        }
        num_stack.contentSize = CGSize(width: contentWidth, height: 50)
        self.view.addSubview(num_stack)
    }
    
    @objc func buttonAction(sender: UIButton!) {
        expressionBar.text?.append(sender.titleLabel!.text! + " ")
        backend.calculation(expressionBar.text!)
        updateResult()
    }
    
    @objc func signButtonAction(sender: UIButton!) {
        expressionBar.text?.append(sender.titleLabel!.text! + " ")
        backend.calculation(expressionBar.text!)
        updateResult()
    }
    
    @objc func undoButtonAction(sender: UIButton!) {
        var text = expressionBar.text?.split(separator: " ")
        if text!.count >= 1 {
            text?.removeLast()
            var full_text = text?.joined(separator: " ")
            full_text?.append(" ")
            expressionBar.text = full_text
            backend.calculation(expressionBar.text!)
            updateResult()
        }
    }
    //---End Num Button Action---
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


}
