//
//  LoadingView.swift
//  DressAsistant
//
//  Created by Libranner Leonel Santos Espinal on 09/06/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import UIKit
import SnapKit

class LoadingView: UIView {
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupLayout()
  }
  
  fileprivate lazy var loadingLabel: UILabel = {
    let label = UIHelper().makeInfoLabelFor("loading", identifier: nil)
    label.textColor = CustomColor.infoLabelColor
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textAlignment = .center
    return label
  }()
  
  fileprivate lazy var iconImageView: UIImageView = {
    let iconImageView = UIImageView()
    iconImageView.image = UIImage(named: "transparent-icon")
    iconImageView.contentMode = .scaleAspectFill
    iconImageView.translatesAutoresizingMaskIntoConstraints = false

    let keyPath = "transform.scale"
    let animation = CABasicAnimation(keyPath: keyPath)
    animation.duration = 0.4
    animation.fromValue = 1.0
    animation.toValue = 1.1
    animation.autoreverses = true
    animation.repeatCount = HUGE
    
    iconImageView.layer.add(animation, forKey: keyPath)
    
    return iconImageView
  }()
  
  func setupLayout() {
    backgroundColor = .white
    alpha = 0.9
    layer.cornerRadius = 10
    layer.borderWidth = 1.0
    layer.borderColor = UIColor.clear.cgColor
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOpacity = 0.6
    layer.shadowOffset = .zero
    layer.shadowRadius = 4
    
    addSubview(iconImageView)
    addSubview(loadingLabel)
    
    iconImageView.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.centerY.equalToSuperview().offset(-20)
      make.height.equalToSuperview().multipliedBy(0.4)
      make.width.equalTo(iconImageView.snp.height)
    }
    
    loadingLabel.snp.makeConstraints { make in
      make.centerX.equalTo(iconImageView)
      make.top.equalTo(iconImageView.snp.bottom).offset(20)
      make.width.equalToSuperview().multipliedBy(0.8)
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
