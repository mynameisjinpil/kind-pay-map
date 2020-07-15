//
//  ViewController.swift
//  RedStore
//
//  Created by yujinpil on 2020/05/09.
//  Copyright © 2020 jinpil. All rights reserved.
//

import UIKit
import NMapsMap
import Alamofire
import RxSwift
import RxCocoa

// 경기도 공공데이터 포털 API 기본 변수
public let KKD_APIKey = "f526eed61def4183a7981d7f6081fd35"
public let defualtDataType = "json"
public let numberOfData = 1000

// default location
private var defaultLocation: CLLocation = CLLocation(latitude: 37.579509,
                                                     longitude: 126.977034) // 경복궁


class MapViewController: UIViewController {
  
  // MARK: Variables

  // stream이 중단될 때 버리는 곳.
  var disposeBag = DisposeBag()
  
  // 서치바를 누르면 나오는 검색창 화면
  private var searchViewController: SearchViewController?
  
  // 지도 뷰
  var mapView: NMFMapView?
  
  // 현재위치를 불러올 때 사용할 Core Location객체
  private var locationManager: CLLocationManager!
  private var defaultZoom: Double = 15.0
  
  // 모델
  private let user: User = User()
  
  private let map: Map = Map()
  
  private var storesObjectArray: [StoresObject] = []
  private let camera: Camera = Camera()
  private var currentTown = ""
  private var currentAddress: Address = Address()
  
  // 마커
  var storeMarkers: [NMFMarker] = []
  
  // 지도 추가기능 뷰 변수들
  @IBOutlet weak var currentLocationButton: ShadingButton!
  @IBOutlet weak var zoomInButton: ShadingButton!
  @IBOutlet weak var zoomOutButton: ShadingButton!
  @IBOutlet weak var centerImage: UIImageView!
  @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
  
  // pop up 뷰 변수들
  @IBOutlet weak var popUpView: RoundingShadingView!
  @IBOutlet weak var popUpTitle: UILabel!
  @IBOutlet weak var popUpIndus: UILabel!
  @IBOutlet weak var popUpTelNumber: UILabel!
  @IBOutlet weak var popUpAddress: UILabel!
  
  // 검색 뷰 변수
  @IBOutlet weak var searchBar: UISearchBar!
  var infoWindow = NMFInfoWindow()
  
  // MARK: 생명주기
  
  override func viewDidLoad() {
    super.viewDidLoad()
    centerImage.isHidden = true
    popUpView.isHidden = true
    searchBar.delegate = self

    initViewController()
  }
  
  // MARK: 초기화 함수
  /*
   * 뷰컨트롤러 초기화함수
   */
  private func initViewController() {
    initLocationManager()
    setButton()
    initMapView()
    initLocationOverlay()
  }
  
  /*
   * 로케이션 메니져 초기화
   */
  private func initLocationManager() {
    locationManager = CLLocationManager()
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.requestAlwaysAuthorization()
    locationManager.distanceFilter = 50
    locationManager.startUpdatingLocation()
    locationManager.delegate = self
    
    print("[App] 로케이션 메니져 설정 완료")
  }
  
  /*
   * 버튼 셋 함수
   */
  private func setButton() {
    let distance: CGFloat = 80.0
    let x = self.view.frame.width - distance
    let y = self.view.frame.height
    self.currentLocationButton.frame.origin = CGPoint(x: x, y: y - distance)
    self.zoomOutButton.frame.origin = CGPoint(x: x, y: y - (2 * distance))
    self.zoomInButton.frame.origin = CGPoint(x: x, y: y - (3 * distance))
    
    print("[App] 버튼 설정 완료")
  }
  
  /*
   * 맵 뷰 초기화
   */
  private func initMapView() {
    // 맵뷰 속성 초기화
    let mapView = NMFMapView(frame: view.frame)
    mapView.positionMode = .normal
    mapView.addCameraDelegate(delegate: self)
    mapView.maxZoomLevel = 18.0
    mapView.minZoomLevel = 8.0
    mapView.touchDelegate = self
    
    view.addSubview(mapView)
    
    self.mapView = mapView
    self.view.sendSubviewToBack(self.mapView!)
    
    print("[App] 맵뷰 설정 완료")
  }
  
  /*
   *
   */
  private func initLocationOverlay() {
    guard let mapView = mapView else {
      print("[App] 맵뷰가 아직 설정되지 않았습니다.")
      return
    }
    
    let locationOverlay = mapView.locationOverlay
    locationOverlay.hidden = false
    locationOverlay.location = self.user.location
    locationOverlay.heading = 90
    locationOverlay.icon = NMFOverlayImage(name: "baseline_navigation_black_24pt")
    
    print("[App] 로케이션 오버레이 설정 완료")
  }
  
