//
//  SearchCell.swift
//  BadStore
//
//  Created by yujinpil on 2020/06/03.
//  Copyright © 2020 jinpil. All rights reserved.
//

import UIKit

class SearchCell: UITableViewCell {
  var store: Store?
  @IBOutlet weak var title: UILabel!
  @IBOutlet weak var address: UILabel!
  @IBOutlet weak var button: UIButton!

  var subscribeButtonAction : (() -> ())?

  override func awakeFromNib() {
    super.awakeFromNib()
    
    self.button.addTarget(self, action: #selector(subscribeButtonTapped(_:)), for: .touchUpInside)
  }
  
  @IBAction func subscribeButtonTapped(_ sender: UIButton) {
    guard let store = self.store else { return }
    subscribeButtonAction?()
  }
}
