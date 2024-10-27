//
//  MainCoordinator.swift
//  MovieDBViewer
//
//  Created by admin on 26/10/24.
//

import Foundation
import UIKit

class MainCoordinator: BaseCoordinator {
	
	var homeScreen: HomeScreen?
	let mainViewModel: MainViewModel?

	init(
		navigationController : UINavigationController,
		homeScreen: HomeScreen = HomeScreen(),
		mainViewModel: MainViewModel = MainViewModel()
	){
		
		self.homeScreen = homeScreen
		self.mainViewModel = mainViewModel
		
		super.init(navigationController: navigationController)
		
	}

	override func start() {
		showHomeScreen()
	}
	
	private func showHomeScreen() {
		
		guard let homeScreen = homeScreen else { return }
		
		homeScreen.viewModel = mainViewModel
		homeScreen.onNavigationEvent = { [weak self] event in
			switch event {
				case .goToDetails(let movie):
					self?.openMovieDetails(movie: movie)
				case .openMovieList:
					self?.openMovieList()
			}
		}
		
		navigationController.pushViewController(homeScreen.make(), animated: true)
		
	}
	
	func openMovieDetails(movie: Movie) {
		let detailViewModel = DetailViewModel(movie: movie)
		
		let detailViewController = DetailMovieViewController(viewModel: detailViewModel)
				
		navigationController.pushViewController(detailViewController, animated: true)
		
	}
	
	func openMovieList() {
		let movieListViewModel = MovieListViewModel()
		let movieListViewController = MovieListViewController(movieListViewModel)
		
		movieListViewController.didSelectMovies = { [weak self] movie in
						
			guard let self = self else { return }
			
			self.openMovieDetails(movie: movie)
		}
		
		navigationController.pushViewController(movieListViewController, animated: true)
	}
	
	enum NavigationEvent {
		case goToDetails(movie: Movie)
		case openMovieList
	}
}
