//
//  Geo.swift
//  BadStore
//
//  Created by yujinpil on 2020/05/15.
//  Copyright © 2020 jinpil. All rights reserved.
//

import Foundation

struct NaverRoot: Decodable {
  var status: Status
  var results: [GeoResult]
}
