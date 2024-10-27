//
//  AppDelegate.swift
//  MovieDBViewer
//
//  Created by admin on 21/10/24.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
	
	var window: UIWindow?
	var appCoordinator : MainCoordinator?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
				
		window = UIWindow(frame: UIScreen.main.bounds)
		
		let navController = UINavigationController()
		
		appCoordinator = MainCoordinator(navigationController: navController)
		appCoordinator?.start()

		window = UIWindow(frame: UIScreen.main.bounds)
		window?.rootViewController = navController
		window?.makeKeyAndVisible()

		return true
	}

}

