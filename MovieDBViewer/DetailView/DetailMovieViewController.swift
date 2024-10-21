//
//  DetailMovieViewController.swift
//  MovieDBViewer
//
//  Created by admin on 21/10/24.
//

import Foundation
import UIKit

class DetailMovieViewController: UIViewController {
	
	var movie: Movie?

	private let posterImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.contentMode = .scaleAspectFill
		imageView.translatesAutoresizingMaskIntoConstraints = false
		return imageView
	}()
	
	private let titleLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.boldSystemFont(ofSize: 24)
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	private let overviewLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.systemFont(ofSize: 16)
		label.numberOfLines = 0
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		setupViews()
		displayMovieDetails()
	}
	
	private func setupViews() {
		view.addSubview(posterImageView)
		view.addSubview(titleLabel)
		view.addSubview(overviewLabel)
		
		NSLayoutConstraint.activate([
			posterImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
			posterImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			posterImageView.heightAnchor.constraint(equalToConstant: 300),
			posterImageView.widthAnchor.constraint(equalToConstant: 200),
		])
		
		NSLayoutConstraint.activate([
			titleLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 20),
			titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
			titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
		])
		
		NSLayoutConstraint.activate([
			overviewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
			overviewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
			overviewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
		])
	}
	
	private func displayMovieDetails() {
		
		guard let movie = movie else { return }
				
		NetworkManager.shared.fetchImageURL(movieID: "\(movie.id)") { result in

			switch result {
				case .success(let image):
					DispatchQueue.main.async {
						self.posterImageView.image = image
					}
				case .failure:
					self.posterImageView.image = .init(named: "placeholder")
			}
		}
		
		titleLabel.text = movie.title
		overviewLabel.text = movie.overview
	}
}
