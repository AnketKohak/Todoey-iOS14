

import UIKit
import CoreData
import RealmSwift
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        print(Realm.Configuration.defaultConfiguration.fileURL)
        
        
        do{
            let realm = try Realm()
            try realm.write {
                
            }
            
        }catch{
            print("error initialising new realm ,\(error)")
        }
        
        
        return true
    }
    
}
