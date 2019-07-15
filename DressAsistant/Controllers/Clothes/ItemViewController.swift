//
//  ItemViewController.swift
//  DressAsistant
//
//  Created by Libranner Leonel Santos Espinal on 14/07/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import UIKit
import SnapKit

class ItemViewController: BaseViewController {
  
  enum Localizations {
    static let detailField = "detail-field"
    static let materialField = "material-field"
    static let itemTypeField = "item-type-field"
    static let itemColorField = "item-color-field"
    static let printTypeField = "print-type-field"
    static let patternTypeField = "pattern-type-field"
    static let saveTitle = "save-title"
    static let selectPhoto = "select-photo"
    static let newItemTitle = "new-item-title"
  }
  
  enum PickerMode: Int {
    case materialPicker = 0
    case patternTypePicker
    case printTypePicker
    case colorPicker
    case itemTypePicker
  }
  
  var nfcCode: String?
  lazy var loadingView = LoadingView()
  var existingItem: Item?
  
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
  
  fileprivate var selectedColor: ItemColor = .none {
    didSet {
      itemColorTextField.text = selectedColor.rawValue
    }
  }
  
  fileprivate var selectedItemType: ItemType = .none {
    didSet {
      itemTypeTextField.text = selectedItemType.rawValue
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

  fileprivate lazy var itemTypeTextField: UITextField = {
    return createTextField(localizeStringId: Localizations.itemTypeField,
                           pickerMode: .itemTypePicker)
  }()
  
  fileprivate lazy var itemColorTextField: UITextField = {
    return createTextField(localizeStringId: Localizations.itemColorField,
                           pickerMode: .colorPicker)
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
  
  fileprivate lazy var itemImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleToFill
    imageView.layer.cornerRadius = UIConstants.defaultRadiusForBorder
    imageView.clipsToBounds = true
    return imageView
  }()
  
  fileprivate lazy var choosePhotoButton: UIButton = {
    let button =  UIButton(type: .custom)
    button.setBackgroundImage(UIImage(named: "camera"), for: .normal)
    button.addTarget(self, action: #selector(choosePhoto), for: .touchUpInside)
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
    
    let saveButtontitle = NSLocalizedString(Localizations.saveTitle, comment: "")
    let saveButton = UIBarButtonItem(title: saveButtontitle, style: .plain,
                                     target: self, action: #selector(save))
    
    navigationItem.rightBarButtonItem = saveButton
    
    NotificationCenter.default.addObserver(self, selector:
      #selector(showingKeyboard), name:UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector:
      #selector(hidingKeyboard), name:UIResponder.keyboardWillHideNotification, object: nil)
    
    self.title = NSLocalizedString(Localizations.newItemTitle, comment: "")
    
    setupUI()
  }
  
  @objc func showingKeyboard(notification: NSNotification) {
    keyboardWillShow(notification: notification)
  }
  
  @objc func hidingKeyboard(notification: NSNotification) {
    keyboardWillHide(notification: notification)
  }
  
  @objc fileprivate func save() {
    
    if (validateFields()) {
      showLoading()
      uploadPhoto { [weak self] photoURL in
        if let self = self {
          self.nfcCode = "123"
          let item = Item(key: nil,
                                nfcCode: self.nfcCode!,
                                imageURL: photoURL,
                                detail: self.detailTextField.text!,
                                material: self.selectedMaterial,
                                patternType: self.selectedPatternType,
                                printType: self.selectedPrintType,
                                color: self.selectedColor,
                                type: self.selectedItemType)
          
          self.persist(item)
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
  
  fileprivate func persist(_ item: Item) {
    showLoading()
    if existingItem == nil {
      _ = ItemService().save(item) { [weak self] error, success in
        self?.handleResponse(error: error, success: success)
      }
    }
    else {
      ItemService().update(key: existingItem!.key!, item: item) {
        [weak self] error, success in
        self?.handleResponse(error: error, success: success)
      }
    }
  }
  
  fileprivate func uploadPhoto(completion: @escaping (_ photoURL: URL)-> Void) {
    if let data = itemImageView.image?.pngData() {
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
    
    mainStackView.addArrangedSubview(itemImageView)
    itemImageView.layer.borderColor = UIColor.gray.cgColor
    itemImageView.layer.borderWidth = 1
    
    itemImageView.snp.makeConstraints { make in
      make.centerX.equalToSuperview().labeled("ImageViewWidthAndCenter")
      make.height.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.35)
    }
    
    scrollView.addSubview(choosePhotoButton)
    choosePhotoButton.snp.makeConstraints { make in
      make.height.equalTo(UIConstants.defaultButtonHeight)
      make.width.equalTo(choosePhotoButton.snp.height)
      make.centerX.bottom.equalTo(itemImageView)
    }

    setupForm()
  }
  
  func setupForm() {
    let data = [Localizations.detailField: detailTextField,
                Localizations.materialField: materialTextField,
                Localizations.itemTypeField: itemTypeTextField,
                Localizations.itemColorField: itemColorTextField,
                Localizations.patternTypeField: patternTypeTextField,
                Localizations.printTypeField: printTypeTextField
    ]
    
    let infoStackView = UIStackView()
    infoStackView.distribution = .fill
    infoStackView.axis = .vertical
    infoStackView.alignment = .fill
    infoStackView.spacing = 10
    
    let keys = [Localizations.detailField, Localizations.materialField,
                Localizations.itemTypeField, Localizations.itemColorField,
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
    guard itemImageView.image != nil else {
      showErrorMessage(CustomError.emptyField(fieldName:
        NSLocalizedString(Localizations.selectPhoto, comment: "")))
      return false
    }
    
    guard !detailTextField.text!.isEmpty else {
      showErrorMessage(CustomError.emptyField(fieldName:
        NSLocalizedString(Localizations.detailField, comment: "")))
      return false
    }
    
    guard selectedItemType != .none else {
      showErrorMessage(CustomError.emptyField(fieldName:
        NSLocalizedString(Localizations.itemTypeField, comment: "")))
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
    
    guard selectedColor != .none else {
      showErrorMessage(CustomError.emptyField(fieldName:
        NSLocalizedString(Localizations.itemColorField, comment: "")))
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
extension ItemViewController: UIPickerViewDelegate, UIPickerViewDataSource {
  private static let patternTypes = PatternType.allCases
  private static let printTypes = PrintType.allCases
  private static let itemColors = ItemColor.allCases
  private static let materials = Material.allCases
  private static let types = ItemType.allCases
  
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
      return ItemViewController.materials.count
    case .colorPicker:
      return ItemViewController.itemColors.count
    case .patternTypePicker:
      return ItemViewController.patternTypes.count
    case .printTypePicker:
      return ItemViewController.printTypes.count
    case .itemTypePicker:
      return ItemViewController.types.count
    }
  }
  
  private func optionAtIndex(_ index: Int, for pickerView: UIPickerView) -> String {
    
    let pickerMode = PickerMode(rawValue: pickerView.tag)
    
    guard pickerMode != nil else {
      return ""
    }
    
    switch pickerMode! {
    case .materialPicker:
      return ItemViewController.materials[index].rawValue
    case .colorPicker:
      return ItemViewController.itemColors[index].rawValue
    case .patternTypePicker:
      return ItemViewController.patternTypes[index].rawValue
    case .printTypePicker:
      return ItemViewController.printTypes[index].rawValue
    case .itemTypePicker:
      return ItemViewController.types[index].rawValue
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
      selectedMaterial = ItemViewController.materials[row]
    case .colorPicker:
      selectedColor = ItemViewController.itemColors[row]
    case .patternTypePicker:
      selectedPatternType = ItemViewController.patternTypes[row]
    case .printTypePicker:
      selectedPrintType = ItemViewController.printTypes[row]
    case .itemTypePicker:
      selectedItemType = ItemViewController.types[row]
    }
  }
  
  @objc func choosePhoto(_ sender: Any) {
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
extension ItemViewController: LoadingScreenDelegate {
  
}

//Mark: - Scrollable
extension ItemViewController: UIViewControllerScrollable {
  
}

//Mark: - Image Picker Delegate
extension ItemViewController: PhotoPickerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
    itemImageView.image = pickedImage
    self.dismiss(animated: true, completion: nil)
  }
}
