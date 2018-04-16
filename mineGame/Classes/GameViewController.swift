//
//  GameViewController.swift
//  mineGame
//
//  Created by 石川 雅之 on 2018/04/16.
//  Copyright © 2018 org.masapp. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    private let charactor = UIImageView()
    private let retryLabel = UILabel()
    private let titleLabel = UILabel()
    private let currentNumber = UILabel()
    private let stageInfo = UIImageView()
    private let stageInfoLabel = UILabel()
    
    private var wscale: CGFloat = 0
    private var hscale: CGFloat = 0
    private var squareWidth: CGFloat = 0
    private var squareHeight: CGFloat = 0
    private var groundWidth: CGFloat = 0
    private var groundHeight: CGFloat = 0
    private var stageCount: Int = 0
    private var status: String = ""
    private var map: [[Int]] = []
    
    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let windowSize = UIScreen.main.bounds
        wscale = windowSize.size.width / 320
        hscale = windowSize.size.height / 568
        squareWidth = 21.5 * wscale
        squareHeight = 21.5 * hscale
        groundWidth = squareWidth * 0.975
        groundHeight = squareHeight * 0.975
        
        // background
        let background = UIImageView(frame: UIScreen.main.bounds)
        background.image = UIImage(named: "grass")
        self.view.addSubview(background)
        
        // charactor control button
        let controlRect = CGRect(x: 9.6 * wscale, y: 471 * hscale, width: 96 * wscale, height: 96 * hscale)
        let control = UIImageView(frame: controlRect)
        control.image = UIImage(named: "button_control")
        self.view.addSubview(control)
        
        // chara at say numbers
        let charactorRect = CGRect(x: 166.4 * wscale, y: 471 * hscale, width: 150.4 * wscale, height: 96 * hscale)
        let sayCharactor = UIImageView(frame: charactorRect)
        sayCharactor.image = UIImage(named: "usayuki")
        self.view.addSubview(sayCharactor)
        
        // current number
        currentNumber.frame = CGRect(x: 189 * wscale, y: 465 * hscale, width: 96 * wscale, height: 96 * hscale)
        currentNumber.font = UIFont.systemFont(ofSize: 70 * wscale)
        self.view.addSubview(currentNumber)
        
        // stage info
        stageInfo.frame = CGRect(x: 0, y: 199 * hscale, width: windowSize.size.width, height: 51 * hscale)
        stageInfo.image = UIImage(named: "info")
        stageInfoLabel.frame = CGRect(x: 80 * wscale, y: 0, width: 499 * wscale, height: 51 * hscale)
        stageInfoLabel.font = UIFont.systemFont(ofSize: 30 * wscale)
        stageInfoLabel.textColor = .white
        stageInfo.addSubview(stageInfoLabel)
        
        retryLabel.frame = CGRect(x: 80 * wscale, y: 295 * hscale, width: 99 * wscale, height: 51 * hscale)
        retryLabel.font = UIFont.systemFont(ofSize: 30 * wscale)
        retryLabel.textColor = .white
        retryLabel.text = "retry"
        
        titleLabel.frame = CGRect(x: 202 * wscale, y: 295 * hscale, width: 99 * wscale, height: 51 * hscale)
        titleLabel.font = UIFont.systemFont(ofSize: 30 * wscale)
        titleLabel.textColor = .white
        titleLabel.text = "title"
        
        stageCount = 1
        
        self.stageStart()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self.view)
            
            if status == "play" {
                // up or down
                if 41.5 * wscale <= location.x && location.x <= 75 * wscale {
                    if 475 * hscale <= location.y && location.y <= 505.5 * hscale {
                        charactor.image = UIImage(named: "back")
                        self.moveCharactor(point: CGPoint(x: 0, y: -squareHeight))
                    } else if 535 * hscale <= location.y && location.y <= 565 * hscale {
                        charactor.image = UIImage(named: "front")
                        self.moveCharactor(point: CGPoint(x: 0, y: squareHeight))
                    }
                }
                
                // left or right
                if 505.5 * hscale <= location.y && location.y <= 535 * hscale {
                    if 10 * wscale <= location.x && location.x <= 42 * wscale {
                        charactor.image = UIImage(named: "left")
                        self.moveCharactor(point: CGPoint(x: -squareWidth, y: 0))
                    } else if 77 * wscale <= location.x && location.x <= 105 * wscale {
                        charactor.image = UIImage(named: "right")
                        self.moveCharactor(point: CGPoint(x: squareWidth, y: 0))
                    }
                }
            } else if status == "gameOver" {
                if 312 * hscale <= location.y && location.y <= 340 * hscale {
                    if 80 * wscale <= location.x && location.x <= 145 * wscale {
                        stageCount = 1
                        self.stageStart()
                        retryLabel.removeFromSuperview()
                        titleLabel.removeFromSuperview()
                    } else if 195 * wscale <= location.x && location.x <= 255 * wscale {
                        self.dismiss(animated: false, completion: nil)
                    }
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - private
    private func drawMap(mapArray: [[Int]]) {
        self.drawGround(mapArray: mapArray)
        self.drawFence()
    }
    
    private func drawGround(mapArray: [[Int]]) {
        // draw ground
        for i in 0 ..< mapArray.count {
            for j in 0 ..< mapArray[i].count {
                // ground
                let groundRect = CGRect(x: squareWidth * CGFloat(j + 1), y: squareHeight * CGFloat(i + 1), width: groundWidth, height: groundHeight)
                let ground = UIImageView(frame: groundRect)
                ground.image = UIImage(named: "soil")
                self.view.addSubview(ground)
            }
        }
    }
    
    private func drawFence() {
        // left top corner
        let leftTopRect = CGRect(x: 0, y: 0, width: groundWidth, height: groundHeight)
        let leftTopCorner = UIImageView(frame: leftTopRect)
        leftTopCorner.image = UIImage(named: "left_top_corner")
        self.view.addSubview(leftTopCorner)
        
        // right top corner
        let rightTopRect = CGRect(x: squareWidth * 14, y: 0, width: groundWidth, height: groundHeight)
        let rightTopCorner = UIImageView(frame: rightTopRect)
        rightTopCorner.image = UIImage(named: "right_top_corner")
        self.view.addSubview(rightTopCorner)
        
        // left under corner
        let leftUnderRect = CGRect(x: 0, y: squareHeight * 21, width: groundWidth, height: groundHeight)
        let leftUnderCorner = UIImageView(frame: leftUnderRect)
        leftUnderCorner.image = UIImage(named: "left_under_corner")
        self.view.addSubview(leftUnderCorner)
        
        // right under corner
        let rightUnderRect = CGRect(x: squareWidth * 14, y: squareHeight * 21, width: groundWidth, height: groundHeight)
        let rightUnderCorner = UIImageView(frame: rightUnderRect)
        rightUnderCorner.image = UIImage(named: "right_under_corner")
        self.view.addSubview(rightUnderCorner)
        
        // height
        for i in 0 ..< 20 {
            let leftHeightRect = CGRect(x: 0, y: squareHeight * CGFloat(i + 1), width: groundWidth, height: groundHeight)
            let leftHeight = UIImageView(frame: leftHeightRect)
            leftHeight.image = UIImage(named: "height")
            self.view.addSubview(leftHeight)
            
            let rightHeightRect = CGRect(x: squareWidth * 14, y: squareHeight * CGFloat(i + 1), width: groundWidth, height: groundHeight)
            let rightHeight = UIImageView(frame: rightHeightRect)
            rightHeight.image = UIImage(named: "height")
            self.view.addSubview(rightHeight)
        }
        
        // width
        for i in 0 ..< 5 {
            let leftTopRect = CGRect(x: squareWidth * CGFloat(i + 1), y: 0, width: groundWidth, height: groundHeight)
            let leftTopWidth = UIImageView(frame: leftTopRect)
            leftTopWidth.image = UIImage(named: "width")
            self.view.addSubview(leftTopWidth)
            
            let rightTopRect = CGRect(x: squareWidth * CGFloat(i + 9), y: 0, width: groundWidth, height: groundHeight)
            let rightTopWidth = UIImageView(frame: rightTopRect)
            rightTopWidth.image = UIImage(named: "width")
            self.view.addSubview(rightTopWidth)
            
            let leftUnderRect = CGRect(x: squareWidth * CGFloat(i + 1), y: squareHeight * 21, width: groundWidth, height: groundHeight)
            let leftUnderWidth = UIImageView(frame: leftUnderRect)
            leftUnderWidth.image = UIImage(named: "width")
            self.view.addSubview(leftUnderWidth)
            
            let rightUnderRect = CGRect(x: squareWidth * CGFloat(i + 9), y: squareHeight * 21, width: groundWidth, height: groundHeight)
            let rightUnderWidth = UIImageView(frame: rightUnderRect)
            rightUnderWidth.image = UIImage(named: "width")
            self.view.addSubview(rightUnderWidth)
        }
        
        // start and end
        for i in 0 ..< 2 {
            let leftEndRect = CGRect(x: squareWidth * 8, y: squareHeight * CGFloat(21 * i), width: groundWidth, height: groundHeight)
            let leftEnd = UIImageView(frame: leftEndRect)
            leftEnd.image = UIImage(named: "left_end")
            self.view.addSubview(leftEnd)
            
            let rightEndRect = CGRect(x: squareWidth * 6, y: squareHeight * CGFloat(21 * i), width: groundWidth, height: groundHeight)
            let rightEnd = UIImageView(frame: rightEndRect)
            rightEnd.image = UIImage(named: "right_end")
            self.view.addSubview(rightEnd)
            
            let flatRect = CGRect(x: squareWidth * 7, y: squareHeight * CGFloat(21 * i), width: groundWidth, height: groundHeight)
            let flat = UIImageView(frame: flatRect)
            flat.image = UIImage(named: "grass")
            self.view.addSubview(flat)
        }
    }
    
    // put the charactor to the start position
    private func setCharactor() {
        charactor.frame = CGRect(x: squareWidth * 7, y: squareHeight * 21, width: groundWidth, height: groundHeight)
        charactor.image = UIImage(named: "back")
        self.view.addSubview(charactor)
    }
    
    private func moveCharactor(point: CGPoint) {
        let nowPoint = charactor.frame.origin
        if self.moveValidate(point: point) {
            return
        }
        
        // charactor move
        charactor.frame.origin.x = nowPoint.x + point.x
        charactor.frame.origin.y = nowPoint.y + point.y
        
        if charactor.frame.origin.x == squareWidth * 7 && round(charactor.frame.origin.y) == 0 {
            self.stageComplete()
            return
        }
        
        // check bomb
        self.checkBomb(point: charactor.frame.origin)
    }
    
    private func moveValidate(point: CGPoint) -> Bool {
        let nowPoint = charactor.frame.origin
        
        // start position
        if nowPoint.x == squareWidth * 7 && nowPoint.y == squareHeight * 21 {
            if point.x != 0 {
                return true
            }
        }
        
        // left validate
        if nowPoint.x <= squareWidth && point.x == -squareWidth {
            return true
        }
        
        // right validate
        if round(nowPoint.x) >= round(squareWidth * 13) && point.x == squareWidth {
            return true
        }
        
        // down validate
        if nowPoint.y >= squareHeight * 20 && point.y == squareHeight {
            return true
        }
        
        // up validate
        if round(nowPoint.y) <= round(squareHeight) && point.y == -squareHeight {
            if nowPoint.x != squareWidth * 7 || round(nowPoint.y) != round(squareHeight) {
                return true
            }
        }
        
        return false
    }
    
    private func stageStart() {
        // disable touch events
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        let mapGenerator = MapGenerator()
        map = mapGenerator.towDimensionalArrayForMap()
        
        self.drawMap(mapArray: map)
        
        // put the charactor to the start position
        self.setCharactor()
        
        // current square number init
        currentNumber.text = ""
        
        // show next stage count
        self.view.addSubview(self.stageInfo)
        self.stageInfoLabel.text = "stage \(stageCount) start"
        
        // timer to hide stage info
        Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(hideStartInfo), userInfo: nil, repeats: false)
    }
    
    private func stageComplete() {
        // disable touch events
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        // show stage clear info
        self.view.addSubview(stageInfo)
        stageInfoLabel.text = "stage \(stageCount) clear"
        
        stageCount += 1

        // timer to hide clear info
        Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(hideClearInfo), userInfo: nil, repeats: false)
    }
    
    private func getSquareNumber(point: CGPoint) -> Int {
        let i = Int(point.y / squareHeight - 1)
        let j = Int(point.x / squareWidth - 1)
        return self.map[i][j]
    }
    
    private func checkBomb(point: CGPoint) {
        let squareNumber = self.getSquareNumber(point: point)
        if squareNumber == -1 {
            self.view.addSubview(stageInfo)
            stageInfoLabel.text = "game over"
            status = "gameOver"
            
            self.view.addSubview(retryLabel)
            self.view.addSubview(titleLabel)
        } else {
            // current square number
            currentNumber.text = String(squareNumber)
            
            // bomb count
            let bombCount = UIImageView(frame: CGRect(x: point.x, y: point.y, width: groundWidth, height: groundHeight))
            bombCount.image = UIImage(named: String(squareNumber))
            self.view.addSubview(bombCount)
            self.view.bringSubview(toFront: charactor)
        }
    }
    
    // MARK: - @objc function
    @objc private func hideStartInfo() {
        // enable touch events
        UIApplication.shared.endIgnoringInteractionEvents()
        stageInfo.removeFromSuperview()
        status = "play"
    }
    
    @objc private func hideClearInfo() {
        // enable touch events
        UIApplication.shared.endIgnoringInteractionEvents()
        stageInfo.removeFromSuperview()
        
        // start next stage
        self.stageStart()
    }
}