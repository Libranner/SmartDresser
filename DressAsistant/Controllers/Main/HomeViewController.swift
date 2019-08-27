//
//  HomeViewController.swift
//  DressAsistant
//
//  Created by Libranner Leonel Santos Espinal on 03/08/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController {
  
  @IBOutlet weak var temperatureLabel: UILabel!
  @IBOutlet weak var iconImageView: RoundImageView!
  @IBOutlet weak var weatherLabel: UILabel!
  @IBOutlet var requestRecomendationButton: RoundedButton!
  
  @IBOutlet var affiliateToButton: RoundedButton!
  private let showRecomendationSegue = "showRecomendations"
  private var weatherResponse: WeatherResponse?
  private var outfits = [Outfit]()
  private var isAffiliated: Bool = false
  
  @IBOutlet var weatherActivityIndicatorView: UIActivityIndicatorView!
  @IBOutlet var mainStackView: UIStackView!
  @IBOutlet var activityIndicatorView: UIActivityIndicatorView!
  lazy var loadingView = LoadingView()
  
  enum Localizations {
    static let welcomeMorning = "welcome-morning"
    static let welcomeAfternoon = "welcome-afternoon"
    static let welcomeEvening = "welcome-evening"
    static let noWeatherMessage = "no-weather-msg"
    static let noWeatherTitle = "no-weather-title"
    static let noOutfitsMessage = "no-outfits-title"
    static let noAffiliatedMessage = "no-affiliated-message"
    static let affiliateToText = "affiliate-to-text"
    static let deaffiliateToText = "deaffiliate-to-text"
    static let closeModal = "close-modal"
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupAffiliateInfo()
    setTitleAccordingTimeOfDay()
    setupWeatherInfo()
  }
  
  private func setupAffiliateInfo() {
    if AppManager.shared.affiliateId != nil {
      showAlreadyAffiliatedText()
    }
    else {
      showNotAffiliatedText()
    }
  }
  
  func showNotAffiliatedText() {
    activityIndicatorView.stopAnimating()
    affiliateToButton.setTitle(NSLocalizedString(Localizations.affiliateToText, comment: ""),
                                for: .normal)
    affiliateToButton.backgroundColor = CustomColor.defaultButtonBackgroundColor
    affiliateToButton.isUserInteractionEnabled = true
    isAffiliated = false
  }
  
  func showAlreadyAffiliatedText() {
    activityIndicatorView.stopAnimating()
    affiliateToButton.setTitle(NSLocalizedString(Localizations.deaffiliateToText, comment: ""),
                                for: .normal)
    affiliateToButton.backgroundColor = .red
    affiliateToButton.isUserInteractionEnabled = true
    isAffiliated = true
  }
  
  private func setTitleAccordingTimeOfDay() {
    var welcomeStringId = ""
    switch WeatherService().currentTimeOfDay {
    case .morning:
      welcomeStringId = Localizations.welcomeMorning
    case .afternoon:
      welcomeStringId = Localizations.welcomeAfternoon
    case .evening:
      welcomeStringId = Localizations.welcomeEvening
    default:
      welcomeStringId = Localizations.welcomeMorning
    }
    
    title = NSLocalizedString(welcomeStringId, comment: "")
  }
  
  private func setupWeatherInfo() {
    weatherActivityIndicatorView.startAnimating()
    WeatherService().downloadCurrentWeather {  [weak self] (response) in
      if let response = response {
        self?.weatherResponse = response
        if Thread.isMainThread {
          self?.loadData(weather: response)
        }
        else {
          DispatchQueue.main.async {
            self?.loadData(weather: response)
          }
        }
      }
      else {
        self?.showNoWeatherAlert()
      }
    }
  }
  
  @IBAction func scanQRButtonTapped(_ sender: Any) {
    affiliateToButton.isUserInteractionEnabled = false
    activityIndicatorView.isHidden = false
    activityIndicatorView.startAnimating()
    
    if isAffiliated {
      if let affiliatedId = AppManager.shared.affiliateId {
        AffiliateService().updateRelation(affiliateId: affiliatedId,
                                          status: false) { [weak self] error in
          guard error == nil else {
            return
          }
          
          self?.showNotAffiliatedText()
        }
      }
    }
    else {
      let scannerVC = ScannerViewController()
      let navVC = UINavigationController(rootViewController: scannerVC)
      scannerVC.delegate = self
      present(navVC, animated: true)
    }
  }
  
  @IBAction func requestRecomendations(_ sender: Any) {
    guard isAffiliated else {
      showNoAffiliatedAlert()
      return
    }
    
    let pickerVC = EventTypePickerTableViewController()
    pickerVC.delegate = self
    let nav = UINavigationController(rootViewController: pickerVC)
    
    present(nav, animated: true)
  }
  
  private func loadData(weather: WeatherResponse) {
    weatherActivityIndicatorView.stopAnimating()
    weatherLabel.alpha = 0
    temperatureLabel.alpha = 0
    iconImageView.alpha = 0
    UIView.animate(withDuration: 0.35, delay: 0, options: .curveEaseIn, animations: {
      self.weatherLabel.text = weather.currentWeather?.largeDescription
      self.temperatureLabel.text = "\(Int(weather.temperature.value))°C"
      
      if let path = weather.currentWeather?.iconPath  {
        self.iconImageView.fillWithURL(WeatherService().getIconUrlFromPath(path) , placeholder: nil)
      }
      self.weatherLabel.alpha = 1
      self.temperatureLabel.alpha = 1
      self.iconImageView.alpha = 1
    })
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == showRecomendationSegue {
      let destinationVC = segue.destination as! RecommendationViewController
      destinationVC.outfits = outfits
    }
  }
  
  func showNoOutfitsAvailableAlert() {
    let title = NSLocalizedString(BaseViewController.Localizations.errorModalTitle, comment: "")
    let okString = NSLocalizedString(BaseViewController.Localizations.okAction, comment: "")
    let message = NSLocalizedString(Localizations.noOutfitsMessage, comment: "")
    
    let alertVC = UIAlertController(title: title, message: message,
                                    preferredStyle: .alert)
    
    let okAction = UIAlertAction(title: okString, style: .default)
    alertVC.addAction(okAction)
    
    present(alertVC, animated: true)
  }
  
  func showNoAffiliatedAlert() {
    let title = NSLocalizedString(BaseViewController.Localizations.errorModalTitle, comment: "")
    let okString = NSLocalizedString(BaseViewController.Localizations.okAction, comment: "")
    let message = NSLocalizedString(Localizations.noAffiliatedMessage, comment: "")
    
    let alertVC = UIAlertController(title: title, message: message,
                                    preferredStyle: .alert)
    
    let okAction = UIAlertAction(title: okString, style: .default)
    alertVC.addAction(okAction)
    
    present(alertVC, animated: true)
  }
  
  func showNoWeatherAlert() {
    let title = NSLocalizedString(BaseViewController.Localizations.errorModalTitle, comment: "")
    let okString = NSLocalizedString(BaseViewController.Localizations.okAction, comment: "")
    let message = NSLocalizedString(Localizations.noWeatherMessage, comment: "")
    
    let alertVC = UIAlertController(title: title, message: message,
                                    preferredStyle: .alert)
    
    let okAction = UIAlertAction(title: okString, style: .default)
    alertVC.addAction(okAction)
    
    present(alertVC, animated: true)
  }
}

