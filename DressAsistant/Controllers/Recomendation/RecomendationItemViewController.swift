//
//  RecomendationItemViewController.swift
//  DressAsistant
//
//  Created by Libranner Leonel Santos Espinal on 03/08/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import UIKit
import CoreNFC
import AVFoundation

class RecomendationItemViewController: BaseViewController {
  
  @IBOutlet weak var itemImageView: AsyncImageView!
  @IBOutlet weak var descLabel: UILabel!
  private var player: AVAudioPlayer?
  
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
    loadData()
  }
  
  @IBAction func startScanning() {
    session = NFCNDEFReaderSession(delegate: self, queue: DispatchQueue.main, invalidateAfterFirstRead: true)
    session?.begin()
  }
  
  private func loadData() {
    itemImageView.fillWithURL(currentItem.imageURL, placeholder: nil)
    
    var desc = "\(currentItem.detail)."
    desc = " \(desc)\n Color: \(currentItem.color.rawValue)."
    
    if currentItem.material != .none {
      desc = "\(desc)\n Material: \(currentItem.material.rawValue)."
    }
    
    if currentItem.printType != .none {
      desc = "\(desc)\n Estampado: \(currentItem.printType.rawValue)."
    }
    
    if !currentItem.location.isEmpty {
      desc = "\(desc)\n Se encuentra en: \(currentItem.location)."
    }
    
    descLabel.text = desc
  }
  
  @IBAction func nextButtonTapped(_ sender: Any) {
    showNextItem()
  }
  
  func playSound() {
    guard let url = Bundle.main.url(forResource: "found", withExtension: "wav") else { return }
    
    do {
      try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
      try AVAudioSession.sharedInstance().setActive(true)
      
      player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.wav.rawValue)
      
      guard let player = player else { return }
      
      player.play()
      
    } catch let error {
      print(error.localizedDescription)
    }
  }
  
  private func showNextItem() {
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
            let exists = self.itemsIdentified.first(where: { (it) -> Bool in
              return it.nfcCode == itemNFC
            })
            
            if exists == nil {
              self.playSound()
              self.itemsIdentified.append(self.currentItem)
              if self.itemsIdentified.count == self.items.count {
                session.invalidate()
                DispatchQueue.main.async {
                  self.allItemsFound()
                }
                return
              }
            }

            self.showNextItem()
          }
          else {
            print("No Item")
          }
        }
      }
    }
    session.invalidate()
  }
  
  private func allItemsFound() {
    view.subviews.forEach { $0.isUserInteractionEnabled = false }
    let modal = ModalView(type: .success,
                          title: "Todo listo",
                          message: "Haz identificado todas las piezas del atuendo.")
    modal.delegate = self
    view.addSubview(modal)
  }
}


extension RecomendationItemViewController: ModalViewDelegate {
  func modalClosed(modalView: ModalView) {
    if let vc = navigationController?.viewControllers[1] {
     navigationController?.popToViewController(vc, animated: true)
    }
  }
}
