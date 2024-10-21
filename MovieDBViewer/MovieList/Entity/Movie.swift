//
//  Movie.swift
//  MovieDBViewer
//
//  Created by admin on 21/10/24.
//
import Foundation

// MARK: - MovieData
struct MovieData: Codable {
	let dates: Dates
	let page: Int
	let results: [Movie]
	let totalPages, totalResults: Int

	enum CodingKeys: String, CodingKey {
		case dates, page, results
		case totalPages = "total_pages"
		case totalResults = "total_results"
	}
}

// MARK: - Dates
struct Dates: Codable {
	let maximum, minimum: String
}

public struct Movie: Identifiable, Codable, Equatable, Hashable, Sendable {

    public let id: Int

    public let title: String

    public let tagline: String?

    public let originalTitle: String?

    public let originalLanguage: String?

    public let overview: String?

    public let runtime: Int?

    public let releaseDate: Date?

    public let posterPath: URL?

    public let backdropPath: URL?

    public let budget: Double?

    public let revenue: Double?

    public let homepageURL: URL?

    public let imdbID: String?

    public let popularity: Double?

    public let voteAverage: Double?

    public let voteCount: Int?

    public let hasVideo: Bool?

    public let isAdultOnly: Bool?

    public init(
        id: Int,
        title: String,
        tagline: String? = nil,
        originalTitle: String? = nil,
        originalLanguage: String? = nil,
        overview: String? = nil,
        runtime: Int? = nil,
        releaseDate: Date? = nil,
        posterPath: URL? = nil,
        backdropPath: URL? = nil,
        budget: Double? = nil,
        revenue: Double? = nil,
        homepageURL: URL? = nil,
        imdbID: String? = nil,
        popularity: Double? = nil,
        voteAverage: Double? = nil,
        voteCount: Int? = nil,
        hasVideo: Bool? = nil,
        isAdultOnly: Bool? = nil
    ) {
        self.id = id
        self.title = title
        self.tagline = tagline
        self.originalTitle = originalTitle
        self.originalLanguage = originalLanguage
        self.overview = overview
        self.runtime = runtime
        self.releaseDate = releaseDate
        self.posterPath = posterPath
        self.backdropPath = backdropPath
        self.budget = budget
        self.revenue = revenue
        self.homepageURL = homepageURL
        self.imdbID = imdbID
        self.popularity = popularity
        self.voteAverage = voteAverage
        self.voteCount = voteCount
        self.hasVideo = hasVideo
        self.isAdultOnly = isAdultOnly
    }

}

extension Movie {

    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case tagline
        case originalTitle
        case originalLanguage
        case overview
        case runtime
        case releaseDate
        case posterPath
        case backdropPath
        case budget
        case revenue
        case homepageURL = "homepage"
        case imdbID = "imdbId"
        case popularity
        case voteAverage
        case voteCount
        case hasVideo = "video"
        case isAdultOnly = "adult"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let container2 = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decode(Int.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.tagline = try container.decodeIfPresent(String.self, forKey: .tagline)
        self.originalTitle = try container.decodeIfPresent(String.self, forKey: .originalTitle)
        self.originalLanguage = try container.decodeIfPresent(String.self, forKey: .originalLanguage)
        self.overview = try container.decodeIfPresent(String.self, forKey: .overview)
        self.runtime = try container.decodeIfPresent(Int.self, forKey: .runtime)

        let releaseDateString = try container.decodeIfPresent(String.self, forKey: .releaseDate)
        self.releaseDate = try {
            guard let releaseDateString, !releaseDateString.isEmpty else {
                return nil
            }

            return try container2.decodeIfPresent(Date.self, forKey: .releaseDate)
        }()

        self.posterPath = try container.decodeIfPresent(URL.self, forKey: .posterPath)
        self.backdropPath = try container.decodeIfPresent(URL.self, forKey: .backdropPath)
        self.budget = try container.decodeIfPresent(Double.self, forKey: .budget)
        self.revenue = try container.decodeIfPresent(Double.self, forKey: .revenue)

        let homepageURLString = try container.decodeIfPresent(String.self, forKey: .homepageURL)
        self.homepageURL = try {
            guard let homepageURLString, !homepageURLString.isEmpty else {
                return nil
            }

            return try container2.decodeIfPresent(URL.self, forKey: .homepageURL)
        }()

        self.imdbID = try container.decodeIfPresent(String.self, forKey: .imdbID)
        self.popularity = try container.decodeIfPresent(Double.self, forKey: .popularity)
        self.voteAverage = try container.decodeIfPresent(Double.self, forKey: .voteAverage)
        self.voteCount = try container.decodeIfPresent(Int.self, forKey: .voteCount)
        self.hasVideo = try container.decodeIfPresent(Bool.self, forKey: .hasVideo)
        self.isAdultOnly = try container.decodeIfPresent(Bool.self, forKey: .isAdultOnly)
    }

}
