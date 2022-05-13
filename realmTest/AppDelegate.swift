//
//  AppDelegate.swift
//  realmTest
//

import UIKit
import RealmSwift
import FirebaseCore
import GoogleMobileAds


let bannerTestCode = "ca-app-pub-3940256099942544/2934735716" //テスト
let bannerCode = "ca-app-pub-9107991111278719~9091152654"   //本番用
let videoTestCode = "ca-app-pub-3940256099942544/1712485313"  //テスト
let videoCode = "ca-app-pub-9107991111278719/3318831666"    //本番用

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // マイグレーション処理
        migration()
        FirebaseApp.configure()
        FirestoreExtention.PremiumSubscription(ProductID: "test", Expired: Date(), items: "test1") { success in
            print(success, "testSubsc")
        }
        
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [ "5F1608BF-0233-4AE8-AE93-1A9B7C6ADA01" ]   //本番あげるときに消す
        //Google広告
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        return true
      }

      // Realmマイグレーション処理
      func migration() {
        // 次のバージョン（現バージョンが０なので、１をセット）
        let nextSchemaVersion = 14

        // マイグレーション設定
        let config = Realm.Configuration(
          schemaVersion: UInt64(nextSchemaVersion),
          migrationBlock: { migration, oldSchemaVersion in
            if (oldSchemaVersion < nextSchemaVersion) {
            }
          })
          Realm.Configuration.defaultConfiguration = config
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    /*
    // Realmマイグレーション処理
    func migration() {
      // 次のバージョン（現バージョンが０なので、１をセット）
      let nextSchemaVersion = 1

      // マイグレーション設定
      let config = Realm.Configuration(
        schemaVersion: UInt64(nextSchemaVersion),
        migrationBlock: { migration, oldSchemaVersion in
          if (oldSchemaVersion < nextSchemaVersion) {
          }
        })
        Realm.Configuration.defaultConfiguration = config
    }
 */
    


}

