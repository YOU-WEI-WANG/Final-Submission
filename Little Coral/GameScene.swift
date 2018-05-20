//
//  GameScene.swift
//  Little Coral
//
//  Created by YOUWEI WANG on 20/5/18.
//  Copyright © 2018 YOUWEI WANG. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreData

class GameScene: SKScene {
    
    private var coral : SKSpriteNode!
    private var times : TimeInterval = 0
    private var score = 0
    private var level = 0
    private var initialFishCount = 0
    private var scoreLabel : SKLabelNode!
    private var levelLabel : SKLabelNode!
    private var finishedLabel: SKLabelNode!
    private let scoreSet = [5, 10, 15, 20, 25, 35, 45, 55, 65, 70]
    private var max = false
    
    override func didMove(to view: SKView) {
        //set background image
        let bg = SKSpriteNode(imageNamed: "background.jpg")
        bg.position = CGPoint(x: size.width/2, y: size.height/2)
        bg.size = CGSize(width: size.width, height: size.height)
        
        let bed = SKSpriteNode(imageNamed: "bed")
        bed.position = CGPoint(x: size.width/2, y: 45)
        bed.size = CGSize.init(width: size.width, height: 90)
        
        //set coral
        self.coral = SKSpriteNode(imageNamed: "1.png")
        self.coral.name = "coral"
        self.coral.position = CGPoint(x: size.width/2 + 25, y:75)
        self.coral.anchorPoint = CGPoint.init(x: 0.5, y: 0)
        
        //set cloud(it now replacing by the bubbles score image because the first edition is actually setted the cloud as the score background image)
        let cloud = SKSpriteNode(imageNamed: "bubblescrore.png")
        cloud.position = CGPoint(x:size.width/4, y:size.height - 75)
        cloud.size = CGSize(width:size.width/3, height:size.height/12)
        
        
        let cloud2 = SKSpriteNode(imageNamed: "upgradescore.png")
        cloud2.position = CGPoint(x:size.width/4*3, y:size.height - 75)
        cloud2.size = CGSize(width:size.width/3, height:size.height/12)
        
        
        //set score label
        self.scoreLabel = SKLabelNode(text: String(self.score))
        self.scoreLabel.position = CGPoint(x: size.width / 4,
                                           y: size.height - 90)
        self.scoreLabel.fontColor = SKColor.init(red: 165.0/255.0, green: 285.0/255.0, blue: 227.0/255.0, alpha: 1.0)
        self.scoreLabel.fontName = "Marion-Bold"
        //set level score label
        self.levelLabel = SKLabelNode(text: String(self.scoreSet[self.level]))
        self.levelLabel.position = CGPoint(x: size.width / 4 * 3,
                                           y: size.height - 90)
        self.levelLabel.fontColor = SKColor.init(red: 165.0/255.0, green: 285.0/255.0, blue: 227.0/255.0, alpha: 1.0)
        self.levelLabel.fontName = "Marion-Bold"
        //initial finished label
        self.finishedLabel = SKLabelNode(text: "Max Level")
        self.finishedLabel.fontSize = 65
        self.finishedLabel.fontColor = SKColor.black
        self.finishedLabel.position = CGPoint(x: self.size.width/2, y:self.size.height/2)
        //add nodes to scene
        addChild(bg)
        creatSunShine()
        addChild(self.coral)
        addChild(bed)
        addChild(cloud)
        addChild(cloud2)
        addChild(self.scoreLabel)
        addChild(self.levelLabel)
    }

    func creatFish(){
        //the source of each fish
        let images : Array = ["fishGroup1","RedFish","FatFish","WhiteFish","fishGroup2","YellowFish", "Shark"]
        //random generate different fish
        let randomFish : Int = Int(arc4random() % 4)
        
        let textureAlas = SKTextureAtlas.init(named: images[randomFish])
        let fishTexture = SKTexture(imageNamed: "RedFish1")
        let fish = SKSpriteNode(texture: fishTexture)
        fish.name = "fish"
        fish.isUserInteractionEnabled = false
        fish.setScale(0.5)
        // random swim direction
        let direction : Int = Int(arc4random() % 2)
        let randomX = CGFloat(arc4random()).truncatingRemainder(dividingBy: size.height)
        if direction == 0 {
            //Flip the fish horizontally
            fish.xScale = -0.5
            fish.position = CGPoint.init(x: 0, y: randomX)
        }else{
            fish.position = CGPoint.init(x: size.width, y: randomX)
        }
        addChild(fish)

        var arr : Array = [SKTexture]()
        var tempName:String
        for num in textureAlas.textureNames.enumerated() {
            tempName = String(format: "%@%d", images[randomFish],num.offset + 1)
            let dbTexture = textureAlas.textureNamed(tempName)
            arr.append( dbTexture )
        }

        let flyAction = SKAction.animate(with: arr, timePerFrame: 0.15)
        fish.run(SKAction.repeatForever(flyAction))
        //fish move
        if direction == 0 {
            fish.run(SKAction.sequence([SKAction.moveBy(x: size.width + 40, y: 0, duration: TimeInterval(Int(arc4random() % 15) + 5)), SKAction.removeFromParent()]))
        }else{
            fish.run(SKAction.sequence([SKAction.moveBy(x: -size.width - 40, y: 0, duration: TimeInterval(Int(arc4random() % 15) + 5)), SKAction.removeFromParent()]))
        }
    }
    
