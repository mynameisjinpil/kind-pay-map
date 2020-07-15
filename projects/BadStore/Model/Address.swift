//
//  Address.swift
//  BadStore
//
//  Created by yujinpil on 2020/05/15.
//  Copyright © 2020 jinpil. All rights reserved.
//

import Foundation

struct Address {
  var state: String = "경기도"
  var city: String = ""
  var town: String = ""
  var full: String = ""
  var fetchingKey: String = ""
  var cachingKey: NSString = ""
  
  mutating func setAddress(region: Geo, landNumber: Land?) {
    self.city = region.city.name
    self.town = region.town.name
    
    self.fetchingKey = "\(city) \(town)"
    self.cachingKey = "\(city)\(town)" as NSString
    
    guard let landNumber = landNumber else {
      self.full = "\(city) \(town)"
      return
    }
    
    guard let number1 = landNumber.number1 else {
      self.full = "\(city) \(town)"
      return
    }
    
    guard let number2 = landNumber.number2 else {
      self.full = "\(city) \(town) \(number1)"
      return
    }
    
    self.full = "\(city) \(town) \(number1)-\(number2)"
  }
}
