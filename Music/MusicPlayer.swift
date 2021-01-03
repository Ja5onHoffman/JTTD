//
//  MusicPlayuer.swift
//  JTTD
//
//  Created by Jason Hoffman on 12/29/20.
//  Copyright © 2020 Jason Hoffman. All rights reserved.
//

import Foundation
import AVFoundation
import SpriteKit

class MusicPlayer: SKNode {
    
    static let shared = MusicPlayer()
    var audioPlayer: AVAudioPlayer?
    var explosionPlayer = AVAudioPlayer()
    
    let explosions = [
        "Blown Transformer.wav",
        "Bombed Explosion.wav",
        "Burst Fireworks.wav",
        "Cataclysmic Explosive.wav",
        "Catastrophic Explosive.wav",
        "Clysmic Explosion.wav",
        "Deep Fireworks.wav",
        "Explosive Nova.wav",
        "Heat Waves Explosion.wav",
        "Nova Explosion.wav",
        "Roar Nova Explosion.wav",
        "Shock Blast.wav",
        "ShockWav Explosion.wav",
        "Short Explosion.wav",
    ]
    
    func startBackgroundMusic(_ title: String) {
        if let bundle = Bundle.main.path(forResource: title, ofType: "mp3") {
            let backgroundMusic = NSURL(fileURLWithPath: bundle)
            do {
                audioPlayer = try AVAudioPlayer(contentsOf:backgroundMusic as URL)
                guard let audioPlayer = audioPlayer else { return }
                audioPlayer.setVolume(0.7, fadeDuration: 1.0)
                audioPlayer.numberOfLoops = -1
                audioPlayer.prepareToPlay()
                audioPlayer.play()
            } catch {
                print(error)
            }
        }
    }
    
    func addExplosionTo(_ node: SKNode, atPostion position: CGPoint) {
        let title = explosions.randomElement()
        let explosion = SKAudioNode(fileNamed: title!)
        explosion.isPositional = true
        explosion.autoplayLooped = false
        explosion.position = position
        node.addChild(explosion)
        explosion.run(SKAction.play())
    }
    
    func shipExplosion(_ node: SKNode, atPosition position: CGPoint) {
        let explosion = SKAudioNode(fileNamed: "Thunderous Explosive.wav")
        explosion.isPositional = true
        explosion.autoplayLooped = false
        explosion.position = position
        node.addChild(explosion)
        explosion.run(SKAction.play())
        
        
    }
}
