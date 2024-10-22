//
//  HomeViewController.swift
//  MovieDBViewer
//
//  Created by admin on 21/10/24.
//

import Foundation
import UIKit

class HomeViewController: UIViewController {
	
	let openMovieDBButton = CustomButton(style: .blue, title: "Show Nowplaying")
	let showOverlayButton = CustomButton(style: .white, title: "Show overlay")
	
	
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
			self?.openMovieDB()
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
	
	func openMovieDB() {
		
		let vm = MovieListViewModel()
		let vc = MovieListViewController(vm)
		let vc2 = OverlayViewController()
		
		vc.didSelectMovies = { [weak self] movie in
						
			guard let self = self else { return }
			
			let vc = OverlayViewController()
						
			vc.showPopup(on: self, title: movie.title, subTitle: movie.overview, image: getimageFromCache(movieID: "\(movie.id)"), primaryButtonTitle: "Primary Button", secondaryButtonTitle: movie.title.contains("a") ? "Secondary Button" : nil)

		}
		
		self.navigationController?.pushViewController(vc, animated: true)
	}
	
	@objc func showOverlay() {
		let vc = OverlayViewController()
		
		vc.showPopup(on: self, title: "test", subTitle: "abcdefghijklmnopqrestuvwxyz", image: nil, primaryButtonTitle: "button1", secondaryButtonTitle: nil)
	}
	
	private func getimageFromCache(movieID: String) -> UIImage? {

		guard let imagePath = NetworkManager.shared.movieIDCache[movieID] else {
			return UIImage(named: "tmdb-logo")
		}
		
		let cacheKey = NSString(string: "https://image.tmdb.org/t/p/original\(imagePath)")

		guard let image = NetworkManager.shared.imageCache.object(forKey: cacheKey) else {
			return UIImage(named: "tmdb-logo")
		}
		
		return image
		
	}

}
