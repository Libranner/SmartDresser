//
//  OptionPickerViewController.swift
//  DressAsistant
//
//  Created by Libranner Leonel Santos Espinal on 20/06/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import UIKit

private let REUSE_IDENTIFIER = "OptionCell"

protocol OptionPickerDelegate {
  func optionPicker(didSelectItem item: Option)
}

class OptionPickerViewController: UICollectionViewController {
  
  var data = [Option]()
  var delegate: OptionPickerDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    data.append(Option(itemId: "1", name: "Prueba 1", imageURL: URL(string: "https://www.google.com")!))
    data.append(Option(itemId: "2", name: "Prueba 2", imageURL: URL(string: "https://www.google.com")!))
    data.append(Option(itemId: "3", name: "Prueba 3", imageURL: URL(string: "https://www.google.com")!))
    data.append(Option(itemId: "4", name: "Prueba 4", imageURL: URL(string: "https://www.google.com")!))
    data.append(Option(itemId: "5", name: "Prueba 5", imageURL: URL(string: "https://www.google.com")!))
    
    setupCollectionView()
    self.clearsSelectionOnViewWillAppear = false
  }
  
  fileprivate func setupCollectionView() {
    collectionView.backgroundColor = .white
    collectionView.register(OptionCollectionViewCell.self, forCellWithReuseIdentifier: REUSE_IDENTIFIER)
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.estimatedItemSize = CGSize(width: 100,height: 100)
    flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    collectionView.collectionViewLayout = flowLayout

    /*if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
      flowLayout.estimatedItemSize = CGSize(width: 1,height: 1)
      flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 10)
    }*/
  }
  
  // MARK: - Collection View Datasouce
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return data.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: REUSE_IDENTIFIER, for: indexPath) as! OptionCollectionViewCell
    let item = data[indexPath.row]
    cell.configureCell(name: item.name, imageURL: item.imageURL, backgroundColor: .blue)
    return cell
  }
  
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let item = data[indexPath.row]
    delegate?.optionPicker(didSelectItem: item)
    dismiss(animated: true)
  }
}
