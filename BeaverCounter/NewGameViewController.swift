//
//  NewGameViewController.swift
//  Beaver Counter
//
//  Copyright © 2020 Roger Wetzel. All rights reserved.
//

import Foundation
import UIKit

class NewGameViewController: UIViewController {
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet var numberOfPlayerButtons: [UIButton]!

    var selectedButtonIndex: Int?
    
    let smallScaleFactor: CGFloat = 0.5
    let largeScaleFactor: CGFloat = 1.0
    
    override func viewWillAppear(_ animated: Bool) {
        // Hide OK button if nothing is preselected
        okButton.isHidden = true
        
        for button in numberOfPlayerButtons {
            button.transform = CGAffineTransform(scaleX: smallScaleFactor, y: smallScaleFactor)
        }
        
        if let index = selectedButtonIndex {
            numberOfPlayerButtons[index].transform = CGAffineTransform(scaleX: largeScaleFactor, y: largeScaleFactor)
            okButton.isHidden = false
        }
        
        super.viewWillAppear(animated)
    }

    @IBAction func selectNumberOfPlayers(_ sender: Any) {
        let button: UIButton = sender as! UIButton
        
        playSelectSound()
        
        // Make previous selected button (digit) small
        if let index = selectedButtonIndex {
            UIView.animate(withDuration: 0.2, animations: {
                let button = self.numberOfPlayerButtons[index]
                button.transform = CGAffineTransform(scaleX: self.smallScaleFactor, y: self.smallScaleFactor)
            }, completion: nil)
        }

        // Make selected button (digit) large
        selectedButtonIndex = button.tag
        if let index = selectedButtonIndex {
            UIView.animate(withDuration: 0.2, animations: {
                let button = self.numberOfPlayerButtons[index]
                button.transform = CGAffineTransform(scaleX: self.largeScaleFactor, y: self.largeScaleFactor)
                }, completion: nil)
        }
        
        okButton.isHidden = false
    }
    
    func playSelectSound() {
        SoundPlayer.play("/System/Library/Audio/UISounds/nano/3rdParty_Success_Haptic.caf")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "cancel" {
            SoundPlayer.play("/System/Library/Audio/UISounds/jbl_cancel.caf")
        } else if segue.identifier == "ok" {
            SoundPlayer.play("/System/Library/Audio/UISounds/health_notification.caf")

            theGame().numberOfPlayers = selectedButtonIndex! + 2
            theGame().round = 1
        }
    }

    func theGame() -> Game {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.game
    }
}
