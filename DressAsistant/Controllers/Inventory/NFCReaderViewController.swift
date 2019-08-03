//
//  NFCReaderViewController.swift
//  DressAsistant
//
//  Created by Libranner Leonel Santos Espinal on 17/07/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import UIKit
import CoreNFC

class NFCReaderViewController: BaseViewController {
  enum Localizations {
    static let itemExistsMessage = "item-exists-message"
    static let itemDoesNotExistsMessage = "item-not-exists-message"
  }
  
  var session: NFCNDEFReaderSession?
  var isAddingNew = true
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    let modal = ModalView(type: .success, title: "titulo de pruebatitulo de pruebatitulo de pruebatitulo de prueba", message: "titulo de pruebatitulo de pruebatitulo de pruebatitulo de pruebatitulo de pruebatitulo de pruebatitulo de pruebatitulo de pruebatitulo de pruebatitulo de pruebatitulo de pruebatitulo de pruebatitulo de pruebatitulo de prueba")
    view.addSubview(modal)
  }
  
  @IBAction func startScanning() {
    session = NFCNDEFReaderSession(delegate: self, queue: DispatchQueue.main, invalidateAfterFirstRead: true)
    session?.begin()
  }
  
  private func createItem(nfcCode: String) {
    ItemService().get(withNFC: nfcCode) { [weak self] error, data in
      guard error != .generic else {
        self?.showErrorMessage(.errorGettingData)
        return
      }
      
      guard data == nil else {
        self?.showItemExistsAlert(item: data!)
        return
      }
      
      let itemVC = ItemViewController(nfcCode: nfcCode)
      self?.navigationController?.pushViewController(itemVC, animated: true)
    }
  }
  
  private func showItemExistsAlert(item: Item) {
    let title = NSLocalizedString(BaseViewController.Localizations.errorModalTitle, comment: "")
    let okString = NSLocalizedString(BaseViewController.Localizations.yesAction, comment: "")
    let canceltring = NSLocalizedString(BaseViewController.Localizations.cancelAction, comment: "")
    let message = NSLocalizedString(Localizations.itemExistsMessage, comment: "")
    
    let alertVC = UIAlertController(title: title, message: message,
                                    preferredStyle: .alert)
    
    let okAction = UIAlertAction(title: okString, style: .default) { [weak self] _ in
      let itemVC = ItemViewController(item: item, previewMode: true)
      self?.navigationController?.pushViewController(itemVC, animated: true)
    }
    alertVC.addAction(okAction)
    
    let cancelAction = UIAlertAction(title: canceltring, style: .cancel)
    alertVC.addAction(cancelAction)
    
    present(alertVC, animated: true)
  }
  
  private func showItem(nfcCode: String) {
    ItemService().get(withNFC: nfcCode) { [weak self] error, data in
      guard error == nil else {
        self?.showErrorMessage(.errorGettingData)
        return
      }
      
      guard let unWrappedData = data else {
        self?.showErrorMessage(.errorGettingData)
        return
      }
      
      let itemVC = ItemViewController(item: unWrappedData, previewMode: true)
      self?.navigationController?.pushViewController(itemVC, animated: true)
    }
  }
}


// MARK: NFCNDEReaderSessionDelegate
extension NFCReaderViewController: NFCNDEFReaderSessionDelegate {
  func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
    print(error)
  }
  
  func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
    for message in messages {
      for record in message.records {
        if let itemNFC = String(data: record.payload.advanced(by: 3), encoding: .utf8) {
          DispatchQueue.main.async {
            if self.isAddingNew {
              self.createItem(nfcCode: itemNFC)
            }
            else {
              self.showItem(nfcCode: itemNFC)
            }
          }
          session.invalidate()
        }
      }
    }
  }
}


extension NFCReaderViewController: ModalViewDelegate {
  func modalClosed(modalView: ModalView) {
    
  }
}
