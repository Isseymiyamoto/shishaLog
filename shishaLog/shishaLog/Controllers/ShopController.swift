//
//  ShopController.swift
//  shishaLog
//
//  Created by 宮本一成 on 2020/08/04.
//  Copyright © 2020 ISSEY MIYAMOTO. All rights reserved.
//

import UIKit
import MapKit

class ShopController: UIViewController {
    
    // MARK: - Properties
    
    private let shop: Shop
    
    private let shopImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .red
        return iv
    }()
    
    private let shopNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    private let mapView: MKMapView = {
        let mv = MKMapView()
        return mv
    }()
    
    private let infoEditButton: UIButton = {
        let button = UIButton(type: .system)
        return button
    }()
    
    // MARK: - Lifecycle
    
    init(shop: Shop){
        self.shop = shop
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.isHidden = false
    }
    
    // MARK: - Helpers
    
    func configureUI(){
        view.backgroundColor = .white
        
        let frameWidth = view.frame.width
        view.addSubview(shopImageView)
        shopImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: frameWidth / 2)
        
        view.addSubview(shopNameLabel)
        shopNameLabel.anchor(top: shopImageView.bottomAnchor, left: view.leftAnchor, paddingTop: 16, paddingLeft: 8)
        
        view.addSubview(mapView)
        mapView.anchor(top: shopImageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 64, height: frameWidth / 3 * 2)
        
        shopImageView.sd_setImage(with: shop.shopImageUrl, completed: nil)
        shopNameLabel.text = shop.shopName
        geoCording()
        
    }
    
    func configureNavigationBar(){
        navigationItem.title = shop.shopName
    }
    
    fileprivate func geoCording(){
        let address = shop.address
        var resultlat: CLLocationDegrees!
        var resultlng: CLLocationDegrees!
        
        // 住所から位置情報に変換する
        CLGeocoder().geocodeAddressString(address) { (placemarks, error) in
            if let lat = placemarks?.first?.location?.coordinate.latitude {
                print("DEBUG: latitude is \(lat)")
                resultlat = lat
            }
            
            if let lng = placemarks?.first?.location?.coordinate.longitude {
                print("DEBUG: longitude is \(lng)")
                resultlng = lng
            }
            
            if (resultlat != nil && resultlng != nil){
                // 位置情報データの作成
                let cordinate = CLLocationCoordinate2DMake(resultlat, resultlng)
                let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                // 照準を合わせる
                let region = MKCoordinateRegion(center: cordinate, span: span)
                self.mapView.region = region
                
                // 同時に取得した位置にピンを立てる
                let pin = MKPointAnnotation()
                pin.title = self.shop.shopName
                pin.subtitle = address
                
                pin.coordinate = cordinate
                self.mapView.addAnnotation(pin)
            }
        }
    }
}
