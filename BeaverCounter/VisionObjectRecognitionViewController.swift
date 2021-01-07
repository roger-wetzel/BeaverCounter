//
//  VisionObjectRecognitionViewController.swift
//  Beaver Counter
//
//  Copyright © 2020 Roger Wetzel. All rights reserved.
//

import UIKit
import AVFoundation
import Vision

class VisionObjectRecognitionViewController: ViewController {
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var playerStackView: UIStackView!

    var forceHideOkButton = false
    var currentPlayer = 1
    var lastValidScore: Int?
    
    private var detectionOverlay: CALayer! = nil
    
    // Vision parts
    private var requests = [VNRequest]()
    
    @discardableResult
    func setupVision() -> NSError? {
        // Setup Vision parts
        let error: NSError! = nil
        
        guard let modelURL = Bundle.main.url(forResource: "Detector", withExtension: "mlmodelc") else {
            return NSError(domain: "VisionObjectRecognitionViewController", code: -1, userInfo: [NSLocalizedDescriptionKey: "Model file is missing"])
        }
        do {
            let visionModel = try VNCoreMLModel(for: MLModel(contentsOf: modelURL))
            let objectRecognition = VNCoreMLRequest(model: visionModel, completionHandler: { (request, error) in
                DispatchQueue.main.async(execute: {
                    // Perform all the UI updates on the main queue
                    if let results = request.results {
                        self.handleVisionRequestResults(results)
                    }
                })
            })
            self.requests = [objectRecognition]
        } catch let error as NSError {
            print("Model loading went wrong: \(error)")
        }
        
        return error
    }

    func handleVisionRequestResults(_ results: [Any]) {
        guard results.count == 4 else {
            self.lastValidScore = nil
            hideScoreAndOkButton(true)
            return
        }
        
        let labels = ["0": 0, "1": 1, "2": 2, "3": 3, "4": 4,
                      "5": 5, "6": 6, "7": 7, "8": 8, "9": 9,
                      "S": -1, "T": -1, "Z": -1]
        
        var score = 0
        for observation in results where observation is VNRecognizedObjectObservation {
            guard let objectObservation = observation as? VNRecognizedObjectObservation else {
                score = -1
                break
            }
            let topLabelObservation = objectObservation.labels[0]
            if topLabelObservation.confidence > 0.91 {
                let summand = labels[topLabelObservation.identifier]!
                if summand == -1 {
                    score = -1
                    break
                }
                score += summand
            } else {
                score = -1
                break
            }
        }

        // There are 4 cards but the score is not confident enough.
        // Let's assume that the user is still scanning the same set of 4 cards and
        // the last valid score. This keeps the score display away from flickering.
        if score < 0 && lastValidScore != nil {
            score = lastValidScore!
        }

        if score >= 0 {
            let playerIndex = currentPlayer - 1
            theGame().players[playerIndex].scoreOfRound = score
            let scoreStackView = playerStackView.arrangedSubviews[1] as! UIStackView
            theGame().players[playerIndex].updateScoreOfRound(scoreStackView)
            hideScoreAndOkButton(false)
            lastValidScore = score
        } else {
            hideScoreAndOkButton(true)
        }
    }

    func hideScoreAndOkButton(_ value: Bool) {
        let scoreStackView = playerStackView.arrangedSubviews[1] as! UIStackView
        scoreStackView.isHidden = value

        if forceHideOkButton {
            okButton.isHidden = true
        } else {
            okButton.isHidden = value
        }
    }
    
    func updatePlayerName() {
        let playerNameImageView = playerStackView.arrangedSubviews[0] as! UIImageView
        playerNameImageView.image = UIImage(named: "p" + String(currentPlayer))
    }
    
    override func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        
        let exifOrientation = exifOrientationFromDeviceOrientation()
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: exifOrientation, options: [:])
        do {
            try imageRequestHandler.perform(self.requests)
        } catch {
            print(error)
        }
    }
    
    override func setupAVCapture() {
        super.setupAVCapture()
        
        // Setup Vision parts
        setupVision()
        
        currentPlayer = 1
        updatePlayerName()
        hideScoreAndOkButton(true)
        
        // TODO Preview layer should not hide these UI elements
        view.bringSubviewToFront(playerStackView)
        view.bringSubviewToFront(cancelButton)
        view.bringSubviewToFront(okButton)

        // Start the capture
        startCaptureSession()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "cancel" {
            SoundPlayer.play("/System/Library/Audio/UISounds/jbl_cancel.caf")
        } else if segue.identifier == "ok" {
            SoundPlayer.play("/System/Library/Audio/UISounds/health_notification.caf")
        }
    }

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "cancel" {
            return true
        }
        
        if currentPlayer >= theGame().numberOfPlayers! {
            theGame().addUpScores()
            theGame().nextRound()
            return true // All score scans done. Go to home screen.
        }

        currentPlayer += 1 // Next player
        updatePlayerName()

        // Prevent double Ok button taps
        forceHideOkButton = true
        Timer.scheduledTimer(withTimeInterval: 1.2, repeats: false) { timer in
            self.forceHideOkButton = false
        }

        hideScoreAndOkButton(true)
        SoundPlayer.play("/System/Library/Audio/UISounds/payment_success.caf")
        return false
    }
    
    func theGame() -> Game {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.game
    }
}
