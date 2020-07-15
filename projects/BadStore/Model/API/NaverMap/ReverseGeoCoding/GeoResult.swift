//
//  GeoResult.swift
//  BadStore
//
//  Created by yujinpil on 2020/05/15.
//  Copyright © 2020 jinpil. All rights reserved.
//

import Foundation

struct GeoResult: Decodable {
  var region: Geo
  var land: Land?
}
