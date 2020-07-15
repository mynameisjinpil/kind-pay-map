//
//  RoundingView.swift
//  BadStore
//
//  Created by yujinpil on 2020/06/04.
//  Copyright © 2020 jinpil. All rights reserved.
//

import UIKit

class RoundingButton: UIButton {
  override init(frame: CGRect) {
    super.init(frame: frame)
    initLayer()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    initLayer()
  }
  
  private func initLayer() {
    self.layer.cornerRadius = 7.0
    self.layer.borderWidth = 1.0
    self.layer.borderColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0).cgColor
    self.layer.masksToBounds = false
  }
}
