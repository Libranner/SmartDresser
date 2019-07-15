//
//  InventoryViewController.swift
//  DressAsistant
//
//  Created by Libranner Leonel Santos Espinal on 15/07/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import UIKit

class InventoryViewController: UIViewController {
  private let reuseIdentifier = "ItemCell"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }
  
  private lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical;
    layout.minimumLineSpacing = 30;
    //layout.minimumInteritemSpacing = 100;
    //layout.estimatedItemSize = CGSize(width: 1, height: 1)
    layout.itemSize = CGSize(width: 100, height: 100)
    layout.sectionInset = UIEdgeInsets(top: 30, left: 0, bottom: 0, right: 0)
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.backgroundColor = .white
    collectionView.register(ItemCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    collectionView.delegate = self
    collectionView.dataSource = self
    return collectionView
  }()
  
  private func setupUI() {
    view.addSubview(collectionView)
    collectionView.snp.makeConstraints { make in
      make.top.bottom.centerX.equalToSuperview().labeled("CollectionViewWidthAndCenter")
      make.width.equalToSuperview().multipliedBy(0.90)
    }
  }
}

//Mark: - Collection View Delegate
extension InventoryViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
  }
}

//Mark: - Collection View Datasource
extension InventoryViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 25
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                  for: indexPath) as! ItemCollectionViewCell
    
    cell.backgroundColor = .white
    cell.imageView.image = UIImage(named: "next")
    
    cell.layer.borderColor = UIColor.red.cgColor
    cell.layer.borderWidth = 2.0
    cell.layer.cornerRadius = 5.0
    
    return cell
  }
}

private class ItemCollectionViewCell: UICollectionViewCell {
  var imageView: UIImageView = UIImageView()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI() {
    addSubview(imageView)
    imageView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
}
