//
//  RecommendationViewController.swift
//  DressAsistant
//
//  Created by Libranner Leonel Santos Espinal on 25/05/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import UIKit

class RecommendationViewController: UIViewController {
  private let REUSE_IDENTIFIER = "ClothesCell"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }

  lazy var collectionView: UICollectionView = {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: ColumnFlowLayout())
    collectionView.backgroundColor = .white
    collectionView.register(ClothesCollectionViewCell.self, forCellWithReuseIdentifier: REUSE_IDENTIFIER)
    collectionView.delegate = self
    collectionView.dataSource = self
    return collectionView
  }()
  
  lazy var mainStackView: UIStackView = {
    let mainStackView = UIStackView()
    mainStackView.axis = .vertical
    mainStackView.distribution = .equalSpacing
    mainStackView.spacing = 20
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
        .labeled("ScrollViewEdges")
    }
    
    scrollView.addSubview(mainStackView)
    
    mainStackView.snp.makeConstraints { make in
      make.centerX.width.equalTo(scrollView).labeled("MainStackViewCenterX")
      make.top.equalTo(scrollView).offset(20).labeled("MainStackViewTop")
    }
    
    mainStackView.addArrangedSubview(collectionView)
    collectionView.snp.makeConstraints { make in
      make.width.equalToSuperview().labeled("CollectionViewWidthAndCenter")
      make.height.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.45).labeled("CollectionViewHeight")
    }
    
    loadRecommendationInfo()
    setupControlButtons()
  }
  
  fileprivate lazy var identifyButton: UIButton = {
    return UIHelper().makeDefaultButton("Identificar ropa", identifier: "Identificar ropa")
  }()
  
  fileprivate lazy var controlButtonStackView: UIStackView = {
    let stackview = UIStackView()
    stackview.axis = .horizontal
    stackview.distribution = .equalSpacing
    stackview.translatesAutoresizingMaskIntoConstraints = false
    
    let previousButton = UIButton()
    previousButton.setBackgroundImage(UIImage(named: "previous"), for: .normal)
    previousButton.translatesAutoresizingMaskIntoConstraints = false
    
    let nextButton = UIButton()
    nextButton.setBackgroundImage(UIImage(named: "next"), for: .normal)
    nextButton.translatesAutoresizingMaskIntoConstraints = false
    
    stackview.addArrangedSubview(previousButton)
    stackview.addArrangedSubview(nextButton)
    
    previousButton.snp.makeConstraints { make in
      make.width.equalTo(80)
    }
    
    nextButton.snp.makeConstraints { make in
      make.width.equalTo(80)
    }
    
    return stackview
  }()
  
  fileprivate func setupControlButtons() {
    mainStackView.addArrangedSubview(controlButtonStackView)
    
    controlButtonStackView.snp.makeConstraints { make in
      make.height.equalTo(80)
    }
  }
  
  fileprivate func loadRecommendationInfo() {
    let data = ["Description":"Test Test Test"]
    
    let infoStackView = UIStackView()
    infoStackView.distribution = .fill
    infoStackView.axis = .vertical
    infoStackView.alignment = .fill
    infoStackView.spacing = 10
    infoStackView.accessibilityIdentifier = "InfoStackView"
    
    for element in data {
      let rowStackView = UIStackView()
      rowStackView.distribution = .fill
      rowStackView.alignment = .leading
      rowStackView.axis = .vertical
      rowStackView.spacing = 5
      
      let identifier = "\(element.key): \(element.value)"
      let infoLabel = UIHelper().makeInfoLabelFor(element.key, identifier: identifier)
      let descLabel = UIHelper().makeDescriptionLabelFor(element.value, identifier: identifier)
      
      rowStackView.addArrangedSubview(infoLabel)
      rowStackView.addArrangedSubview(descLabel)
      
      let separatorView = UIHelper().makeSeparatorView()
      rowStackView.addArrangedSubview(separatorView)
      
      separatorView.snp.makeConstraints { make in
        make.width.equalToSuperview().labeled("SeparatorViewWidth")
        make.height.equalTo(1).labeled("SeparatorViewHeight")
      }
      
      infoStackView.addArrangedSubview(rowStackView)
    }
    
    mainStackView.addArrangedSubview(infoStackView)
    mainStackView.addArrangedSubview(identifyButton)
    
    identifyButton.snp.makeConstraints { make in
      make.height.equalTo(UIConstants.defaultButtonHeight)
    }
  }
}

extension RecommendationViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
  }
}

extension RecommendationViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 3
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: REUSE_IDENTIFIER,
                                                  for: indexPath) as! ClothesCollectionViewCell
    
    cell.backgroundColor = .white
    cell.imageView.image = UIImage(named: "next")
    
    return cell
  }
}

private class ClothesCollectionViewCell: UICollectionViewCell {
  var imageView: UIImageView = UIImageView()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupUI() {
    addSubview(imageView)
    imageView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
}