    //generate the bubbles
    func creatBubble(){
        //generate bubbles
        let bubbleTexture = SKTexture(imageNamed: "bubble")
        let bubble = SKSpriteNode(texture: bubbleTexture)
        bubble.isUserInteractionEnabled = false;
        //random generate the position of bubbules
        let randomX = CGFloat(arc4random()).truncatingRemainder(dividingBy: size.height)
        bubble.position = CGPoint.init(x: randomX, y: 0)
        //scaling bubble texture resources
        bubble.setScale(0.1)
        addChild(bubble)
        //exsiting time for bubbles
        let time = TimeInterval(Int(arc4random() % 15) + 5)
        //bubbles becomes bigger
        let wiggleIn = SKAction.scale(to: 1, duration: time)
        bubble.run(wiggleIn)
        //bubbles move to the top
        bubble.run(SKAction.sequence([SKAction.moveBy(x: 0, y: size.height, duration: time), SKAction.removeFromParent()]))
    }
    
    //create the sinshine
    func creatSunShine(){
        let sunShines = SKEmitterNode.init(fileNamed: "SunShine.sks")
        sunShines?.name = "1111"
        sunShines?.isUserInteractionEnabled = false;
        addChild(sunShines!)
        sunShines?.position = CGPoint(x: size.width/2, y: size.height/2)
        sunShines?.particlePositionRange = CGVector.init(dx: size.width, dy: size.height)
    }
    func update() {
        if let i = self.scoreSet.index(of: score) {
            self.level = i + 1
        }
        
        let levelMax = self.level >= self.scoreSet.count
        
        if !levelMax {
            self.updateLevel(level: self.level)
        }
        
        if levelMax && score == self.scoreSet[self.level - 1] {
            self.max = true
            self.finished()
        }
        
        self.updateScore(score: self.score)
    }
    
    func updateScore(score : Int) {
        self.scoreLabel.text = String(String(score))
    }
    
    func finished() {
        self.addChild(self.finishedLabel)
    }
    
    func updateLevel(level: Int) {
        self.levelLabel.text = String(self.scoreSet[self.level])
        //different lever with different coral shape
        let image = UIImage.init(named: String(level+1) + ".png")
        let size = image?.size
        self.coral.texture = SKTexture(imageNamed: String(level+1) + ".png")
        self.coral.size = size!
    }
    override func update(_ currentTime: TimeInterval) {
        times = times + 1;
        
        //when initial the game, generate 10 fished in the beginning
        if self.initialFishCount < 10{
            creatFish()
            creatBubble()
            self.initialFishCount = self.initialFishCount + 1;
        }
        //contorl the fish and bubbles generate rate, the bigger value the slower the fish and bubbles generate.
        if times > 40 {
            creatFish()
            creatBubble()
            times = 0;
        }
    }
    
    func coralBubble(coral: SKNode, position: CGPoint){
        
        //current group of bubbles, there are 5 bubbles in a group
        var coralBubbleCount = 0
        
        
        
        enumerateChildNodes(withName: "coralBubble") { (node, _) in
            //cauculate the current nubmer of group for bubbles
            coralBubbleCount += 1
        }
        //set maximum groups for bubbles generate
        if coralBubbleCount < 4{
            //if touch coral, generate bubbles
            let bubble = SKEmitterNode.init(fileNamed: "Bubble.sks")
            bubble?.name = "coralBubble"
            addChild(bubble!)
            bubble!.position = CGPoint(x: position.x, y: coral.position.y + coral.frame.size.height/2)
            
            //the bubbles animation, taking 20 seconds
            let waitAction = SKAction.wait(forDuration: 20)
            let removeAtion = SKAction.removeFromParent()
            
            bubble!.run(SKAction.sequence([waitAction,removeAtion]))
            
            //coral scale left-right
            let wiggleIn = SKAction.scaleX(to: 0.9, duration: 0.3)
            let wiggleOut = SKAction.scaleX(to: 1.1, duration: 0.3)
            let wiggleOut1 = SKAction.scaleX(to: 0.9, duration: 0.3)
            let wiggleOut2 = SKAction.scaleX(to: 1.1, duration: 0.3)
            let wiggleOutNormal = SKAction.scaleX(to: 1, duration: 0.3)
            let wiggle1 = SKAction.sequence([wiggleIn, wiggleOut,wiggleOut1,wiggleOut2,wiggleOutNormal])
            coral.run(.repeat(wiggle1, count: 1))
            //coral scale top-bottom
            let wiggleUp = SKAction.scaleY(to: 1.1, duration: 0.3)
            let wiggledown = SKAction.scaleY(to: 0.9, duration: 0.3)
            let wiggledown1 = SKAction.scaleY(to: 1.1, duration: 0.3)
            let wiggledown2 = SKAction.scaleY(to: 0.9, duration: 0.3)
            let wiggledown2No = SKAction.scaleY(to: 1, duration: 0.3)
            let wiggle2 = SKAction.sequence([wiggleUp,wiggledown,wiggledown1,wiggledown2,wiggledown2No])
            coral.run(.repeat(wiggle2, count: 1))
        }
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            //identify is coral area or not base on the touch
            let location = t.location(in: self)
            let coralTemp = atPoint(location)
            if coralTemp.name == "coral"{
                coralBubble(coral: coralTemp, position: location)
            }
            else{
                if !self.max {
                    self.score += 1
                    self.update()
                } else {
                    let location = t.location(in: self)
                    
                    if self.finishedLabel.contains(location) {
                        self.level = 0
                        self.score = 0
                        self.max = false
                        self.update()
                        self.finishedLabel.removeFromParent()
                    }
                }
            }
        }
    }
}

