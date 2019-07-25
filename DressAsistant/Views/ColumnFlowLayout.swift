/*
 See LICENSE folder for this sample’s licensing information.
 
 Abstract:
 Custom view flow layout for single column or multiple columns.
 */

import UIKit

class ColumnFlowLayout: UICollectionViewFlowLayout {
  
  private let minColumnWidth: CGFloat = 100.0
  
  // MARK: Layout Overrides
  override func prepare() {
    super.prepare()
    
    guard let collectionView = collectionView else { return }
    
    let availableHeight = collectionView.bounds.inset(by: collectionView.layoutMargins).height
    let availableWidth = collectionView.bounds.inset(by: collectionView.layoutMargins).width
    
    let cellwidth: CGFloat = availableWidth * 0.80

    self.scrollDirection = .horizontal
    self.itemSize = CGSize(width: cellwidth, height: availableHeight )
    self.sectionInset = UIEdgeInsets(top: self.minimumInteritemSpacing, left: 0.0, bottom: 0.0, right: 0.0)
    self.sectionInsetReference = .fromSafeArea
  }
}


class RowFlowLayout: UICollectionViewFlowLayout {
  
  private let minColumnWidth: CGFloat = 100.0
  
  // MARK: Layout Overrides
  override func prepare() {
    super.prepare()
    
    guard let collectionView = collectionView else { return }
    
    let availableHeight = collectionView.bounds.inset(by: collectionView.layoutMargins).height
    let availableWidth = collectionView.bounds.inset(by: collectionView.layoutMargins).width
    
    let cellwidth: CGFloat = availableWidth * 0.80
    
    self.scrollDirection = .vertical
    self.itemSize = CGSize(width: cellwidth, height: availableHeight )
    self.sectionInset = UIEdgeInsets(top: self.minimumInteritemSpacing, left: 0.0, bottom: 0.0, right: 0.0)
    self.sectionInsetReference = .fromSafeArea
  }
}
