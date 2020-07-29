//
//  SpotController.swift
//  shishaLog
//
//  Created by 宮本一成 on 2020/07/29.
//  Copyright © 2020 ISSEY MIYAMOTO. All rights reserved.
//

import UIKit

private let reuseIdentifier = "SpotHeader"

class SpotController: UICollectionViewController {
    
    // MARK: - Properties
    
    private let spot: Spot
    
    
    
    
    // MARK: - Lifecycle
    
    init(spot: Spot) {
        self.spot = spot
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
    // MARK: - Helpers
    
    func configureCollecitonView(){
        collectionView.backgroundColor = .white
        
//        collectionView.register(<#T##cellClass: AnyClass?##AnyClass?#>, forCellWithReuseIdentifier: <#T##String#>)
    }
    
    
}
