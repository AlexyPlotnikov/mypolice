
import UIKit
import CoreLocation
import UserNotifications

struct Shop {
    
//    private let lanta_center = CLLocation(latitude: CLLocationDegrees(exactly: 55.02202617458976)!, longitude: CLLocationDegrees(exactly: 82.93102727220459)!)
    private let aura = CLLocation(latitude: CLLocationDegrees(exactly: 55.028244)!, longitude: CLLocationDegrees(exactly: 82.937937)!)
//    private let sib_moll = CLLocation(latitude: CLLocationDegrees(exactly: 55.038893)!, longitude: CLLocationDegrees(exactly: 82.959695)!)
    private let royal_park = CLLocation(latitude: CLLocationDegrees(exactly: 55.055873)!, longitude: CLLocationDegrees(exactly: 82.912896)!)
    private let gallery = CLLocation(latitude: CLLocationDegrees(exactly: 55.042939)!, longitude: CLLocationDegrees(exactly: 82.921592)!)
    private let san_city = CLLocation(latitude: CLLocationDegrees(exactly: 54.979806)!, longitude: CLLocationDegrees(exactly: 82.898278)!)
    
    var nameShop = ""
    var position = CLLocation()
    var description = ""
    var timeParking : Date?
    private var id : NameBigShop?
    
    enum NameBigShop {
        case Aura
        case Gallery
//        case Sibirskiy_Moll
        case Royal_Park
//        case Lanta_Canter
        case San_City
        case None
    }
    
    func getIdObject() -> NameBigShop {
        return id ?? NameBigShop.None
    }
    
    init(name: NameBigShop) {
        self.id = name
        
        switch name {
        case .Aura:
            self.nameShop = "Вы находитель рядом с ТЦ Аура"
            self.description = "Бесплатная парковка 3 часа"
            self.timeParking = Calendar.current.date(bySettingHour: 3, minute: 0, second: 0, of: Date())!
            self.position = aura
            
        case .Gallery:
            self.nameShop = "Вы находитель рядом с ТЦ Галерея"
            self.description = "Бесплатная парковка 2 часа"
            self.timeParking = Calendar.current.date(bySettingHour: 2, minute: 0, second: 0, of: Date())!
            self.position = gallery
            
        case .Royal_Park:
            self.nameShop = "Вы находитель рядом с ТЦ Ройал Парк"
            self.description = "Бесплатная парковка 3 часа"
            self.timeParking = Calendar.current.date(bySettingHour: 3, minute: 0, second: 0, of: Date())!
            self.position = royal_park
            
        case .San_City:
            self.nameShop = "Вы находитель рядом с ТЦ Сан Сити"
            self.description = "Бесплатная парковка 2 часа"
            self.timeParking = Calendar.current.date(bySettingHour: 2, minute: 0, second: 0, of: Date())!
            self.position = san_city
            
        case .None:
            break
        }
    }
}

protocol DelegateSetTimer: NSObject {
    func setAutoTimer(shop:Shop?)
}

final class LocationService: NSObject, CLLocationManagerDelegate, UNUserNotificationCenterDelegate {
    private let locationManager = CLLocationManager()
//    private let motionManager = CMMotionActivityManager()
    
    var lastLocation: CLLocation?
    weak var delegate: DelegateSetTimer?
    var currentShop: Shop?
    
    override init() {
        super.init()
        configurate()
        
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert,.sound,.badge],
            completionHandler: { (granted,error) in
                print(granted)
        })
    }
    
    private func configurate() {
        locationManager.delegate = self
        UNUserNotificationCenter.current().delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.startMonitoringSignificantLocationChanges()
    }
    
    
    func requestPermission() {
        locationManager.requestAlwaysAuthorization()
    }
    
    func start() {
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
    }
    
    
    

    private var besideShop: Shop? {
        for shop in [Shop(name: .Aura), Shop(name: .Gallery), Shop(name: .Royal_Park), Shop(name: .San_City)] {
                        let distance: CLLocationDistance = locationManager.location?.distance(from:shop.position) ?? 0.0
                        if distance <= 50 {
                            return shop
                        }
        }
        return nil
    }
    
    
    // делегат перехода в приложение через натификацию "Установка таймера"
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.notification.request.identifier == "timer" {
            if let deleg = delegate {
                deleg.setAutoTimer(shop: besideShop)
            }
        }
        completionHandler()
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if  self.besideShop != nil &&
            self.besideShop?.getIdObject() != self.currentShop?.getIdObject() &&
            self.besideShop?.getIdObject() != .None &&
            UIApplication.shared.applicationState == .background {
            
            let content = UNMutableNotificationContent()
            content.title = self.besideShop!.nameShop
            content.subtitle = self.besideShop!.description
            content.launchImageName = "timer"
            content.body = ""//"Для установки таймера нажмите на уведомление"
            content.sound = .default
            
            //Set the trigger of the notification -- here a timer.
            //                                                    let trigger = UNTimeIntervalNotificationTrigger (
            //                                                        timeInterval: 60,
            //                                                        repeats: false)
            //Set the request for the notification from the above
            let request = UNNotificationRequest (
                identifier: "timer",
                content: content,
                trigger: nil
            )
            
            self.currentShop = self.besideShop
            //Add the notification to the currnet notification center
            UNUserNotificationCenter.current().add(request) { (error) in
                if error == nil {
                    
                }
            }
        }
    }

}
