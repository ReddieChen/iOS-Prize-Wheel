
import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var wRatio:CGFloat! = 0, hRatio:CGFloat! = 0
    var redCotton, redCottonShadow, adCircle, adCircleShadow, prizeCircle, pointer, pointerShadow: SKSpriteNode!
    var redCottonPosY:CGFloat = 600
    var adCirclePosX:CGFloat = 225, adCirclePosY:CGFloat = 410
    var prizeCirclePosX:CGFloat = 225, prizeCirclePosY:CGFloat = 410
    var pointerPosX:CGFloat = 225, pointerPosY:CGFloat = 410
    var phase = 0
    var delta:CGFloat = 0
    
    override func didMove(to view: SKView) {
        wRatio = frame.size.width / 450
        hRatio = frame.size.height / 800
        anchorPoint = CGPoint(x: 0, y: 1)
        initBackground()
        initRedCotton()
        initCircle()
    }
    
    func initBackground() {
        let background = SKSpriteNode(imageNamed: "background")
        background.size.width = 450 * wRatio
        background.size.height = 800 * hRatio
        background.anchorPoint = CGPoint(x: 0, y: 1)
        background.position = CGPoint(x: 0, y: 0)
        background.zPosition = 1
        addChild(background)
    }
    
    func initRedCotton() {
        redCottonShadow = SKSpriteNode(imageNamed: "red-cotton-shadow")
        redCottonShadow.size.width = 450 * wRatio
        redCottonShadow.size.height = 800 * hRatio
        redCottonShadow.anchorPoint = CGPoint(x: 0, y: 1)
        redCottonShadow.position = CGPoint(x: 0, y: redCottonPosY * hRatio)
        redCottonShadow.zPosition = 10
        addChild(redCottonShadow)
        redCotton = SKSpriteNode(imageNamed: "red-cotton")
        redCotton.size.width = 450 * wRatio
        redCotton.size.height = 800 * hRatio
        redCotton.anchorPoint = CGPoint(x: 0, y: 1)
        redCotton.position = CGPoint(x: 0, y: redCottonPosY * hRatio)
        redCotton.zPosition = 11
        addChild(redCotton)
    }
    
    func initCircle() {
        // AD cirlce
        adCircleShadow = SKSpriteNode(imageNamed: "ad-circle-shadow")
        adCircleShadow.size.width = 420 * wRatio
        adCircleShadow.size.height = 420 * hRatio
        adCircleShadow.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        adCircleShadow.position = CGPoint(x: adCirclePosX * wRatio, y: -adCirclePosY * hRatio)
        adCircleShadow.zPosition = 2
        addChild(adCircleShadow)
        adCircle = SKSpriteNode(imageNamed: "ad-circle")
        adCircle.size.width = 420 * wRatio
        adCircle.size.height = 420 * hRatio
        adCircle.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        adCircle.position = CGPoint(x: adCirclePosX * wRatio, y: -adCirclePosY * hRatio)
        adCircle.zPosition = 3
        addChild(adCircle)
        adCircle.run(SKAction.repeatForever(SKAction.rotate(byAngle: -CGFloat(M_PI), duration: 200.0)), withKey: "adCircle")
        // Prize
        prizeCircle = SKSpriteNode(imageNamed: "prize-circle")
        prizeCircle.size.width = 250 * wRatio
        prizeCircle.size.height = 250 * hRatio
        prizeCircle.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        prizeCircle.position = CGPoint(x: prizeCirclePosX * wRatio, y: -prizeCirclePosY * hRatio)
        prizeCircle.zPosition = 4
        addChild(prizeCircle)
        // Pointer
        pointerShadow = SKSpriteNode(imageNamed: "pointer-shadow")
        pointerShadow.size.width = 150 * wRatio
        pointerShadow.size.height = 150 * hRatio
        pointerShadow.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        pointerShadow.position = CGPoint(x: pointerPosX * wRatio, y: -pointerPosY * hRatio)
        pointerShadow.zPosition = 5
        addChild(pointerShadow)
        pointer = SKSpriteNode(imageNamed: "pointer")
        pointer.size.width = 150 * wRatio
        pointer.size.height = 150 * hRatio
        pointer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        pointer.position = CGPoint(x: pointerPosX * wRatio, y: -pointerPosY * hRatio)
        pointer.zPosition = 6
        addChild(pointer)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if phase == 0 {
            phase = 1
        } else if phase == 1 {
            phase = 2
        } else if phase == 4 {
            let action = SKAction.moveTo(y: redCottonPosY * hRatio, duration: 0.3)
            redCotton.run(action)
            redCottonShadow.run(action) {
                self.phase = 0
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func update(_ currentTime: TimeInterval) {
        if phase == 1 {
            delta = delta + 0.75
            prizeCircle.zRotation = prizeCircle.zRotation + delta * CGFloat(M_PI / 180)
            if delta > 40 {
                delta = 40
                pointer.zRotation = random(min: -5, max: 5) * CGFloat(M_PI / 180)
                prizeCircle.position = CGPoint(x: (prizeCirclePosX + random(min: -2, max: 2)) * wRatio, y: -(prizeCirclePosY + random(min: -2, max: 2)) * hRatio)
            }
        } else if phase == 2 {
            delta = delta - 0.5
            prizeCircle.zRotation = prizeCircle.zRotation + delta * CGFloat(M_PI / 180)
            pointer.zRotation = 0
            prizeCircle.position = CGPoint(x: prizeCirclePosX * wRatio, y: -prizeCirclePosY * hRatio)
            if delta < 0 {
                delta = 0
                phase = 3
                let action = SKAction.sequence([SKAction.wait(forDuration: 2.0), SKAction.moveTo(y: 0, duration: 0.3)])
                redCotton.run(action)
                redCottonShadow.run(action) {
                    self.phase = 4
                }
            }
        }
    }
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
}
