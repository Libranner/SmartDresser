//
//  CreateAffiliateViewController.swift
//  DressAsistant
//
//  Created by Libranner Leonel Santos Espinal on 10/06/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import UIKit

class CreateAffiliateViewController: BaseViewController, LoadingScreenDelegate {
  lazy var loadingView = LoadingView()
  
  private let TAKE_PHOTO_STRING_ID = "take-photo"
  private let CHOOSE_PHOTO_STRING_ID = "choose-gallery-photo"
  private let SELECT_PHOTO_STRING_ID = "select-photo"
  private let NICKNAME_FIELD_NAME_STRING_ID = "nickname-field"
  
  private let affiliateCardSegueName = "showAffiliateCard"
  private let optionPickerSegueName = "showOptionPicker"
  
  @IBOutlet var profilePicture: RoundImageView!
  @IBOutlet var nameTextfield: UITextField!
  @IBOutlet var birthdateTextfield: UITextField!
  @IBOutlet var sexTextfield: UITextField!
  @IBOutlet var heightTextfield: UITextField!
  @IBOutlet var weightTextfield: UITextField!
  
  @IBOutlet weak var eyeColorImageView: RoundImageView!
  @IBOutlet weak var skinColorView: RoundedView!
  @IBOutlet weak var hairColorImageView: RoundImageView!
  
  fileprivate var sexSelected: Sex = .none
  fileprivate var birthdateSelected: Date? = nil
  fileprivate var eyeColorSelectedId: String?
  fileprivate var skinColorSelectedId: String?
  fileprivate var hairColorSelectedId: String?
  
  fileprivate var affiliateId: String?
  
  fileprivate var availableOptions = [Option]()
  
  enum OptionPickerMode {
    case eyeColorPicker
    case hairColorPicker
    case skinColorPicker
  }
  
  fileprivate var optionPickerMode: OptionPickerMode?
  
  @IBOutlet var scrollView: UIScrollView!

  // MARK: - Keyboard Delegates
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupSexPickerView()
    setupBirthdatePickerView()
    
    NotificationCenter.default.addObserver(self, selector:
      #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector:
      #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
  }
  
  private func setupSexPickerView() {
    let sexPickerView = UIPickerView(frame: .zero)
    sexPickerView.dataSource = self
    sexPickerView.delegate = self
    sexTextfield.inputView = sexPickerView
    sexTextfield.inputAccessoryView = defaultAccessoryView
  }
  
  private func setupBirthdatePickerView() {
    let birthdatePickerView = UIDatePicker(frame: .zero)
    birthdatePickerView.datePickerMode = .date
    birthdatePickerView.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
    
    let today = Date()
    let minimumDate = Calendar.current.date(byAdding: .year, value: -120, to: today)
    let maximumDate = Calendar.current.date(byAdding: .day, value: -1, to: today)
    
    birthdatePickerView.minimumDate = minimumDate
    birthdatePickerView.maximumDate = maximumDate
    birthdateTextfield.inputView = birthdatePickerView
    birthdateTextfield.inputAccessoryView = defaultAccessoryView
  }
  
