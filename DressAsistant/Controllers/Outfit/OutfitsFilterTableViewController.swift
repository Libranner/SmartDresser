//
//  OutfitsFilterTableViewController.swift
//  DressAsistant
//
//  Created by Libranner Leonel Santos Espinal on 31/07/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import UIKit

class OutfitsFilterTableViewController: UITableViewController {
  
  enum Localizations {
    static let weather = "weather-field"
    static let season = "season-field"
    static let eventType = "event-type-field"
    static let timeOfDay = "time-of-day-field"
    static let screenTitle = "filter-outfits-title"
  }
  
  private let reuseIdentifier = "Cell"
  var sectionTitles = [String]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    sectionTitles.append(NSLocalizedString(Localizations.season, comment: ""))
    sectionTitles.append(NSLocalizedString(Localizations.weather, comment: ""))
    sectionTitles.append(NSLocalizedString(Localizations.eventType, comment: ""))
    sectionTitles.append(NSLocalizedString(Localizations.timeOfDay, comment: ""))
    
    title = NSLocalizedString(Localizations.screenTitle, comment: "")
    
    tableView.allowsMultipleSelection = true
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
  }
  
  // MARK: - Table view data source
  override func numberOfSections(in tableView: UITableView) -> Int {
    return sectionTitles.count
  }

  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return sectionTitles[section]
  }
  
  private func textFor(_ indexPath: IndexPath) -> String {
    switch indexPath.section {
    case 0:
      return Season.allCases[indexPath.row].rawValue
    case 1:
      return WeatherCondition.allCases[indexPath.row].rawValue
    case 2:
      return EventType.allCases[indexPath.row].rawValue
    case 3:
      return TimeOfDay.allCases[indexPath.row].rawValue
    default:
      return ""
    }
  }
  
  private func numberOfRows(_ section: Int) -> Int {
    switch section {
    case 0:
      return Season.allCases.count
    case 1:
      return WeatherCondition.allCases.count
    case 2:
      return EventType.allCases.count
    case 3:
      return TimeOfDay.allCases.count
    default:
      return 0
    }
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return numberOfRows(section) - 1
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
    cell.textLabel?.text = textFor(indexPath)
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    tableView.backgroundColor = .white
  }
  
  override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    tableView.cellForRow(at: indexPath)?.accessoryType = .none
    tableView.backgroundColor = .white
  }
}
