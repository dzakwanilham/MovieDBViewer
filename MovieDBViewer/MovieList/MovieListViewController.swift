//
//  MovieListViewController.swift
//  MovieDBViewer
//
//  Created by admin on 21/10/24.
//

import Foundation
import UIKit

class MovieListViewController: UIViewController {
	
	enum Section {
		case main
	}
	
	var didSelectMovies: ((_ movie: Movie) -> ())?
	
	var viewModel: MovieListViewModel
	var collectionView: UICollectionView?
	var dataSource: UICollectionViewDiffableDataSource<Section, Movie>?
	var isSearching: Bool = false
	
	init(_ movieListViewModel: MovieListViewModel) {
		self.viewModel = movieListViewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		configureView()
		configureCollectionView()
		configureDataSource()
		configureViewModel()
		configureSearchController()
		
	}
	
	override func viewWillAppear(_ animated: Bool) {
		//navigationController?.isNavigationBarHidden = false
		navigationController?.setNavigationBarHidden(false, animated: true)
	}
	
	private func configureViewModel() {
		viewModel.fetchMovies()
		
		viewModel.onNeedToUpdateData = { [weak self] in
			self?.updateData(on: self?.viewModel.movies ?? [])
		}
		
	}
	
	private func configureView() {
		view.backgroundColor = .systemBackground
		navigationController?.navigationBar.prefersLargeTitles = true
	}
	
	private func configureCollectionView() {
		
		collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createCustomFlowLayout(in: view))
		
		guard let collectionView = collectionView else { return }
		
		view.addSubview(collectionView)
		collectionView.delegate = self
		collectionView.backgroundColor = .systemGray
		collectionView.register(DzCollectionCellView.self, forCellWithReuseIdentifier: DzCollectionCellView.reuseID)
	}
	
	private func configureDataSource() {
		
		guard let collectionView = collectionView else { return }
		
		dataSource = UICollectionViewDiffableDataSource<Section,Movie>(collectionView: collectionView, cellProvider: { collectionView, indexPath, movie in
			
			guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DzCollectionCellView.reuseID, for: indexPath) as? DzCollectionCellView else {
				return UICollectionViewCell()
			}
			
			cell.set(movie: movie)
			return cell
		})
	}
	
	private func configureSearchController() {
		let searchController = UISearchController()
		searchController.searchResultsUpdater = self
		searchController.searchBar.placeholder = "Search for a Movie"
		searchController.searchBar.delegate = self
		searchController.obscuresBackgroundDuringPresentation = false
		
		navigationItem.hidesSearchBarWhenScrolling = false
		navigationItem.searchController = searchController
	}
	
	func updateData(on movie: [Movie]) {
		
		var snapshot = NSDiffableDataSourceSnapshot<Section, Movie>()
		snapshot.appendSections([.main])
		snapshot.appendItems(movie)

		DispatchQueue.main.async {
			self.dataSource?.apply(snapshot,animatingDifferences: true)
		}
		
	}
}

extension MovieListViewController: UICollectionViewDelegate {
	
	func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
		let offsetY = scrollView.contentOffset.y
		let contentHeight = scrollView.contentSize.height
		let height = scrollView.frame.size.height
		
		if offsetY > contentHeight - height {
			guard viewModel.hasMoreMovie else {
				return
			}
			viewModel.page += 1
			viewModel.fetchMovies()
		}
		
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
		var movie: [Movie] = isSearching ? viewModel.filteredmovies : viewModel.movies
		
		let selectedMovies = movie[indexPath.item]
		
		self.didSelectMovies?(selectedMovies)
		
	}
	
}

extension MovieListViewController: UISearchResultsUpdating, UISearchBarDelegate {
	
	func updateSearchResults(for searchController: UISearchController) {
		guard let filter = searchController.searchBar.text, !filter.isEmpty else { return }
		isSearching = true
		viewModel.filteredmovies = viewModel.movies.filter{ $0.title.lowercased().contains(filter.lowercased()) }
		updateData(on: viewModel.filteredmovies)
		
	}
	
	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		isSearching = false
		updateData(on: viewModel.movies)
	}
	
}
