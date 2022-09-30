//
//  Model.swift
//  Touch'N'Watch
//
//  Created by Roman Tverdokhleb on 26.09.2022.
//

import Foundation

let startPoint = urlHot.randomElement()
let elementPosition = urlHot.firstIndex(of: startPoint!)

var urlGiven = [URL?]()
var urlQueue = [startPoint!]
var textGiven = [String?]()
var textQueue = [textHot[elementPosition!]]

func changeSegment(urlSegment: Array<URL?>, textSegment: Array<String>) {
    urlGiven = urlSegment
    urlQueue.removeAll()
    textGiven = textSegment
    textQueue.removeAll()
}

func arrayAppend(currentElement: URL, elementPosition: Int) {
    urlQueue.append(currentElement)
    textQueue.append(textGiven[elementPosition]!)
}

func nonRepeat(elementPosition: Int) {
    urlGiven.remove(at: elementPosition)
    textGiven.remove(at: elementPosition)
}

func checkConnection() {
    if NetworkMonitor.shared.isConnected {
        print("connected")
    } else {
        print("not connected")
    }
}

//func playerSwitch() {
//    let currentElement = urlGiven.randomElement()!
//    let elementPosition = urlGiven.firstIndex(where: {$0 == currentElement})!
//    
//    arrayAppend(currentElement: currentElement!, elementPosition: elementPosition)
//    
//    playerSwitchLoad(element: currentElement!)
//    nonRepeat(elementPosition: elementPosition)
//}
