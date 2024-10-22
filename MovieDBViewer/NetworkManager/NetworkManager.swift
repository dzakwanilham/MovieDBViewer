//
//  NetworkManager.swift
//  MovieDBViewer
//
//  Created by admin on 21/10/24.
//

import Foundation
import UIKit

enum DzError: String, Error {
	case unableToComplete = "Unable to complete your request. Please check your internet connection"
	case invalidResponse = "Invalid response from the server. Please try again"
	case invalidData = "The data received from the server was invalid. Please try again."
	case jsonError = "The data received from the server was corrupt. Please try again."
}

enum DzImageError: String, Error {
	case invalidRequest = "This process created an invalid request. Please try again."
	case failedToGetFilePath = "Unable to find image. Please try again"
	case failedToGetImage = "Unable to find image, Please try again"
	case invalidData = "The data received from the server was invalid. Please try again."
	case jsonError = "The data received from the server was corrupt. Please try again."
}

enum MovieLanguage: String {
	case english = "en-US"
	case french = "fr-FR"
	case spanish = "es-ES"
	case italian = "it-IT"
	case dutch = "nl-NL"
}

class NetworkManager {
	
	static let shared = NetworkManager()
	private let baseURL = "https://api.themoviedb.org/3/"
	let imageCache = NSCache<NSString, UIImage>()
	var movieIDCache = [String :String]()
	
	var movieData: MovieData?
	
	private init(){}
	
	func getMovie(for language: MovieLanguage, page: Int, onComplete: @escaping (Result<[Movie],DzError>) -> Void) {
		
		let endPoint = baseURL + "movie/now_playing?language=\(language.rawValue)&page=\(page)"
		
		guard let url = URL(string: endPoint) else {
			onComplete(.failure(.unableToComplete))
			return
		}
		
		let task = URLSession.shared.dataTask(with: self.prepareURL(url: url)) { data, response, error in
			
			if let _ = error {
				onComplete(.failure(.unableToComplete))
			}
			
			guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
				onComplete(.failure(.invalidResponse))
				return
			}
			
			guard let data = data else {
				onComplete(.failure(.invalidData))
				return
			}
			
			do {
				let decoder = JSONDecoder()
				decoder.keyDecodingStrategy = .convertFromSnakeCase
				
				let decodedMovieData = try? JSONDecoder().decode(MovieData.self, from: data)
				
				self.movieData = decodedMovieData
				
				guard let movieData = self.movieData else {
					onComplete(.failure(.invalidData))
					return
				}
				
				onComplete(.success(movieData.results))
				
			} catch {
				
				onComplete(.failure(.invalidData))
			}
		}
		task.resume()
	}
	
	func fetchImageURL(movieID: String, onComplete: @escaping (Result<UIImage,DzImageError>) -> Void) {
		
		let endPoint = baseURL + "movie/\(movieID)/images"
		
		if let imageCache = movieIDCache[movieID] {
			
			self.downloadImage(from: imageCache, onComplete: onComplete)
			
			return
		}
		
		guard let url = URL(string: endPoint) else {
			onComplete(.failure(.invalidRequest))
			return
		}
		
		let task = URLSession.shared.dataTask(with: self.prepareURL(url: url)) { [weak self] data, response, error in
			
			guard let self = self else {
				onComplete(.failure(.failedToGetFilePath))
				return
			}
			
			if error != nil {
				onComplete(.failure(.failedToGetFilePath))
				return
			}
			
			guard let response = response as? HTTPURLResponse, response.statusCode == 200, let data = data else {
				onComplete(.failure(.invalidData))
				return
			}
			
			do {
				if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
				   let posters = json["posters"] as? [[String: Any]] {
					
					if let imagePath = posters.first(where: { $0["iso_639_1"] as? String == "en" })?["file_path"] as? String {
						
						self.movieIDCache.updateValue(imagePath, forKey: movieID)

						
						self.downloadImage(from: imagePath, onComplete: onComplete)
					}
					
				}
			} catch {
				onComplete(.failure(.jsonError))
			}
		}
		
		task.resume()
		
	}
	
	private func prepareURL(url: URL) -> URLRequest {
		
		var request = URLRequest(url: url)
		request.httpMethod = "GET"
		request.allHTTPHeaderFields = [
			"accept": "application/json",
			"Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI1ZjkwMTAxMjk5YTc1NTAyZTFlMWE1MDc5N2VkOWViYyIsIm5iZiI6MTcyOTQ4Nzg3MS45Mzk2NTYsInN1YiI6IjY0YjA1ZDIzZTI0YjkzNWIzMWNhN2JlNyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.igWiQei6-Py1w1hfnbXtu2YQIGxoFNVIO8sgDL0A8w4"
		]
		
		return request
	}
	
	private func downloadImage(from imagePath: String, onComplete: @escaping (Result<UIImage,DzImageError>) -> Void) {
		
		let baseUrl = "https://image.tmdb.org/t/p/original\(imagePath)"
		
		let cacheKey = NSString(string: baseUrl)
		
		if let image = imageCache.object(forKey: cacheKey) {
			onComplete(.success(image))
			return
		}
		
		guard let url = URL(string: baseUrl) else {
			onComplete(.failure(.invalidRequest))
			return
		}
		
		let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
			
			guard let self = self else {
				onComplete(.failure(.failedToGetImage))
				return
			}
			
			if error != nil {
				onComplete(.failure(.failedToGetImage))
				return
			}
			
			guard let response = response as? HTTPURLResponse, response.statusCode == 200, let data = data else {
				onComplete(.failure(.invalidData))
				return
			}
			
			guard let image = UIImage(data: data)else {
				onComplete(.failure(.invalidData))
				return
			}
			
			self.imageCache.setObject(image, forKey: cacheKey)
			
			print("[dzakwan] setimageFromCache \(cacheKey)")
			
			DispatchQueue.main.async { [weak self] in
				onComplete(.success(image))
			}
			
		}
		
		task.resume()
	}
}

