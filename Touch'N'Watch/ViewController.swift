//
//  ViewController.swift
//  Touch'N'Watch
//
//  Created by Roman Tverdokhleb on 09.09.2022.
//

import UIKit
import AVKit
import Network
import AVFoundation

class ViewController: UIViewController {

    var n = 0
    
    let returnImage = UIImage(systemName: "return.left", withConfiguration: UIImage.SymbolConfiguration(pointSize: 17, weight: .unspecified))
    
    let reloadImage = UIImage(systemName: "arrow.clockwise", withConfiguration: UIImage.SymbolConfiguration(pointSize: 17, weight: .unspecified))
    
    let nextImage = UIImage(systemName: "arrow.forward", withConfiguration: UIImage.SymbolConfiguration(pointSize: 17, weight: .unspecified))
    
    let endImage = UIImage(systemName: "arrow.counterclockwise", withConfiguration: UIImage.SymbolConfiguration(pointSize: 17, weight: .unspecified))
    
    lazy var textLabel: UILabel = {
        videoTextLabel.numberOfLines = 0
        videoTextLabel.lineBreakMode = .byWordWrapping
        videoTextLabel.font = UIFont.systemFont(ofSize: 20)
        videoTextLabel.sizeToFit()
        return videoTextLabel
    }()
    
    @IBOutlet weak var videoTextLabel: UILabel!
    
