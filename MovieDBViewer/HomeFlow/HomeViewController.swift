//
//  HomeViewController.swift
//  MovieDBViewer
//
//  Created by admin on 21/10/24.
//

import Foundation
import UIKit

class HomeViewController: UIViewController {
	
	let openMovieDBButton: UIButton = {
		let button = UIButton()
		button.setTitle("Open MovieDB", for: .normal)
		button.setTitleColor(.white, for: .normal)
		button.backgroundColor = .systemBlue
		button.layer.cornerRadius = 10
		button.addTarget(self, action: #selector(openMovieDB), for: .touchUpInside)
		return button
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = "Home"
		configureContent()

	}
	
	private func configureContent() {
		configurViews()
	}
	
	private func configurViews() {
		
		view.addSubview(openMovieDBButton)
		
		openMovieDBButton.translatesAutoresizingMaskIntoConstraints = false

		let padding: CGFloat = 20

		NSLayoutConstraint.activate([
			openMovieDBButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			openMovieDBButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
			openMovieDBButton.heightAnchor.constraint(equalToConstant: 60)
		])
		
	}
	
	@objc func openMovieDB() {
		
		let vm = MovieListViewModel()
		let vc = MovieListViewController(vm)
		
		self.navigationController?.pushViewController(vc, animated: true)
	}

	
}
