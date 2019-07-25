//
//  OutfitViewController.swift
//  DressAsistant
//
//  Created by Libranner Leonel Santos Espinal on 24/07/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import UIKit

class OutfitViewController: BaseViewController {
  enum Localizations {
    static let weatherField = "weather-field"
    static let seasonField = "season-field"
    static let timeOfDayField = "time-of-day-field"
    static let eventTypeField = "event-type-field"
    static let itemsTitle = "item-title"
    static let deleteButtonTitle = "remove-button-title"
    static let removeItem = "remove-item"
    static let outfit = "outfit"
    static let saveTitle = "save-title"
    static let newOutfitTitle = "new-outfit-title"
  }
  
  private let reuseIdentifier = "ItemCell"
  
  enum PickerMode: Int {
    case weatherPicker = 0
    case seasonPicker
    case eventTypePicker
    case timeOfDayPicker
  }
  
  lazy var loadingView = LoadingView()
  var existingOutfit: Outfit?
  var items = [Item]()
  
  private lazy var mainStackView: UIStackView = {
    let mainStackView = UIStackView()
    mainStackView.axis = .vertical
    mainStackView.distribution = .equalSpacing
    mainStackView.spacing = 10
    return mainStackView
  }()
  
  private lazy var collectionView: UICollectionView = {
    let layout = ItemsCollectionLayout(direction: .horizontal)
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.backgroundColor = .white
    collectionView.register(ItemCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    collectionView.dataSource = self
    collectionView.delegate = self
    return collectionView
  }()
  
  private lazy var scrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.isScrollEnabled = true
    scrollView.showsVerticalScrollIndicator = true
    return scrollView
  }()
  
  private lazy var weatherTextField: UITextField = {
    return createTextField(localizeStringId: Localizations.weatherField,
                           pickerMode: .weatherPicker)
  }()
  
  private lazy var eventTypeTextField: UITextField = {
    return createTextField(localizeStringId: Localizations.eventTypeField,
                           pickerMode: .eventTypePicker)
  }()
  
  private lazy var seasonTextField: UITextField = {
    return createTextField(localizeStringId: Localizations.seasonField,
                           pickerMode: .seasonPicker)
  }()
  
  private lazy var timeOfDayTextField: UITextField = {
    return createTextField(localizeStringId: Localizations.timeOfDayField,
                           pickerMode: .timeOfDayPicker)
  }()
  
  private var selectedWeather: Weather = .none {
    didSet {
      weatherTextField.text = selectedWeather.rawValue
    }
  }
  
  private var selectedEventType: EventType = .none {
    didSet {
      eventTypeTextField.text = selectedEventType.rawValue
    }
  }
  
  private var selectedSeason: Season = .none {
    didSet {
      seasonTextField.text = selectedSeason.rawValue
    }
  }
  
  private var selectedTimeOfDay: TimeOfDay = .none {
    didSet {
      timeOfDayTextField.text = selectedTimeOfDay.rawValue
    }
  }
  
