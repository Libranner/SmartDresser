//
//  CreateAccountViewController.swift
//  DressAsistant
//
//  Created by Libranner Leonel Santos Espinal on 08/06/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import UIKit

class CreateAccountViewController: UIViewController {
  private let alertSheetTakePhotoStringId = "take-photo"
  private let alertSheetChoosePhotoStringId = "choose-photo"
  
  @IBOutlet weak var profilePicture: UIImageView!
  @IBOutlet weak var nicknameTextfield: UITextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }
  
  private func animateUI() {
    
  }
  
  @IBAction func selectProfilePhoto(_ sender: Any) {
    let alertVC = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
    let takePhotoString = NSLocalizedString(alertSheetTakePhotoStringId, comment: "")
    let choosePhotoString = NSLocalizedString(alertSheetChoosePhotoStringId, comment: "")
    
    let takePhotoAction = UIAlertAction(title: takePhotoString, style: .default) { [weak self] _ in
      self?.takePhoto()
    }
    
    let choosePhotoAction = UIAlertAction(title: choosePhotoString, style: .default) { [weak self] _ in
      self?.selectPhotoFromGallery()
    }
    
    alertVC.addAction(takePhotoAction)
    alertVC.addAction(choosePhotoAction)
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
    self.dismiss(animated: true, completion: nil)
  }
}
