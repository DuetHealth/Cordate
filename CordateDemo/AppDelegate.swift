//
//  AppDelegate.swift
//  JidaiDemo
//
//  Created by James Power on 11/20/17.
//  Copyright © 2017 Duet Health. All rights reserved.
//

import Cordate
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow()

        let vc = ViewController()
        let nav = UINavigationController(rootViewController: ViewController())
        vc.navigationItem.title = NSLocalizedString("Demo", comment: "")
        window.rootViewController = nav

        self.window = window
        window.makeKeyAndVisible()
        return true
    }

}

