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
    
    static let sbid = "ColorSaveController"
    weak var colorRequestor: ColorRetrievable?
    
    var cancellables = Cancellables()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameField.delegate = self
        setUpStyle()
        subscribeToKeyboardNotifications()
        bindPublishers()
    }
    
    func bindPublishers() {
        
        let redSliderValue = redSlider
            .publisher(for: .valueChanged)
            .map { $0.value }
            .prepend(0.0)
            .removeDuplicates()
        
        let greenSliderValue = greenSlider
            .publisher(for: .valueChanged)
            .map { $0.value }
            .prepend(0.0)
            .removeDuplicates()
        
        let blueSliderValue = blueSlider
            .publisher(for: .valueChanged)
            .map { $0.value }
            .prepend(0.0)
            .removeDuplicates()
        
        let sliderValues = Publishers
            .CombineLatest3(
                redSliderValue,
                greenSliderValue,
                blueSliderValue
        )
        
        let colorName = nameField
            .publisher(for: .editingChanged)
            .compactMap { $0.text }
        
        sliderValues
            .print("Sliders")
            .supply(to: colorView.input.color)
            .store(in: &cancellables)
        
        redSliderValue
            .map(ColorHelper.toDecimal)
            .map(String.init)
            .supply(to: redValue.input.text)
            .store(in: &cancellables)
        
        greenSliderValue
            .map(ColorHelper.toDecimal)
            .map(String.init)
            .supply(to: greenValue.input.text)
            .store(in: &cancellables)
        
        blueSliderValue
            .map(ColorHelper.toDecimal)
            .map(String.init)
            .supply(to: blueValue.input.text)
            .store(in: &cancellables)
        
        sliderValues
            .map(ColorHelper.toDecimalRGB)
            .map(ColorHelper.toHexRGB)
            .supply(to: hexValueLabel.input.text)
            .store(in: &cancellables)
        
        colorName
            .print("Text Entered")
            .map { $0.hasPrefix("Fav ") }
            .removeDuplicates()
            .map { $0 ? UIColor.green : UIColor.red }
            .supply(to: nameField.input.textColor)
            .store(in: &cancellables)
    }
    
    @IBAction func didChangeColor(_ sender: Any) {
//        updateUI(
//            red: redSlider.value,
//            green: greenSlider.value,
//            blue: blueSlider.value)
    }
    
    
    @IBAction func cancelColor(_ sender: Any) {
    
    }
    
    @IBAction func saveColor(_ sender: Any) {
        let color = FavColor(
            r: redSlider.value,
            g: greenSlider.value,
            b: blueSlider.value,
            name: nameField.text)
        colorRequestor?.didSave(color: color)
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
        colorView.shiftTo(red, green, blue)
        let decimal = ColorHelper.toDecimalRGB(r: red, g: green, b: blue)
        self.redValue.text = String(decimal.red)
        self.greenValue.text = String(decimal.green)
        self.blueValue.text = String(decimal.blue)
        self.hexValueLabel.text = ColorHelper.toHexRGB(r: decimal.red, g: decimal.green, b: decimal.blue)
    }
    
}

// MARK: - Textfield Management
extension ColorController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
                animations: { [view] in view?.frame.origin.y = 0 - clearance} )
        } else {
            UIView.animate(
                withDuration: 1,
                delay: 0,
                options: [ .curveEaseOut ],
                animations: { [view] in view?.frame.origin.y = 0 } )
        }
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        keyboardClearance(up: true, by: keyboardFrame.height)
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        keyboardClearance(up: false)
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

