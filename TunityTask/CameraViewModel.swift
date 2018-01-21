//
//  CameraViewModel.swift
//  TunityTask
//
//  Created by user on 21/01/2018.
//  Copyright © 2018 YJ corp. All rights reserved.
//

import Foundation
import UIKit


class CameraViewModel: DataUpdate {
    func updateBuffer(buffer: CVPixelBuffer) {
        let ciimage : CIImage = CIImage(cvPixelBuffer: buffer)
        let image : UIImage = self.convert(cmage: ciimage)
        delegate.updateImage(image: image)

    }
    // Convert CIImage to UIImage
    func convert(cmage:CIImage) -> UIImage
    {
        let context:CIContext = CIContext.init(options: nil)
        let cgImage:CGImage = context.createCGImage(cmage, from: cmage.extent)!
        let image:UIImage = UIImage.init(cgImage: cgImage, scale: 1.0, orientation: UIImageOrientation.right)
        return image
    }
    lazy var model: CameraModel = CameraModel(delegate: self)
    private let delegate: DataViewUpdate
    init(delegate: DataViewUpdate){
        self.delegate = delegate
    }
}
