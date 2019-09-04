//
//  AffiliatesTableViewController.swift
//  DressAsistant
//
//  Created by Libranner Leonel Santos Espinal on 08/07/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import UIKit

class AffiliatesListViewController: BaseViewController, LoadingScreenDelegate {
  lazy var loadingView = LoadingView()
  
  @IBOutlet var tableView: UITableView!
  private var affiliates = [Affiliate]()
  private let cellIdentifier = "AffiliateCell"
  private let showDetailSegueName = "showDetail"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
    
    setupRefreshControl()
  }
  
  @IBAction func logout(_ sender: Any) {
    AuthService().logout()
    self.dismiss(animated: true)
  }
  
  private func setupRefreshControl() {
    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(loadAffiliates), for: .valueChanged)
    tableView.refreshControl = refreshControl
    tableView.refreshControl?.beginRefreshing()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    tableView.refreshControl?.beginRefreshing()
    AppManager.shared.currentAffiliate = nil
    loadAffiliates()
  }
  
  @objc private func loadAffiliates() {
    AffiliateService().getAll { [weak self] (error, affiliates) in
      self?.affiliates = affiliates
      self?.tableView.reloadData()
      self?.tableView?.refreshControl?.endRefreshing()
    }
  }
  
  @IBAction func addAffiliateAction() {
    let affiliateCV = storyboard?.instantiateViewController(withIdentifier: "AffiliateViewController")
    navigationController?.pushViewController(affiliateCV!, animated: true)
  }
  
  var selectedAffiliate: Affiliate? {
    if let indexPath = tableView.indexPathForSelectedRow {
      return affiliates[indexPath.row]
    }
    
    return nil
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let affiliate = selectedAffiliate {
      AppManager.shared.currentAffiliate = affiliate
    }
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
    
    cell.connectionIndicatorView.backgroundColor = affiliate.isConnected ? .green : .red
    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    performSegue(withIdentifier: showDetailSegueName, sender: self)
    self.tableView.deselectRow(at: indexPath, animated: false)
  }
}
