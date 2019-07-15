//
//  UIViewControllerScrollable.swift
//  DressAsistant
//
//  Created by Libranner Leonel Santos Espinal on 15/07/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import Foundation
import UIKit

protocol UIViewControllerScrollable {
  func keyboardWillShow(notification:NSNotification)
  func keyboardWillHide(notification:NSNotification)
}

extension UIViewControllerScrollable where Self: UIViewController {
  //Mark: - ScrollView position manage
  func keyboardWillShow(notification:NSNotification){
    if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
      let window = self.view.window?.frame {
      self.view.frame = CGRect(x: self.view.frame.origin.x,
                               y: self.view.frame.origin.y,
                               width: self.view.frame.width,
                               height: window.origin.y + window.height - keyboardSize.height)
    } else {
      debugPrint("We're showing the keyboard and either the keyboard size or window is nil: panic widely.")
    }
  }
  
  func keyboardWillHide(notification:NSNotification){
    if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
      let viewHeight = self.view.frame.height
      self.view.frame = CGRect(x: self.view.frame.origin.x,
                               y: self.view.frame.origin.y,
                               width: self.view.frame.width,
                               height: viewHeight + keyboardSize.height)
    } else {
      debugPrint("We're about to hide the keyboard and the keyboard size is nil. Now is the rapture.")
    }
  }
}
