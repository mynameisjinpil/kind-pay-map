
//
//  CityCode.swift
//  BadStore
//
//  Created by yujinpil on 2020/05/14.
//  Copyright © 2020 jinpil. All rights reserved.
//

import Foundation

struct CityCode {
  static public let shared = CityCode()
  
  func returnCityCode(city: String) -> String {
    switch city {
    case "가평군": return "41820"
    case "경기도": return "41000"
    case "고양시": return "41280"
    case "과천시": return "41290"
    case "광명시": return "41219"
    case "광주시": return "41610"
    case "구리시": return "41310"
    case "군포시": return "41410"
    case "김포시": return "41570"
    case "남양주시": return "41360"
    case "동두천시": return "41250"
    case "부천시": return "41190"
    case "성남시": return "41130"
    case "수원시": return "41110"
    case "시흥시": return "41390"
    case "안산시": return "41270"
    case "안성시": return "41150"
    case "안양시": return "41170"
    case "양주시": return "41630"
    case "양평군": return "41830"
    case "여주시": return "41670"
    case "연쳔군": return "41800"
    case "오산시": return "41370"
    case "용인시": return "41460"
    case "의왕시": return "41430"
    case "의정부시": return "41150"
    case "이천시": return "41500"
    case "파주시": return "41480"
    case "평택시": return "41220"
    case "포천시": return "41650"
    case "하남시": return "41450"
    case "화성시": return "41590"
    default:
      return "null"
    }
  }
}
