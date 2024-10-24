//
//  DzAvatarImageView.swift
//  MovieDBViewer
//
//  Created by admin on 21/10/24.
//

import Foundation
import UIKit

class DzAvatarImageView: UIImageView {
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		self.configureImageView()
	}
	
	override init(image: UIImage?) {
		super.init(image: image)
		self.configureImageView()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func configureImageView() {
		layer.cornerRadius = 10
		clipsToBounds = true
		image = Images.placeholder
		translatesAutoresizingMaskIntoConstraints = false
	}
	
	func fetchImage(from movieID: String) {
				
		MovieDBNetworkManager.shared.fetchImageURL(movieID: movieID, onComplete: { result in

			switch result {
				case.success(let image):
					self.image = image
					
				case.failure(let error):
					self.image = Images.placeholder

			}
		})
	}
}
