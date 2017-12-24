//
//  AppDelegate.swift
//  Todoey
//
//  Created by Thiago Andrade on 12/22/17.
//  Copyright © 2017 Andrade. All rights reserved.
//

import UIKit

import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
       
        //print(Realm.Configuration.defaultConfiguration.fileURL!)

        do {
            _ = try Realm()
        } catch  {
            print("Error initialising new Realm: \(error)")
        }
        
        return true
    }

    
    // MARK: - Core Data stack
   

}

