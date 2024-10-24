//
//  MovieDBNetworkManager.swift
//  MovieDBViewer
//
//  Created by admin on 24/10/24.
//

import Foundation
import NetworkManagerFramework
import UIKit

enum MovieLanguage: String, Codable {
	case english
	case french
}

class MovieDBNetworkManager {
	
	public static let shared = MovieDBNetworkManager()
	
	private let baseURL = "https://api.themoviedb.org/3/"
	
	private init () {}
	
	func fetchMovies(language: MovieLanguage? = .english, page: Int, onComplete: @escaping (Result<[Movie], InternalErrorCode>) -> Void) {
		
		NetworkManager.shared.request(url: self.makeGetMovieURL(language: .english, page: page), responseType: MovieData.self) { result in
			switch result {
			case .success(let movie):
					onComplete(.success(movie.results))
			case .failure(let error):
					onComplete(.failure(error))
			}
		}
	}
	
	func fetchImageURL(movieID: String, onComplete: @escaping (Result<UIImage,InternalErrorCode>) -> Void) {
		
		NetworkManager.shared.request(url: self.makeGetImageURL(movieID: movieID), responseType: Data.self) { result in
			switch result
			{
				case .success(let imagePathData):
					
					let imagePath = self.processImagePath(data: imagePathData)
					
					self.downloadImage(from: imagePath, onComplete: onComplete)
					
				case .failure(let error):
					onComplete(.failure(error))
			}
		}
		
	}
	
	private func downloadImage(from imagePath: String, onComplete: @escaping (Result<UIImage,InternalErrorCode>) -> Void) {
		
		let baseUrl = "https://image.tmdb.org/t/p/original\(imagePath)"
		
		let cacheKey = NSString(string: baseUrl)
				
		guard let url = URL(string: baseUrl) else {
			onComplete(.failure(.unableToComplete))
			return
		}
		
		NetworkManager.shared.request(url: URLRequest(url: url), responseType: Data.self) { result in
			switch result
			{
				case .success(let imageData):
					
					guard let image = UIImage(data: imageData) else {
						onComplete(.failure(.invalidData))
						return
					}
					
					onComplete(.success(image))
										
				case .failure(let error):
					onComplete(.failure(error))
			}

		}
	}

	private func makeGetMovieURL(language: MovieLanguage, page: Int) -> URLRequest {
		
		let endPoint = baseURL + "movie/now_playing?language=\(language.rawValue)&page=\(page)"
		
		guard let url = URL(string: endPoint) else {
			return URLRequest(url: URL(string: "www.google.com")!)
		}
		
		return addAuthHeader(url: url)
	}
	
	private func makeGetImageURL(movieID: String) -> URLRequest {
		let endPoint = baseURL + "movie/\(movieID)/images"

		guard let url = URL(string: endPoint) else {
			return URLRequest(url: URL(string: "www.google.com")!)
		}
		
		return addAuthHeader(url: url)
	}
	
	private func addAuthHeader(url: URL) -> URLRequest {
		var request = URLRequest(url: url)
		request.httpMethod = "GET"
		request.allHTTPHeaderFields = [
			"accept": "application/json",
			"Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI1ZjkwMTAxMjk5YTc1NTAyZTFlMWE1MDc5N2VkOWViYyIsIm5iZiI6MTcyOTQ4Nzg3MS45Mzk2NTYsInN1YiI6IjY0YjA1ZDIzZTI0YjkzNWIzMWNhN2JlNyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.igWiQei6-Py1w1hfnbXtu2YQIGxoFNVIO8sgDL0A8w4"
		]
		
		return request
	}

}

extension MovieDBNetworkManager {
	
	private func processImagePath(data: Data) -> String {
		do {
			if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
			   let posters = json["posters"] as? [[String: Any]] {
				
				if let imagePath = posters.first(where: { $0["iso_639_1"] as? String == "en" })?["file_path"] as? String {
					return imagePath
				}
			}
		}
		catch {
			print("Error parsing JSON: \(error.localizedDescription)")
		}
		return ""
	}
}
