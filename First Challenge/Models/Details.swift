//
//  Details.swift
//  First Challenge
//
//  Created by Santo Michael Sihombing on 07/10/21.
//

import UIKit

struct genre: Decodable {
    var id: Int
    var name: String
}

struct MovieDetailModel: Decodable {
    
    var movieId: Int
    var movieOverview: String
    var movieImageUrl: String
    var movieTitle: String
    var adult: Bool
    var backdrop: String
    var genres: [genre]
    var voteAverage: Double
    
    enum CodingKeys: String, CodingKey {
        case movieTitle    = "title"
        case movieOverview = "overview"
        case movieImageUrl = "poster_path"
        case movieId = "id"
        case voteAverage = "vote_average"
        case adult = "adult"
        case backdrop = "backdrop_path"
        case genres = "genres"
    }
}

struct DetailManager {
    
    func fetchMovies(movieId: Int, completed: @escaping (_ result: MovieDetailModel) -> ()) {
        
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieId)?api_key=be8b6c8aa9a5f4e240bb6093f9849051") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            
            guard let data = data, error == nil else {
                print("Something went wrong: \(error!)")
                return
            }
            
            var result: MovieDetailModel?
            
            do {
                result = try JSONDecoder().decode(MovieDetailModel.self, from: data)
            } catch {
                print("ERROR => ",error)
                return
            }
            
            guard let json = result else {return}
            
            DispatchQueue.main.async {
                completed(json)
            }
        }
        task.resume()
    }
}
