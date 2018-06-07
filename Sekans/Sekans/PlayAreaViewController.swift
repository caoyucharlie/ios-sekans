//
//  PlayAreaViewController.swift
//  Sekans
//
//  Created by Yu cao on 11/30/17.
//  Copyright © 2017 Yu cao. All rights reserved.
//

import UIKit

class PlayAreaViewController: UIViewController {
    
    var snakeView: SnakeView?
    var timer: Timer?
    var computerTimer : Timer?
    var snake: Snake?
    
    var computerSnake: Snake?
//    var fruit: Point?
    
    var config = PointConfig()
    var fruits: [Point] = []
    
    var playerName = "Player1"  //名字
    var gameOverMessage = "You Win!"
    
    var winNumber: Int = 0 {
        didSet {
            self.scoreLabel.text = "Score:" + String(self.winNumber)
        }
    }
    
    @IBOutlet weak var upButton: UIButton!
    @IBOutlet weak var downButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    var settingsVC : ConfigViewController? = nil
    var gameOverVC : GameOverViewController? = nil
    var scoresVC : ScoresViewController? = nil
    
    var lostNb : Int = 0
    var winNb : Int = 0
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let height = self.view.frame.size.height - 64 - 54
        let width = self.view.frame.size.width
        let snakeFrame = CGRect(x: Int(0), y: Int(64), width: Int(width), height: Int(width))
        
        self.snakeView = SnakeView(frame: snakeFrame)
        self.view.insertSubview(self.snakeView!, at: 0)
        
        if let view = self.snakeView {
            view.delegate = self
        }
        
        view.isMultipleTouchEnabled = true
        
        upButton.layer.cornerRadius = 1.0
        downButton.layer.cornerRadius = 1.0
        leftButton.layer.cornerRadius = 1.0
        rightButton.layer.cornerRadius = 1.0
        
        let viewController1 = navigationController?.viewControllers[0]
        settingsVC = viewController1 as? ConfigViewController
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "setting", style: .done, target: self, action: #selector(goSetting))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.startGame()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.timer?.invalidate()
        self.timer = nil
        
