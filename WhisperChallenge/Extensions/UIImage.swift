//
//  UIImage.swift
//  WhisperChallenge
//
//  Created by Efrén Pérez Bernabe on 6/10/19.
//  Copyright © 2019 Efrén Pérez Bernabe. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    
    /// Allow download images from web.
    /// - Note: Only HTTPS request are allowed
    /// - Parameter urlString: String with the url image.
    func imageFromURL(_ urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }
        
        if image != nil {
            image = nil
        }
        
        let loadImageIndicator: UIActivityIndicatorView!
        loadImageIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        loadImageIndicator.center = self.center
        loadImageIndicator.startAnimating()
        self.addSubview(loadImageIndicator)
        
        URLSession.shared.dataTask(with: URLRequest(url: url)) { [weak self] (data, _, error) in
            guard error == nil,
                let data = data,
                let weakSelf = self else {
                    return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data)
                weakSelf.contentMode = .scaleToFill
                weakSelf.image = image
                loadImageIndicator.removeFromSuperview()
            })
        }.resume()
    }
}
