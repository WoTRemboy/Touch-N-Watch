//
//  ViewController.swift
//  Touch'N'Watch
//
//  Created by Roman Tverdokhleb on 09.09.2022.
//

import UIKit
import AVKit
import AVFoundation

class ViewController: UIViewController {

    var observerStatus: NSKeyValueObservation?
    
    lazy var textLabel: UILabel = {
        videoTextLabel.numberOfLines = 0
        videoTextLabel.lineBreakMode = .byWordWrapping
        videoTextLabel.font = UIFont.systemFont(ofSize: 20)
        videoTextLabel.sizeToFit()
        return videoTextLabel
    }()
    
    @IBOutlet weak var changeSegmentOutlet: UISegmentedControl!
    @IBOutlet weak var retryImage: UIImageView!
    @IBOutlet weak var retryButton: UIButton!
    @IBOutlet weak var retryLabel: UILabel!
    @IBOutlet weak var videoTextLabel: UILabel!
    @IBOutlet weak var imageContent: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBAction func retryButtonAction(_ sender: Any) {
        self.playerSwitchLoad(element: urlQueue.last!!)
    }
    
    @IBAction func didChangedSegment(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            changeSegment(urlSegment: urlHot, textSegment: textHot)
            videoPlay()
        } else if sender.selectedSegmentIndex == 1 {
            changeSegment(urlSegment: urlBest, textSegment: textBest)
            videoPlay()
        }
    }
        
    @IBAction func backButtonAction(_ sender: Any) {
        if urlQueue.count == 1 {
            
            urlQueue.removeAll()
            textQueue.removeAll()
            
            videoPlay()
        } else {
            urlGiven.append(urlQueue.last!)
            textGiven.append(textQueue.last!)
            
            urlQueue.removeLast()
            textQueue.removeLast()
            
            let previousElement = urlQueue.last!
            playerSwitchLoad(element: previousElement!)
        }
    }
    
    @IBAction func nextButtonAction(_ sender: Any) {
        if urlGiven.count == 0 {
            urlGiven = urlQueue
            textGiven = textQueue
            
            let urlTempSave = urlGiven.last!
            let textTempSave = textGiven.last!
            
            urlGiven.removeLast()
            urlQueue.removeAll()
            
            textGiven.removeLast()
            textQueue.removeAll()
            
            videoPlay()
            
            urlGiven.append(urlTempSave)
            textGiven.append(textTempSave)
            
        } else {
            videoPlay()
        }
    }
    
    private func showSpinner() {
        activityIndicator.startAnimating()
        loadingView.isHidden = false
    }
    
    private func hideSpinner() {
        activityIndicator.stopAnimating()
        activityIndicator.hidesWhenStopped = true
        loadingView.isHidden = true
    }
    
    private func firstLoad() {
        urlGiven = urlHot
        textGiven = textHot
        textLabel.alpha = 0
        nextButton.isEnabled = false
        backButton.isEnabled = false
        changeSegmentOutlet.isEnabled = false
        
        let elementPosition = urlGiven.firstIndex(of: urlQueue[0])!
        
        nonRepeat(elementPosition: elementPosition)
    }
    
    private func videoPlay() {
        let currentElement = urlGiven.randomElement()!
        let elementPosition = urlGiven.firstIndex(of: currentElement)!
        playerSwitchLoad(element: currentElement!)
        arrayAppend(currentElement: currentElement!, elementPosition: elementPosition)
        nonRepeat(elementPosition: elementPosition)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        firstLoad()
        showSpinner()
        checkConnection()
    }
    
    var playerLayer: AVPlayerLayer?
    var playerLooper: AVPlayerLooper?
    
    private func playerView(urlElement: URL) {
        let playerItem = AVPlayerItem(url: urlElement)
        let player = AVQueuePlayer(items: [playerItem])
        playerLayer = AVPlayerLayer(player: player)
        
        playerLayer?.isHidden = true
        
        self.playerLooper = AVPlayerLooper(player: player, templateItem: playerItem)
        self.view.layer.addSublayer(playerLayer!)
        playerLayer!.frame = imageContent.frame
        playerLayer!.videoGravity = .resizeAspectFill

        player.volume = 0
        player.play()
        
        view.addSubview(textLabel)
        
        observerStatus = playerItem.observe(\.status, changeHandler: { (item, value) in
            debugPrint("status: \(item.status.rawValue)")
            if item.status == .failed {
                
                self.retryLabel.isHidden = false
                self.retryButton.isHidden = false
                self.retryImage.isHidden = false
                
                self.nextButton.isEnabled = false
                self.backButton.isEnabled = false
                self.changeSegmentOutlet.isEnabled = false
                
                self.hideSpinner()
                
            } else if item.status == .readyToPlay {
                self.retryLabel.isHidden = true
                self.retryButton.isHidden = true
                self.retryImage.isHidden = true
                
                self.showSpinner()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.playerLayer?.isHidden = false
                    self.nextButton.isEnabled = true
                    self.backButton.isEnabled = true
                    self.changeSegmentOutlet.isEnabled = true
                    UIView.animate(withDuration: 0.1) {
                        self.textLabel.alpha = 1
                    }
                }
            }
        })
    }
    
    private func playerSwitchLoad(element: URL) {
        playerLayer?.isHidden = true
        nextButton.isEnabled = false
        backButton.isEnabled = false
        changeSegmentOutlet.isEnabled = false
        
        UIView.animate(withDuration: 0.1) {
            self.textLabel.alpha = 0
        }
        let playerItemReplace = AVPlayerItem(url: element)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.playerLayer?.player?.replaceCurrentItem(with: playerItemReplace)
            self.viewDidAppear(true)

        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        imageContent.layer.cornerRadius = 10
        playerView(urlElement: urlQueue.last!!)
        
        textLabel.text = textQueue.last
        checkConnection()

        if urlQueue.count == 1 {
            backButton.setImage(.Symbols.reload, for: .normal)
        } else {
            backButton.setImage(.Symbols.back, for: .normal)
        }
        if urlGiven.count == 0 && urlQueue.count != 1 {
            nextButton.setImage(.Symbols.end, for: .normal)
        } else {
            nextButton.setImage(.Symbols.next, for: .normal)
        }
    }
}

