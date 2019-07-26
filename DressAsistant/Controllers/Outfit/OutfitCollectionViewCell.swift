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
  
  lazy var timeOfDayLabel: UILabel = {
    let label = UIHelper().makeInfoLabelFor("", identifier: nil)
    label.textColor = .white
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textAlignment = .center
    return label
  }()
  
  lazy var weatherLabel: UILabel = {
    let label = UIHelper().makeInfoLabelFor("", identifier: nil)
    label.textColor = .white
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textAlignment = .center
    return label
  }()
  
  lazy var seasonLabel: UILabel = {
    let label = UIHelper().makeInfoLabelFor("", identifier: nil)
    label.textColor = .white
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textAlignment = .center
    return label
  }()
  
  lazy var eventTypeLabel: UILabel = {
    let label = UIHelper().makeInfoLabelFor("", identifier: nil)
    label.textColor = .white
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textAlignment = .center
    return label
  }()
  
  lazy var messageLabel: UILabel = {
    let label = UIHelper().makeInfoLabelFor("", identifier: nil)
    label.numberOfLines = 0
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textAlignment = .center
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
  
  private func makePillView(_ label: UILabel) -> UIView {
    let pillView = UIView()
    pillView.translatesAutoresizingMaskIntoConstraints = false
    
    let padding: CGFloat = 5
    let height = label.font.pointSize + padding * 2
    
    pillView.layer.cornerRadius = height/2
    pillView.backgroundColor = CustomColor.secondaryColor
    pillView.addSubview(label)
    
    label.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(padding)
      make.bottom.equalToSuperview().offset(-padding)
      make.centerX.equalToSuperview()
    }
    
    return pillView
  }
  
  private lazy var dataStackView: UIStackView = {
    let topStack = UIStackView(arrangedSubviews: [makePillView(timeOfDayLabel),
                                                  makePillView(eventTypeLabel)])
    topStack.distribution = .fillProportionally
    topStack.spacing = 10
    topStack.axis = .horizontal
    topStack.translatesAutoresizingMaskIntoConstraints = false
    
    let middleStack = UIStackView(arrangedSubviews: [makePillView(weatherLabel),
                                                     makePillView(seasonLabel)])
    middleStack.distribution = .fillProportionally
    middleStack.spacing = 10
    middleStack.axis = .horizontal
    middleStack.translatesAutoresizingMaskIntoConstraints = false
    
    let dataStackView = UIStackView(arrangedSubviews: [topStack, middleStack, messageLabel])
    dataStackView.distribution = .fill
    dataStackView.spacing = 7
    dataStackView.axis = .vertical
    dataStackView.translatesAutoresizingMaskIntoConstraints = false
    
    return dataStackView
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
    //contentView.addSubview(mainStackView)
    
    contentView.addSubview(carouselContainerView)
    contentView.addSubview(separatorView)
    contentView.addSubview(dataStackView)
    contentView.backgroundColor = .white
    
    contentView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
      make.width.equalTo(carouselContainerView)
    }
    
    let width = Int(UIScreen.main.bounds.width * 0.7)
    let height = Float(width) * 1.2
    
    carouselContainerView.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.width.equalTo(width)
      make.height.equalTo(height)
    }
    
    separatorView.snp.makeConstraints { make in
      make.height.equalTo(UIConstants.separatorViewHeight)
      make.leading.trailing.equalToSuperview()
      make.top.equalTo(carouselContainerView.snp.bottom)
    }
    
    dataStackView.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(10)
      make.bottom.trailing.equalToSuperview().offset(-10)
      make.top.equalTo(separatorView.snp.bottom).offset(10)
    }
  }
}
