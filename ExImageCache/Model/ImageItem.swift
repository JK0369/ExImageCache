//
//  ImageItem.swift
//  ExImageCache
//
//  Created by 김종권 on 2021/10/28.
//

import Foundation
import UIKit

class ImageItem: Item {
    var image: UIImage?
    let imageUrl: URL
    let identifier = "\(Date().timeIntervalSince1970)"

    init(image: UIImage, imageUrl: URL) {
        self.image = image
        self.imageUrl = imageUrl
    }
}

extension ImageItem: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }

    static func == (lhs: ImageItem, rhs: ImageItem) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}
