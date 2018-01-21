//
//  CameraModel.swift
//  TunityTask
//
//  Created by user on 21/01/2018.
//  Copyright © 2018 YJ corp. All rights reserved.
//

import Foundation
import AVFoundation

class CameraModel: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    private(set) var colorsData = [UInt32]()
    private var shouldCollectColor = false
    var session: AVCaptureSession?
    private let delegate: DataUpdate
    
      init(delegate: DataUpdate) {
        self.delegate = delegate
        
    }
    
    func createSession() {
        if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) == .authorized {
            createSessionInternal()
        } else {
            AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
                
                if response {
                    self.createSessionInternal()
                    
                } else {
                    
                }
            }
        }
    }
    private func createSessionInternal() {
    
        //access granted
        self.session = AVCaptureSession()
        
        let device =  AVCaptureDevice.default(AVCaptureDevice.DeviceType.builtInWideAngleCamera,
                                              for: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
        var input: AVCaptureDeviceInput?
        do {
            input = try AVCaptureDeviceInput(device: device!)
        } catch _ {
            NSLog("error creating capture")
        }
        self.session!.addInput(input!)
        
        let output = AVCaptureVideoDataOutput()
        output.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
        
        output.setSampleBufferDelegate(self, queue: DispatchQueue.main)
        self.session!.addOutput(output)
        
    }

    
    
     func start() {
        if let session = self.session {
            session.startRunning()
        } else {
            createSession()
            session?.startRunning()
        }
    }
     func stop() {
        if let session = self.session {
            session.stopRunning()
        }
    }
    
    func startCollectingData() {
        colorsData.removeAll()
        shouldCollectColor = true
    }
    // MARK: AVCaptureVideoDataOutputSampleBufferDelegate
    
    func captureOutput(_ output: AVCaptureOutput, didDrop sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
    }
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)!


        delegate.updateBuffer(buffer: pixelBuffer)
        
        if (shouldCollectColor) {
            let color = currentCenterImageColor(sampleBuffer: sampleBuffer)
            
            colorsData.append(color)
            NSLog(String(color, radix: 16, uppercase: true))
        }
    }
    
    // MARK: hepler function
    func currentCenterImageColor(sampleBuffer: CMSampleBuffer)-> UInt32 {
        let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)!
        CVPixelBufferLockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0));
        let int32Buffer = unsafeBitCast(CVPixelBufferGetBaseAddress(pixelBuffer), to: UnsafeMutablePointer<UInt32>.self)
        let int32PerRow = CVPixelBufferGetBytesPerRow(pixelBuffer)
        let height = CVPixelBufferGetHeight(pixelBuffer)
        let width = CVPixelBufferGetWidth(pixelBuffer)
        
        // Get BGRA of center of frame
        let center = (Int(height/2 * int32PerRow/4) + width/2)
        let luma = int32Buffer[center]
        CVPixelBufferUnlockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
        return luma
    }
}
