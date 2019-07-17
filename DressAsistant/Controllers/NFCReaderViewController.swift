//
//  NFCReaderViewController.swift
//  DressAsistant
//
//  Created by Libranner Leonel Santos Espinal on 17/07/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import UIKit
import CoreNFC

class NFCReaderViewController: UIViewController, NFCNDEFReaderSessionDelegate {
  var session: NFCNDEFReaderSession?
  override func viewDidLoad() {
    super.viewDidLoad()
    
    startScanning()
  }
  
  private func startScanning() {
    session = NFCNDEFReaderSession(delegate: self, queue: DispatchQueue.main, invalidateAfterFirstRead: false)
    session?.begin()
  }
  
  // MARK: NFCNDEReaderSessionDelegate
  func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
    print(error)
  }
  
  func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
    for message in messages {
      for record in message.records {
        if let string = String(data: record.payload, encoding: .utf8) {
          print(string)
          session.invalidate()
        }
      }
    }
  }
}
