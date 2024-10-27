//
//  MovieListViewModel.swift
//  MovieDBViewer
//
//  Created by admin on 21/10/24.
//

import Foundation
import UIKit

class MovieListViewModel {
	
	var presentErrorAlert: ((_: String) -> ())?
	var onNeedToUpdateData: (() -> ())?
	var presentEmptyState: ((String) -> ())?

	var page: Int = 1
	var movies: [Movie] = []
	var filteredmovies: [Movie] = []
	var hasMoreMovie: Bool = true
	var perPage: Int = 20
	var counterA: Int = 0
	
	let imageCache = NSCache<NSString, UIImage>()
	var movieIDCache = [String :String]()
	
	init() {
	}
	
	func fetchMovies() {
		MovieDBNetworkManager.shared.fetchMovies(page: page) { result in
			switch result {
				case .success(let newMovies):
					let uniqueMovies = newMovies.filter { newMovie in
						!self.movies.contains(where: { $0.id == newMovie.id })
					}
					
					self.movies.append(contentsOf: uniqueMovies)
					
					if self.movies.isEmpty {
						DispatchQueue.main.async {
							self.presentEmptyState?("No movies found")
						}
						return
					}
					
					self.onNeedToUpdateData?()
				
				case .failure(let error):
					self.presentErrorAlert?(error.rawValue)
			}
		}
	}

	
}
