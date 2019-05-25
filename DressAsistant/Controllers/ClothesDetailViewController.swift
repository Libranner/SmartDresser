//
//  ClothesDetailViewController.swift
//  DressAsistant
//
//  Created by Libranner Leonel Santos Espinal on 22/05/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import UIKit
import SnapKit

class ClothesDetailViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupUI()
  }
  
  lazy var imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    imageView.image = UIImage(named: "logotipo")
    return imageView
  }()
  
  lazy var mainStackView: UIStackView = {
    let mainStackView = UIStackView()
    mainStackView.axis = .vertical
    mainStackView.distribution = .equalSpacing
    mainStackView.spacing = 10
    return mainStackView
  }()
  
  lazy var scrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.isScrollEnabled = true
    scrollView.showsVerticalScrollIndicator = true
    return scrollView
  }()

  
  fileprivate func setupUI() {
    view.addSubview(scrollView)
    
    scrollView.snp.makeConstraints { make in
      make.edges.equalTo(view.safeAreaLayoutGuide)
        .inset(UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
    }
    
    imageView.image = UIImage(named: "logotipo")
    scrollView.addSubview(mainStackView)
    
    mainStackView.snp.makeConstraints { make in
      make.edges.centerX.equalTo(scrollView)
    }
    
    mainStackView.addArrangedSubview(imageView)
    imageView.snp.makeConstraints { make in
      make.width.centerX.equalToSuperview()
      make.height.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.45)
    }
    
    setupClotheInfo()
  }
  
  func setupClotheInfo() {
    let data = ["Description":"Test Test Test", "Size": "sdfsdf"]
    
    let infoStackView = UIStackView()
    infoStackView.distribution = .fill
    infoStackView.axis = .vertical
    infoStackView.alignment = .fill
    infoStackView.spacing = 10

    for _ in 0..<20 {
      for element in data {
        let rowStackView = UIStackView()
        rowStackView.distribution = .fill
        rowStackView.alignment = .leading
        rowStackView.axis = .vertical
        rowStackView.spacing = 5
        
        let infoLabel = UIHelper().makeInfoLabelFor(element.key)
        let descLabel = UIHelper().makeDescriptionLabelFor(element.value)
        
        rowStackView.addArrangedSubview(infoLabel)
        rowStackView.addArrangedSubview(descLabel)
        
        let separatorView = UIHelper().makeSeparatorView()
        rowStackView.addArrangedSubview(separatorView)
        
        separatorView.snp.makeConstraints { make in
          make.width.equalToSuperview()
          make.height.equalTo(1)
        }
        
        infoStackView.addArrangedSubview(rowStackView)
      }
    }
    
    mainStackView.addArrangedSubview(infoStackView)
  }  
}
