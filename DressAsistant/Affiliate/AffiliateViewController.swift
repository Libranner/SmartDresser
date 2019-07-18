//
//  CreateAffiliateViewController.swift
//  DressAsistant
//
//  Created by Libranner Leonel Santos Espinal on 10/06/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import UIKit

class AffiliateViewController: BaseViewController, LoadingScreenDelegate {
  lazy var loadingView = LoadingView()
  var existingAffiliate: Affiliate?
  
  enum Localizations {
    static let takePhoto = "take-photo"
    static let choosePhoto = "choose-gallery-photo"
    static let selectPhoto = "select-photo"
    static let nicknameField = "nickname-field"
    static let removeItem = "remove-item"
    static let affiliate = "affiliate"
  }

  private let affiliateCardSegueName = "showAffiliateCard"
  private let optionPickerSegueName = "showOptionPicker"
  
  @IBOutlet var scrollView: UIScrollView!
  
  @IBOutlet var profilePicture: RoundImageView!
  @IBOutlet var nameTextfield: UITextField!
  @IBOutlet var birthdateTextfield: UITextField!
  @IBOutlet var sexTextfield: UITextField!
  @IBOutlet var heightTextfield: UITextField!
  @IBOutlet var weightTextfield: UITextField!
  @IBOutlet weak var showQrButton: UIButton!
  
  @IBOutlet weak var eyeColorImageView: RoundImageView!
  @IBOutlet weak var skinColorView: RoundedView!
  @IBOutlet weak var hairColorImageView: RoundImageView!
  @IBOutlet weak var removeButton: UIButton!
  
  fileprivate var sexSelected: Sex = .none {
    didSet {
      sexTextfield.text = sexSelected.rawValue
    }
  }
  
  fileprivate var birthdateSelected: Date? = nil {
    didSet {
      if let birthdateSelected = birthdateSelected  {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let selectedDate = dateFormatter.string(from: birthdateSelected)
        birthdateTextfield.text = selectedDate
      }
    }
  }
  
  fileprivate var eyeColorSelected: EyeColor? {
    didSet {
      if let eyeColor = eyeColorSelected {
        eyeColorImageView.fillWithURL(eyeColor.imageURL, placeholder: nil)
      }
    }
  }
  fileprivate var skinColorSelected: SkinColor? {
    didSet {
      if let skinColor = skinColorSelected {
        skinColorView.backgroundColor = skinColor.rgbColor()
      }
    }
  }
  
  fileprivate var hairColorSelected: HairColor? {
    didSet {
      if let hairColor = hairColorSelected {
        hairColorImageView.fillWithURL(hairColor.imageURL, placeholder: nil)
      }
    }
  }
  
  fileprivate var affiliateId: String?
  fileprivate var availableOptions = [Option]()
  fileprivate var optionPickerMode: OptionPickerMode?
  
  var editMode = false
  
  enum OptionPickerMode {
    case eyeColorPicker
    case hairColorPicker
    case skinColorPicker
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupSexPickerView()
    setupBirthdatePickerView()
    
    NotificationCenter.default.addObserver(self, selector:
      #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector:
      #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
    
    removeButton.isHidden = !editMode
    
    if existingAffiliate != nil {
      fillUpForm()
      showQrButton.isHidden = false
    }
  }

  @IBAction func showQrButtonTapped(_ sender: Any) {
    self.performSegue(withIdentifier: self.affiliateCardSegueName,
                      sender: self)
  }
  
  private func fillUpForm() {
    if let affiliate = existingAffiliate {
      nameTextfield.text = affiliate.name
      birthdateSelected =  affiliate.birthdate
      sexSelected = affiliate.sex
      heightTextfield.text = "\(affiliate.height)"
      weightTextfield.text = "\(affiliate.weight)"
      
      skinColorSelected  = affiliate.skinColor
      eyeColorSelected = affiliate.eyeColor
      hairColorSelected = affiliate.hairColor
      
      if let avatarURL = affiliate.avatarUrl {
        profilePicture.fillWithURL(avatarURL, placeholder: nil)
      }
    }
    else {
      showErrorMessage(.errorGettingData)
    }
  }
  
  // MARK: - Keyboard Delegates
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
  
  private func setupSexPickerView() {
    let sexPickerView = UIPickerView(frame: .zero)
    sexPickerView.dataSource = self
    sexPickerView.delegate = self
    sexTextfield.inputView = sexPickerView
    sexTextfield.inputAccessoryView = UIHelper().defaultAccessoryView(action:
      #selector(doneButtonTapped(_:)))
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
    birthdateTextfield.inputAccessoryView = UIHelper().defaultAccessoryView(action:
      #selector(doneButtonTapped(_:)))
  }
  
  @objc func doneButtonTapped(_ sender: UIButton) {
    hideKeyboard()
  }
  
  @objc func datePickerValueChanged(_ sender: UIDatePicker){
    birthdateSelected = sender.date
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
    
    guard !birthdateTextfield.text!.isEmpty && birthdateSelected != nil else {
      showErrorMessage(CustomError.emptyField(fieldName:
        NSLocalizedString(BIRTHDATE_ID, comment: "")))
      return false
    }
    
    guard !sexTextfield.text!.isEmpty && sexSelected != .none else {
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
    
    guard eyeColorSelected != nil else {
      showErrorMessage(CustomError.emptyField(fieldName:
        NSLocalizedString(EYE_COLOR_FIELD_ID, comment: "")))
      return false
    }
    
    guard skinColorSelected != nil else {
      showErrorMessage(CustomError.emptyField(fieldName:
        NSLocalizedString(SKIN_COLOR_FIELD_ID, comment: "")))
      return false
    }
    
    guard hairColorSelected != nil else {
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
            self?.showErrorMessage(.errorSavingData)
          }
        }
        else {
          if let error = error {
            self?.showErrorMessage(error)
          }
        }
      }
    }
  }
  
