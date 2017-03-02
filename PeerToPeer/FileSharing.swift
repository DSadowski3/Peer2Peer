//
//  FileSharing.swift
//  PeerToPeer
//
//  Created by Dominik Sadowski on 3/1/17.
//  Copyright © 2017 Dominik Sadowski. All rights reserved.
//

import UIKit

class FileSharing: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "File Sharing"
        collectionView?.backgroundColor = .white
        collectionView?.alwaysBounceVertical = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addFile))
        
        collectionView?.register(FileSharingCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    func addFile() {
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! FileSharingCell
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 50)
    }
}
