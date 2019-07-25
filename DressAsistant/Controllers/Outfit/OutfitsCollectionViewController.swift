//
//  OutfitsCollectionViewController.swift
//  DressAsistant
//
//  Created by Libranner Leonel Santos Espinal on 24/07/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import UIKit

class OutfitsCollectionViewController: BaseViewController {
  lazy var loadingView = LoadingView()
  private var outfits = [Outfit]()
  
  private let reuseIdentifier = "OutfitCell"
  enum Localizations {
    static let outfitsTitle = "outfits-list-title"
  }
  
  private lazy var collectionView: UICollectionView = {
    
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.estimatedItemSize = CGSize(width: 1, height: 1)
    layout.scrollDirection = .vertical
    layout.sectionInset = UIEdgeInsets(top: CGFloat(UIConstants.defaultTopSpace),
                                left: 5.0, bottom: 5.0, right: 5.0)
    layout.minimumLineSpacing = 50
    
    let collectionView = UICollectionView(frame: .zero,
                                          collectionViewLayout: layout)
    collectionView.backgroundColor = .white
    collectionView.register(OutfitCollectionViewCell.self,
                            forCellWithReuseIdentifier: reuseIdentifier)
    collectionView.delegate = self
    collectionView.dataSource = self
    return collectionView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.title = NSLocalizedString(Localizations.outfitsTitle,
                                   comment: "")
    
    let addButton = UIBarButtonItem(barButtonSystemItem: .add,
                                    target: self, action: #selector(addItem))
    navigationItem.rightBarButtonItem = addButton
    
    loadData()
    setupUI()
  }
  
  private func setupUI() {
    view.addSubview(collectionView)
    collectionView.snp.makeConstraints { make in
      make.top.bottom.centerX.equalToSuperview().labeled("CollectionViewWidthAndCenter")
      make.width.equalToSuperview().multipliedBy(0.90)
    }
  }
  
  private func loadData() {
    showLoading()
    OutfitService().getAll { [weak self] (error, outfits) in
      self?.outfits = outfits
      self?.collectionView.reloadData()
      self?.hideLoading()
    }
  }
  
  @objc private func addItem() {
    let vc = OutfitViewController()
    navigationController?.pushViewController(vc, animated: true)
  }
}

// MARK: UICollectionViewDataSource
extension OutfitsCollectionViewController: UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return outfits.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                  for: indexPath) as! OutfitCollectionViewCell
    
    let outfit = outfits[indexPath.row]
    cell.dataLabel.text = outfit.eventType.rawValue
    
    let picturesURLs = [URL(string: "https://www.boden.co.uk/content/dam/boden/homepage-and-landing-pages/drop-7_19/2-womens/WW_WK1_CB31.jpg.rendition.290.870.jpg")!, URL(string: "https://media.kohlsimg.com/is/image/kohls/wo-dtm-b4-20190704-d2?scl=1&fmt=pjpeg&qlt=80,1")! ]
    
    cell.setPictures(picturesURLs)
    
    cell.contentView.backgroundColor = .red
    return cell
  }
}

// MARK: UICollectionViewDelegate
extension OutfitsCollectionViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
  }
}

extension OutfitsCollectionViewController: LoadingScreenDelegate {
}