  /*
   * 맵뷰에 핀을 찍어주는 함수
   */
  func setMarkers(_ stores: [Store]) {
    // 핀을 새롭게 찍을 때 기존의 핀 모두 제거
    resetMarkers(markers: &storeMarkers)
    
    for store in stores {
      // 마커의 최소 조건을 통과하면 지도에 Marker로 표시
      guard let latitude = store.latitude else { continue }
      guard let longitude = store.longitude else { continue }
      guard let name = store.name else { continue }
      
      // 인포 윈도우에 보여줄 스트링 데이터
      var infoBody = name
      if let newAddress = store.newAddress { infoBody += "\n\(newAddress)" }
      if let telNumber = store.telNumber { infoBody += "\n\(telNumber)" }
      
      // 마커 초기화
      let location = NMGLatLng(lat: Double(latitude)!, lng: Double(longitude)!)
      let marker = initMarker(location: location, store)
      marker.mapView = self.mapView
      
      // 마커 관리를 위해 저장
      self.storeMarkers.append(marker)
    }
    print("[UI] \(storeMarkers.count)개의 마커를 성공적으로 추가했습니다.")
    
    // 마커 설정이 끝나면 로딩 뷰 숨김
    self.loadingIndicator.isHidden = true
  }
  
  /*
   * 마커 설정하는 함수
   */
  private func initMarker(location: NMGLatLng, _ info: Store) -> NMFMarker {
    // 마커를 터치했을 때 로직
    let handler: NMFOverlayTouchHandler = { [weak self] (overlay) -> Bool in
      
      self?.popUpView.isHidden = false
      
      // 우선 마커를 중심으로 이동
      self?.camera.location =  NMGLatLng(lat: location.lat, lng: location.lng)
      let newCamera = NMFCameraUpdate(scrollTo: location, zoomTo: 25.0)
      self?.mapView!.moveCamera(newCamera)
      
      // 인포윈도우에 들어갈 데이터
      if let name = info.name {
        self?.popUpTitle.text = name
      }
      else {
        self?.popUpTitle.text = "상호명 정보 없음"
      }
      
      if let industType = info.industType {
        self?.popUpIndus.text = industType
      }
      else {
        self?.popUpIndus.text = "업종 정보 없음"
      }
      
      if let adress = info.oldAddress {
        self?.popUpAddress.text = adress
      }
      else {
        self?.popUpAddress.text = "주소정보 정보 없음"
      }
      
      if let telNumber = info.telNumber {
        self?.popUpTelNumber.text = telNumber
      }
      else {
        self?.popUpTelNumber.text = "번호 정보 없음"
      }
      
      return true
    };
    
    // 마커 프로퍼티 설정
    let marker = NMFMarker()
    marker.position = location
    marker.iconTintColor = UIColor(red: 237/255, green: 40/255, blue: 54/255, alpha: 1.0)
    marker.iconImage = NMFOverlayImage(image: UIImage(named: "baseline_place_black_48pt")!)
    marker.isHideCollidedMarkers = false
    marker.touchHandler = handler
    
    return marker
  }
  
  /*
   * 핀을 초기화해주는 함수
   */
  func resetMarkers(markers: inout [NMFMarker]) {
    for marker in markers {
      marker.mapView = nil
    }
    markers.removeAll()
  }
  
  // MARK: UI Function
  
  @IBAction func zoomIn(_ sender: Any) {
    guard let currentZoom = mapView?.zoomLevel else {
      print("[NAVER API] 현재 줌 레벨을 가져올 수 없습니다.")
      return
    }
    
    if currentZoom < 18 {
      let cameraUpdate = NMFCameraUpdate(zoomTo: currentZoom + 1.0)
      self.mapView?.moveCamera(cameraUpdate)
    }
    else {
      print("Zoom level reach to max.")
    }
  }
  
  @IBAction func zoomOut(_ sender: Any) {
    guard let currentZoom = mapView?.zoomLevel else {
      print("[NAVER API] 현재 줌 레벨을 가져올 수 없습니다.")
      return
    }
    
    if currentZoom > 8 {
      if currentZoom < 12{
        print("[NAVER API] 줌아웃으로 인한 마커 초기화")
        resetMarkers(markers: &storeMarkers)
      }
      let cameraUpdate = NMFCameraUpdate(zoomTo: currentZoom - 1.0)
      self.mapView?.moveCamera(cameraUpdate)
    }
    else {
      print("Zoom level reach to min.")
    }
  }
  
