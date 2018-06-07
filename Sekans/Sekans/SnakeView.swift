import UIKit

protocol SnakeViewDelegate {
    func computerSnakeForSnakeView(_ view:SnakeView) -> Snake?
    
	func snakeForSnakeView(_ view:SnakeView) -> Snake?
	//func pointOfFruitForSnakeView(_ view:SnakeView) -> Point?
    func pointOfFruitForSnakeView(_ view:SnakeView) -> [Point]?
}

class SnakeView : UIView {
	var delegate:SnakeViewDelegate?

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.backgroundColor = UIColor.white
	}

    func isHeadHitBody() -> Bool {
        if let snake:Snake = delegate?.snakeForSnakeView(self) {
            if snake.isHeadHitBody() {
                return true
            }
            
            let worldSize = snake.worldSize
            let tileSizeWidth = self.bounds.size.width
            let tileSizeHeight = self.bounds.size.height
            
            if worldSize <= 0 {
                return true
            }
            let w = Int(Float(tileSizeWidth) / Float(worldSize))
            let h = Int(Float(tileSizeHeight) / Float(worldSize))
            
            if snake.points[0].x * w <= 0 || snake.points[0].x * w >= Int(self.frame.width) {
                return true
            }
            if snake.points[0].y * h <= 0 || snake.points[0].y * h >= Int(self.frame.maxY) {
                return true
            }
        }
        
        return false
    }
    
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.backgroundColor = UIColor.white
	}

	override func draw(_ rect: CGRect) {
		super.draw(rect)

        // 背景色
        UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.00).set()
        UIBezierPath(rect: rect).fill()

        if let computer: Snake = delegate?.computerSnakeForSnakeView(self) {
            let worldSize = computer.worldSize
            let tileSizeWidth = self.bounds.size.width
            let tileSizeHeight = self.bounds.size.height
            
            if worldSize <= 0 {
                return
            }
            let w = Int(Float(tileSizeWidth) / Float(worldSize))
            let h = Int(Float(tileSizeHeight) / Float(worldSize))
            
            UIColor(red:0.20, green:0.20, blue:0.20, alpha:1.00).set()
            let points = computer.points
            for (_, point) in points.enumerated() {
                let rect = CGRect(x: point.x * w, y: point.y * h, width: w, height: h)
                UIBezierPath(rect: rect).fill()
            }
        }
        
		if let snake:Snake = delegate?.snakeForSnakeView(self) {
			let worldSize = snake.worldSize
            let tileSizeWidth = self.bounds.size.width
            let tileSizeHeight = self.bounds.size.height

			if worldSize <= 0 {
				return
			}

			let w = Int(Float(tileSizeWidth) / Float(worldSize))
			let h = Int(Float(tileSizeHeight) / Float(worldSize))

			UIColor(red:0.01, green:0.53, blue:0.88, alpha:1.00).set()
			let points = snake.points
			for (index, point) in points.enumerated() {
                if index == 0 {
                    UIColor(red:0.00, green:0.71, blue:0.44, alpha:1.00).set()
                } else {
                    UIColor(red:0.01, green:0.53, blue:0.88, alpha:1.00).set()
                }
				let rect = CGRect(x: point.x * w, y: point.y * h, width: w, height: h)
				UIBezierPath(rect: rect).fill()
			}

//            if let fruit = delegate?.pointOfFruitForSnakeView(self) {
//                UIColor(red:0.93, green:0.31, blue:0.30, alpha:1.00).set()
//                let rect = CGRect(x: fruit.x * w, y: fruit.y * h, width: w, height: h)
//                print(rect)
//                UIBezierPath(ovalIn: rect).fill()
//            }
            
            if let fruits = delegate?.pointOfFruitForSnakeView(self) {
                for fruit in fruits {
                    UIColor(red:0.93, green:0.31, blue:0.30, alpha:1.00).set()
                    let rect = CGRect(x: fruit.x * w, y: fruit.y * h, width: w, height: h)
                    //print(rect)
                    UIBezierPath(ovalIn: rect).fill()
                }
            }
        }
	}
}
