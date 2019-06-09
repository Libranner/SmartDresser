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
  
  func makeDescriptionLabelFor(_ localizationStringId: String, identifier: String?) -> UILabel {
    let label = makeLabel(localizationStringId, identifier: identifier)
    label.font = UIFont.boldSystemFont(ofSize: 14)
    label.textColor = .black
    return label
  }
  
  func makeDefaultButton(_ localizationStringId: String, identifier: String?) -> UIButton {
    let localizeString = NSLocalizedString(localizationStringId, comment: "")
    let button = UIButton()
    button.accessibilityIdentifier = identifier ?? localizeString
    button.setTitle(localizeString, for: .normal)
    button.backgroundColor = CustomColor.defaultButtonBackgroundColor
    button.setTitleColor(CustomColor.defaultButtonTextColor, for: .normal)
    return button
  }
}
