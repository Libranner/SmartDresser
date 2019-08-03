//
//  RecomendationItemViewController.swift
//  DressAsistant
//
//  Created by Libranner Leonel Santos Espinal on 03/08/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import UIKit
import CoreNFC

class RecomendationItemViewController: BaseViewController {
  
  @IBOutlet weak var itemImageView: AsyncImageView!
  @IBOutlet weak var descLabel: UILabel!
  
  var items = [Item]()
  private var itemsIdentified = [Item]()
  private var index = 0
  private var session: NFCNDEFReaderSession?
  
  private var currentItem: Item {
    if index >= items.count || index < 0 {
      index = 0
    }
    
    return items[index]
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    itemImageView.layer.cornerRadius = 10
    itemImageView.layer.masksToBounds = true
    itemImageView.layer.borderWidth = 1.0
    itemImageView.layer.borderColor = UIColor.gray.cgColor
    
    loadData()
  }
  
  @IBAction func startScanning() {
    session = NFCNDEFReaderSession(delegate: self, queue: DispatchQueue.main, invalidateAfterFirstRead: true)
    session?.begin()
  }
  
  private func loadData() {
    itemImageView.fillWithURL(currentItem.imageURL, placeholder: nil)
    
    let desc =
    """
    \(currentItem.detail)
    Material: \(currentItem.material.rawValue)
    Color: \(currentItem.color.rawValue)
    Estampado: \(currentItem.printType.rawValue)
    """
    
    descLabel.text = desc
  }
  
  @IBAction func nextButtonTapped(_ sender: Any) {
    index += 1
    loadData()
  }
  
  @IBAction func previousButtonTapped(_ sender: Any) {
    index -= 1
    loadData()
  }
}

// MARK: NFCNDEReaderSessionDelegate
extension RecomendationItemViewController: NFCNDEFReaderSessionDelegate {
  func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
    print(error)
  }
  
  func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
    for message in messages {
      for record in message.records {
        if let itemNFC = String(data: record.payload.advanced(by: 3), encoding: .utf8) {
          if itemNFC == self.currentItem.nfcCode {
            print("Found")
            let exists = self.itemsIdentified.first(where: { (it) -> Bool in
              return it.nfcCode == itemNFC
            })
            
            if exists != nil {
              self.itemsIdentified.append(self.currentItem)
            }
          }
          session.invalidate()
        }
      }
    }
    
    if 1 == 1 {
      if let vc = navigationController?.viewControllers[1] {
        navigationController?.popToViewController(vc, animated: true)
      }
    }
  }
}


extension RecomendationItemViewController: ModalViewDelegate {
  func modalClosed(modalView: ModalView) {
    
  }
}
