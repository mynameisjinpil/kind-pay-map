//
//  SearchViewController.swift
//  BadStore
//
//  Created by yujinpil on 2020/06/03.
//  Copyright © 2020 jinpil. All rights reserved.
//

import UIKit
import Alamofire
import NMapsMap
// MARK:- 검색화면 컨트롤러

class SearchViewController: UIViewController {
  var mapViewController: MapViewController?
  typealias VoidTouchHandler = () -> ()

  // 테이블 뷰의 데이터 소스
  private var stores: [Store] = []
  
  // Storyboard UI
  @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var searchBar: UISearchBar!
  
  // MARK: 생명주기
  override func viewDidLoad() {
    initSuperView()
    initTableView()
    initSearchBar()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    self.searchBar.becomeFirstResponder()
  }
  
  // MARK: 뷰 컨트롤러 초기화 함수
  
  /*
   * 테이블 뷰 초기화 함수
   */
  private func initTableView() {
    self.tableView.dataSource = self
    self.tableView.separatorStyle = .none
  }
  
  /*
   * 테이블 뷰 초기화 함수
   */
  private func initSearchBar() {
    self.searchBar.delegate = self
  }
  
   /*
    * 최상위 뷰 초기화 함수
    */
   private func initSuperView() {
     let resignTap = UITapGestureRecognizer(target: self, action: #selector(self.dissmissKeyboard))
     self.view.addGestureRecognizer(resignTap)
  }
  
  // MARK: UI 함수
  
  /*
   * 뒤로가기
   */
  @IBAction func back(_ sender: Any) {
    self.view.removeFromSuperview()
  }
  
  /*
   * 화면 탭하면 키보드 dissmiss하는 함수
   */
  @objc func dissmissKeyboard() {
    searchBar.resignFirstResponder()
    searchBar.endEditing(true)
  }
  
  @IBAction func goToStore(_ sender: UIButton) {
    
  }
}

// MARK: 테이블 뷰 델리게이트

extension SearchViewController: UITableViewDataSource {
  /*
   * 섹션 개수 반환하는 함수
   */
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  /*
   * 섹션당 셀개수 반환하는 함수
   */
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return stores.count
  }
  
  /*
   * 셀 반환하는 함수
   */
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Search Cell") as! SearchCell
    let item = stores[indexPath.row]
    cell.store = item
    cell.title.text = item.name
    cell.address.text = item.oldAddress
    
    let handler: VoidTouchHandler = { [weak self] in
      guard let store = self?.stores[indexPath.row] else { return }
      
      guard let latitude = store.latitude else { return }
      guard let longitude = store.longitude else { return }
      
      // 마커 초기화
      let location = NMGLatLng(lat: Double(latitude)!, lng: Double(longitude)!)
      
      self?.mapViewController?.mapView?.moveCamera(NMFCameraUpdate(scrollTo: location, zoomTo: 25.0))
      
      // 인포윈도우에 들어갈 데이터
      if let name = store.name {
        self?.mapViewController?.popUpTitle.text = name
      }
      else {
        self?.mapViewController?.popUpTitle.text = "상호명 정보 없음"
      }
      
      if let industType = store.industType {
        self?.mapViewController?.popUpIndus.text = industType
      }
      else {
        self?.mapViewController?.popUpIndus.text = "업종 정보 없음"
      }
      
      if let adress = store.oldAddress {
        self?.mapViewController?.popUpAddress.text = adress
      }
      else {
        self?.mapViewController?.popUpAddress.text = "주소정보 정보 없음"
      }
      
      if let telNumber = store.telNumber {
        self?.mapViewController?.popUpTelNumber.text = telNumber
      }
      else {
        self?.mapViewController?.popUpTelNumber.text = "번호 정보 없음"
      }
      
      self?.mapViewController?.popUpView.isHidden = false
      
      self?.view.removeFromSuperview()
    }
    
    cell.subscribeButtonAction = handler
    
    return cell
  }
}

// MARK: 서치바 델리게이트

extension SearchViewController: UISearchBarDelegate {
  /*
   *  서치바 엔터 누르면 발생하는 함수
   */
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    loadingIndicator.isHidden = false
    
    guard let name = searchBar.text else { return }
    searchStores(for: name)
    self.view.endEditing(true)
  }
  
  /*
  *  서치바 글씨 변화에 대응하는 함수
  */
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    if searchText == "" {
      searchBar.text = ""
      searchBar.resignFirstResponder()
      stores = []
      tableView.reloadData()
      self.view.endEditing(true)
    }
  }
}

// MARK: 네트워킹함수

extension SearchViewController {
  /*
  * 한글이 들어가는 URL처리하는 함수
  */
  private func generateURL(string: String) -> String {
    guard let encodedString = string.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
      return ""
    }
    return encodedString
  }
  
  /*
  * 가맹점 검색하는 함수 (상호명에 따라)
  */
  private func searchStores(for name: String) {
    let urlString = "https://openapi.gg.go.kr/RegionMnyFacltStus?KEY=\(KKD_APIKey)&TYPE=json&pSize=\(numberOfData)&CMPNM_NM=\(name)"
    
    let url = generateURL(string: urlString)
    
    AF.request(url)
      .validate()
      .responseDecodable(of: StoreRoot.self) { response in
        guard let root = response.value else {
          print("[GG API]데이터를 불러올수 없습니다.: \(response)")
          print("[GG API]실패파라미터: \(name)")
          self.loadingIndicator.isHidden = true
          return
        }
        
        guard let head = root.RegionMnyFacltStus[0].head else {
          print("[GG API]요청 해더 디코딩에 실패했습니다.")
          return
        }
        
        guard let count = head[0].count else {
          print("[GG API]불러온 가맹점 카운팅에 실패했습니다.")
          return
        }
        
        guard let stores = root.RegionMnyFacltStus[1].row else {
          print("[GG API]가맹점 정보를 불러오는데 실패했습니다.")
          return
        }
        
        print("[GG API] 가게 이름 \(name)에 대한 \(count)개의 가맹점 정보를 불러오는데 성공했습니다.")
        
        self.stores = stores
        
        self.tableView.reloadData()
        self.loadingIndicator.isHidden = true
    }
  }
}

