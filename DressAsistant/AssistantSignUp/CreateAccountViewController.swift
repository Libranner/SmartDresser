//
//  CreateAccountViewController.swift
//  DressAsistant
//
//  Created by Libranner Leonel Santos Espinal on 08/06/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import UIKit

class CreateAccountViewController: BaseViewController {
  private let TAKE_PHOTO_STRING_ID = "take-photo"
  private let CHOOSE_PHOTO_STRING_ID = "choose-gallery-photo"
  private let SELECT_PHOTO_STRING_ID = "select-photo"
  private let NICKNAME_FIELD_NAME_STRING_ID = "nickname-field"
  
  private let showMainSegue = "showMain"
  
  @IBOutlet weak var profilePicture: UIImageView!
  @IBOutlet weak var nicknameTextfield: UITextField!
  
  @IBOutlet weak var mainStackView: UIStackView!
  @IBOutlet weak var saveButton: RoundedButton!
  @IBOutlet weak var scrollview: UIScrollView!
  @IBOutlet weak var selectPhotoButton: UIButton!
  override func viewDidLoad() {
    super.viewDidLoad()
    nicknameTextfield.delegate = self
    // Do any additional setup after loading the view.
  }
  
  private func animateUI() {
    
  }
  
  @IBAction func selectProfilePhoto(_ sender: Any) {
    
    let takePhotoString = NSLocalizedString(TAKE_PHOTO_STRING_ID, comment: "")
    let choosePhotoString = NSLocalizedString(CHOOSE_PHOTO_STRING_ID, comment: "")
    let selectPhotoString = NSLocalizedString(SELECT_PHOTO_STRING_ID, comment: "")
    let cancelActionString = NSLocalizedString(BaseViewController.CANCEL_ACTION_STRING_ID, comment: "")
    
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
  
  private func saveUser(nickname: String, photoURL: URL?) {
    UserService().saveUser(displayName: nickname, photoURL: photoURL) { [weak self] saved in
      self?.hideLoading()
      guard saved else {
        self?.showErrorMessage(CustomError.generic)
        return
      }
      if let self = self {
        self.performSegue(withIdentifier: self.showMainSegue, sender: self)
      }
    }
  }
  
  @IBAction func saveButtonTapped(_ sender: Any) {
    
    guard nicknameTextfield.text != nil && !nicknameTextfield.text!.isEmpty else {
      let nicknameString = NSLocalizedString(NICKNAME_FIELD_NAME_STRING_ID, comment: "")
      showErrorMessage(CustomError.emptyField(fieldName: nicknameString))
      return
    }
    
    if let nickname = nicknameTextfield.text {
      showLoading()
      if let data = profilePicture.image?.pngData() {
        FileService().uploadUserPhoto(data) { [weak self] error, success, photoURL in
          if success {
            self?.saveUser(nickname: nickname, photoURL: photoURL)
          }
          else {
            if let error = error {
              self?.showErrorMessage(error)
            }
            self?.hideLoading()
          }
        }
      }
      else {
       saveUser(nickname: nickname, photoURL: nil)
      }
    }
  }
}

//Mark: - UITextfield delegates
extension CreateAccountViewController: UITextFieldDelegate {
  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    let y = mainStackView.frame.minY + 300.0
    scrollview.setContentOffset(CGPoint(x: 0, y: y), animated: true);
    return true
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
     scrollview.setContentOffset(CGPoint(x: 0, y: 0), animated: true);
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
