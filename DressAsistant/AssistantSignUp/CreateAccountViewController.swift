//
//  CreateAccountViewController.swift
//  DressAsistant
//
//  Created by Libranner Leonel Santos Espinal on 08/06/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import UIKit

class CreateAccountViewController: BaseViewController {
  private let alertSheetTakePhotoStringId = "take-photo"
  private let alertSheetChoosePhotoStringId = "choose-gallery-photo"
  private let alertSheetMessageSelectPhotoStringId = "select-photo"
  private let alertSheetCancelStringId = "cancel-action"
  
  @IBOutlet weak var profilePicture: UIImageView!
  @IBOutlet weak var nicknameTextfield: UITextField!
  
  @IBOutlet weak var selectPhotoButton: UIButton!
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }
  
  private func animateUI() {
    
  }
  
  @IBAction func selectProfilePhoto(_ sender: Any) {
    
    let takePhotoString = NSLocalizedString(alertSheetTakePhotoStringId, comment: "")
    let choosePhotoString = NSLocalizedString(alertSheetChoosePhotoStringId, comment: "")
    let selectPhotoString = NSLocalizedString(alertSheetMessageSelectPhotoStringId, comment: "")
    let cancelActionString = NSLocalizedString(alertSheetCancelStringId, comment: "")
    
    let alertVC = UIAlertController(title: "", message: selectPhotoString, preferredStyle: .actionSheet)
    
    let takePhotoAction = UIAlertAction(title: takePhotoString, style: .default) { [weak self] _ in
      self?.takePhoto()
    }
    
    let choosePhotoAction = UIAlertAction(title: choosePhotoString, style: .default) { [weak self] _ in
      self?.selectPhotoFromGallery()
    }
    
    let cancelAction = UIAlertAction(title: cancelActionString, style: .destructive)
    
    alertVC.addAction(takePhotoAction)
    alertVC.addAction(choosePhotoAction)
    alertVC.addAction(cancelAction)
    present(alertVC, animated: true)
  }
}

//Mark: - Image Picker
extension CreateAccountViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {

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
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
    profilePicture.image = pickedImage
    selectPhotoButton.alpha = 0
    self.dismiss(animated: true, completion: nil)
  }
}
