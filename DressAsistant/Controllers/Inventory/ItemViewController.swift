//
//  ItemViewController.swift
//  DressAsistant
//
//  Created by Libranner Leonel Santos Espinal on 14/07/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import UIKit
import SnapKit
import CoreNFC

class ItemViewController: BaseViewController {
  
  enum Localizations {
    static let detailField = "detail-field"
    static let materialField = "material-field"
    static let itemTypeField = "item-type-field"
    static let itemColorField = "item-color-field"
    static let printTypeField = "print-type-field"
    static let patternTypeField = "pattern-type-field"
    static let locationField = "location-field"
    static let nfcField = "nfc-field"
    static let saveTitle = "save-title"
    static let selectPhoto = "select-photo"
    static let newItemTitle = "new-item-title"
    static let editItemTitle = "edit-item-title"
    static let itemTitle = "item-title"
    static let deleteButtonTitle = "remove-button-title"
    static let removeItem = "remove-item"
    static let item = "item"
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
  var previewMode: Bool = false
  var session: NFCNDEFReaderSession?
  
  convenience init(item: Item, previewMode: Bool = false) {
    self.init()
    existingItem = item
    self.previewMode = previewMode
  }
  
  convenience init(nfcCode: String, previewMode: Bool = true) {
    self.init()
    self.nfcCode = nfcCode
    self.previewMode = previewMode
  }
  
  fileprivate var editMode: Bool {
    return existingItem != nil && !previewMode
  }
  
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
  
