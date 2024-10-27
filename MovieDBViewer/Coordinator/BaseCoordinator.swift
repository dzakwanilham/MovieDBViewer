//
//  BaseCoordinator.swift
//  MovieDBViewer
//
//  Created by admin on 26/10/24.
//

import Foundation
import UIKit

protocol Coordinator: AnyObject {
	var parentCoordinator: Coordinator? { get set }
	var childCoordinators: [Coordinator] { get set }
	var navigationController: UINavigationController { get set }

	func start()
}

protocol Screen: AnyObject {
	
	func make() -> UIViewController
	
}

class BaseCoordinator: Coordinator {
	
	var parentCoordinator: Coordinator?
	var childCoordinators: [Coordinator] = []
	var navigationController: UINavigationController

	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}
	
	func start() {}
	
	func addChildCoordinator(_ coordinator: Coordinator) {
		childCoordinators.append(coordinator)
	}
	
	func removeChildCoordinator(_ coordinator: Coordinator) {
		childCoordinators = childCoordinators.filter { $0 !== coordinator }
	}
}
