//
//  WhisperCell.swift
//  WhisperChallenge
//
//  Created by Efrén Pérez Bernabe on 6/10/19.
//  Copyright © 2019 Efrén Pérez Bernabe. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
}
class WhisperCell: UICollectionViewCell {
    
    @IBOutlet weak var whisperImage: UIImageView!
    @IBOutlet weak var likeCount: UILabel!
    @IBOutlet weak var imageActivityIndicator: UIActivityIndicatorView!
    
    var whisper: Whisper! {
        didSet {
            self.likeCount.text = "\(whisper.me2)"
            self.whisperImage.imageFromURL(whisper.urlImage)
        }
    }
    
    override func awakeFromNib() {
        whisperImage.layer.cornerRadius = 6
        whisperImage.layer.masksToBounds = true
    }

    override func prepareForReuse() {
        whisperImage.image = nil
    }
}
