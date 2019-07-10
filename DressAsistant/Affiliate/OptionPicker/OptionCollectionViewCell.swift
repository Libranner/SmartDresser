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
  
  private lazy var optionImageView: RoundImageView = {
    let imageView = RoundImageView(frame: .zero)
    imageView.backgroundColor = .clear
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()
  
  private lazy var activityIndicatorView: UIActivityIndicatorView = {
    let activityIndicatorView = UIActivityIndicatorView(style: .gray)
    activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
    activityIndicatorView.hidesWhenStopped = true
    
    return activityIndicatorView
  }()
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    contentView.addSubview(optionImageView)
    
    optionImageView.snp.makeConstraints { make  in
      make.width.equalTo(CELL_WIDTH)
      make.height.equalTo(optionImageView.snp.width)
      make.edges.equalToSuperview()
    }
    
    contentView.addSubview(activityIndicatorView)
    activityIndicatorView.snp.makeConstraints { make  in
      make.center.equalToSuperview()
    }
  }
  
  func configureCell(name: String, imageURL: URL?, backgroundColor: UIColor = .clear) {
    if let url = imageURL {
      activityIndicatorView.startAnimating()
      optionImageView.fillWithURL(url, placeholder: nil) { [weak self] success in
        if success {
          self?.activityIndicatorView.stopAnimating()
        }
      }
    }
    optionImageView.backgroundColor = backgroundColor
  }
  
}
