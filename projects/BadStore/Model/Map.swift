//
//  Map.swift
//  BadStore
//
//  Created by yujinpil on 2020/05/21.
//  Copyright © 2020 jinpil. All rights reserved.
//

import Foundation
import NMapsMap

// MARK: 맵 객체

class Map: NSObject {
  // 맵이 보여주고있는 가운데 포인트
  public var centerPoint = NMGLatLng()
  // 맵에 보여줄 가맹점 정보들을 저장하는 객체
  var storeCache =  NSCache<NSString, StoresObject>()
  
  public func findNearbyStore(_ key: NSString) -> [Store] {
    if let all = storeCache.object(forKey: key) {
      var filtered: [Store] = []
      
      for store in all.stores {
        // store객체에 위도 경도 정보가 없는 경우도 있더라고...
        guard let stringLatitude = store.latitude else {
          print("[Object] 위도를 불러 올 수 없습니다.")
          continue
        }
        
        guard let stringLongitude = store.longitude else {
          print("[Object] 경도를 불러 올 수 없습니다.")
          continue
        }
        
        // 가맹점 위치
        let latitude = Double(stringLatitude)!
        let longitude = Double(stringLongitude)!
        
        // 가로, 세로 약 100m 내의 가맹점만 필터링.
        if longitude >= centerPoint.lng - 0.001 && longitude <= centerPoint.lng + 0.001 {
          if latitude >= centerPoint.lat - 0.001 && latitude <= centerPoint.lat + 0.001 {
            filtered.append(store)
          }
        }
      }
      print("[Object] \(filtered.count)개의 가맹점이 주위에 있습니다.")
      
      return filtered
    }
    else {
      print("[Object] \(key)로 등록된 캐시가 없습니다.")
      return []
    }
  }
}

