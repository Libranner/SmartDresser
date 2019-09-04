//
//  AffilateCardViewController.swift
//  DressAsistant
//
//  Created by Libranner Leonel Santos Espinal on 06/07/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import UIKit

class AffiliateCardViewController: BaseViewController {
  
  @IBOutlet weak var goToListButton: UIButton!
  @IBOutlet var qrImageView: UIImageView!
  
  var affiliateId: String?
  var shouldGoToRoot = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let affiliateId = affiliateId {
      let image = generateQRCode(from: affiliateId)
      qrImageView.image = image
    }
    
    if shouldGoToRoot {
      goToListButton.isHidden = false
      navigationItem.hidesBackButton = true
    }
    else {
      goToListButton.isHidden = true
    }
  }
  
  @IBAction func goToListTapped(_ sender: Any) {
    navigationController?.popToRootViewController(animated: true)
  }
  
  func generateQRCode(from string: String) -> UIImage? {
    let data = string.data(using: String.Encoding.ascii)
    
    if let filter = CIFilter(name: "CIQRCodeGenerator") {
      filter.setValue(data, forKey: "inputMessage")
      let transform = CGAffineTransform(scaleX: 3, y: 3)
      
      if let output = filter.outputImage?.transformed(by: transform) {
        return UIImage(ciImage: output)
      }
    }
    
    return nil
  }
}
