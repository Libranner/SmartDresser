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
    static let inventorySelectionTitle = "inventory-selection-title"
  }
  
  lazy var loadingView = LoadingView()
  private let reuseIdentifier = "ItemCell"
  private var items = [Item]()
  private var selectedItems = [Item]()
  private var isInSelectMode = false
  
  convenience init(isInSelectMode: Bool) {
    self.init()
    self.isInSelectMode = isInSelectMode
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = NSLocalizedString(Localizations.inventoryTitle,
                                   comment: "")
    
    let addButton = UIBarButtonItem(barButtonSystemItem: .add,
                                    target: self, action: #selector(addItem))
    navigationItem.rightBarButtonItem = addButton
    
    let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh,
                                        target: self, action: #selector(refreshData))
    navigationItem.leftBarButtonItem = refreshButton
    
    setupUI()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    loadData()
  }
  
  @objc private func refreshData() {
    selectedItems.removeAll()
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
    let layout = ItemsCollectionLayout(direction: .vertical)
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
    
    if isInSelectMode {
      let isAlreadySelected = isItemAlreadySelected(item)
      cell.formatCell(showAsSelected: isAlreadySelected)
    }

    cell.activityIndicatorView.startAnimating()
    cell.imageView.fillWithURL(item.imageURL, placeholder: nil) { _ in
      cell.activityIndicatorView.stopAnimating()
    }

    cell.nameLabel.text = item.detail
    cell.selectItemButton.tag = indexPath.row
    cell.selectItemButton.isHidden = !isInSelectMode
    
    if isInSelectMode {
      cell.selectItemButton.addTarget(self, action: #selector(itemSelected), for: .touchUpInside)
    }
    
    return cell
  }
  
  @objc private func itemSelected(sender: Any?) {
    let button = sender as! UIButton
    let selectedItem = dataForIndex(button.tag)
    var isAdded = false
    
    if isItemAlreadySelected(selectedItem) {
      selectedItems.removeAll { (item) -> Bool in
        return item.key == selectedItem.key
      }
    }
    else {
      selectedItems.append(selectedItem)
      isAdded = true
    }
    
    if selectedItems.count > 0 {
      let localizedString = NSLocalizedString(Localizations.inventorySelectionTitle, comment: "")
      self.title = String(format: localizedString, selectedItems.count)
    }
    else {
      self.title = NSLocalizedString(Localizations.inventoryTitle,
                                     comment: "")
    }
    
    if let cell = button.superview?.superview as? ItemCollectionViewCell {
      cell.formatCell(showAsSelected: isAdded)
    }
  }
  
  private func isItemAlreadySelected(_ item: Item) -> Bool {
    let result = selectedItems.first(where: { it -> Bool in
      return it.key == item.key
    })
    
    return result != nil
  }
  
  private func dataForIndex(_ index: Int) -> Item {
    return items[index]
  }
}

