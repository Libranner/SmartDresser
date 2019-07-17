//
//  InventoryViewController.swift
//  DressAsistant
//
//  Created by Libranner Leonel Santos Espinal on 15/07/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import UIKit

class InventoryViewController: BaseViewController, LoadingScreenDelegate {
  enum Localizations {
    static let inventoryTitle = "inventory-title"
  }
  
  lazy var loadingView = LoadingView()
  private let reuseIdentifier = "ItemCell"
  private var items = [Item]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = NSLocalizedString(Localizations.inventoryTitle, comment: "")
    
    let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem))
    navigationItem.rightBarButtonItem = addButton
    
    setupUI()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    loadData()
  }
  
  private func loadData() {
    showLoading()
    ItemService().getAll { [weak self] (error, items) in
      self?.items = items
      self?.collectionView.reloadData()
      self?.hideLoading()
    }
  }
  
  @objc private func addItem() {
    let vc = ItemViewController()
    navigationController?.pushViewController(vc, animated: true)
  }
  
  private lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.minimumLineSpacing = 20
    layout.minimumInteritemSpacing = 5
    layout.estimatedItemSize = CGSize(width: 1, height: 1)
    layout.sectionInset = UIEdgeInsets(top: CGFloat(UIConstants.defaultTopSpace),
                                       left: 5.0, bottom: 5.0, right: 5.0)
    
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
    let itemVC = ItemViewController(item: dataForIndex(indexPath.row))
    navigationController?.pushViewController(itemVC, animated: true)
  }
}

//Mark: - Collection View Datasource
extension InventoryViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return items.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                  for: indexPath) as! ItemCollectionViewCell
    
    let item = dataForIndex(indexPath.row)
    
    cell.activityIndicatorView.startAnimating()
    cell.imageView.fillWithURL(item.imageURL, placeholder: nil) { _ in
      cell.activityIndicatorView.stopAnimating()
    }

    cell.nameLabel.text = item.detail
    return cell
  }
  
  private func dataForIndex(_ index: Int) -> Item {
    return items[index]
  }
}
