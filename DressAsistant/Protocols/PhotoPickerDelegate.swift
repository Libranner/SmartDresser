//
//  Proto.swift
//  DressAsistant
//
//  Created by Libranner Leonel Santos Espinal on 06/07/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import Foundation
import UIKit

protocol PhotoPickerDelegate: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
  func takePhoto()
  func selectPhotoFromGallery()
}

extension PhotoPickerDelegate where Self: UIViewController {
  func takePhoto() {
    let imagePickerController = UIImagePickerController()
    imagePickerController.delegate = self
    imagePickerController.sourceType = .camera
    self.present(imagePickerController, animated: true, completion: nil)
  }
  
  func selectPhotoFromGallery() {
    let imagePickerController = UIImagePickerController()
    imagePickerController.delegate = self
    imagePickerController.sourceType = .photoLibrary
    self.present(imagePickerController, animated: true, completion: nil)
  }
}
