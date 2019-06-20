//
//  CreateAffiliateViewController.swift
//  DressAsistant
//
//  Created by Libranner Leonel Santos Espinal on 10/06/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import UIKit

class CreateAffiliateViewController: BaseViewController {
  
  private let TAKE_PHOTO_STRING_ID = "take-photo"
  private let CHOOSE_PHOTO_STRING_ID = "choose-gallery-photo"
  private let SELECT_PHOTO_STRING_ID = "select-photo"
  private let NICKNAME_FIELD_NAME_STRING_ID = "nickname-field"
  
  @IBOutlet weak var profilePicture: RoundImageView!
  
  @IBOutlet var nameTextfield: UITextField!
  @IBOutlet var birthdateTextfield: UITextField!
  @IBOutlet var sexTextfield: UITextField!
  @IBOutlet var heightTextfield: UITextField!
  @IBOutlet var weightTextfield: UITextField!
  
  fileprivate var sexSelected: Int = 0
  

  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupSexPickerView()
    setupBirthdatePickerView()
    /*HairStyleService().get { (error, data) in
      print(data)
    }*/
  }
  
  private func setupSexPickerView() {
    let sexPickerView = UIPickerView(frame: .zero)
    sexPickerView.dataSource = self
    sexPickerView.delegate = self
    
    sexTextfield.inputView = sexPickerView
  }
  
  private func setupBirthdatePickerView() {
    let birthdatePickerView = UIDatePicker(frame: .zero)
    
    birthdateTextfield.inputView = birthdatePickerView
  }
  
  private func saveAffialiate() {
    /*let affiliate = Affiliate(key: nil, name: "John Test", avatarUrl: nil, birthdate: Date(), height: 12, weight: 32, sex: .female, hairColor: .Male, eyeColor: .Black, skinColor: .Male)
    
    AffiliateService().save(affiliate) {
      error, success in
      print(error ?? "")
    }*/
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
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if (segue.identifier == "showOptionPicker") {
      let destinationVC =  segue.destination as! OptionPickerViewController
      destinationVC.delegate = self
    }
  }
  
  @IBAction func pickEyeColorTapped(_ sender: Any) {
    performSegue(withIdentifier: "showOptionPicker", sender: self)
  }
  
}

//Mark: - Option Picker delegate
extension CreateAffiliateViewController: OptionPickerDelegate {
  func optionPicker(didSelectItem item: Option) {
    print(item)
  }
}

//Mark: - Option Picker delegate and datasource
extension CreateAffiliateViewController: UIPickerViewDelegate, UIPickerViewDataSource {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return 2
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return "sdsd"
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    sexSelected = row
  }
}

//Mark: - UITextfield delegates
extension CreateAffiliateViewController: UITextFieldDelegate {
  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    //let y = mainStackView.frame.minY + 300.0
    //scrollview.setContentOffset(CGPoint(x: 0, y: y), animated: true);
    return true
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    //scrollview.setContentOffset(CGPoint(x: 0, y: 0), animated: true);
  }
}

//Mark: - Image Picker
extension CreateAffiliateViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
  
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
