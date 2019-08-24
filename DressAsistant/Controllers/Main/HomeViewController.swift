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
  
  private let showRecomendationSegue = "showRecomendations"
  private var weatherResponse: WeatherResponse?
  private var outfits = [Outfit]()
  
  lazy var loadingView = LoadingView()
  
  enum Localizations {
    static let welcomeMorning = "welcome-morning"
    static let welcomeAfternoon = "welcome-afternoon"
    static let welcomeEvening = "welcome-evening"
    static let noWeatherMessage = "no-weather-msg"
    static let noWeatherTitle = "no-weather-title"
    static let noOutfitsMessage = "no-outfits-title"
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
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
  
  @IBAction func requestRecomendations(_ sender: Any) {
    let pickerVC = EventTypePickerTableViewController()
    pickerVC.delegate = self
    let nav = UINavigationController(rootViewController: pickerVC)
    
    present(nav, animated: true)
  }
  
  private func loadData(weather: WeatherResponse) {
    weatherLabel.text = weather.currentWeather?.largeDescription
    temperatureLabel.text = "\(Int(weather.temperature.value))°C"
    
    if let path = weather.currentWeather?.iconPath  {
      iconImageView.fillWithURL(WeatherService().getIconUrlFromPath(path) , placeholder: nil)
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == showRecomendationSegue {
      if outfits.isEmpty {
        showNoOutfitsAvailableAlert()
        return
      }
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
          self.performSegue(withIdentifier: self.showRecomendationSegue,
                            sender: self)
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
