//
//  GameViewController.swift
//  HealthPro
//
//  Created by User on 9/9/22.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    @IBOutlet weak var particleView: SKView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        if let view = self.particleView as! SKView? {
         
         let scene = ParticleScene(size: view.bounds.size) // Создать экземпляр объекта класса GameScene с помощью кода
         
            scene.scaleMode = .aspectFill
         
            view.presentScene(scene)
         
            view.ignoresSiblingOrder = true
         
            view.showsFPS = true
         
            view.showsNodeCount = true
         

    }
}
}
