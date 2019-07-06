//
//  ViewController.swift
//  TVShows
//
//  Created by Krešimir Baković on 04/07/2019.
//  Copyright © 2019 Krešimir Baković. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var myswitch: UISwitch!
    @IBOutlet weak var labela: UILabel!
    @IBOutlet weak var firstNumberOutlet: UITextField!
    @IBOutlet weak var secondNumberOutlet: UITextField!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var sumLabel: UILabel!
    var brojPritisaka = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myswitch.setOn(false, animated: true)
        configureTextFields()
    }
    
    @IBAction func switchChanged(_ sender: UISwitch) {
        let color: UIColor = sender.isOn ? .yellow : .white
        view.backgroundColor = color
        brojPritisaka += 1
        labela.text = "Broj pritisaka: \(brojPritisaka)"
    }
    
    
    func configureTextFields() {
        firstNumberOutlet.delegate = self
        secondNumberOutlet.delegate = self
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        if firstNumberOutlet.text != "" && secondNumberOutlet.text != "" {
            let a = Int(firstNumberOutlet.text!)
            let b = Int(secondNumberOutlet.text!)
            let rez = a! + b!
            sumLabel.text = "Sum: \(rez)"
        }
                }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


