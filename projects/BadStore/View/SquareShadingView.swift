//
//  ShadingView.swift
//  BadStore
//
//  Created by yujinpil on 2020/06/03.
//  Copyright © 2020 jinpil. All rights reserved.
//

import UIKit

class SquareShadingView: UIView {
  override init(frame: CGRect) {
    super.init(frame: frame)
    initLayer()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    initLayer()
  }
  
  private func initLayer() {
    self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
    self.layer.shadowOffset = CGSize(width: 0.0, height: 0.3)
    self.layer.shadowOpacity = 1.0
    self.layer.shadowRadius = 0.0
    
    self.layer.masksToBounds = false
  }
}
