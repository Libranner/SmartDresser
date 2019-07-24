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
  
  lazy var imageView: AsyncImageView = {
    let imageview = AsyncImageView()
    imageview.translatesAutoresizingMaskIntoConstraints = false
    imageview.clipsToBounds = true
    imageview.layer.cornerRadius = 10
    imageview.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    
    return imageview
  }()
  
  private lazy var labelContainerView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    
    view.addSubview(nameLabel)
    view.snp.makeConstraints { make in
      make.top.equalTo(nameLabel).offset(-5)
      make.bottom.equalTo(nameLabel)
      make.leading.equalTo(nameLabel).offset(-5)
      make.trailing.equalTo(nameLabel).offset(5)
    }
    
    return view
  }()
  
  fileprivate var separatorView: UIView = {
    let view = UIHelper().makeSeparatorView()
    view.translatesAutoresizingMaskIntoConstraints = false
    
    return view
  }()
  
  private lazy var mainStackView: UIStackView = {
    let stackview = UIStackView(arrangedSubviews:
      [imageView, separatorView, labelContainerView])
    stackview.distribution = .equalSpacing
    stackview.axis = .vertical
    stackview.spacing = 0
    stackview.translatesAutoresizingMaskIntoConstraints = false
    
    return stackview
  }()
  
  lazy var selectItemButton: UIButton = {
    let button = UIButton()
    button.setBackgroundImage(UIImage(named: "select-item-icon"), for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    
    return button
  }()
  
  func formatCell(showAsSelected: Bool) {
    let borderColor = showAsSelected ? CustomColor.selectedItemColor.cgColor :
      UIColor.lightGray.cgColor
    let borderWidth: CGFloat = showAsSelected ? 2.0 : 1.0
    let shadowColor = showAsSelected ? CustomColor.selectedItemColor.cgColor :
      UIColor.black.cgColor
    
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
  
  private func setupUI() {
    contentView.addSubview(mainStackView)
    contentView.addSubview(activityIndicatorView)
    contentView.backgroundColor = .white
    contentView.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(mainStackView)
    contentView.addSubview(activityIndicatorView)
    contentView.addSubview(selectItemButton)
    contentView.backgroundColor = .white
    
    activityIndicatorView.snp.makeConstraints { make in
      make.center.equalTo(imageView)
    }
    
    separatorView.snp.makeConstraints { make in
      make.height.equalTo(UIConstants.separatorViewHeight)
    }
    
    snp.makeConstraints { make in
      make.edges.equalTo(contentView)
    }
    
    mainStackView.snp.makeConstraints { make in
      make.top.leading.trailing.equalToSuperview()
      make.bottom.equalTo(contentView).offset(-5)
    }
    
    selectItemButton.snp.makeConstraints { make in
      make.width.equalTo(25)
      make.height.equalTo(selectItemButton.snp.width)
      make.trailing.equalToSuperview().offset(-5)
      make.bottom.equalTo(imageView).offset(-5)
    }
    
    let width = Int((((UIScreen.main.bounds.width * 0.90) - 25) / 2))
    imageView.snp.makeConstraints { make in
      make.width.equalTo(width)
      make.height.equalTo(imageView.snp.width)
    }
  }
}

