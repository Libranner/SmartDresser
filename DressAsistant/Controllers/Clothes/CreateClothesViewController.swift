//
//  CreateClothesViewController.swift
//  DressAsistant
//
//  Created by Libranner Leonel Santos Espinal on 14/07/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import UIKit
import SnapKit

class CreateClothesViewController: BaseViewController {
  
  enum Localizations {
    static let detailField = "detail-field"
    static let materialField = "material-field"
    static let clothesSizeField = "clothes-size-field"
    static let clothesColorField = "clothes-color-field"
    static let printTypeField = "print-type-field"
    static let patternTypeField = "pattern-type-field"
    static let saveTitle = "save-title"
    static let selectPhoto = "select-photo"
  }
  
  enum PickerMode: Int {
    case materialPicker = 0
    case patternTypePicker
    case printTypePicker
    case clothesColorPicker
    case clothesSizePicker
  }
  
  var nfcCode: String?
  lazy var loadingView = LoadingView()
  var existingClothes: Clothes?
  
  fileprivate var selectedMaterial: Material = .none {
    didSet {
      materialTextField.text = selectedMaterial.rawValue
    }
  }
  
  fileprivate var selectedPatternType: PatternType = .none {
    didSet {
      patternTypeTextField.text = selectedPatternType.rawValue
    }
  }
  
  fileprivate var selectedPrintType: PrintType = .none {
    didSet {
      printTypeTextField.text = selectedPrintType.rawValue
    }
  }
  
  fileprivate var selectedClothesColor: ClothesColor = .none {
    didSet {
      clothesColorTextField.text = selectedClothesColor.rawValue
    }
  }
  
  fileprivate var selectedClothesSize: ClothesSize = .none {
    didSet {
      clothesSizeTextField.text = selectedClothesSize.rawValue
    }
  }
  
  fileprivate lazy var detailTextField: UITextField = {
    let textfield = UIHelper().makeTextFieldFor(Localizations.detailField,
                                                identifier: nil)
    return textfield
  }()
  
  fileprivate lazy var materialTextField: UITextField = {
    return createTextField(localizeStringId: Localizations.materialField,
                           pickerMode: .materialPicker)
  }()

  fileprivate lazy var clothesSizeTextField: UITextField = {
    return createTextField(localizeStringId: Localizations.clothesSizeField,
                           pickerMode: .clothesSizePicker)
  }()
  
  fileprivate lazy var clothesColorTextField: UITextField = {
    return createTextField(localizeStringId: Localizations.clothesColorField,
                           pickerMode: .clothesColorPicker)
  }()
  
  fileprivate lazy var printTypeTextField: UITextField = {
    return createTextField(localizeStringId: Localizations.printTypeField,
                           pickerMode: .printTypePicker)
  }()
  
  fileprivate lazy var patternTypeTextField: UITextField = {
    return createTextField(localizeStringId: Localizations.patternTypeField,
                           pickerMode: .patternTypePicker)
  }()
  
  fileprivate func createTextField(localizeStringId: String,
                                   pickerMode: PickerMode) -> UITextField {
    let textfield = UIHelper().makeTextFieldFor(localizeStringId, identifier: nil)
    textfield.inputView = createPickerView(for: pickerMode)
    textfield.inputAccessoryView = UIHelper().defaultAccessoryView(action:
      #selector(hideKeyboard))
    
    return textfield
  }
  
  fileprivate func createPickerView(for pickerMode: PickerMode) -> UIPickerView {
    let pickerView = UIPickerView()
    pickerView.delegate = self
    pickerView.dataSource =  self
    pickerView.tag = pickerMode.rawValue
    return pickerView
  }
  
  fileprivate lazy var clothesImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleToFill
    imageView.layer.cornerRadius = UIConstants.defaultRadiusForBorder
    imageView.clipsToBounds = true
    return imageView
  }()
  
