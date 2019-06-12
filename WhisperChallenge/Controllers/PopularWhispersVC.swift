//
//  ViewController.swift
//  WhisperChallenge
//
//  Created by Efrén Pérez Bernabe on 6/10/19.
//  Copyright © 2019 Efrén Pérez Bernabe. All rights reserved.
//

import UIKit

final class PopularWhispersVC: UIViewController {
    
    // MARK: - Private properties
    @IBOutlet private weak var whispersList: UICollectionView! {
        didSet {
            whispersList.register(UINib(nibName: .whisperNib, bundle: nil),
                                 forCellWithReuseIdentifier: .whisperCell)
            self.whispersList.dataSource = whisperListDataSource
            self.whispersList.delegate = self
        }
    }
    private var whisperListDataSource = WhisperDataSource()
    
    // MARK: - Life View Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "logo"))
        loadDataFromRepository()
    }
    
    // MARK: - Auxiliar functions
    func loadDataFromRepository() {
        let repository = WhisperRepository()
        repository.execute(request: .popularWhispers, PopularWhispers.self) { [weak self] result in
            guard let weakSelf = self else { return }
            switch result {
            case .success(let whispers):
                DispatchQueue.main.async {
                    weakSelf.whisperListDataSource.whispers = whispers.popular
                    weakSelf.whispersList.reloadData()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    weakSelf.present(error.createAlert(), animated: true)
                }
            }
        }
    }

}

extension PopularWhispersVC: UICollectionViewDelegateFlowLayout {
    
    // MARK: - Collection View Delegate
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = self.view.frame.width / 2.1
        let height = width * 1.5
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let repliesVC = self.storyboard?.instantiateViewController(withIdentifier: .repliesVC) as? WhisperRepliesVC else {
            fatalError("Unable to cast WhisperRepliesVC ")
        }
        repliesVC.parentWhisper = whisperListDataSource.whispers[indexPath.row]
        navigationController?.pushViewController(repliesVC, animated: true)
    }
}
