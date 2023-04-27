//
//  AppDelegate.swift
//  Non-Persistent E2E Messaging
//
//  Created by Dylan Moran on 1/30/23.
//

import UIKit
import Foundation
import SwiftUI
import CoreData
import BackgroundTasks


@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    let defaults = UserDefaults.standard

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        addObserverForAppStatus()
       // registerBackgroundTask()
        //scheduleBackgroundTask()

        
        return true
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

    func registerBackgroundTask() {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.cipher.app.fetchMessages", using: nil) { task in
            self.handleAppRefreshTask(task: task as! BGAppRefreshTask)
        }
    }
    
    func scheduleBackgroundTask() {
        let request = BGAppRefreshTaskRequest(identifier: "com.cipher.app.fetchMessages")
        request.earliestBeginDate = Date(timeIntervalSinceNow: 60 * 1) // Schedule the task to run in 1 minutes
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Could not schedule the background task: \(error)")
        }
    }

    func handleAppRefreshTask(task: BGAppRefreshTask) {
        // Schedule the next background task before processing the current one
       // scheduleBackgroundTask()
        
        // Connect to the XMPP server to fetch new messages
       //XMPPController.shared.connect()
        
        // Implement a completion handler for your XMPP connection
        // When your connection is done fetching messages, call task.setTaskCompleted(success: true)
        // If there was an error, call task.setTaskCompleted(success: false)
    }

    
    func addObserverForAppStatus() {
        NotificationCenter.default.addObserver(self, selector: #selector(appWillResignActive), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }

    @objc func appWillResignActive() {
        XMPPController.shared.disconnectStream()
    }

    @objc func appDidBecomeActive() {
        
        let isLoggedIn = defaults.bool(forKey: "logged_in")
    
        
        if isLoggedIn {
            print("Delegate connecting")
            XMPPController.shared.connect()
        }
        
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground(_:).
        
        // Disconnect the xmppStream
        XMPPController.shared.disconnectStream()

        // Remove notification observers
        NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)

        // Perform any other cleanup tasks as necessary
    }


    


    
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "MessageData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
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
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }


}