        self.computerTimer?.invalidate()
        self.computerTimer = nil
    }

    @IBAction func upButtonHandler(_ sender: AnyObject) {
        if (self.snake?.changeDirection(Direction.up) != nil) {
            self.snake?.lockDirection()
        }
        setDefaultColors(false)
    }
    
    @IBAction func downButtonHandler(_ sender: AnyObject) {
        if (self.snake?.changeDirection(Direction.down) != nil) {
            self.snake?.lockDirection()
        }
        setDefaultColors(false)
    }
    
    @IBAction func leftButtonHandler(_ sender: AnyObject) {
        if (self.snake?.changeDirection(Direction.left) != nil) {
            self.snake?.lockDirection()
        }
        setDefaultColors(true)
    }
    
    @IBAction func rightButtonHandler(_ sender: AnyObject) {
        if (self.snake?.changeDirection(Direction.right) != nil) {
            self.snake?.lockDirection()
        }
        setDefaultColors(true)
    }
    
    func setDefaultColors(_ isUpDown : Bool) {
        if (isUpDown) {
            upButton.isEnabled = true
            downButton.isEnabled = true
            rightButton.isEnabled = false
            leftButton.isEnabled = false
        } else {
            rightButton.isEnabled = true
            leftButton.isEnabled = true
            upButton.isEnabled = false
            downButton.isEnabled = false
        }
    }
    
    @objc func goSetting() {
        performSegue(withIdentifier: "toSettingsScores", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        
        if(segue.identifier == "toSettingsScores") {
            let tabBarController = segue.destination as? UITabBarController
            let tabBarControllerArray = tabBarController!.viewControllers
            
            let viewController1 = tabBarControllerArray?[1]
            settingsVC = viewController1 as? ConfigViewController
            settingsVC!.playerName = playerName
            
            let viewControllerSc = tabBarControllerArray?[0]
            scoresVC = viewControllerSc as? ScoresViewController
            scoresVC!.name = playerName
            scoresVC!.lostNb = lostNb
            scoresVC!.winNb = winNb
            scoresVC!.gameController = self
        } else {
            gameOverVC = segue.destination as? GameOverViewController
            gameOverVC!.gameOverMessage = gameOverMessage
            gameOverVC!.gameController = self
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if touches.count >= 2 {
            
            performSegue(withIdentifier: "toSettingsScores", sender: self)
        } else if touches.count == 1 {
            
        }
    }
    
    
    func makeNewFruit() {
        srandomdev()
        let worldSize = self.snake!.worldSize
        var x = 0, y = 0
        while (true) {
            x = Int(arc4random_uniform(UInt32(worldSize)))
            y = Int(arc4random_uniform(UInt32(worldSize)))
            var isBody = false
            for p in self.snake!.points {
                if p.x == x && p.y == y {
                    isBody = true
                    break
                }
            }
            if !isBody {
                break
            }
        }
        //self.fruit = Point(x: x, y: y)
        self.fruits.append(Point(x: x, y: y))
    }
    
    
    func startGame() {
        if (self.timer != nil) {
            return
        }
        
        let height = self.view.frame.size.width
        let worldSize = Int(height.truncatingRemainder(dividingBy: 100))
        self.snake = Snake(inSize: worldSize, length: 2)
        
        self.computerSnake = Snake(inSize: worldSize, length: 2)
        self.computerSnake?.direction  = .down
        setDefaultColors(true)
        //self.makeNewFruit()
        
        winNumber = 0
        
        self.fruits.removeAll()
        for _ in 0..<config.enemiesNumber {
            self.makeNewFruit()
        }
        
        self.timer = Timer.scheduledTimer(timeInterval: TimeInterval(self.config.speed), target: self, selector: #selector(timerMethod(_:)), userInfo: nil, repeats: true)
        
        self.computerTimer = Timer.scheduledTimer(timeInterval: TimeInterval(self.config.speed * 4), target: self, selector: #selector(timerCompMove), userInfo: nil, repeats: true)
        
        self.snakeView!.setNeedsDisplay()
    }
    
    @objc func timerCompMove() {
        if arc4random_uniform(5) == 2 {
            if (self.computerSnake?.changeDirection(Direction.random()) != nil) {
                self.computerSnake?.lockDirection()
            }
        }
        
        self.computerSnake?.move()
        self.computerSnake?.unlockDirection()
    }
    
    func endGame() {
        var win = true
        gameOverMessage = "Game Over!"
        
        if (win) {
            winNb = winNb + 1
        }
        
        performSegue(withIdentifier: "gameOverScreen", sender: self)
        
        self.timer?.invalidate()
        self.timer = nil
        self.computerTimer?.invalidate()
        self.computerTimer = nil
    }
    
    @objc func timerMethod(_ timer:Timer) {
        self.snake?.move()
        
        
        
        //let headHitBody = self.snake?.isHeadHitBody()
        let headHitBody = self.snakeView?.isHeadHitBody()
        if headHitBody == true {
            self.endGame()
            return
        }
        
        let head = self.snake?.points[0]
//        if head?.x == self.fruit?.x &&  head?.y == self.fruit?.y {
//            self.snake!.increaseLength(2)
//            self.makeNewFruit()
//        }
        
        for (index, fruit) in self.fruits.enumerated() {
            if head?.x == fruit.x &&  head?.y == fruit.y {
                self.snake!.increaseLength(2)
                self.fruits.remove(at: index)
                self.makeNewFruit()
                winNumber += 1
                
                break
            }
        }
        
        self.snake?.unlockDirection()
        
        self.snakeView!.setNeedsDisplay()
    }

    // 重新开始
    func restartGame(_ isFromConfig: Bool) {
        startGame()
    }
    
    func openScores() {
        print("Opeing Scores")
        performSegue(withIdentifier: "toSettingsScores", sender: self)
    }
    
    func changeSettingsAndRestart(_ playerName: String, speed: Float, snakeWidth: Int, enemiesNb: Int) {   //名字，速度，大小，点数量
        self.playerName = playerName
        self.config.speed = speed
        self.config.pointWidth = snakeWidth
        self.config.enemiesNumber = enemiesNb
        
        restartGame(true)
    }
}

extension PlayAreaViewController: SnakeViewDelegate {
    func computerSnakeForSnakeView(_ view:SnakeView) -> Snake? {
        return computerSnake
    }
    func snakeForSnakeView(_ view:SnakeView) -> Snake? {
        return self.snake
    }
//    func pointOfFruitForSnakeView(_ view:SnakeView) -> Point? {
//        return self.fruit
//    }
    func pointOfFruitForSnakeView(_ view:SnakeView) -> [Point]? {
        return self.fruits
    }
}
