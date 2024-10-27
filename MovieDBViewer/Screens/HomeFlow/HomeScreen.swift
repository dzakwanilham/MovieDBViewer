//
//  HomeScreen.swift
//  MovieDBViewer
//
//  Created by admin on 27/10/24.
//

import Foundation
import UIKit

class HomeScreen: Screen {
	
	var onNavigationEvent: ((MainCoordinator.NavigationEvent)->Void)?
	var viewModel : MainViewModel?
	
	init(viewModel: MainViewModel? = MainViewModel(),
		 onNavigationEvent: ((MainCoordinator.NavigationEvent)->Void)? = nil) {
		self.onNavigationEvent = onNavigationEvent
		self.viewModel = viewModel
	}
	
	convenience init() {
		self.init(onNavigationEvent: nil)
	}
	
	func make() -> UIViewController{
				
		guard let viewModel = viewModel else {
			return UIViewController()
		}
		
		let viewController = HomeViewController(viewModel: viewModel,
												onNavigationEvent: onNavigationEvent)
		
		return viewController
	}
	
}
