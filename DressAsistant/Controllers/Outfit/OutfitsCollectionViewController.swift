//
//  OutfitsCollectionViewController.swift
//  DressAsistant
//
//  Created by Libranner Leonel Santos Espinal on 24/07/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"
enum Localizations {
  static let outfitsTitle = "outfits-list-title"
}

class OutfitsCollectionViewController: UICollectionViewController {
  lazy var loadingView = LoadingView()
  private var outfits = [Outfit]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.title = NSLocalizedString(Localizations.outfitsTitle,
                                   comment: "")
    
    let addButton = UIBarButtonItem(barButtonSystemItem: .add,
                                    target: self, action: #selector(addItem))
    navigationItem.rightBarButtonItem = addButton
    
    self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    loadData()
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

  // MARK: UICollectionViewDataSource
  override func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of items
    return 0
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
    // Configure the cell
    
    return cell
  }
  
  // MARK: UICollectionViewDelegate
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
  }
}

extension OutfitsCollectionViewController: LoadingScreenDelegate {
}
