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
    static let outfitsNumberOfItems = "number-of-items"
  }
  
  private lazy var collectionView: UICollectionView = {
    let width = Int(UIScreen.main.bounds.width * 0.7)
    let height = Int(Float(width) * 1.2 + 100)
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.estimatedItemSize = CGSize(width: width, height: height)
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
    
    /* TODO: Add filtering
     let filterButton = UIBarButtonItem(barButtonSystemItem: .edit,
                                    target: self, action: #selector(filter))*/
    
    navigationItem.rightBarButtonItem = addButton
    
    setupUI()
  }
  
  @objc
  private func filter() {
    let filterVC = OutfitsFilterTableViewController()
    let nav = UINavigationController(rootViewController: filterVC)
    navigationController?.present(nav, animated: true, completion: {
      
    })
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    loadData()
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
    let inventoryVC = InventoryViewController(isInSelectMode: true)
    inventoryVC.delegate = self
    let nav = UINavigationController(rootViewController: inventoryVC)
    present(nav, animated: true)
  }
}

// MARK: InventoryController Delegate
extension OutfitsCollectionViewController: InventoryDelegate {
  func inventory(_ inventory: InventoryViewController, didSelect items: [Item]) {
    guard !items.isEmpty else {
      return
    }
    
    let outfitVC = OutfitViewController(items: items)
    navigationController?.pushViewController(outfitVC, animated: true)
  }
}

// MARK: UICollectionViewDataSource
extension OutfitsCollectionViewController: UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if outfits.isEmpty {
      self.collectionView.showEmpty(messageId: "no-data-message")
    }
    else {
      self.collectionView.restore()
    }
    
    return outfits.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                  for: indexPath) as! OutfitCollectionViewCell
    
    let outfit = outfits[indexPath.row]
    cell.weatherLabel.text = outfit.weather.rawValue
    cell.seasonLabel.text = outfit.season.rawValue
    cell.eventTypeLabel.text = outfit.eventType.rawValue
    cell.timeOfDayLabel.text = outfit.timeOfDay.rawValue
    let localizationString =  NSLocalizedString(Localizations.outfitsNumberOfItems, comment: "")
    cell.messageLabel.text = String.init(format: localizationString, outfit.items.count)
    
    let urls = outfit.items.compactMap { $0.imageURL }
    cell.setPictures(urls)
    
    return cell
  }
}

// MARK: UICollectionViewDelegate
extension OutfitsCollectionViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let outfit = outfits[indexPath.row]
    navigationController?.pushViewController(OutfitViewController(outfit: outfit), animated: true)
  }
}

extension OutfitsCollectionViewController: LoadingScreenDelegate {
}
