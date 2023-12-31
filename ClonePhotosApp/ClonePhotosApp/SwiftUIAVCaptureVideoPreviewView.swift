//
//  ClonePhotosAppApp.swift
//  ClonePhotosApp
//
//  Created by Daniela Turiello on 20/11/23.
//


import SwiftUI
import AVFoundation
import Vision

class UIAVCaptureVideoPreviewView: UIView, AVCaptureVideoDataOutputSampleBufferDelegate {
    // AVCaptureVideoDataOutputSampleBufferDelegate
    // when you want to handle the video input every second, you will add the delegate
    var recognitionInterval = 0 //Interval for object recognition
    
    var mlModel: VNCoreMLModel? // CoreML model
    
    var captureSession: AVCaptureSession!
    
    var resultLabel: UILabel!
    
    func setModel() {
        
        // create instance, model property
        mlModel = try? VNCoreMLModel(for: PhotosApp_1().model)
    }
    
    func setupSession() {
        captureSession = AVCaptureSession()
        captureSession.beginConfiguration()
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        
        guard let videoInput = try? AVCaptureDeviceInput(device: videoCaptureDevice) else { return }
        guard captureSession.canAddInput(videoInput) else { return }
        captureSession.addInput(videoInput)
        
        // Output settings
        let output = AVCaptureVideoDataOutput()
        output.setSampleBufferDelegate(self, queue: DispatchQueue(label: "VideoQueue")) // set delegate to receive the data every frame
        if captureSession.canAddOutput(output) {
            captureSession.addOutput(output)
        }
        
        captureSession.commitConfiguration()
        
    }
    
    func setupPreview() {
        self.frame = CGRect(x: 0, y: -50, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
        previewLayer.frame = self.frame
  
        self.layer.addSublayer(previewLayer)
        
        
        resultLabel = UILabel()
        resultLabel.text = ""
        resultLabel.frame = CGRect(x: 30, y: UIScreen.main.bounds.height - 290, width: UIScreen.main.bounds.width - 60, height: 80)
       
        resultLabel.textColor = UIColor.black
        resultLabel.textAlignment = NSTextAlignment.center
        resultLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
        resultLabel.backgroundColor = UIColor(red: 255, green: 255, blue: 255, alpha: 0.7)
        
        self.addSubview(resultLabel)
        resultLabel.layer.cornerRadius = 25
        resultLabel.layer.masksToBounds = true
        DispatchQueue.global(qos: .background).async {
            self.captureSession.startRunning()
        }
        
    }
    
    // captureOutput will be called for each frame was written
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        // Recognise the object every 20 frames
        if recognitionInterval < 20 {
            recognitionInterval += 1
            //stampare il risultato e usarlo per leggerlo tramite accessibilità
//            let testoPerAccessibilità: String = String(recognitionInterval)
//            print(testoPerAccessibilità)
            return
        }
        recognitionInterval = 0
            
        
        // Convert CMSampleBuffer(an object holding media data) to CMSampleBufferGetImageBuffer
        guard
            let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer),
            let model = mlModel // Unwrap the mlModel
        else { return }
        
        // Create image process request, pass model and result
        let request = VNCoreMLRequest(model: model) { //An image analysis request that uses a Core ML model to process images.
            
            (request: VNRequest, error: Error?) in
            
            // Get results as VNClassificationObservation array
            guard let results = request.results as? [VNClassificationObservation] else { return }
            
            // top 5 results
            var displayText = ""
            for result in results.prefix(5) {
                displayText += "\(Int(result.confidence * 100))%" + result.identifier + "\n"
            }
            
            print(displayText)
            // Execute it in the main thread
            DispatchQueue.main.async {
                self.resultLabel.text = displayText
            }
        }
        
        // Execute the request
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
    }
}

struct SwiftUIAVCaptureVideoPreviewView: UIViewRepresentable {
    
    func makeUIView(context: Context) -> UIAVCaptureVideoPreviewView {
        let view = UIAVCaptureVideoPreviewView()
        view.setModel()
        view.setupSession()
        view.setupPreview()
        return view
    }
    
    func updateUIView(_ uiView: UIAVCaptureVideoPreviewView, context: Context) {
    }
}
