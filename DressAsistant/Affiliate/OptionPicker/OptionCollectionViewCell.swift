//
//  OptionCollectionViewCell.swift
//  DressAsistant
//
//  Created by Libranner Leonel Santos Espinal on 20/06/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import UIKit
import SnapKit

class OptionCollectionViewCell: UICollectionViewCell {
  private let CELL_WIDTH = 100
  
  private lazy var optionImageView: AsyncImageView = {
    let imageView = AsyncImageView(frame: .zero)
    imageView.backgroundColor = .clear
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    contentView.addSubview(optionImageView)
    
    optionImageView.snp.makeConstraints { make  in
      make.width.equalTo(CELL_WIDTH)
      make.height.equalTo(optionImageView.snp.width)
      make.edges.equalToSuperview()
    }
  }
  
  func configureCell(name: String, imageURL: URL?, backgroundColor: UIColor = .clear) {
    if let url = imageURL {
      //optionImageView.fillWithURL(url, placeholder: nil)
      optionImageView.image = UIImage(named: "blue_eyes")
    }
    else {
      optionImageView.image = UIImage(named: "blue_eyes")
      optionImageView.backgroundColor = backgroundColor
    }
  }
  
}
