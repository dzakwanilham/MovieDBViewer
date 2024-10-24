//
//  DzCollectionCellView.swift
//  MovieDBViewer
//
//  Created by admin on 21/10/24.
//

import Foundation
import UIKit

class DzCollectionCellView: UICollectionViewCell {
	
	static let reuseID = "MovieCell"
	
	let movieImage = DzAvatarImageView(frame: .zero)
	let movieTitle = DzTitleLabel(textAlignment: .center, fontSize: 16.0)
	
	private let padding: CGFloat = 8.0
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		configureImageView()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func set(movie: Movie){
		movieTitle.text = movie.title
		movieImage.fetchImage(from: "\(movie.id)")
		
	}
	
	private func configureImageView() {
		
		addSubview(movieImage)
		NSLayoutConstraint.activate([
			movieImage.topAnchor.constraint(equalTo: topAnchor, constant: padding),
			movieImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
			movieImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
			movieImage.heightAnchor.constraint(equalTo: movieImage.widthAnchor),
		])
		
		addSubview(movieTitle)
		NSLayoutConstraint.activate([
			movieTitle.topAnchor.constraint(equalTo: movieImage.bottomAnchor, constant: 12),
			movieTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
			movieTitle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
			movieTitle.heightAnchor.constraint(equalToConstant: 20)
		])
		
		translatesAutoresizingMaskIntoConstraints = false

	}
	
}
