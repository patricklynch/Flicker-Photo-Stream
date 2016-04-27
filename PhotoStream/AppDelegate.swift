//
//  AppDelegate.swift
//  PhotoStream
//
//  Created by Patrick Lynch on 4/27/16.
//  Copyright © 2016 lynchdev. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var persistentStore: PersistentStoreType = ApplicationPersistentStore()

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        savePersistentStore()
    }

    func applicationDidEnterBackground(application: UIApplication) {
        savePersistentStore()
    }

    func applicationWillEnterForeground(application: UIApplication) {
    }

    func applicationDidBecomeActive(application: UIApplication) {
    }

    func applicationWillTerminate(application: UIApplication) {
        savePersistentStore()
    }

    private func savePersistentStore() {
        persistentStore.mainContext.ext_performBlockAndWait() { context in
            context.ext_save()
        }
    }
}

