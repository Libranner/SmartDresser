//
//  CreateAccountViewController.swift
//  DressAsistant
//
//  Created by Libranner Leonel Santos Espinal on 08/06/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import UIKit

class CreateAccountViewController: BaseViewController, LoadingScreenDelegate {
  lazy var loadingView = LoadingView()
  
  enum Localizations {
    static let takePhoto = "take-photo"
    static let choosePhoto = "choose-gallery-photo"
    static let selectPhoto = "select-photo"
    static let nicknameField = "nickname-field"
  }
  
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
    
    let takePhotoString = NSLocalizedString(Localizations.takePhoto, comment: "")
    let choosePhotoString = NSLocalizedString(Localizations.choosePhoto, comment: "")
    let selectPhotoString = NSLocalizedString(Localizations.selectPhoto, comment: "")
    let cancelActionString = NSLocalizedString(BaseViewController.Localizations
      .cancelAction, comment: "")
    
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
      let nicknameString = NSLocalizedString(Localizations.nicknameField, comment: "")
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
extension CreateAccountViewController: PhotoPickerDelegate {
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
    profilePicture.image = pickedImage
    self.dismiss(animated: true, completion: nil)
  }
}
