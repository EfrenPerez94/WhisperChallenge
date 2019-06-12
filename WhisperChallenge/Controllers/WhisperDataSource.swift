//
//  WhisperDataSource.swift
//  WhisperChallenge
//
//  Created by Efrén Pérez Bernabe on 6/10/19.
//  Copyright © 2019 Efrén Pérez Bernabe. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Collection view data source
final class WhisperDataSource: NSObject, UICollectionViewDataSource {
    
    // MARK: - Public properties
    var whispers = [Whisper]()
    
    // MARK: - Collection View protocols
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return whispers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let whisperCell = collectionView.dequeueReusableCell(withReuseIdentifier: .whisperCell, for: indexPath) as? WhisperCell else {
            fatalError("Unable cast cell as WhisperCell")
        }
        
        whisperCell.whisper = self.whispers[indexPath.row]
        return whisperCell
    }
    
}