  fileprivate func createAffiliateWithAvatar(_ avatarURL: URL) -> Affiliate {
    return Affiliate(key: nil,
                     name: nameTextfield.text!,
                     avatarUrl: avatarURL,
                     birthdate: birthdateSelected!,
                     height: Float(heightTextfield.text!)!,
                     weight: Float(weightTextfield.text!)!,
                     sex: sexSelected,
                     hairColor: hairColorSelected!,
                     eyeColor: eyeColorSelected!,
                     skinColor: skinColorSelected!)
  }
  
  func handleResponse(error: CustomError?, success: Bool) {
    hideLoading()
    if success {
      DispatchQueue.main.async {
        self.performSegue(withIdentifier: self.affiliateCardSegueName,
                          sender: self)
      }
    }
    else {
      print(error ?? "")
    }
  }
  
  fileprivate func persistAffialiate(avatarURL: URL) {
    showLoading()
    var newAffiliate = createAffiliateWithAvatar(avatarURL)
    if existingAffiliate == nil {
      affiliateId = AffiliateService().save(newAffiliate) { [weak self] error, success in
        self?.handleResponse(error: error, success: success)
      }
    }
    else {
      affiliateId = existingAffiliate!.key
      newAffiliate.key = existingAffiliate!.key
      AffiliateService().update(newAffiliate) { [weak self] error, success in
        self?.handleResponse(error: error, success: success)
      }
    }
  }
  
  @IBAction private func saveAffiliate() {
    if validateFields() {
      showLoading()
      uploadPhoto { [weak self] photoURL in
        self?.persistAffialiate(avatarURL: photoURL)
      }
    }
  }
  
  @IBAction private func deleteAffiliate() {
    askUserBeforeDeletion()
  }
  
  private func delete() {
    showLoading()
    if let key = existingAffiliate?.key {
      AffiliateService().delete(key) { [weak self] error, success in
        self?.hideLoading()
        if success {
          DispatchQueue.main.async {
            self?.navigationController?.popToRootViewController(animated: true)
          }
        }
        else {
          print(error ?? "")
        }
      }
    }
  }
  
  private func askUserBeforeDeletion() {
    var removeTitleString = NSLocalizedString(Localizations.removeItem, comment: "")
    let affiliateString = NSLocalizedString(Localizations.affiliate, comment: "")
    removeTitleString = String(format: removeTitleString, affiliateString)
    let removeActionString = NSLocalizedString(BaseViewController.Localizations
      .removeAction, comment: "")
    let cancelActionString = NSLocalizedString(BaseViewController.Localizations
      .cancelAction, comment: "")
    
    let alertVC = UIAlertController(title: "", message: removeTitleString, preferredStyle: .actionSheet)
    
    let removeAction = UIAlertAction(title: removeActionString, style: .destructive) { [weak self] _ in
      self?.delete()
    }
    
    let cancelAction = UIAlertAction(title: cancelActionString, style: .default)
    
    alertVC.addAction(removeAction)
    alertVC.addAction(cancelAction)
    present(alertVC, animated: true)
  }
  
  
  @IBAction func selectProfilePhoto(_ sender: Any) {
    let takePhotoString = NSLocalizedString(Localizations.takePhoto, comment: "")
    let choosePhotoString = NSLocalizedString(Localizations.choosePhoto, comment: "")
    let selectPhotoString = NSLocalizedString(Localizations.selectPhoto, comment: "")
    let cancelActionString = NSLocalizedString(BaseViewController.Localizations.cancelAction, comment: "")
    
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
        destinationVC.shouldGoToRoot = true
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
  
  fileprivate func resignAllTextFields() {
    nameTextfield.resignFirstResponder()
    birthdateTextfield.resignFirstResponder()
    sexTextfield.resignFirstResponder()
    heightTextfield.resignFirstResponder()
    weightTextfield.resignFirstResponder()
  }
  
  fileprivate func showPickerWithOptions(_ options: [Option]) {
    resignAllTextFields()
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
        return Option(itemId: item.documentID!, name: item.name,
                      backgroundColor: item.rgbColor())
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
extension AffiliateViewController: OptionPickerDelegate {
  func optionPicker(didSelectItem item: Option) {
    if let optionPickerMode = optionPickerMode {
      switch optionPickerMode {
      case .eyeColorPicker:
        eyeColorSelected = EyeColor(documentID: item.itemId,
                                    name: item.name,
                                    imageURL: item.imageURL!)
      case .hairColorPicker:
        hairColorSelected = HairColor(documentID: item.itemId,
                                      name: item.name,
                                      imageURL: item.imageURL!)
      case .skinColorPicker:
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        item.backgroundColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        skinColorSelected = SkinColor(documentID: item.itemId,
                                      name: item.name,
                                      colorComponents: [red*255,
                                                        green*255,
                                                        blue*255,
                                                        alpha])
      }
    }
  }
}

//Mark: - Option Picker delegate and datasource
extension AffiliateViewController: UIPickerViewDelegate, UIPickerViewDataSource {
  private static let sexOptions = Sex.allCases
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return AffiliateViewController.sexOptions.count
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    let options = AffiliateViewController.sexOptions
    return options[row].rawValue
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    let options = AffiliateViewController.sexOptions
    sexSelected = options[row]
  }
}

//Mark: - Image Picker Delegate
extension AffiliateViewController: PhotoPickerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
    profilePicture.image = pickedImage
    self.dismiss(animated: true, completion: nil)
  }
}
