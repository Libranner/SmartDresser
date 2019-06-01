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
  
  func makeInfoLabelFor(_ localizationString: String, identifier: String?) -> UILabel {
    let label = makeLabel(localizationString, identifier: identifier)
    label.font = UIFont.boldSystemFont(ofSize: 12)
    label.textColor = .lightGray
    
    return label
  }
  
  fileprivate func makeLabel(_ localizationString: String, identifier: String?) -> UILabel{
    let label = UILabel()
    let localizeString = NSLocalizedString(localizationString, comment: "")
    label.accessibilityIdentifier = identifier ?? localizeString
    label.text = localizeString
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }
  
  func makeDescriptionLabelFor(_ localizationString: String, identifier: String?) -> UILabel {
    let label = makeLabel(localizationString, identifier: identifier)
    label.font = UIFont.boldSystemFont(ofSize: 14)
    label.textColor = .black
    return label
  }
  
  func makeDefaultButton(_ localizationString: String, identifier: String?) -> UIButton {
    let localizeString = NSLocalizedString(localizationString, comment: "")
    let button = UIButton()
    button.accessibilityIdentifier = identifier ?? localizeString
    button.setTitle(localizeString, for: .normal)
    button.backgroundColor = CustomColor.defaultButtonBackgroundColor
    button.setTitleColor(CustomColor.defaultButtonTextColor, for: .normal)
    return button
  }
}