  @IBAction func moveToCurrentLocation(_ sender: Any) {
    var location = mapView?.cameraPosition.target
    let cameraUpdate = NMFCameraUpdate(scrollTo: self.user.location, zoomTo: 17)
    self.mapView?.moveCamera(cameraUpdate)
  }
  
  @IBAction func confirm(_ sender: Any) {
    self.popUpView.isHidden = true
  }
}

// MARK:- 데이터를 가져오는 함수

extension MapViewController {
  /*
   * 이전에 추가된 request cancel
   */
  private func killAllRequest() {
    DispatchQueue.global().sync {
      
      AF.session.getAllTasks { (tasks) in
        tasks.forEach{ $0.cancel() }
      }
    }
  }
  
  /*
   * URL에 한글이 들어있는 경우 이를 처리해주는 함수
   */
  private func generateURL(string: String) -> String {
    guard let encodedString = string.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
      return ""
    }
    return encodedString
  }
  
  /*
   * Reverse Geocoding 함수
   */
  private func doReverseGeocoding(lat: Double, lng: Double, completionHandler: @escaping (Bool, Address?, String?) -> Void) {
    let id = HTTPHeader(name: "X-NCP-APIGW-API-KEY-ID", value:"sb10h4g44n")
    let key = HTTPHeader(name: "X-NCP-APIGW-API-KEY", value:"Czs7ZzPQHmgvPg0Y2cfMQEjxNg2WgOUB9LgS2uno")
    let headers: HTTPHeaders = HTTPHeaders([id, key])
    let urlString = "https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc?request=coordsToaddr&coords=\(lng),\(lat)&sourcecrs=epsg:4326&output=json&orders=admcode,addr"
    
    guard let url = URL(string: generateURL(string: urlString)) else {
      return
    }
    
    AF.request(url, method: .get, headers: headers)
      .validate()
      .responseDecodable(of: NaverRoot.self) { (response) in
        guard let root = response.value else {
          completionHandler(false, nil, "[NAVER API] 리버스 지오코딩 정보를 불러올 수 없습니다. : \(response)")
          self.camera.setAddress(address: Address())
          return
        }
        
        if root.status.code == 3 {
          completionHandler(false, nil, "[NAVER API] 상세 주소 불러오기에 실패했습니다.")
          return
        }
        
        let region: Geo
        let landNumber: Land?
        
        // addr로 인한 호출이 정상적으로 이뤄지지않을때가 있음.
        if root.results.count == 2 {
          region = root.results[1].region
          landNumber = root.results[1].land
          self.currentAddress.setAddress(region: region, landNumber: landNumber)
        }
        else {
          region = root.results[0].region
          self.currentAddress.setAddress(region: region, landNumber: nil)
          
        }
        
        if self.camera.address.full == self.currentAddress.full {
          // 만약 아전 위치와 같다면 컴플리션 핸들러 호출 안함
          completionHandler(false, nil, nil)
        }
        else {
          // 이전 위치와 다르다면 카메라 위치를 바꾸고 컴플리션 핸들러 호출
          self.camera.setAddress(address: self.currentAddress)
          completionHandler(true, self.currentAddress, "[NAVER API] 리버스 지오코딩 성공")
        }
    }
  }
  
  /*
   * 가멩점 정보 불러오는 함수, 캐싱되어있는 정보가 없으면 호출.
   */
  private func fetchStores(key: Address, location: CLLocation ) {
    self.loadingIndicator.isHidden = false
    
    let startTime = CFAbsoluteTimeGetCurrent()
    
    let urlString = "https://openapi.gg.go.kr/RegionMnyFacltStus?KEY=\(KKD_APIKey)&TYPE=json&pSize=\(numberOfData)&REFINE_LOTNO_ADDR=\(key.fetchingKey)"
    let url = generateURL(string: urlString)
    
    killAllRequest()
        
    
    AF.request(url)
      .validate()
      .responseDecodable(of: StoreRoot.self) { (response) in
        print("run time: \(CFAbsoluteTimeGetCurrent() - startTime)")
        guard let root = response.value else {
          print("[GG API]데이터를 불러올수 없습니다.: \(response)")
          print("[GG API]실패파라미터: \(key.fetchingKey)")
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
        
        print("[GG API] \(key.fetchingKey)지역에 대한 \(count)개의 가맹점 정보를 불러오는데 성공했습니다.")
        
        // 캐싱을 위해 클래스에 따로 저장.
        
        let storesObject = StoresObject()
        storesObject.stores = stores
        self.storesObjectArray.append(storesObject)
        
        self.map.storeCache.setObject(storesObject, forKey: key.cachingKey)
        let filteredStores = self.map.findNearbyStore(key.cachingKey)
        // 마커 설정
        self.setMarkers(filteredStores)
    }
  }
  
  /*
   *  위치 기반 가맹점 검색 함수
   */
  private func findStoreFollowCameraCoord(location: CLLocation) {
    doReverseGeocoding(lat: location.coordinate.latitude, lng: location.coordinate.longitude) { (isSuccess, address, message) in
      guard let message = message else { return }
      print(message)
      
      // 지오코딩 결과로 true반환시
      if isSuccess {
        guard let address = address else { return }
        
        // 해당 키로 캐시가 저장되어있는 경우
        if let storeCachedData = self.map.storeCache.object(forKey: address.cachingKey as NSString) {
          print("[GG API] 캐시에서 \(address.fetchingKey)지역에 대한 \(storeCachedData.stores.count)개의 가맹점 정보를 불러오는데 성공했습니다.")
          
          let filteredStores = self.map.findNearbyStore(address.cachingKey)
          // 캐싱된 결과로 마커 추가
          self.setMarkers(filteredStores)
        }
        else {
          // 캐시에 저장되어 있지 않은 경우 패치 진행
          self.fetchStores(key: address, location: location)
        }
      }
    }
  }

}