  private lazy var defaultAccessoryView: UIView = {
    let customView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 44))
    customView.backgroundColor = CustomColor.defaultButtonBackgroundColor
    
    let doneButton = UIButton(type: .system)
    doneButton.setTitle("Hecho", for: .normal)
    doneButton.setTitleColor(.white, for: .normal)
    doneButton.translatesAutoresizingMaskIntoConstraints = false
    doneButton.addTarget(self, action: #selector(doneButtonTapped(_:)), for: .touchUpInside)
    
    customView.addSubview(doneButton)
    
    NSLayoutConstraint.activate([
      doneButton.trailingAnchor.constraint(equalTo: customView.trailingAnchor, constant: -20),
      doneButton.centerYAnchor.constraint(equalTo: customView.centerYAnchor)
      ])
    
    return customView
  }()
  
  @objc func doneButtonTapped(_ sender: UIButton) {
    hideKeyboard()
  }
  
  @objc func datePickerValueChanged(_ sender: UIDatePicker){
    birthdateSelected = sender.date

    let dateFormatter: DateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd/MM/yyyy"
    let selectedDate = dateFormatter.string(from: sender.date)
    
    birthdateTextfield.text = selectedDate
  }
  
  private func validateFields() -> Bool {
    let PROFILE_PICTURE_FIELD_ID = "profile-picture-field"
    let NAME_FIELD_ID = "name-field"
    let BIRTHDATE_ID = "birthdate-field"
    let SEX_ID = "sex-field"
    let HEIGHT_FIELD_ID = "height-field"
    let WEIGHT_FIELD_ID = "weight-field"
    let EYE_COLOR_FIELD_ID = "eye-color-field"
    let SKIN_COLOR_FIELD_ID = "skin-color-field"
    let HAIR_COLOR_FIELD_ID = "hair-color-field"
    
    guard profilePicture.image != nil else {
      showErrorMessage(CustomError.emptyField(fieldName:
        NSLocalizedString(PROFILE_PICTURE_FIELD_ID, comment: "")))
      return false
    }
    
    guard !nameTextfield.text!.isEmpty else {
      showErrorMessage(CustomError.emptyField(fieldName:
        NSLocalizedString(NAME_FIELD_ID, comment: "")))
      return false
    }
    
    guard !birthdateTextfield.text!.isEmpty else {
      showErrorMessage(CustomError.emptyField(fieldName:
        NSLocalizedString(BIRTHDATE_ID, comment: "")))
      return false
    }
    
    guard !sexTextfield.text!.isEmpty else {
      showErrorMessage(CustomError.emptyField(fieldName:
        NSLocalizedString(SEX_ID, comment: "")))
      return false
    }
    
    guard !heightTextfield.text!.isEmpty else {
      showErrorMessage(CustomError.emptyField(fieldName:
        NSLocalizedString(HEIGHT_FIELD_ID, comment: "")))
      return false
    }
    
    guard !weightTextfield.text!.isEmpty else {
      showErrorMessage(CustomError.emptyField(fieldName:
        NSLocalizedString(WEIGHT_FIELD_ID, comment: "")))
      return false
    }
    
    guard eyeColorSelectedId != nil && !eyeColorSelectedId!.isEmpty else {
      showErrorMessage(CustomError.emptyField(fieldName:
        NSLocalizedString(EYE_COLOR_FIELD_ID, comment: "")))
      return false
    }
    
    guard skinColorSelectedId != nil && !skinColorSelectedId!.isEmpty else {
      showErrorMessage(CustomError.emptyField(fieldName:
        NSLocalizedString(SKIN_COLOR_FIELD_ID, comment: "")))
      return false
    }
    
    guard hairColorSelectedId != nil && !hairColorSelectedId!.isEmpty else {
      showErrorMessage(CustomError.emptyField(fieldName:
        NSLocalizedString(HAIR_COLOR_FIELD_ID, comment: "")))
      return false
    }
    
    return true
  }
  
  fileprivate func uploadPhoto(completion: @escaping (_ photoURL: URL)-> Void) {
    if let data = profilePicture.image?.pngData() {
      FileService().uploadAffiliatePhoto(data) { [weak self] error,
        success, photoURL in
        
        if success {
          if let photoURL = photoURL {
            completion(photoURL)
          }
          else {
            self?.hideLoading()
            self?.showErrorMessage(.errorSavingData)
          }
        }
        else {
          if let error = error {
            self?.showErrorMessage(error)
          }
          self?.hideLoading()
        }
      }
    }
  }
  
  fileprivate func persistAffialiate(avatarURL: URL) {
    let affiliate = Affiliate(key: nil,
                              name: nameTextfield.text!,
                              avatarUrl: avatarURL,
                              birthdate: birthdateSelected!,
                              height: Float(heightTextfield.text!)!,
                              weight: Float(weightTextfield.text!)!,
                              sex: sexSelected,
                              hairColor: hairColorSelectedId!,
                              eyeColor: eyeColorSelectedId!,
                              skinColor: skinColorSelectedId!)
    
    affiliateId = AffiliateService().save(affiliate) { [weak self] error, success in
      self?.hideLoading()
      if success {
        DispatchQueue.main.async {
          if let self = self {
            self.performSegue(withIdentifier: self.affiliateCardSegueName,
                              sender: self)
          }
        }
      }
      else {
        print(error ?? "")
      }
    }
  }
  
  @IBAction func saveAffiliate() {
    if validateFields() {
      showLoading()
      uploadPhoto { [weak self] photoURL in
        self?.persistAffialiate(avatarURL: photoURL)
      }
    }
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
    if (segue.identifier == optionPickerSegueName) {
      let navController = segue.destination as! UINavigationController
      if let destinationVC = navController.topViewController as? OptionPickerViewController {
        destinationVC.data = availableOptions
        destinationVC.delegate = self
      }
    }
    else if (segue.identifier == affiliateCardSegueName) {
      if let destinationVC = segue.destination as? AffiliateCardViewController {
        destinationVC.affiliateId = affiliateId
      }
    }
  }
  
  @IBAction func selectHairStyleTapped(_ sender: Any) {
    optionPickerMode = .hairColorPicker
    showLoading()
    HairStyleService().getAll { [weak self] error, data in
      guard error == nil  else {
        return
      }
      
      let opts = data.map({ (item) -> Option in
        return Option(itemId: item.documentID!, name: item.name, imageURL: item.imageURL)
      })
      
      DispatchQueue.main.async {
        self?.showPickerWithOptions(opts)
      }
    }
  }
  
  fileprivate func showPickerWithOptions(_ options: [Option]) {
    availableOptions = options
    hideLoading()
    performSegue(withIdentifier: optionPickerSegueName, sender: self)
  }
  
  @IBAction func selectEyeColor(_ sender: Any) {
    optionPickerMode = .eyeColorPicker
    showLoading()
    EyeColorService().getAll { [weak self] error, data in
      guard error == nil  else {
        return
      }
      
      let opts = data.map({ (item) -> Option in
        return Option(itemId: item.documentID!, name: item.name, imageURL: item.imageURL)
      })
      
      DispatchQueue.main.async {
        self?.showPickerWithOptions(opts)
      }
    }
  }
  
  @IBAction func selectSkinColor(_ sender: Any) {
    optionPickerMode = .skinColorPicker
    showLoading()
    SkinColorService().getAll { [weak self] error, data in
      guard error == nil  else {
        return
      }
      
      let opts = data.compactMap({ (item) -> Option? in
        let color = UIColor(red: item.colorString[0]/255,
                            green: item.colorString[1]/255,
                            blue: item.colorString[2]/255,
                            alpha: 1.0)
        
        return Option(itemId: item.documentID!, name: item.name,
                 backgroundColor: color)
      })
      
      DispatchQueue.main.async {
        self?.showPickerWithOptions(opts)
      }
    }
  }
  
  //Mark: - ScrollView position manage
  @objc func keyboardWillShow(notification:NSNotification){
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
  
  @objc func keyboardWillHide(notification:NSNotification){
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

//Mark: - Option Picker delegate
extension CreateAffiliateViewController: OptionPickerDelegate {
  func optionPicker(didSelectItem item: Option) {
    if let optionPickerMode = optionPickerMode {
      switch optionPickerMode {
      case .eyeColorPicker:
        eyeColorImageView.fillWithURL(item.imageURL!, placeholder: nil)
        eyeColorSelectedId = item.itemId
      case .hairColorPicker:
        hairColorImageView.fillWithURL(item.imageURL!, placeholder: nil)
        hairColorSelectedId = item.itemId
      case .skinColorPicker:
        skinColorView.backgroundColor = item.backgroundColor
        skinColorSelectedId = item.itemId
      }
    }
  }
}

//Mark: - Option Picker delegate and datasource
extension CreateAffiliateViewController: UIPickerViewDelegate, UIPickerViewDataSource {
  private static let sexOptions = Sex.allCases
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return CreateAffiliateViewController.sexOptions.count
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    let options = CreateAffiliateViewController.sexOptions
    return options[row].rawValue
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    let options = CreateAffiliateViewController.sexOptions
    sexSelected = options[row]
    sexTextfield.text = sexSelected.rawValue
  }
}

//Mark: - Image Picker Delegate
extension CreateAffiliateViewController: PhotoPickerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
    profilePicture.image = pickedImage
    self.dismiss(animated: true, completion: nil)
  }
}
