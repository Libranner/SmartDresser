//
//  ModalView.swift
//  DressAsistant
//
//  Created by Libranner Leonel Santos Espinal on 21/07/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import UIKit

protocol ModalViewDelegate {
  func modalClosed(modalView: ModalView)
}

class ModalView: UIView {
  enum ModalType {
    case info
    case success
    case error
  }
  var modalType: ModalType?
  var delegate: ModalViewDelegate?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  init(type: ModalType, title: String, message: String) {
    super.init(frame: .zero)
    self.titleLabel.text = title
    self.messageLabel.text = message
    self.modalType = type
    
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeModal))
    self.addGestureRecognizer(tapGesture)
  }
  
  @objc private func closeModal(){
    UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut, animations: {
      self.alpha = 0
    }){ _ in
      self.removeFromSuperview()
      self.delegate?.modalClosed(modalView: self)
    }
  }
  
  override func layoutSubviews() {
    setupLayout()
  }
  
  fileprivate lazy var titleLabel: UILabel = {
    let label = UIHelper().makeTitleLabelFor("", identifier: nil)
    label.numberOfLines = 0
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textAlignment = .center
    return label
  }()
  
  fileprivate lazy var messageLabel: UILabel = {
    let label = UIHelper().makeInfoLabelFor("", identifier: nil)
    label.numberOfLines = 0
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textAlignment = .center
    return label
  }()
  
  fileprivate lazy var iconImageView: UIImageView = {
    let iconImageView = UIImageView()
    iconImageView.contentMode = .scaleAspectFill
    iconImageView.translatesAutoresizingMaskIntoConstraints = false
   
    return iconImageView
  }()
  
  func setupLayout() {
    backgroundColor = .white
    alpha = 0.95
    layer.cornerRadius = 10
    layer.borderWidth = 1.0
    layer.borderColor = UIColor.clear.cgColor
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOpacity = 0.6
    layer.shadowOffset = .zero
    layer.shadowRadius = 4
    
    addSubview(titleLabel)
    addSubview(iconImageView)
    addSubview(messageLabel)
    
    switch modalType! {
    case .success:
      iconImageView.image = UIImage(named: "success")
    default:
      iconImageView.image = nil
    }
    
    self.snp.makeConstraints { make in
      make.center.equalToSuperview()
      make.height.equalTo(self.superview!.safeAreaLayoutGuide).multipliedBy(0.80)
      make.width.equalToSuperview().multipliedBy(0.80)
    }
    
    titleLabel.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.centerY.equalToSuperview().multipliedBy(0.6)
      make.width.equalToSuperview().multipliedBy(0.80)
    }
    
    iconImageView.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalTo(titleLabel.snp.bottom).offset(30)
      make.height.equalToSuperview().multipliedBy(0.20)
      make.width.equalTo(iconImageView.snp.height)
    }
    
    messageLabel.snp.makeConstraints { make in
      make.centerX.equalTo(titleLabel)
      make.top.equalTo(iconImageView.snp.bottom).offset(30)
      make.width.equalTo(titleLabel)
    }
    
    self.alpha = 0
    UIView.animate(withDuration: 0.35, delay: 0,
                   options: .curveEaseIn, animations: {
      self.alpha = 0.97
    })
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
