//
//  ColorController.swift
//  Combine Colors
//
//  Created by Stephen Martinez on 8/17/19.
//  Copyright © 2019 Stephen Martinez. All rights reserved.
//

import UIKit
import Combine

class ColorController: UIViewController {
    
    @IBOutlet weak var colorView: ColorView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var hexValueLabel: UILabel!
    
    @IBOutlet weak var redValue: UILabel!
    @IBOutlet weak var greenValue: UILabel!
    @IBOutlet weak var blueValue: UILabel!
    
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    
    let textFieldHandler = TextFieldHandler()
    
    // Make a `Cancellables` storage here
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameField.delegate = textFieldHandler
        setUpStyle()
        subscribeToKeyboardNotifications()
        // bind Publishers here
    }
    
    // MARK: - Publishers
    
    // Make Some Publishers here
    
    // MARK: - Subscriptions
    
    func bindPublishers() {
        // Make Some Subscriptions here
    }
    
    @IBAction func didChangeColor(_ sender: Any) {
        updateUI(
            red: redSlider.value,
            green: greenSlider.value,
            blue: blueSlider.value
        )
    }
    
    func setUpStyle() {
        let pHolderText = NSAttributedString(
            string: "Enter Color Name",
            attributes: [
                .font : UIFont.futuraMedium(pt: 18),
                .foregroundColor : UIColor.lightGray])
        nameField.attributedPlaceholder = pHolderText
    }
    
    func updateUI(red: Float, green: Float, blue: Float) {
        let colorValues = Color.Values(red: red, green: green, blue: blue)
        colorView.shiftTo(colorValues)
        redValue.text = String(colorValues.red)
        greenValue.text = String(colorValues.green)
        blueValue.text = String(colorValues.blue)
        hexValueLabel.text = colorValues.hex
    }
    
}

// MARK: - Keyboard Management
extension ColorController {
    
    private func keyboardClearance(up: Bool, by: CGFloat? = nil) {
        if up {
            guard let clearance = by else { return }
            UIView.animate(
                withDuration: 1,
                delay: 0,
                options: [ .curveEaseOut ],
                animations: { [weak view] in view?.frame.origin.y = 0 - clearance} )
        } else {
            UIView.animate(
                withDuration: 1,
                delay: 0,
                options: [ .curveEaseOut ],
                animations: { [weak view] in view?.frame.origin.y = 0 } )
        }
    }
    
    @objc
    func keyboardWillShow(_ notification: Notification) {
        let frame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        guard let keyboardFrame = frame else { return }
        keyboardClearance(up: true, by: keyboardFrame.height)
    }
    
    @objc
    func keyboardWillHide(_ notification: Notification) {
        keyboardClearance(up: false)
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification, object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
}

