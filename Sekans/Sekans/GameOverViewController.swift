//
//  ConfigViewController.swift
//  Sekans
//
//  Created by Yu cao on 11/30/17.
//  Copyright © 2017 Yu cao. All rights reserved.
//


import UIKit

class GameOverViewController: UIViewController {
    
    @IBOutlet weak var gameOverLabel: UILabel!
    
    var gameOverMessage : String = ""
    var gameController : PlayAreaViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameOverLabel.text = gameOverMessage
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func restartButtonHandler(_ sender: AnyObject) {
        self.dismiss(animated: false, completion: nil)
        gameController!.restartGame(false)
    }
    
    @IBAction func scoresButtonHandler(_ sender: AnyObject) {
        self.dismiss(animated: false, completion: nil)
        gameController!.openScores()
    }
}



