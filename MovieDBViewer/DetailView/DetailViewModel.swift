//
//  DetailViewModel.swift
//  MovieDBViewer
//
//  Created by admin on 27/10/24.
//

import Foundation
import UIKit

class DetailViewModel {
	
	let movie: Movie?
	var posterImage: UIImage?
	var onNeedToUpdateData: (() -> ())?
	
	init(movie: Movie? = nil) {
		self.movie = movie
		self.fetchPosterImage()
	}
	
	func fetchPosterImage() {
		
		guard let movie = movie else { return }
				
		MovieDBNetworkManager.shared.fetchImageURL(movieID:"\(movie.id)", onComplete: { result in

			switch result {
				case.success(let image):
					self.posterImage = image
					self.onNeedToUpdateData?()

				case.failure(let error):
					self.posterImage = .init(named: "placeholder")
			}
		})
	}
	
}
