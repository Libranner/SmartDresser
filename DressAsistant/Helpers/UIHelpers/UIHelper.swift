//
//  UIHelper.swift
//  DressAsistant
//
//  Created by Libranner Leonel Santos Espinal on 25/05/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import Foundation
import UIKit

struct UIHelper {
  func makeSeparatorView() -> UIView {
    let separatorView = UIView()
    separatorView.backgroundColor = .lightGray
    separatorView.translatesAutoresizingMaskIntoConstraints = false
    return separatorView
  }
  
  func makeTextFieldFor(_ localizationStringId: String, identifier: String?) -> UITextField {
    let textfield = UITextField()
    textfield.borderStyle = .roundedRect
    textfield.translatesAutoresizingMaskIntoConstraints = false
    
    let localizeString = NSLocalizedString(localizationStringId, comment: "")
    textfield.accessibilityIdentifier = identifier ?? localizeString
    textfield.placeholder = localizeString
    
    return textfield
  }
  
  func makeTitleLabelFor(_ localizationStringId: String, identifier: String?) -> UILabel {
    let label = makeLabel(localizationStringId, identifier: identifier)
    label.text = label.text?.uppercased()
    label.font = UIFont.boldSystemFont(ofSize: 14)
    label.textColor = .lightGray
    
    return label
  }
  
  func makeDescriptionLabelFor(_ localizationStringId: String, identifier: String?) -> UILabel {
    let label = makeLabel(localizationStringId, identifier: identifier)
    label.font = UIFont.systemFont(ofSize: 16)
    label.textColor = .black
    
    return label
  }
  
  func makeInfoLabelFor(_ localizationStringId: String, identifier: String?) -> UILabel {
    let label = makeLabel(localizationStringId, identifier: identifier)
    label.font = UIFont.boldSystemFont(ofSize: 12)
    label.textColor = .lightGray
    
    return label
  }
  
  fileprivate func makeLabel(_ localizationStringId: String, identifier: String?) -> UILabel{
    let label = UILabel()
    let localizeString = NSLocalizedString(localizationStringId, comment: "")
    label.accessibilityIdentifier = identifier ?? localizeString
    label.text = localizeString
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }
  
  func makeActivityIndicatior() -> UIActivityIndicatorView {
    let activityIndicatorView = UIActivityIndicatorView()
    activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
    activityIndicatorView.hidesWhenStopped = true
    activityIndicatorView.startAnimating()
    
    return activityIndicatorView
  }
  
  func makeDefaultButton(_ localizationStringId: String, identifier: String?) -> UIButton {
    let localizeString = NSLocalizedString(localizationStringId, comment: "")
    let button = RoundedButton()
    button.accessibilityIdentifier = identifier ?? localizeString
    button.setTitle(localizeString, for: .normal)
    button.backgroundColor = CustomColor.defaultButtonBackgroundColor
    button.setTitleColor(CustomColor.defaultButtonTextColor, for: .normal)
    return button
  }
  
  func defaultAccessoryView(action: Selector) -> UIView{
    let localizeString = NSLocalizedString("hecho", comment: "")
    let customView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 44))
    customView.backgroundColor = CustomColor.defaultButtonBackgroundColor
    
    let doneButton = UIButton(type: .system)
    doneButton.setTitle(localizeString, for: .normal)
    doneButton.setTitleColor(.white, for: .normal)
    doneButton.translatesAutoresizingMaskIntoConstraints = false
    doneButton.addTarget(self, action: action, for: .touchUpInside)
    
    customView.addSubview(doneButton)
    
    NSLayoutConstraint.activate([
      doneButton.trailingAnchor.constraint(equalTo: customView.trailingAnchor, constant: -20),
      doneButton.centerYAnchor.constraint(equalTo: customView.centerYAnchor)
      ])
    
    return customView
  }
}
