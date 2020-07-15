//
//  Camera.swift
//  BadStore
//
//  Created by yujinpil on 2020/05/21.
//  Copyright © 2020 jinpil. All rights reserved.
//

import Foundation
import NMapsMap
class Camera: NSObject {
  public var zoom: Double = 15.0
  public var location: NMGLatLng = NMGLatLng()
  public var address: Address = Address()
  
  func setAddress(address: Address) {
    self.address = address
  }
}
