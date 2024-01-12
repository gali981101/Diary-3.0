//
//  AppDelegate.swift
//  Diary
//
//  Created by Terry Jason on 2023/12/21.
//

import UIKit
import CoreData
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        
        UITabBar.appearance().tintColor = .systemMint
        UITabBar.appearance().standardAppearance = tabBarAppearance
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            granted ? print("User notifications are allowed") : print("User notifications are not allowed")
        }
        
        return true
        
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let directoryUrls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let applicationDocumentDirectory = directoryUrls[0]
        let storeUrl = applicationDocumentDirectory.appendingPathComponent("Diary.sqlite")
        
        if !FileManager.default.fileExists(atPath: storeUrl.path) {
            
            let sourceSqliteURLs = [
                Bundle.main.url(forResource: "Diary" , withExtension: "sqlite")!,
                Bundle.main.url(forResource: "Diary", withExtension: "sqlite-wal")!,
                Bundle.main.url(forResource: "Diary", withExtension: "sqlite-shm")!
            ]
            
            let destSqliteURLs = [
                applicationDocumentDirectory.appendingPathComponent("Diary.sqlite"),
                applicationDocumentDirectory.appendingPathComponent("Diary.sqlite-wal"),
                applicationDocumentDirectory.appendingPathComponent("Diary.sqlite-shm")
            ]
            
            for i in 0..<sourceSqliteURLs.count {
                do {
                    try FileManager.default.copyItem(at: sourceSqliteURLs[i], to: destSqliteURLs[i])
                } catch {
                    print(error)
                }
            }
            
        }
        
        let description = NSPersistentStoreDescription()
        description.url = storeUrl
        
        let container = NSPersistentContainer(name: "Diary")
        container.persistentStoreDescriptions = [description]
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        return container
        
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}




