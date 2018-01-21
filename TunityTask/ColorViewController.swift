//
//  ColorViewController.swift
//  TunityTask
//
//  Created by user on 21/01/2018.
//  Copyright © 2018 YJ corp. All rights reserved.
//

import Foundation
import UIKit
class ColorViewController: UIViewController {
    var model: CameraModel?
    
    @IBOutlet weak var frameLabel: UILabel!
    @IBOutlet weak var frameColorSlider: UISlider!
    @IBAction func colorFrameSliderChanged(_ sender: UISlider) {
        let frameIndex = Int(sender.value) 
        frameLabel.text = "\(frameIndex)"

        if let colorsData = model?.colorsData {
            
        let hexint = colorsData[frameIndex]
        let red = CGFloat((hexint & 0xff0000) >> 16) / 255.0
        let green = CGFloat((hexint & 0xff00) >> 8) / 255.0
        let blue = CGFloat((hexint & 0xff) >> 0) / 255.0
        
        // Create color object, specifying alpha as well
        let color = UIColor(red: red, green: green, blue: blue, alpha: 1)
            self.colorView.backgroundColor = color
        }
    }
    
    @IBOutlet weak var colorView: UIView!
    
    override func viewWillAppear(_ animated: Bool) {
        frameColorSlider.minimumValue = 0
        if let colorsData = model?.colorsData {
        frameColorSlider.maximumValue = Float(colorsData.count - 1)
        }
        frameLabel.text = "0"
    }
}
