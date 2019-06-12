//
//  Node.swift
//  WhisperChallenge
//
//  Created by Efrén Pérez Bernabe on 6/10/19.
//  Copyright © 2019 Efrén Pérez Bernabe. All rights reserved.
//

import Foundation
import UIKit

/// Model to store whispers in a n-ary tree.
class Node {
    var father: Node?
    var me2: Int
    var childs: [Node?]
    var childWID: [String]?
    var urlImage: String?
    
    init(childWID: [String]? = nil, father: Node? = nil, urlImage: String? = nil, me2: Int, childs: Node?...) {
        self.me2 = me2
        self.childs = childs
        self.father = father
        self.urlImage = urlImage
        self.childWID = childWID
    }
    
    func add(child: Node) {
        childs.append(child)
    }
}
