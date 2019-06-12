//
//  WhisperRepliesVC.swift
//  WhisperChallenge
//
//  Created by Efrén Pérez Bernabe on 6/10/19.
//  Copyright © 2019 Efrén Pérez Bernabe. All rights reserved.
//

import UIKit

final class WhisperRepliesVC: UIViewController {
    
    // MARK: - Private properties
    @IBOutlet private weak var repliesCollectionView: UICollectionView! {
        didSet {
            repliesCollectionView.register(UINib(nibName: .whisperNib, bundle: nil),
                                  forCellWithReuseIdentifier: .whisperCell)
            self.repliesCollectionView.dataSource = whisperListDataSource
            self.repliesCollectionView.delegate = self
        }
    }
    @IBOutlet private weak var totalCounter: UILabel!
    @IBOutlet private weak var rootImage: UIImageView!
    @IBOutlet private weak var repliesActivityIndicator: UIActivityIndicatorView!
    private var whisperListDataSource = WhisperDataSource()

    // MARK: - Private properties
    
    /// Root information
    private var rootChildrenWIDs: [String] = []
    private var rootUrls: [String] = []
    private var heartCount: [Int] = []
    private var root = Node(me2: 0)
    
    /// Search auxiliars
    private var actualCount = 0
    private var path: [Node]?
    private var maxCount = 0
    private var whisperRootReplies: [Whisper] = []
    private var lastNode: Node = Node(me2: 0)
    
    private var firstDispatch = DispatchGroup()
    private var repliesDispatch = DispatchGroup()
    
    // MARK: - Public properties
    var parentWhisper: Whisper!

    // MARK: - Life View Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "DETAIL"
        root.me2 = parentWhisper.replies // could be unecessary
        totalCounter.text = "\(parentWhisper.me2)"
        
        repliesActivityIndicator.hidesWhenStopped = true
        repliesActivityIndicator.startAnimating()
        
        rootImage.imageFromURL(parentWhisper.urlImage)
    
        firstDispatch.enter()
        rootPreparation()
        
        firstDispatch.notify(queue: .main) {
            self.AddChildrens(childrenWIDs: self.rootChildrenWIDs, father: self.root, urls: self.rootUrls)
            DispatchQueue.main.async {
                self.repliesDispatch.notify(queue: .main) {
                    self.loadPath()
                    self.repliesActivityIndicator.stopAnimating()
                }
            }
        }
    }
    
    // MARK: - Auxiliar functions
    
    func rootPreparation() {
        let repository = WhisperRepository()
        repository.execute(request: .replies, forWid: parentWhisper.wid, WhisperReplies.self) { [weak self] result in
            guard let weakSelf = self else {
                fatalError("Self contains a nil value")
            }
            switch result {
            case .success(let replies):
                DispatchQueue.main.sync {
                    for reply in replies.replies {
                        weakSelf.rootChildrenWIDs.append(reply.wid)
                        weakSelf.rootUrls.append(reply.urlImage)
                        weakSelf.heartCount.append(reply.me2)
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    weakSelf.present(error.createAlert(), animated: true)
                }
            }
            weakSelf.firstDispatch.leave()
        }
    }
    
    func loadPath() {
        var hasFather = true
        var whispers: [Whisper] = []

        searchHighestPath(node: root)
        maxCount = 0

        while hasFather {
            if let lastNodeFather = lastNode.father, let url = lastNode.urlImage {
                whispers.append(Whisper(urlImage: url, wid: "", replies: 0, me2: lastNode.me2))
                lastNode = lastNodeFather
            } else {
                hasFather = false
            }
        }
        
        self.whisperListDataSource.whispers = whispers.reversed()
        DispatchQueue.main.async {
            self.repliesCollectionView.reloadData()
        }
    }
    
    func AddChildrens(childrenWIDs: [String] = [], father: Node, urls: [String]) {
        for (index, wid) in childrenWIDs.enumerated() {
            repliesDispatch.enter()
            let actualFather = Node(childWID: childrenWIDs, father: father, urlImage: urls[index], me2: heartCount[index])
            father.add(child: actualFather)
            let repository = WhisperRepository()
            repository.execute(request: .replies, forWid: wid, WhisperReplies.self) { [weak self] result in
                guard let weakSelf = self else {
                    fatalError("Self contains a nil value")
                }
                switch result {
                case .success(let replies):
                    DispatchQueue.main.sync {
                        var childrenWIDs: [String] = []
                        var urls: [String] = []
                        var heartCount: [Int] = []
                        for reply in replies.replies {
                            childrenWIDs.append(reply.wid)
                            urls.append(reply.urlImage)
                            heartCount.append(reply.me2)
                        }
                        weakSelf.AddChildrens(childrenWIDs: childrenWIDs, father: actualFather, urls: urls )
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        weakSelf.present(error.createAlert(), animated: true)
                    }
                }
                weakSelf.repliesDispatch.leave()
            }
        }
    }
    
    func searchHighestPath(node: Node?) {
        guard let safeNode = node else {
            return
        }
        
        if safeNode.childs.isEmpty {
            if actualCount > maxCount {
                maxCount = actualCount
                lastNode = safeNode
            }
        }
        
        for child in safeNode.childs {
            guard let safeChild = child else {
                return
            }

            actualCount += safeChild.me2
            searchHighestPath(node: child)
            actualCount -= safeChild.me2
        }
    }
}

extension WhisperRepliesVC: UICollectionViewDelegateFlowLayout {
    
    // MARK: - Collection View Delegate
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = self.view.frame.width / 3.2
        let height = width * 1.5
        
        return CGSize(width: width, height: height)
    }
}
