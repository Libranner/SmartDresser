//
//  OutfitCollectionViewCell.swift
//  DressAsistant
//
//  Created by Libranner Leonel Santos Espinal on 24/07/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import UIKit

class OutfitCollectionViewCell: UICollectionViewCell {
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  lazy var activityIndicatorView: UIActivityIndicatorView = {
    let activityIndicatorView = UIActivityIndicatorView(style: .gray)
    activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
    activityIndicatorView.hidesWhenStopped = true
    activityIndicatorView.startAnimating()
    
    return activityIndicatorView
  }()
  
  lazy var dataLabel: UILabel = {
    let label = UIHelper().makeInfoLabelFor("", identifier: nil)
    label.numberOfLines = 0
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private var carousel: ItemsPictureViewController = {
    let carousel = ItemsPictureViewController(picturesURLs: [])
    
    return carousel
  }()
  
  private var separatorView: UIView = {
    let view = UIHelper().makeSeparatorView()
    view.translatesAutoresizingMaskIntoConstraints = false
    
    return view
  }()
  
  private lazy var carouselContainerView: UIView = {
    let view = UIView()
    view.backgroundColor = .white
    view.clipsToBounds = true
    view.layer.cornerRadius = 10
    view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    
    view.addSubview(carousel.view)
    
    carousel.view.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
    return view
  }()
  
  private lazy var mainStackView: UIStackView = {
    let stackview = UIStackView(arrangedSubviews: [carouselContainerView,
                                                   separatorView,
                                                   dataLabel])
    stackview.distribution = .equalSpacing
    stackview.axis = .vertical
    stackview.spacing = 0
    stackview.translatesAutoresizingMaskIntoConstraints = false
    
    return stackview
  }()
  
  private func formatCell() {
    let borderColor = UIColor.lightGray.cgColor
    let borderWidth: CGFloat = 2.0
    let shadowColor = UIColor.black.cgColor
    
    contentView.layer.cornerRadius = 10
    contentView.layer.borderWidth = borderWidth
    contentView.layer.borderColor = borderColor
    contentView.layer.shadowColor = shadowColor
    contentView.layer.shadowOpacity = 0.6
    contentView.layer.shadowOffset = .zero
    contentView.layer.shadowRadius = 4
  }
  
  override func prepareForReuse() {

  }
  
  func setPictures(_ urls:[URL]) {
    carousel.picturesURLs = urls
  }
  
  private func setupUI() {
    formatCell()

    contentView.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(mainStackView)
    contentView.backgroundColor = .white
    
    contentView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
    separatorView.snp.makeConstraints { make in
      make.height.equalTo(UIConstants.separatorViewHeight)
    }
    
    let width = Int(UIScreen.main.bounds.width * 0.7)
    let height = Float(width) * 1.2
    
    carouselContainerView.snp.makeConstraints { make in
      make.width.equalTo(width)
      make.height.equalTo(height)
    }
    
    mainStackView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
}
