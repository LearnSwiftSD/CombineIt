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
    var cancellables = Cancellables()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameField.delegate = textFieldHandler
        setUpStyle()
        // bind Publishers here
        bindPublishers()
    }
    
    // MARK: - Publishers
    
    lazy var redSliderValue: SharedPublisher<Float, Never> = {
        redSlider.publisher(for: .valueChanged)
            .map { $0.value }
            .prepend(0.0)
            .removeDuplicates()
            .eraseToAnyPublisher()
            .share()
    }()
    
    lazy var greenSliderValue: SharedPublisher<Float, Never> = {
        greenSlider.publisher(for: .valueChanged)
            .map { $0.value }
            .prepend(0.0)
            .removeDuplicates()
            .eraseToAnyPublisher()
            .share()
    }()
    
    lazy var blueSliderValue: SharedPublisher<Float, Never> = {
        blueSlider.publisher(for: .valueChanged)
            .map { $0.value }
            .prepend(0.0)
            .removeDuplicates()
            .eraseToAnyPublisher()
            .share()
    }()
    
    lazy var sliderValues: SharedPublisher<Color.Values, Never> = {
        Publishers.CombineLatest3(
            redSliderValue,
            greenSliderValue,
            blueSliderValue
        )
        .print("Sliders")
        .map(Color.Values.init)
        .eraseToAnyPublisher()
        .share()
    }()
    
    var colorName: AnyPublisher<String, Never> {
        nameField.publisher(for: .editingChanged)
            .compactMap { $0.text }
            .print("Text Entered")
            .eraseToAnyPublisher()
    }
    
    var keyboardWillShowNotification: AnyPublisher<Notification, Never> {
        NotificationCenter.default
            .publisher(for: UIResponder.keyboardWillShowNotification)
            .print("keyboardWillShow")
            .eraseToAnyPublisher()
    }
    
    var keyboardWillHideNotification: AnyPublisher<Notification, Never> {
        NotificationCenter.default
            .publisher(for: UIResponder.keyboardWillHideNotification)
            .print("keyboardWillHide")
            .eraseToAnyPublisher()
    }
    
    // MARK: - Subscriptions
    
    func bindPublishers() {
        
        sliderValues
            .supply(to: colorView.input.color)
            .store(in: &cancellables)
        
        redSliderValue
            .map(Color.toDecimal)
            .map(String.init)
            .supply(to: redValue.input.text)
            .store(in: &cancellables)
        
        greenSliderValue
            .map(Color.toDecimal)
            .map(String.init)
            .supply(to: greenValue.input.text)
            .store(in: &cancellables)
        
        blueSliderValue
            .map(Color.toDecimal)
            .map(String.init)
            .supply(to: blueValue.input.text)
            .store(in: &cancellables)
        
        sliderValues
            .map { $0.hex }
            .supply(to: hexValueLabel.input.text)
            .store(in: &cancellables)
        
        // TextField Text Validator for beginning with "Fav "
        colorName
            .map { $0.hasPrefix("Fav ") }
            .removeDuplicates()
            .map { $0 ? UIColor.green : UIColor.red }
            .supply(to: nameField.input.textColor)
            .store(in: &cancellables)
        
        keyboardWillShowNotification
            .supply(to: keyboardWillShow)
            .store(in: &cancellables)
        
        keyboardWillHideNotification
            .supply(to: keyboardWillHide)
            .store(in: &cancellables)
    }
    
    func setUpStyle() {
        let pHolderText = NSAttributedString(
            string: "Enter Color Name",
            attributes: [
                .font : UIFont.futuraMedium(pt: 18),
                .foregroundColor : UIColor.lightGray])
        nameField.attributedPlaceholder = pHolderText
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
    
    var keyboardWillShow: (Notification) -> Void {
        return { [weak self] in
            guard
                let self = self,
                let keyboardFrame = ($0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
                else { return }
            self.keyboardClearance(up: true, by: keyboardFrame.height)
        }
    }
    
    var keyboardWillHide: (Notification) -> Void {
        return { [weak self] _ in
            guard let self = self else { return }
            self.keyboardClearance(up: false)
        }
    }
    
}