// MARK:- 맵뷰를 컨트롤할 때 호출되는 델리게이트

extension MapViewController: NMFMapViewTouchDelegate {
  func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
    infoWindow.close()
  }
}

// MARK:- 맵뷰의 카메라를 컨트롤할 때 마다 상황에 따라 호출되는 이벤트 델리게이트

extension MapViewController: NMFMapViewCameraDelegate {
  /*
   * 카메라가 움직일 때 호출되는 함수
   */
  func mapView(_ mapView: NMFMapView, cameraWillChangeByReason reason: Int, animated: Bool) {
    centerImage.isHidden = false
    self.camera.location = mapView.cameraPosition.target
    self.map.centerPoint = self.camera.location
  }
  
  /*
   * 카메라 움직임이 멈추면 호출되는 함수
   */
  func  mapViewCameraIdle(_ mapView: NMFMapView) {
    if mapView.cameraPosition.zoom > 10 {
      centerImage.isHidden = true
      let location = mapView.cameraPosition.target
      self.map.centerPoint = location
      findStoreFollowCameraCoord(location: CLLocation(latitude: location.lat, longitude: location.lng))
    }
    else {
      print("도시간 이동중")
    }
  }
}

// MARK:- 현재위치를 불러올 때 상황에따라 호출되는 델리게이트

extension MapViewController: CLLocationManagerDelegate {
  /*
   * 현재 위치를 읽어올 때 실행되는 함수.
   */
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    let location: CLLocation = locations.last!
    
    guard let mapView = self.mapView else { return }
    
    self.user.location =  NMGLatLng(lat: location.coordinate.latitude, lng: location.coordinate.longitude)
    
    let newCamera = NMFCameraUpdate(scrollTo: user.location, zoomTo: camera.zoom)
    mapView.moveCamera(newCamera)
    mapView
  }
  
  /*
   * 로케이션 접근 권한 처리 함수.
   */
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    switch status {
    case .restricted:
      print("Location access was restricted.")
    case .denied:
      print("User denied access to location.")
    // Display the map using the default location.
    case .notDetermined:
      print("Location status not determined.")
    case .authorizedAlways: fallthrough
    case .authorizedWhenInUse:
      print("Location status is OK.")
    @unknown default:
      fatalError()
    }
  }
  
  /*
   *
   */
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    manager.stopUpdatingLocation()
    print("Error: \(error)")
  }
}

// MARK:- 검색시에 호출되는 델리게이트

extension MapViewController: UISearchBarDelegate {

  /*
   * 서치바가 에디팅에 시작하면 실행되는 함수
   */
  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    let vc = mainStoryBoard.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
    
    // 데이터 주고받기위해 컨트롤러 주소 저장
    vc.mapViewController = self
    
    // ARC때문에 객체 참조해줘야함.
    self.searchViewController = vc

    // non modally하게 넣기 위해서 서브뷰로
    self.view.addSubview(vc.view)
  }
}

// MARK: 그외에 필요한 함수

extension MapViewController {
  
}
