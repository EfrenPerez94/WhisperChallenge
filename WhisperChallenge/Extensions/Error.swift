//
//  Error.swift
//  WhisperChallenge
//
//  Created by Efrén Pérez Bernabe on 6/11/19.
//  Copyright © 2019 Efrén Pérez Bernabe. All rights reserved.
//

import Foundation
import UIKit

extension Error {
    
    /**
     Create a custom alert for an error.
     
     - Returns: An `UIAlertController` with the error description.
     */
    func createAlert() -> UIAlertController {
        var message = self.localizedDescription
        if let error = self as? RepositoryError, let customMessage = error.errorDescription {
            message = customMessage
        }
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        return alert
    }
}
