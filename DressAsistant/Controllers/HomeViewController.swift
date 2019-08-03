//
//  HomeViewController.swift
//  DressAsistant
//
//  Created by Libranner Leonel Santos Espinal on 03/08/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
  
  @IBOutlet weak var temperatureLabel: UILabel!
  @IBOutlet weak var iconImageView: RoundImageView!
  @IBOutlet weak var weatherLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    WeatherService().getCurrentWeather {  [weak self] (response) in
      if let response = response {
        if Thread.isMainThread {
          self?.loadData(weather: response)
        }
        else {
          DispatchQueue.main.async {
            self?.loadData(weather: response)
          }
        }
      }
    }
  }
  
  private func loadData(weather: WeatherResponse) {
    weatherLabel.text = weather.currentWeather?.largeDescription
    temperatureLabel.text = "\(Int(weather.temperature.value))°C"
    
    if let path = weather.currentWeather?.iconPath  {
      iconImageView.fillWithURL(WeatherService().getIconUrlFromPath(path) , placeholder: nil)
    }
  }
}
