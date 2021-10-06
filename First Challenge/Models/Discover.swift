//
//  Discover.swift
//  First Challenge
//
//  Created by Santo Michael Sihombing on 06/10/21.
//

import UIKit

struct DiscoverResponseModel: Decodable {
    var page: Int
    var results: [MovieModel]
}

struct MovieModel: Decodable {
    
    var movieTitle, movieOverview, movieImageUrl: String
    var movieId: Int
    
    enum CodingKeys: String, CodingKey {
        case movieTitle    = "title"
        case movieOverview = "overview"
        case movieImageUrl = "poster_path"
        case movieId = "id"
    }
}

struct DiscoverManager {
    
    func fetchMovies(page: Int = 1, genreId: Int = 99, refresh: Bool = false, completed: @escaping (_ result: (Int, [MovieModel])) -> ()) {
        
        guard let url = URL(string: "https://api.themoviedb.org/3/discover/movie?api_key=be8b6c8aa9a5f4e240bb6093f9849051&page=\(page)&with_genres=\(genreId)") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            
            guard let data = data, error == nil else {
                print("Something went wrong: \(error!)")
                return
            }
            
            var result: DiscoverResponseModel?
            
            do {
                result = try JSONDecoder().decode(DiscoverResponseModel.self, from: data)
            } catch {
                print("ERROR => ",error)
                return
            }
            
            guard let json = result else {return}
            
            DispatchQueue.main.async {
                completed((json.page,json.results))
            }
        }
        task.resume()
    }
}
