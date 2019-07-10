//
//  AffiliatesTableViewController.swift
//  DressAsistant
//
//  Created by Libranner Leonel Santos Espinal on 08/07/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import UIKit

class AffiliatesListViewController: UIViewController, LoadingScreenDelegate {
  lazy var loadingView = LoadingView()
  
  @IBOutlet var tableView: UITableView!
  var affiliates = [Affiliate]()
  let cellIdentifier = "AffiliateCell"
  let showDetailSegueName = "showDetail"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self

    showLoading()
    AffiliateService().getAll { [weak self] (error, affiliates) in
      self?.affiliates = affiliates
      self?.tableView.reloadData()
      self?.hideLoading()
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
  }
}

extension AffiliatesListViewController: UITableViewDelegate, UITableViewDataSource {
  // MARK: - Table view data source
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return affiliates.count
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 94
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! AffiliateTableViewCell
    
    // Configure the cell...
    let affiliate = affiliates[indexPath.row]
    cell.affiliateNameLabel.text = affiliate.name
    if let avatarURL = affiliate.avatarUrl {
      cell.affiliateImageView.fillWithURL(avatarURL, placeholder: nil)
    }
    
    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    performSegue(withIdentifier: showDetailSegueName, sender: self)
    //self.tableView.deselectRow(at: indexPath, animated: false)
  }
}
