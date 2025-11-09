//
//  ImageCacheService.swift
//  DragonballChars
//
//  Created by Sujith Bolisetty on 08/11/25.
//

import Foundation
import Kingfisher
import UIKit

struct ImageService {
    @MainActor static func setImage(on imageView: UIImageView, url: URL?, placeholder: UIImage? = UIImage(named: "placeholderImage")) {
        imageView.kf.setImage(with: url, placeholder: placeholder, options: [.transition(.fade(0.25))])
    }
}


