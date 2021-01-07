//
//  HomeViewController.swift
//  Beaver Counter
//
//  Copyright © 2020 Roger Wetzel. All rights reserved.
//

import Foundation
import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var scanButton: UIButton!
    @IBOutlet weak var roundStackView: UIStackView!
    @IBOutlet var scoreStackViews: [UIStackView]!

    override func viewWillAppear(_ animated: Bool) {
        hideShowPlayers()
        updateScores()
        updateRound()
        updateScanButton()
        
        super.viewWillAppear(animated)
    }

    func hideShowPlayers() {
        var num: Int = 0
        if let temp = theGame().numberOfPlayers {
            num = temp
        }
        
        for index in 0..<scoreStackViews.count {
            let isHidden = index >= num
            scoreStackViews[index].isHidden = isHidden
        }
    }
    
    func updateScores() {
        var index = 0
        for player in theGame().players {
            player.updateScore(scoreStackViews[index].arrangedSubviews[1] as! UIStackView)
            index += 1
        }
    }
    
    func updateRound() {
        if let round = theGame().round {
            if theGame().isEndOfGame() {
                roundStackView.isHidden = true
            } else {
                let roundNumberImageView = roundStackView.arrangedSubviews[1] as! UIImageView
                roundNumberImageView.image = UIImage(named: "digit_" + String(round))
                roundStackView.isHidden = false
            }
        } else {
            roundStackView.isHidden = true
        }
    }
    
    func updateScanButton() {
        scanButton.isHidden = theGame().numberOfPlayers == nil
        
        if theGame().isEndOfGame() {
            scanButton.isHidden = true
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newGame" {
            SoundPlayer.play("/System/Library/Audio/UISounds/health_notification.caf")

            if let numberOfPlayers = theGame().numberOfPlayers {
                let destinationViewController = segue.destination as! NewGameViewController
                destinationViewController.selectedButtonIndex = numberOfPlayers - 2 // Preset
            }
        } else if segue.identifier == "scan" {
            SoundPlayer.play("/System/Library/Audio/UISounds/health_notification.caf")
        }
    }

    func theGame() -> Game {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.game
    }
}
