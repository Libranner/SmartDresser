//
//  AffiliateTableViewCell.swift
//  DressAsistant
//
//  Created by Libranner Leonel Santos Espinal on 08/07/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import UIKit

class AffiliateTableViewCell: UITableViewCell {
  
  @IBOutlet var affiliateNameLabel: UILabel!
  @IBOutlet var affiliateImageView: RoundImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func prepareForReuse() {
    affiliateNameLabel.text = ""
    affiliateImageView.image = nil
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
}
