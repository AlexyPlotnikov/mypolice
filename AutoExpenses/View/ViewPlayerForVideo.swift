//
//  ViewPlayerForVideo.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 12.11.2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit


class ViewPlayerForVideo: UIView {

    private var buttonFullScreen: UIButton?
    private var switcherMute: UIButton?
    private weak var playerLayer: AVPlayerLayer?
    private weak var player: AVPlayer?
    private var audioSession: AVAudioSession!
    
    //private var fullRect: FullScreenStruct?
//    private var viewForFullScreenVideo: UIView?
    
//     var isFull: Bool = true {
//        didSet {
//            self.buttonFullScreen?.setImage(UIImage(named: self.isFull ? "fullVideo" : "smallVideo"), for: .normal)
//
//
//        }
//    }
    
    var isMuted: Bool = true {
        didSet {
            player?.isMuted = self.isMuted
            switcherMute?.setImage(UIImage(named: self.isMuted ? "volume_off" : "volume_on"), for: .normal)
        }
    }
    var isLoop: Bool = false
    var isPlaying  = false {
        didSet {
            playingControllAutomatic()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//             audioSession = AVAudioSession()
//                  do {
//                   try audioSession!.setActive(true)
//                  } catch {
//                   print("some error")
//                  }
        
//         audioSession!.addObserver(self, forKeyPath: "outputVolume", options: NSKeyValueObservingOptions.new, context: nil)
    }
    
    
    
    @objc private func muteController() {
        self.isMuted = !self.isMuted
    }
    
      
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
      if keyPath == "outputVolume" {
        self.isMuted = false
      }
    }
        
    func configure(view: UIView) {
        
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(playingControll)))
        
        if let videoURL = URL(string: "https://b2b.rx-agent.ru/assets/images/movieToryeki.mov") {
            
            if player == nil {
//                 listenVolumeButton()
                let player = AVPlayer(url: videoURL)
                self.player = player
                
                let playerLayer = AVPlayerLayer(player: player)
                self.playerLayer = playerLayer
                self.playerLayer!.frame = bounds
                self.playerLayer!.videoGravity = AVLayerVideoGravity.resizeAspectFill
                
                if let playerLayer = self.playerLayer {
                    layer.addSublayer(playerLayer)
                }
                
                buttonFullScreen = UIButton()
            //    buttonFullScreen?.addTarget(self, action: #selector(fullScreenControll), for: .touchDown)
                self.addSubview(buttonFullScreen!)
                
                switcherMute = UIButton()
                switcherMute?.addTarget(self, action: #selector(muteController), for: .touchUpInside)
                self.addSubview(switcherMute!)
                
                isMuted = true
//                isFull = false
                
                NotificationCenter.default.addObserver(self, selector: #selector(reachTheEndOfTheVideo(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player?.currentItem)
            }
        }
    }
      
    deinit {
        print("deinit PlayerView")
        NotificationCenter.default.removeObserver(self)
        audioSession?.removeObserver(self, forKeyPath: "outputVolume")
        audioSession = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame = bounds
        switcherMute?.frame = CGRect(x: 0, y: self.frame.height - 45, width: 45, height: 45)
        buttonFullScreen?.frame = CGRect(x: self.frame.width - 45, y: self.frame.height - 45, width: 45, height: 45)
    }
    
//    @objc private func fullScreenControll() {
//        isFull = !isFull
//
//        if isFull {
//            self.viewForFullScreenVideo?.layer.addSublayer(self.layer)
//        } else {
//            self.layer.addSublayer(playerLayer!)
//        }
//
//        let rotateCount = isFull ? 1 : 0
//        self.transform = CGAffineTransform(rotationAngle: (rotateCount.toCGFloat() * CGFloat(Double.pi/2)))
//        frame = self.isFull ? self.viewForFullScreenVideo?.frame ?? CGRect.zero : self.frame
//
//        self.setNeedsLayout()
//    }
    
    @objc private func playingControll() {
        isPlaying = !(player?.isPlaying ?? false)
    }
    
    func playingControllAutomatic() {
        if self.isPlaying {
            player?.play()
        } else {
            player?.pause()
        }
    }
    
    
   @objc func play() {
        if player?.timeControlStatus != AVPlayer.TimeControlStatus.playing {
            isPlaying = true
        }
    }
        
    func pause() {
        isPlaying = false
    }
        
    func stop() {
        player?.pause()
        player?.seek(to: CMTime.zero)
    }
        
    @objc func reachTheEndOfTheVideo(_ notification: Notification) {
        if isLoop {
            player?.pause()
            player?.seek(to: CMTime.zero)
            player?.play()
        }
    }
}

extension AVPlayer {
    var isPlaying: Bool {
        get {
            return self.timeControlStatus == AVPlayer.TimeControlStatus.playing
        }
    }
}