    @IBOutlet weak var imageContent: UIImageView!
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var loadingView: UIView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBAction func didChangedSegment(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            changeSegment(urlSegment: urlHot, textSegment: textHot)
//            urlGiven = urlHot
//            urlQueue.removeAll()
//            textGiven = textHot
//            textQueue.removeAll()
            let currentElement = urlGiven.randomElement()!
            //let elementPosition = urlGiven.firstIndex(where: {$0 == currentElement})!
            let elementPosition = urlGiven.firstIndex(of: currentElement)!
            arrayAppend(currentElement: currentElement!, elementPosition: elementPosition)
//            urlQueue.append(currentElement!)
//            textQueue.append(textGiven[elementPosition]!)
            playerSwitchLoad(element: currentElement!)
            nonRepeat(elementPosition: elementPosition)
            n = 0

        } else if sender.selectedSegmentIndex == 1 {
            changeSegment(urlSegment: urlBest, textSegment: textBest)
//            urlGiven = urlBest
//            urlQueue.removeAll()
//            textGiven = textBest
//            textQueue.removeAll()
            
            let currentElement = urlGiven.randomElement()!
            //let elementPosition = urlGiven.firstIndex(where: {$0 == currentElement})!
            let elementPosition = urlGiven.firstIndex(of: currentElement)!
            
            arrayAppend(currentElement: currentElement!, elementPosition: elementPosition)
//            urlQueue.append(currentElement!)
//            textQueue.append(textGiven[elementPosition]!)
            playerSwitchLoad(element: currentElement!)
            nonRepeat(elementPosition: elementPosition)
            n = 0
        }
    }
        
    @IBAction func backButtonAction(_ sender: Any) {
        if urlQueue.count == 1 {
            let currentElement = urlGiven.randomElement()!
            //let elementPosition = urlGiven.firstIndex(where: {$0 == currentElement})!
            let elementPosition = urlGiven.firstIndex(of: currentElement)!
            
            urlQueue.removeAll()
            textQueue.removeAll()
            
            playerSwitchLoad(element: currentElement!)
            arrayAppend(currentElement: currentElement!, elementPosition: elementPosition)
//            urlQueue[0] = currentElement
//            textQueue[0] = textGiven[elementPosition]!
            nonRepeat(elementPosition: elementPosition)
        } else {
            urlGiven.append(urlQueue.last!)
            textGiven.append(textQueue.last!)
            
            urlQueue.removeLast()
            textQueue.removeLast()
            
            let previousElement = urlQueue.last!
            playerSwitchLoad(element: previousElement!)
            //nonRepeat(element: previousElement!)
           
            n -= 1
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
            
            let currentElement = urlGiven.randomElement()!
            //let elementPosition = urlGiven.firstIndex(where: {$0 == currentElement})!
            let elementPosition = urlGiven.firstIndex(of: currentElement)!
            arrayAppend(currentElement: currentElement!, elementPosition: elementPosition)
//            urlQueue.append(nextElement)
//            textQueue.append(textGiven[elementPosition]!)
            playerSwitchLoad(element: currentElement!)
            //urlGiven.remove(at: elementPosition!)
            nonRepeat(elementPosition: elementPosition)
            urlGiven.append(urlTempSave)
            textGiven.append(textTempSave)
            n = 0
        } else {
            let currentElement = urlGiven.randomElement()!
//            let elementPosition = urlGiven.firstIndex(where: {$0 == currentElement})!
            let elementPosition = urlGiven.firstIndex(of: currentElement)!
            playerSwitchLoad(element: currentElement!)
            arrayAppend(currentElement: currentElement!, elementPosition: elementPosition)
//            urlQueue.append(currentElement)
//            textQueue.append(textGiven[elementPosition]!)
            //urlGiven.remove(at: elementPosition!)
            nonRepeat(elementPosition: elementPosition)
            n += 1
        }
        
    }
    
    private func firstLoad() {
        urlGiven = urlHot
        textGiven = textHot
        textLabel.alpha = 0
        nextButton.isEnabled = false
        backButton.isEnabled = false
        
        //let elementPosition = urlGiven.firstIndex(where: {$0 == urlQueue[0]})!
        let elementPosition = urlGiven.firstIndex(of: urlQueue[0])!
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.nextButton.isEnabled = true
            self.backButton.isEnabled = true
        }
        UIView.animate(withDuration: 0.1) {
            self.textLabel.alpha = 1
        }
        nonRepeat(elementPosition: elementPosition)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstLoad()
        showSpinner()
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
    
    var playerLayer: AVPlayerLayer?
    var playerLooper: AVPlayerLooper?
    
    private func playerView(urlElement: URL) {
        let playerItem = AVPlayerItem(url: urlElement)
        let player = AVQueuePlayer(items: [playerItem])
        playerLayer = AVPlayerLayer(player: player)
        
        self.playerLooper = AVPlayerLooper(player: player, templateItem: playerItem)
        self.view.layer.addSublayer(playerLayer!)
        playerLayer!.frame = imageContent.frame
        playerLayer!.videoGravity = .resizeAspectFill

        player.volume = 0
        player.play()
        
        view.addSubview(textLabel)
        
    }
    
    
    private func playerSwitchLoad(element: URL) {
        playerLayer?.isHidden = true
        nextButton.isEnabled = false
        backButton.isEnabled = false
        textLabel.alpha = 0

        let playerItemReplace = AVPlayerItem(url: element)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.playerLayer?.player?.replaceCurrentItem(with: playerItemReplace)
            self.viewDidAppear(true)
            self.playerLayer?.isHidden = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.playerLayer?.isHidden = false
            self.playerLayer?.player?.play()
            
            self.nextButton.isEnabled = true
            self.backButton.isEnabled = true
            
            UIView.animate(withDuration: 0.1) {
                self.textLabel.alpha = 1
            }
        }

    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        imageContent.layer.cornerRadius = 10
        playerView(urlElement: urlQueue.last!!)
        
        textLabel.text = textQueue.last

        if urlQueue.count == 1 {
            backButton.setImage(reloadImage, for: .normal)
        } else {
            backButton.setImage(returnImage, for: .normal)
        }
        
        if urlGiven.count == 0 && urlQueue.count != 1 {
            nextButton.setImage(endImage, for: .normal)
        } else {
            nextButton.setImage(nextImage, for: .normal)
        }
        
        
        }
    }

