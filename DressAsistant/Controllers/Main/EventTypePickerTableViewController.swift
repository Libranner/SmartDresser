//
//  EventTypePicker TableViewController.swift
//  DressAsistant
//
//  Created by Libranner Leonel Santos Espinal on 04/08/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import UIKit

protocol EventPickerDelegate {
  func eventPicker( _ eventPicker: EventTypePickerTableViewController, didSelect eventType: EventType)
}

class EventTypePickerTableViewController: UITableViewController {
  lazy var eventTypes: [EventType] = {
    return EventType.allCases.compactMap { (event) -> EventType? in
      guard event != .none else {
        return nil
      }
      return event
    }
  }()
  
  private let reuseIdentifier = "cellIdentifier"
  var delegate: EventPickerDelegate?
  
  enum Localizations {
    static let title = "event-picker-title"
    static let closeModal = "close-modal"
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = NSLocalizedString(Localizations.title, comment: "")
    
    let closeModalTitle = NSLocalizedString(Localizations.closeModal, comment: "")
    let closeModalButton = UIBarButtonItem(title: closeModalTitle,
                                     style: .done,
                                    target: self,
                                    action: #selector(dismissModal))
    
    navigationItem.rightBarButtonItem = closeModalButton
    
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
  }
  
  @objc private func dismissModal() {
    dismiss(animated: true)
  }
  
  // MARK: - Table view data source
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return eventTypes.count - 1
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
    
    cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 30)
    cell.textLabel?.textColor = CustomColor.mainColor
    cell.textLabel?.text = eventTypes[indexPath.row].rawValue.capitalized
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let eventType = eventTypes[indexPath.row]
    delegate?.eventPicker(self, didSelect: eventType)
    dismiss(animated: true)
  }
}
