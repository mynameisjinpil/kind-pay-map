//
//  Geo.swift
//  BadStore
//
//  Created by yujinpil on 2020/05/15.
//  Copyright © 2020 jinpil. All rights reserved.
//

import Foundation

struct Geo: Decodable {
  var city: GeoData
  var town: GeoData
  
  enum CodingKeys: String, CodingKey {
    case city = "area2"
    case town = "area3"
  }
}

struct GeoData: Decodable {
  var name: String
}

