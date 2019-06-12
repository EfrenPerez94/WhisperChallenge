//
//  RepositoryError.swift
//  WhisperChallenge
//
//  Created by Efrén Pérez Bernabe on 6/10/19.
//  Copyright © 2019 Efrén Pérez Bernabe. All rights reserved.
//

import Foundation

/// Common repository errors.
enum RepositoryError: Error {
    case dataIsNil
    case failedParsing
}

/// Repository errors description
extension RepositoryError: LocalizedError {
    var description: String? {
        switch self {
        case .dataIsNil:
            return "Data is nil"
        case .failedParsing:
            return "Could not parse object"
        }
    }
}