  fileprivate lazy var locationTextField: UITextField = {
    let textfield = UIHelper().makeTextFieldFor(Localizations.locationField,
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
  
  fileprivate lazy var itemImageView: AsyncImageView = {
    let imageView = AsyncImageView()
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
  
  fileprivate lazy var deleteButton: UIButton = {
    let button =  UIButton(type: .custom)
    let title = NSLocalizedString(Localizations.deleteButtonTitle, comment: "")
    button.setTitle(title, for: .normal)
    button.backgroundColor = .red
    button.addTarget(self, action: #selector(askUserBeforeDeletion), for: .touchUpInside)
    
    return button
  }()
  
  private lazy var mainStackView: UIStackView = {
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
  
  fileprivate lazy var activityIndicatorView = UIHelper().makeActivityIndicatior()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    NotificationCenter.default.addObserver(self, selector:
      #selector(showingKeyboard), name:UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector:
      #selector(hidingKeyboard), name:UIResponder.keyboardWillHideNotification, object: nil)

    setupUI()
    deleteButton.isHidden = !editMode
    
    if editMode {
      setupSaveButton()
      self.title = NSLocalizedString(Localizations.editItemTitle, comment: "")
    }
    else {
      if previewMode {
        self.title = NSLocalizedString(Localizations.itemTitle, comment: "")
      }
      else {
        self.title = NSLocalizedString(Localizations.newItemTitle, comment: "")
        setupSaveButton()
        session = NFCNDEFReaderSession(delegate: self, queue: DispatchQueue.main, invalidateAfterFirstRead: true)
        session?.begin()
      }
    }
    
    if existingItem != nil {
      fillUpForm()
    }
  }
  
  private func setupSaveButton() {
    let saveButtontitle = NSLocalizedString(Localizations.saveTitle, comment: "")
    let saveButton = UIBarButtonItem(title: saveButtontitle, style: .plain,
                                     target: self, action: #selector(save))
    
    navigationItem.rightBarButtonItem = saveButton
  }
  
  private func fillUpForm() {
    if let item = existingItem {
      detailTextField.text = item.detail
      locationTextField.text = item.location
      selectedMaterial = item.material
      selectedItemType = item.type
      selectedColor = item.color
      selectedPatternType = item.patternType
      selectedPrintType = item.printType
      
      scrollView.addSubview(activityIndicatorView)
      activityIndicatorView.snp.makeConstraints { make in
        make.center.equalTo(itemImageView)
      }
      
      activityIndicatorView.startAnimating()
      itemImageView.fillWithURL(item.imageURL, placeholder: nil) { [weak self] _ in
        self?.activityIndicatorView.stopAnimating()
      }
    }
    else {
      showErrorMessage(.errorGettingData)
    }
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
          let userId = AuthService().currentUserId
          let affiliateId = AppManager.shared.currentAffiliate?.key
          
          let item = Item(key: nil,
                          nfcCode: self.nfcCode!,
                          imageURL: photoURL,
                          detail: self.detailTextField.text!,
                          material: self.selectedMaterial,
                          patternType: self.selectedPatternType,
                          printType: self.selectedPrintType,
                          color: self.selectedColor,
                          type: self.selectedItemType,
                          location: self.locationTextField.text!,
                          affiliateId: affiliateId,
                          userId: userId)
          
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
    if !editMode {
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
    let compressedImage = itemImageView.image!.jpegData(compressionQuality: 0.6)
    
    if let data = compressedImage {
      FileService().uploadItemPhoto(data) { [weak self] error,
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
                Localizations.printTypeField: printTypeTextField,
                Localizations.locationField: locationTextField
    ]
    
    let infoStackView = UIStackView()
    infoStackView.distribution = .fill
    infoStackView.axis = .vertical
    infoStackView.alignment = .fill
    infoStackView.spacing = 10
    
    let keys = [Localizations.detailField, Localizations.materialField,
                Localizations.itemTypeField, Localizations.itemColorField,
                Localizations.patternTypeField, Localizations.printTypeField,
                Localizations.locationField
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
    
    if editMode {
      mainStackView.addArrangedSubview(deleteButton)
      
      deleteButton.snp.makeConstraints { make in
        make.width.equalToSuperview()
        make.height.equalTo(UIConstants.defaultButtonHeight).labeled("DeleteButtonHeight")
      }
    }
  }
  
  private func delete() {
    if let key = existingItem?.key {
      showLoading()
      ItemService().delete(key) { [weak self] error, success in
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
    else {
      showErrorMessage(CustomError.generic)
    }
  }
  
  @objc private func askUserBeforeDeletion() {
    var removeTitleString = NSLocalizedString(Localizations.removeItem, comment: "")
    let itemString = NSLocalizedString(Localizations.item, comment: "")
    removeTitleString = String(format: removeTitleString, itemString)
    
    let removeActionString = NSLocalizedString(BaseViewController.Localizations.removeAction, comment: "")
    let cancelActionString = NSLocalizedString(BaseViewController.Localizations.cancelAction, comment: "")
    
    let alertVC = UIAlertController(title: "", message: removeTitleString, preferredStyle: .actionSheet)
    let removeAction = UIAlertAction(title: removeActionString, style: .destructive) { [weak self] _ in
      self?.delete()
    }
    let cancelAction = UIAlertAction(title: cancelActionString, style: .default)
    
    alertVC.addAction(removeAction)
    alertVC.addAction(cancelAction)
    present(alertVC, animated: true)
  }
  
  func validateFields() -> Bool {
    guard nfcCode != nil else {
      showErrorMessage(CustomError.emptyField(fieldName:
        NSLocalizedString(Localizations.nfcField, comment: "")))
      return false
    }
    
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
  
  @objc func choosePhoto(_ sender: Any) {
    let takePhotoString = NSLocalizedString("take-photo", comment: "")
    let choosePhotoString = NSLocalizedString("choose-gallery-photo", comment: "")
    let selectPhotoString = NSLocalizedString("select-photo", comment: "")
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
}

// MARK: NFCNDEReaderSessionDelegate
extension ItemViewController: NFCNDEFReaderSessionDelegate {
  func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
    let err = error as! NFCReaderError
    if err.code.rawValue == 200 {
      self.navigationController?.popViewController(animated: true)
    }
    print(error)
  }
  
  func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
    for message in messages {
      for record in message.records {
        if let itemNFC = String(data: record.payload.advanced(by: 3), encoding: .utf8) {
          DispatchQueue.global(qos: .userInteractive).async {
            ItemService().get(withNFC: itemNFC, completion: { [weak self] error, item in
              guard error != .generic else {
                self?.showErrorMessage(CustomError.generic)
                return
              }
              
              guard error == .notFound else {
                self?.showErrorMessage("Item ya existe")
                self?.navigationController?.popViewController(animated: true)
                return
              }
              
              self?.nfcCode = itemNFC
            })
          }
          session.invalidate()
        }
      }
    }
  }
}