extension HomeViewController: LoadingScreenDelegate {
}

extension HomeViewController: ScannerViewControllerDelegate {
  func scannedCode(_ code: String) {
    affiliateToButton.isUserInteractionEnabled = false
    AffiliateService().get(withId: code) { (error, affiliate) in
      guard affiliate != nil else {
        return
      }
      
      AffiliateService().updateRelation(affiliateId: code, status: true) { [weak self] error in
        guard error == nil else {
          self?.showNotAffiliatedText()
          return
        }
        AppManager.shared.currentAffiliate = affiliate
        AppManager.shared.saveAffiliateId(affiliate!.key!)
        self?.isAffiliated = true
        self?.showAlreadyAffiliatedText()
      }
    }
  }
  
  func dismissScan() {
    showNotAffiliatedText()
  }
}

extension HomeViewController: EventPickerDelegate {
  func eventPicker(_ eventPicker: EventTypePickerTableViewController, didSelect eventType: EventType) {
    let season = WeatherService().currentSeason
    let timeOfDay = WeatherService().currentTimeOfDay
    
    if let weather = weatherResponse?.currentWeather?.condition {
      showLoading()
      OutfitService().getRecomendationsForWeather(weather,
                                                  timeOfDay: timeOfDay,
                                                  eventType: eventType,
                                                  season: season) { outfits in
        DispatchQueue.main.async {
          self.outfits = outfits
          self.hideLoading()
          
          if outfits.isEmpty {
            let outfitRequest = OutfitRequest(affiliateId: AppManager.shared.affiliateId!,
                                              season: season,
                                              weather: weather,
                                              eventType: eventType,
                                              timeOfDay: timeOfDay,
                                              date: Date())
            OutfitRequestService().save(outfitRequest)
            self.showNoOutfitsAvailableAlert()
          }
          else {
            self.performSegue(withIdentifier: self.showRecomendationSegue,
                                sender: self)
          }
        }
      }
    }
    else {
      DispatchQueue.main.async {
        self.showNoWeatherAlert()
      }
    }
  }
}
