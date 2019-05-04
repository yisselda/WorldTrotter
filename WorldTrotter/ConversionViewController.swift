//
//  ConversionViewController.swift
//  WorldTrotter
//
//  Created by Yisselda Rhoc on 5/3/19.
//  Copyright © 2019 YR. All rights reserved.
//

import UIKit

class ConversionViewController : UIViewController, UITextFieldDelegate {
    
    let MAXINPUT = 6
    
    @IBOutlet var celsiusLabel: UILabel!
    @IBOutlet var textField: UITextField!
    
    var fahrenheitValue: Measurement<UnitTemperature>? {
        didSet {
            updateCelsiusLabel()
        }
    }
    
    var celsiusValue: Measurement<UnitTemperature>? {
        if let fahrenheitValue = fahrenheitValue {
            return fahrenheitValue.converted(to: .celsius)
        } else {
            return nil
        }
    }
    
//    Closure
    let numberFormatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.minimumFractionDigits = 0
        nf.maximumFractionDigits = 1
        return nf
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateCelsiusLabel()
    }
    
    let colors:  [UIColor] = [.blue, .green, .red, .yellow, .orange, .gray, .black]
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let randNumber = Int.random(in: 0..<colors.count)
        self.view.backgroundColor = colors[randNumber]
    }
    
    @IBAction func fahrenheitFieldEditingChanged(_ textField: UITextField) {
//        if let t = textField.text, let fahrenheit = Int(t) {
//            let celsius = (fahrenheit - 30) / 2
//            celsiusLabel.text = String(celsius)
//        } else {
//            celsiusLabel.text = "--"
//        }
        if let text = textField.text, let value = Double(text) {
            fahrenheitValue = Measurement(value: value, unit: .fahrenheit)
        } else {
            fahrenheitValue = nil
        }
    }
    
    func updateCelsiusLabel() {
        if let celsiusValue = celsiusValue {
//            celsiusLabel.text = "\(celsiusValue)"
            celsiusLabel.text = numberFormatter.string(from: NSNumber(value: celsiusValue.value))
        } else {
            celsiusLabel.text = "--"
        }
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        textField.resignFirstResponder()
    }
    
    func textField(_ textField:  UITextField,
                    shouldChangeCharactersIn range: NSRange,
                    replacementString string: String) -> Bool {
//        print("Current text: \(String(describing: textField.text))")
//        print("Replacement text: \(string)")
//        return true
        
        let existingTextHasDecimalSeparator = textField.text?.range(of: ".")
        let replacementTextHasDecimalSeparator = string.range(of: ".")
        let replacementTextHasAlphabeticCharacters = string.rangeOfCharacter(from: CharacterSet.letters)
        let result = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
        
        
        if existingTextHasDecimalSeparator != nil &&
            replacementTextHasDecimalSeparator != nil ||
            replacementTextHasAlphabeticCharacters != nil ||
            result.count >= MAXINPUT {
                return false
            } else {
                return true
            }
    }
}