  fileprivate lazy var choosePhotoButton: UIButton = {
    let button =  UIButton(type: .custom)
    button.setBackgroundImage(UIImage(named: "camera"), for: .normal)
    button.addTarget(self, action: #selector(chooseClothesPhoto), for: .touchUpInside)
    return button
  }()
  
  fileprivate lazy var mainStackView: UIStackView = {
    let mainStackView = UIStackView()
    mainStackView.axis = .vertical
    mainStackView.distribution = .equalSpacing
    mainStackView.spacing = 10
    return mainStackView
  }()
  
  fileprivate lazy var scrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.isScrollEnabled = true
    scrollView.showsVerticalScrollIndicator = true
    return scrollView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let title = NSLocalizedString(Localizations.saveTitle, comment: "")
    let saveButton = UIBarButtonItem(title: title, style: .plain,
                                     target: self, action: #selector(saveClothes))
    
    navigationItem.rightBarButtonItem = saveButton
    
    NotificationCenter.default.addObserver(self, selector:
      #selector(showingKeyboard), name:UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector:
      #selector(hidingKeyboard), name:UIResponder.keyboardWillHideNotification, object: nil)
    
    setupUI()
  }
  
  @objc func showingKeyboard(notification: NSNotification) {
    keyboardWillShow(notification: notification)
  }
  
  @objc func hidingKeyboard(notification: NSNotification) {
    keyboardWillHide(notification: notification)
  }
  
  @objc fileprivate func saveClothes() {
    
    if (validateFields()) {
      showLoading()
      uploadPhoto { [weak self] photoURL in
        if let self = self {
          let clothes = Clothes(key: nil,
                                nfcCode: self.nfcCode!,
                                imageURL: photoURL,
                                detail: self.detailTextField.text!,
                                material: self.selectedMaterial,
                                patternType: self.selectedPatternType,
                                printType: self.selectedPrintType,
                                color: self.selectedClothesColor,
                                size: self.selectedClothesSize)
          
          self.persist(clothes: clothes)
        }
      }
    }
  }
  
  func handleResponse(error: CustomError?, success: Bool) {
    hideLoading()
    if success {
      DispatchQueue.main.async {
        self.navigationController?.popToRootViewController(animated: true)
      }
    }
    else {
      print(error ?? "")
    }
  }
  
  fileprivate func persist(clothes: Clothes) {
    showLoading()
    if existingClothes != nil {
      _ = ClothesService().save(clothes) { [weak self] error, success in
        self?.handleResponse(error: error, success: success)
      }
    }
    else {
      ClothesService().update(key: existingClothes!.key!, clothes: clothes) {
        [weak self] error, success in
        self?.handleResponse(error: error, success: success)
      }
    }
  }
  
  fileprivate func uploadPhoto(completion: @escaping (_ photoURL: URL)-> Void) {
    if let data = clothesImageView.image?.pngData() {
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
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    scrollView.transform = CGAffineTransform(translationX: scrollView.bounds.size.width, y: 0)
    
    UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseIn, animations: {
      self.scrollView.transform = CGAffineTransform.identity
    }, completion: nil)
  }
  
  fileprivate func setupUI() {
    view.addSubview(scrollView)
    
    scrollView.snp.makeConstraints { make in
      make.edges.equalTo(view.safeAreaLayoutGuide)
        .inset(UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
        .labeled("ScrollViewEdges")
    }
    
    scrollView.addSubview(mainStackView)
    mainStackView.snp.makeConstraints { make in
      make.width.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.9)
      make.top.equalToSuperview().offset(UIConstants.defaultTopSpace)
      make.bottom.equalToSuperview().offset(-20)
      make.centerX.equalTo(scrollView).labeled("MainStackViewPosition")
    }
    
    mainStackView.addArrangedSubview(clothesImageView)
    clothesImageView.layer.borderColor = UIColor.gray.cgColor
    clothesImageView.layer.borderWidth = 1
    
    clothesImageView.snp.makeConstraints { make in
      make.centerX.equalToSuperview().labeled("ImageViewWidthAndCenter")
      make.height.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.35)
    }
    
    scrollView.addSubview(choosePhotoButton)
    choosePhotoButton.snp.makeConstraints { make in
      make.height.equalTo(UIConstants.defaultButtonHeight)
      make.width.equalTo(choosePhotoButton.snp.height)
      make.centerX.bottom.equalTo(clothesImageView)
    }

    setupClotheForm()
  }
  
  func setupClotheForm() {
    let data = [Localizations.detailField: detailTextField,
                Localizations.materialField: materialTextField,
                Localizations.clothesSizeField: clothesSizeTextField,
                Localizations.clothesColorField: clothesColorTextField,
                Localizations.patternTypeField: patternTypeTextField,
                Localizations.printTypeField: printTypeTextField
    ]
    
    let infoStackView = UIStackView()
    infoStackView.distribution = .fill
    infoStackView.axis = .vertical
    infoStackView.alignment = .fill
    infoStackView.spacing = 10
    
    let keys = [Localizations.detailField, Localizations.materialField,
                Localizations.clothesSizeField, Localizations.clothesColorField,
                Localizations.patternTypeField, Localizations.printTypeField
    ]
    
    for key in keys {
      let element = data[key]
      
      guard element != nil else {
        continue
      }
      
      let rowStackView = UIStackView()
      rowStackView.distribution = .fill
      rowStackView.alignment = .leading
      rowStackView.axis = .vertical
      rowStackView.spacing = 5
      
      let infoLabel = UIHelper().makeInfoLabelFor(key, identifier: key)
      rowStackView.addArrangedSubview(infoLabel)
      rowStackView.addArrangedSubview(element!)
      
      element!.snp.makeConstraints { make in
        make.width.equalToSuperview()
        make.height.equalTo(UIConstants.textfieldSize).labeled("TextFieldViewHeight")
      }
      
      infoStackView.addArrangedSubview(rowStackView)
    }
    
    mainStackView.addArrangedSubview(infoStackView)
  }
  
  func validateFields() -> Bool {
    guard clothesImageView.image != nil else {
      showErrorMessage(CustomError.emptyField(fieldName:
        NSLocalizedString(Localizations.selectPhoto, comment: "")))
      return false
    }
    
    guard !detailTextField.text!.isEmpty else {
      showErrorMessage(CustomError.emptyField(fieldName:
        NSLocalizedString(Localizations.detailField, comment: "")))
      return false
    }
    
    guard selectedClothesSize != .none else {
      showErrorMessage(CustomError.emptyField(fieldName:
        NSLocalizedString(Localizations.clothesSizeField, comment: "")))
      return false
    }
    
    guard selectedPatternType != .none else {
      showErrorMessage(CustomError.emptyField(fieldName:
        NSLocalizedString(Localizations.patternTypeField, comment: "")))
      return false
    }
    
    guard selectedMaterial != .none else {
      showErrorMessage(CustomError.emptyField(fieldName:
        NSLocalizedString(Localizations.materialField, comment: "")))
      return false
    }
    
    guard selectedClothesColor != .none else {
      showErrorMessage(CustomError.emptyField(fieldName:
        NSLocalizedString(Localizations.clothesColorField, comment: "")))
      return false
    }
    
    guard selectedPrintType != .none else {
      showErrorMessage(CustomError.emptyField(fieldName:
        NSLocalizedString(Localizations.printTypeField, comment: "")))
      return false
    }
    
    return true
  }
}

//Mark: - Option Picker delegate and datasource
extension CreateClothesViewController: UIPickerViewDelegate, UIPickerViewDataSource {
  private static let patternTypes = PatternType.allCases
  private static let printTypes = PrintType.allCases
  private static let clothesColors = ClothesColor.allCases
  private static let materials = Material.allCases
  private static let clothesSize = ClothesSize.allCases
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    let pickerMode = PickerMode(rawValue: pickerView.tag)
    
