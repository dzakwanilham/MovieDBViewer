//
//  MovieListViewModel.swift
//  MovieDBViewer
//
//  Created by admin on 21/10/24.
//

import Foundation

class MovieListViewModel {
	
	var presentErrorAlert: ((_: String) -> ())?
	var onNeedToUpdateData: (() -> ())?
	var presentEmptyState: ((String) -> ())?

	var page: Int = 1
	var movies: [Movie]? = []
	var filteredmovies: [Movie]? = []
	var hasMoreMovie: Bool = true
	var perPage: Int = 20
	var counterA: Int = 0
	
	init() {
	}
	
	func fetchMovies() {
		NetworkManager.shared.getMovie(for: .english, page: page) { result in
			
			switch result {
				case.success(let responseMovies):
					
					self.movies?.append(contentsOf: responseMovies)

					if (self.movies == nil) {
						DispatchQueue.main.async {
							self.presentEmptyState?("empty state")
						}
						return
					}
					
					self.onNeedToUpdateData?()
					
				case.failure(let error):
					
					self.presentErrorAlert?(error.rawValue)
			}
		}
		
	}
}
