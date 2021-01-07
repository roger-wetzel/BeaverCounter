//
//  Player.swift
//  Beaver Counter
//
//  Copyright © 2020 Roger Wetzel. All rights reserved.
//

import Foundation
import UIKit

class Player {
    var score: Int
    var scoreOfRound: Int?
    
    private var digitImages: [UIImage] = [] // TODO make static
    
    func updateScore(_ scoreStackView: UIStackView) {
        updateScoreImageViews(scoreStackView, self.score)
    }
    
    func updateScoreOfRound(_ scoreStackView: UIStackView) {
        updateScoreImageViews(scoreStackView, self.scoreOfRound!)
    }
    
    func updateScoreImageViews(_ scoreStackView: UIStackView, _ value: Int) {
        guard value >= 0 && value <= 999 else {
            return
        }
        var index = 3 - 1
        var number = value
        while index >= 0 {
            let digit = number % 10
            let imageView = scoreStackView.arrangedSubviews[index] as! UIImageView
            imageView.image = digitImages[digit]
            imageView.isHidden = false
            index -= 1
            number /= 10
            
            if number == 0 {
                break // No leading zeros
            }
        }
        
        // Hide unused (leading) digits
        while index >= 0 {
            let imageView = scoreStackView.arrangedSubviews[index] as! UIImageView
            imageView.isHidden = true
            index -= 1
        }
    }
    
    func initDigitImages() {
        for index in 0...9 {
            digitImages.append(UIImage(named: "digit_" + String(index))!)
        }
    }

    func addUpScore() {
        if let summand = scoreOfRound {
            score += summand
        }
    }
    
    init() {
        self.score = 0
        initDigitImages()
    }
}
