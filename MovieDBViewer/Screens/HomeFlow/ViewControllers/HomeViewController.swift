//
//  HomeViewController.swift
//  MovieDBViewer
//
//  Created by admin on 21/10/24.
//

import Foundation
import UIKit
import DynamicButtonFramework
import NormalFrameworkOverlay

class HomeViewController: UIViewController {
	
	let openMovieDBButton = CustomButton(style: .blue, title: "Show Nowplaying")
	let showOverlayButton = CustomButton(style: .white, title: "Show overlay")
	
	let viewModel: MainViewModel
	var onNavigationEvent: ((MainCoordinator.NavigationEvent)->Void)?
	
	init(viewModel: MainViewModel, onNavigationEvent: ((MainCoordinator.NavigationEvent)->Void)?) {
		
		self.viewModel = viewModel
		self.onNavigationEvent = onNavigationEvent
		
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = "Home"
		configureContent()

	}
	
	private func configureContent() {
		configurViews()
		view.backgroundColor = .lightGray
	}
	
	private func configurViews() {
		
		view.addSubview(openMovieDBButton)

		openMovieDBButton.translatesAutoresizingMaskIntoConstraints = false
		
		openMovieDBButton.didTap = { [weak self] in
			self?.onNavigationEvent?(.openMovieList)
		}

		NSLayoutConstraint.activate([
			openMovieDBButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			openMovieDBButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
			openMovieDBButton.widthAnchor.constraint(equalToConstant: 150),
			openMovieDBButton.heightAnchor.constraint(equalToConstant: 60)
		])
		
		view.addSubview(showOverlayButton)
		
		showOverlayButton.translatesAutoresizingMaskIntoConstraints = false
		
		showOverlayButton.didTap = { [weak self] in
			self?.showOverlay()
		}

		NSLayoutConstraint.activate([
			showOverlayButton.topAnchor.constraint(equalTo: openMovieDBButton.bottomAnchor, constant: 20),
			showOverlayButton.leadingAnchor.constraint(equalTo: openMovieDBButton.leadingAnchor),
			showOverlayButton.widthAnchor.constraint(equalToConstant: 150),
			showOverlayButton.heightAnchor.constraint(equalToConstant: 60)
		])
				
	}
	
	@objc func showOverlay() {
		let vc = OverlayViewController()
		
		vc.showPopup(on: self, title: "test", subTitle: "abcdefghijklmnopqrestuvwxyz", image: nil, primaryButtonTitle: "button1", secondaryButtonTitle: nil)
	}
	
	private func getimageFromCache(movieID: String) -> UIImage? {

//		guard let imagePath = NetworkManager.shared.movieIDCache[movieID] else {
//			return UIImage(named: "tmdb-logo")
//		}
//		
//		let cacheKey = NSString(string: "https://image.tmdb.org/t/p/original\(imagePath)")
//
//		guard let image = NetworkManager.shared.imageCache.object(forKey: cacheKey) else {
//			return UIImage(named: "tmdb-logo")
//		}
		
		return UIImage(named: "tmdb-logo")

		
	}

}
