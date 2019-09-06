//
//  RecommendationViewController.swift
//  DressAsistant
//
//  Created by Libranner Leonel Santos Espinal on 25/05/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import UIKit

class RecommendationViewController: BaseViewController {
  private let reuseIdentifier = "ItemCell"
  var outfits = [Outfit]()
  private var index = -1
  private let showItemSegue = "showItems"
  
  private var currentOutfit: Outfit {    
    if index >= outfits.count || index < 0 {
      index = 0
    }
    return outfits[index]
  }
  
  convenience init(outfits: [Outfit]) {
    self.init()
    self.outfits = outfits
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if !outfits.isEmpty {
      if outfits.count > 1 {
        let desc = """
        Ahora selecciona cual de los atuendos
        prefieres. Hay \(outfits.count) disponibles
        """
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
          UIAccessibility.post(notification: .announcement, argument: desc)
        }
      }
      
      loadData()
      setupUI()
    }
  }
  
  private lazy var collectionView: UICollectionView = {
    let layout = ItemsCollectionLayout(direction: .horizontal)
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.backgroundColor = .white
    collectionView.register(ItemCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    collectionView.dataSource = self
    collectionView.delegate = self
    return collectionView
  }()
  
  lazy var mainStackView: UIStackView = {
    let mainStackView = UIStackView()
    mainStackView.axis = .vertical
    mainStackView.distribution = .equalSpacing
    mainStackView.spacing = 30
    return mainStackView
  }()
  
  lazy var scrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.isScrollEnabled = true
    scrollView.showsVerticalScrollIndicator = true
    return scrollView
  }()
  
  private func setupUI() {
    view.addSubview(scrollView)
    
    scrollView.snp.makeConstraints { make in
      make.edges.equalTo(view.safeAreaLayoutGuide)
        .inset(UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
        .labeled("ScrollViewEdges")
    }
    
    scrollView.addSubview(mainStackView)
    mainStackView.snp.makeConstraints { make in
      make.centerX.equalTo(scrollView).labeled("MainStackViewCenterX")
      make.top.equalTo(scrollView).offset(20).labeled("MainStackViewTop")
      make.width.equalToSuperview().multipliedBy(0.95).labeled("MainStackViewWidth")
    }
    
    mainStackView.addArrangedSubview(collectionView)
    let height = Int((((UIScreen.main.bounds.width * 0.90) - 25) / 2)) + 45
    collectionView.snp.makeConstraints { make in
      make.width.equalToSuperview().labeled("CollectionViewWidthAndCenter")
      make.height.equalTo(height).labeled("CollectionViewHeight")
    }
    
    if !outfits.isEmpty {
      loadRecommendationInfo()
      setupControlButtons()
    }
  }
  
  private func loadData() {
    var desc = currentOutfit.items.reduce("") { (result, item) -> String in
      if result.isEmpty {
        return "\(result) \(item.detail)"
      }
      return "\(result), \(item.detail)"
    }
    
    descriptionLabel.text = desc
    
    self.title = "Recomendación \(index + 1)"
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
      desc = "Este atuendo está constituido por: \(desc)"
      let message = ""
      UIAccessibility.post(notification: .announcement, argument: message)
    }
    
    collectionView.reloadData()
  }
  
  private lazy var selectButton: UIButton = {
    return UIHelper().makeDefaultButton("Elegir esta recomendación", identifier: nil)
  }()
  
  private lazy var titleLabel: UILabel = {
    let label = UIHelper().makeTitleLabelFor("Descripción del atuendo", identifier: nil)
    label.font = UIFont.boldSystemFont(ofSize: 16)
    label.numberOfLines = 0
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textAlignment = .center
    return label
  }()
  
  private lazy var descriptionLabel: UILabel = {
    let label = UIHelper().makeDescriptionLabelFor("", identifier: nil)
    label.font = UIFont.boldSystemFont(ofSize: 20)
    label.numberOfLines = 0
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textAlignment = .center
    return label
  }()
  
  private lazy var controlButtonStackView: UIStackView = {
    let stackview = UIStackView()
    stackview.axis = .horizontal
    stackview.distribution = .equalSpacing
    stackview.translatesAutoresizingMaskIntoConstraints = false
    
    if (outfits.count > 1) {
      let previousButton = UIButton()
      previousButton.accessibilityLabel = "Escuchar recomendación anterior"
      previousButton.setBackgroundImage(UIImage(named: "previous"), for: .normal)
      previousButton.addTarget(self, action: #selector(showPrevioustRecomendation), for: .touchUpInside)
      previousButton.translatesAutoresizingMaskIntoConstraints = false
      
      let nextButton = UIButton()
      nextButton.accessibilityLabel = "Escuchar recomendación siguiente"
      nextButton.addTarget(self, action: #selector(showNextRecomendation), for: .touchUpInside)
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
    }
    
    return stackview
  }()
  
  @objc private func showNextRecomendation() {
    index += 1
    loadData()
  }
  
  @objc private func showPrevioustRecomendation() {
    index -= 1
    loadData()
  }
  
  private func setupControlButtons() {
    view.addSubview(controlButtonStackView)
    controlButtonStackView.snp.makeConstraints { make in
      make.top.equalTo(selectButton.snp.bottom).offset(60)
      make.height.equalTo(80)
      make.width.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.6)
      make.centerX.equalToSuperview()
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == showItemSegue {
      let itemsVC = segue.destination as! RecomendationItemViewController
      itemsVC.items = currentOutfit.items
    }
  }
  
  private func loadRecommendationInfo() {
    let infoStackView = UIStackView()
    infoStackView.distribution = .fill
    infoStackView.axis = .vertical
    infoStackView.alignment = .fill
    infoStackView.spacing = 10
    infoStackView.accessibilityIdentifier = "InfoStackView"
    
    let rowStackView = UIStackView()
    rowStackView.distribution = .fill
    rowStackView.alignment = .leading
    rowStackView.axis = .vertical
    rowStackView.spacing = 15
    
    rowStackView.addArrangedSubview(titleLabel)
    rowStackView.addArrangedSubview(descriptionLabel)
    
    let separatorView = UIHelper().makeSeparatorView()
    rowStackView.addArrangedSubview(separatorView)
    
    separatorView.snp.makeConstraints { make in
      make.width.equalToSuperview().labeled("SeparatorViewWidth")
      make.height.equalTo(0.5).labeled("SeparatorViewHeight")
    }
    
    infoStackView.addArrangedSubview(rowStackView)

    mainStackView.addArrangedSubview(infoStackView)
    scrollView.addSubview(selectButton)
    
    selectButton.snp.makeConstraints { make in
      make.height.equalTo(UIConstants.defaultBigButtonHeight)
      make.top.equalTo(separatorView.snp.bottom).offset(40)
      make.width.equalToSuperview().multipliedBy(0.8)
      make.centerX.equalToSuperview()
    }
    
    selectButton.addTarget(self, action: #selector(selectRecomendation(_:)), for: .touchUpInside)
  }
  
  @objc private func selectRecomendation(_ sender: Any?) {
    performSegue(withIdentifier: showItemSegue, sender: self)
  }
}

extension RecommendationViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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

//Collection View DataSource
extension RecommendationViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return currentOutfit.items.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                  for: indexPath) as! ItemCollectionViewCell
    let item = currentOutfit.items[indexPath.row]
    cell.activityIndicatorView.startAnimating()
    cell.imageView.fillWithURL(item.imageURL, placeholder: nil) { _ in
      cell.activityIndicatorView.stopAnimating()
    }
    
    cell.nameLabel.text = item.detail
    cell.selectItemButton.isHidden = true
    cell.imageView.accessibilityLabel = item.detail
    
    return cell
  }
}
