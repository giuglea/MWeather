//
//  ChangeCity.swift
//  MWeather
//
//  Created by Andrei Giuglea on 01/04/2019.
//  Copyright © 2019 Andrei Giuglea. All rights reserved.
//


import UIKit


class ChangeCity: UIViewController {
    
    var delegate : ChangeCityDelegate?
    
    @IBOutlet weak var selectLabel: UIButton!
    @IBOutlet weak var changeCityTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectLabel.layer.cornerRadius = 15
    }
    
    
    @IBAction func sendData(_ sender: Any) {
        let cityName : String = changeCityTextField.text!
        delegate?.sendCityName(city: cityName)
        self.dismiss(animated: true, completion: nil)
        
    }
    
}


protocol ChangeCityDelegate {
    func sendCityName(city:String)
}
