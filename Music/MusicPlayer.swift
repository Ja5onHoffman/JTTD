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
                audioPlayer.setVolume(0.1, fadeDuration: 1.0)
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
    
    func shieldExplosion(_ node: SKNode, atPosition position: CGPoint) {
        let explosion = SKAudioNode(fileNamed: "Electric Engine Explosion.wav")
        explosion.isPositional = true
        explosion.autoplayLooped = false
        explosion.position = position
        node.addChild(explosion)
        explosion.run(SKAction.play())
    }
    
    func shipExplosion(_ node: SKNode, atPosition position: CGPoint) {
        let explosion = SKAudioNode(fileNamed: "Thunderous Explosive.wav")
//        explosion.isPositional = true
        explosion.autoplayLooped = false
        explosion.position = position
        let vol = SKAction.changeVolume(to: 1.0, duration: 1.0)
        let group = SKAction.group([vol, SKAction.play()])
        node.addChild(explosion)
        explosion.run(group)
    }
    
    func beamSound(_ node: SKNode) {
        let beam = SKAudioNode(fileNamed: "Sci-Fi Static Electricity Loop 1.wav")
        let vol = SKAction.changeVolume(to: 10.0, duration: 3.0)
        beam.isPositional = true
        beam.autoplayLooped = false
        beam.position = node.position
        node.addChild(beam)
        let play = SKAction.group([vol, SKAction.play()])
        beam.run(play)
    }
    
    // TODO: Speed this up
    func tractorSound(_ node: SKNode) {
        let tractor = SKAudioNode(fileNamed: "Sci-Fi Energy Sweep 1.wav")
        tractor.isPositional = true
        tractor.autoplayLooped = false
        tractor.position = node.position
        
        node.addChild(tractor)
        tractor.run(SKAction.play())
    }
}