  private lazy var deleteButton: UIButton = {
    let button =  UIButton(type: .custom)
    let title = NSLocalizedString(Localizations.deleteButtonTitle, comment: "")
    button.setTitle(title, for: .normal)
    button.backgroundColor = .red
    button.addTarget(self, action: #selector(askUserBeforeDeletion), for: .touchUpInside)
    
    return button
  }()
  
  convenience init(outfit: Outfit) {
    self.init()
    existingOutfit = outfit
    items = outfit.items
  }
  
  convenience init(items: [Item]) {
    self.init()
    self.items = items
  }
  
  private var editMode: Bool {
    return existingOutfit != nil
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    ItemService().getAll { (error, items) in
      self.items = items
      self.collectionView.reloadData()
    }
    
    let saveButtontitle = NSLocalizedString(Localizations.saveTitle, comment: "")
    let saveButton = UIBarButtonItem(title: saveButtontitle, style: .plain,
                                     target: self, action: #selector(save))
    navigationItem.rightBarButtonItem = saveButton
    
    NotificationCenter.default.addObserver(self, selector:
      #selector(showingKeyboard), name:UIResponder.keyboardWillShowNotification,
                                  object: nil)
    NotificationCenter.default.addObserver(self, selector:
      #selector(hidingKeyboard), name:UIResponder.keyboardWillHideNotification,
                                 object: nil)
    
    self.title = NSLocalizedString(Localizations.newOutfitTitle, comment: "")
    
    setupUI()
    
    if editMode {
      fillUpForm()
      deleteButton.isHidden = false
    }
  }
  
  private func setupUI() {
    view.addSubview(collectionView)
    view.addSubview(scrollView)

    collectionView.snp.makeConstraints { make in
      make.top.leading.trailing.equalToSuperview()
      make.height.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.5)
    }
    
    scrollView.snp.makeConstraints { make in
      make.top.equalTo(collectionView.snp.bottom)
      make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
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
    
    setupForm()
  }
  
  private func fillUpForm() {
    if let outfit = existingOutfit {
      selectedTimeOfDay = outfit.timeOfDay
      selectedSeason = outfit.season
      selectedEventType = outfit.eventType
      selectedWeather = outfit.weather
    }
    else {
      
      showErrorMessage(.errorGettingData)
    }
  }
  
  @objc private func showingKeyboard(notification: NSNotification) {
    keyboardWillShow(notification: notification)
  }
  
  @objc private func hidingKeyboard(notification: NSNotification) {
    keyboardWillHide(notification: notification)
  }
  
  @objc private func save() {
    if (validateFields()) {
      showLoading()
      let outfit = Outfit(key: nil,
                        season: selectedSeason,
                        weather: selectedWeather,
                        eventType: selectedEventType,
                        timeOfDay: selectedTimeOfDay,
                        items: items)
      
      self.persist(outfit)
    }
  }
  
  func validateFields() -> Bool {
    guard selectedWeather != .none else {
      showErrorMessage(CustomError.emptyField(fieldName:
        NSLocalizedString(Localizations.weatherField, comment: "")))
      return false
    }
    
    guard selectedEventType != .none else {
      showErrorMessage(CustomError.emptyField(fieldName:
        NSLocalizedString(Localizations.eventTypeField, comment: "")))
      return false
    }
    
    guard selectedSeason != .none else {
      showErrorMessage(CustomError.emptyField(fieldName:
        NSLocalizedString(Localizations.seasonField, comment: "")))
      return false
    }
    
    guard selectedTimeOfDay != .none else {
      showErrorMessage(CustomError.emptyField(fieldName:
        NSLocalizedString(Localizations.timeOfDayField, comment: "")))
      return false
    }
    
    return true
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
  
  private func persist(_ outfit: Outfit) {
    showLoading()
    if !editMode {
      _ = OutfitService().save(outfit) { [weak self] error, success in
        self?.handleResponse(error: error, success: success)
      }
    }
    else {
      OutfitService().update(key: existingOutfit!.key!, outfit: outfit) {
        [weak self] error, success in
        self?.handleResponse(error: error, success: success)
      }
    }
  }

  private func createTextField(localizeStringId: String,
                                   pickerMode: PickerMode) -> UITextField {
    let textfield = UIHelper().makeTextFieldFor(localizeStringId, identifier: nil)
    textfield.inputView = createPickerView(for: pickerMode)
    textfield.inputAccessoryView = UIHelper().defaultAccessoryView(action:
      #selector(hideKeyboard))
    
    return textfield
  }
  
  private func createPickerView(for pickerMode: PickerMode) -> UIPickerView {
    let pickerView = UIPickerView()
    pickerView.delegate = self
    pickerView.dataSource =  self
    pickerView.tag = pickerMode.rawValue
    return pickerView
  }

  func setupForm() {
    let fields = [Localizations.weatherField: weatherTextField,
                  Localizations.eventTypeField: eventTypeTextField,
                  Localizations.seasonField: seasonTextField,
                  Localizations.timeOfDayField: timeOfDayTextField
    ]
    
    let infoStackView = UIStackView()
    infoStackView.distribution = .fill
    infoStackView.axis = .vertical
    infoStackView.alignment = .fill
    infoStackView.spacing = 10
    
    let keys = [Localizations.weatherField, Localizations.eventTypeField,
                Localizations.seasonField, Localizations.timeOfDayField
    ]
    
    for key in keys {
      let element = fields[key]
      
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
  
  @objc private func askUserBeforeDeletion() {
    var removeTitleString = NSLocalizedString(Localizations.removeItem, comment: "")
    let itemString = NSLocalizedString(Localizations.outfit, comment: "")
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
  
  private func delete() {
    if let key = existingOutfit?.key {
      showLoading()
      OutfitService().delete(key) { [weak self] error, success in
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
}

//Mark: - Option Picker delegate and datasource
extension OutfitViewController: UIPickerViewDelegate, UIPickerViewDataSource {
  private static let weathers = Weather.allCases
  private static let seasons = Season.allCases
  private static let eventTypes = EventType.allCases
  private static let timesOfDay = TimeOfDay.allCases
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    let pickerMode = PickerMode(rawValue: pickerView.tag)
    
    guard pickerMode != nil else {
      return 0
    }
    
    switch pickerMode! {
    case .weatherPicker:
      return OutfitViewController.weathers.count
    case .seasonPicker:
      return OutfitViewController.seasons.count
    case .timeOfDayPicker:
      return OutfitViewController.timesOfDay.count
    case .eventTypePicker:
      return OutfitViewController.eventTypes.count
    }
  }
  
  private func optionAtIndex(_ index: Int, for pickerView: UIPickerView) -> String {
    
    let pickerMode = PickerMode(rawValue: pickerView.tag)
    
    guard pickerMode != nil else {
      return ""
    }
    
    switch pickerMode! {
    case .weatherPicker:
      return OutfitViewController.weathers[index].rawValue
    case .seasonPicker:
      return OutfitViewController.seasons[index].rawValue
    case .timeOfDayPicker:
      return OutfitViewController.timesOfDay[index].rawValue
    case .eventTypePicker:
      return OutfitViewController.eventTypes[index].rawValue
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
    case .weatherPicker:
      selectedWeather = OutfitViewController.weathers[row]
    case .eventTypePicker:
      selectedEventType = OutfitViewController.eventTypes[row]
    case .seasonPicker:
      selectedSeason = OutfitViewController.seasons[row]
    case .timeOfDayPicker:
      selectedTimeOfDay = OutfitViewController.timesOfDay[row]
    }
  }
}

//Mark: - Loading
extension OutfitViewController: LoadingScreenDelegate {
}

//Mark: - Scrollable
extension OutfitViewController: UIViewControllerScrollable {
}

//Collection View Delegate
extension OutfitViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let itemVC = ItemViewController(item: items[indexPath.row], previewMode: true)
    navigationController?.pushViewController(itemVC, animated: true)
  }
}

//Collection View DataSource
extension OutfitViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return items.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                  for: indexPath) as! ItemCollectionViewCell
    let item = items[indexPath.row]
    
    cell.activityIndicatorView.startAnimating()
    cell.imageView.fillWithURL(item.imageURL, placeholder: nil) { _ in
      cell.activityIndicatorView.stopAnimating()
    }
    
    cell.nameLabel.text = item.detail
    cell.selectItemButton.isHidden = true
    
    return cell
  }
}
