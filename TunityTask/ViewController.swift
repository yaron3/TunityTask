//
//  ViewController.swift
//  TunityTask
//
//  Created by user on 21/01/2018.
//  Copyright © 2018 YJ corp. All rights reserved.
//

import UIKit

protocol DataUpdate {
    func updateBuffer(buffer: CVPixelBuffer)
}

protocol DataViewUpdate {
    func updateImage(image: UIImage)

}
class ViewController: UIViewController, DataViewUpdate {
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    private var model:CameraModel?
    private var buttonTapped = false
    override func viewDidLoad() {
        super.viewDidLoad()
        model = CameraViewModel(delegate: self).model
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        model?.start()
        startButton.setTitle("Start", for: UIControlState.normal)
        buttonTapped = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        model?.stop()
    }
    
    @IBAction func startTapped(_ sender: Any) {
        if buttonTapped {
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ColorViewController") as? ColorViewController
            {
                vc.model = model
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else {
            startButton.setTitle("Results", for: UIControlState.normal)
            model?.startCollectingData()
            buttonTapped = true
        }
    }
    
    func updateImage(image: UIImage) {
        self.imageView.image = image
    }


}

