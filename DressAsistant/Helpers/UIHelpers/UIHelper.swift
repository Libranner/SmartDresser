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
  
  func makeInfoLabelFor(_ text: String) -> UILabel {
    let label = UILabel()
    label.font = UIFont.boldSystemFont(ofSize: 12)
    label.textColor = .lightGray
    label.text = text.uppercased()
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }
  
  func makeDescriptionLabelFor(_ text: String) -> UILabel {
    let label = UILabel()
    label.font = UIFont.boldSystemFont(ofSize: 14)
    label.textColor = .black
    label.text = text
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }
}
