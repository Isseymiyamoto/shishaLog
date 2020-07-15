//
//  LogController.swift
//  shishaLog
//
//  Created by 宮本一成 on 2020/06/28.
//  Copyright © 2020 ISSEY MIYAMOTO. All rights reserved.
//

import UIKit

private let reuseIdentifier = "LogHeader"

class LogController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView!.register(LogCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }

   

}

// MARK: UICollectionViewDataSource / Delegate

extension LogController{
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! LogCell
        return cell
    }
    
    
}