    guard pickerMode != nil else {
      return 0
    }
    
    switch pickerMode! {
    case .materialPicker:
      return CreateClothesViewController.materials.count
    case .clothesColorPicker:
      return CreateClothesViewController.clothesColors.count
    case .patternTypePicker:
      return CreateClothesViewController.patternTypes.count
    case .printTypePicker:
      return CreateClothesViewController.printTypes.count
    case .clothesSizePicker:
      return CreateClothesViewController.clothesSize.count
    }
  }
  
  private func optionAtIndex(_ index: Int, for pickerView: UIPickerView) -> String {
    
    let pickerMode = PickerMode(rawValue: pickerView.tag)
    
    guard pickerMode != nil else {
      return ""
    }
    
    switch pickerMode! {
    case .materialPicker:
      return CreateClothesViewController.materials[index].rawValue
    case .clothesColorPicker:
      return CreateClothesViewController.clothesColors[index].rawValue
    case .patternTypePicker:
      return CreateClothesViewController.patternTypes[index].rawValue
    case .printTypePicker:
      return CreateClothesViewController.printTypes[index].rawValue
    case .clothesSizePicker:
      return CreateClothesViewController.clothesSize[index].rawValue
    }
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return optionAtIndex(row, for: pickerView)
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    let pickerMode = PickerMode(rawValue: pickerView.tag)
    
    guard pickerMode != nil else {
      return
    }
    
    switch pickerMode! {
    case .materialPicker:
      selectedMaterial = CreateClothesViewController.materials[row]
    case .clothesColorPicker:
      selectedClothesColor = CreateClothesViewController.clothesColors[row]
    case .patternTypePicker:
      selectedPatternType = CreateClothesViewController.patternTypes[row]
    case .printTypePicker:
      selectedPrintType = CreateClothesViewController.printTypes[row]
    case .clothesSizePicker:
      selectedClothesSize = CreateClothesViewController.clothesSize[row]
    }
  }
  
  @objc func chooseClothesPhoto(_ sender: Any) {
    let takePhotoString = NSLocalizedString("take-photo", comment: "")
    let choosePhotoString = NSLocalizedString("choose-gallery-photo", comment: "")
    let selectPhotoString = NSLocalizedString("select-photo", comment: "")
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
}

//Mark: - Loading
extension CreateClothesViewController: LoadingScreenDelegate {
  
}

//Mark: - Scrollable
extension CreateClothesViewController: UIViewControllerScrollable {
  
}

//Mark: - Image Picker Delegate
extension CreateClothesViewController: PhotoPickerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
    clothesImageView.image = pickedImage
    self.dismiss(animated: true, completion: nil)
  }
}
