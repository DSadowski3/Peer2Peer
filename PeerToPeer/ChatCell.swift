//
//  ChatCell.swift
//  PeerToPeer
//
//  Created by Dominik Sadowski on 3/1/17.
//  Copyright © 2017 Dominik Sadowski. All rights reserved.
//

import UIKit

class ChatCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .red
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
