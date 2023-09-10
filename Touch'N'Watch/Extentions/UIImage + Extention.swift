//
//  UIImage + Extention.swift
//  Touch'N'Watch
//
//  Created by Roman Tverdokhleb on 10.09.2023.
//

import UIKit

extension UIImage {
    enum Symbols {
        static let back = UIImage(systemName: "return.left", withConfiguration: UIImage.SymbolConfiguration(pointSize: 17, weight: .unspecified))
        static let reload = UIImage(systemName: "arrow.clockwise", withConfiguration: UIImage.SymbolConfiguration(pointSize: 17, weight: .unspecified))
        static let next = UIImage(systemName: "arrow.forward", withConfiguration: UIImage.SymbolConfiguration(pointSize: 17, weight: .unspecified))
        static let end = UIImage(systemName: "arrow.counterclockwise", withConfiguration: UIImage.SymbolConfiguration(pointSize: 17, weight: .unspecified))
    }
}
