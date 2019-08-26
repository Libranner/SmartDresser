//
//  ClothesDetailViewController.swift
//  DressAsistant
//
//  Created by Libranner Leonel Santos Espinal on 22/05/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import UIKit
import SnapKit

class ClothesDetailViewController: BaseViewController {
  let clotheImageIdentifier = "Foto de la ropa"
  let alertSheetMessageStringId = "Ropa identificada. ¿Qué deseas hacer ahora?"
  let readAgainStringId = "Leer datos nuevamente"
  let recommendationTextStringId = "Recibir recomendación"
  let scanAgainStringId = "Escanear otra ropa"
  let finishStringId = "Terminar"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = CustomColor.defaultBackgroundColor
    setupUI()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    scrollView.transform = CGAffineTransform(translationX: scrollView.bounds.size.width, y: 0)

    UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseIn, animations: {
      self.scrollView.transform = CGAffineTransform.identity
    }, completion: nil)
  }
  
  lazy var imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    imageView.accessibilityIdentifier = clotheImageIdentifier
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
        .labeled("ScrollViewEdges")
    }
    
    imageView.image = UIImage(named: "logotipo")
    scrollView.addSubview(mainStackView)
    
    mainStackView.snp.makeConstraints { make in
      make.edges.centerX.equalTo(scrollView).labeled("MainStackViewPosition")
    }
    
    mainStackView.addArrangedSubview(imageView)
    imageView.snp.makeConstraints { make in
      make.width.centerX.equalToSuperview().labeled("ImageViewWidthAndCenter")
      make.height.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.45).labeled("ImageViewHeight")
    }
    
    setupInfo()
  }
  
  func setupInfo() {
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
        
        let identifier = "\(element.key): \(element.value)"
        let infoLabel = UIHelper().makeInfoLabelFor(element.key, identifier: identifier)
        //let descLabel = UIHelper().makeDescriptionLabelFor(element.value, identifier: identifier)
        
        rowStackView.addArrangedSubview(infoLabel)
        //rowStackView.addArrangedSubview(descLabel)
        
        let textfield = UITextField()
        textfield.borderStyle = .roundedRect
        textfield.placeholder = element.key
        rowStackView.addArrangedSubview(textfield)
        
        textfield.snp.makeConstraints { make in
          make.width.equalToSuperview()
          make.height.equalTo(UIConstants.textfieldSize).labeled("TextFieldViewHeight")
        }
        
        let separatorView = UIHelper().makeSeparatorView()
        rowStackView.addArrangedSubview(separatorView)
        
        separatorView.snp.makeConstraints { make in
          make.width.equalToSuperview().labeled("SeparatorViewWidth")
          make.height.equalTo(1).labeled("SeparatorViewHeight")
        }
        
        infoStackView.addArrangedSubview(rowStackView)
      }
    }
    
    mainStackView.addArrangedSubview(infoStackView)
  }
  
  func showOptions() {
    let message = NSLocalizedString(alertSheetMessageStringId, comment: "")
    let readAgainText = NSLocalizedString(readAgainStringId, comment: "")
    let recommendationText = NSLocalizedString(recommendationTextStringId, comment: "")
    let continueScanText = NSLocalizedString(scanAgainStringId, comment: "")
    let finishText = NSLocalizedString(finishStringId, comment: "")
    
    let alertVC = UIAlertController(title: nil, message: message, preferredStyle: .actionSheet)
    let readAgainAction = UIAlertAction(title: readAgainText, style: .default, handler: nil)
    let recommendationAction = UIAlertAction(title: recommendationText, style: .default, handler: nil)
    let continueScanningAction = UIAlertAction(title: continueScanText, style: .cancel, handler: nil)
    let finishAction = UIAlertAction(title: finishText, style: .destructive, handler: nil)
    
    alertVC.addAction(readAgainAction)
    alertVC.addAction(recommendationAction)
    alertVC.addAction(continueScanningAction)
    alertVC.addAction(finishAction)
    
    present(alertVC, animated: true, completion: nil)
  }
}
