//
//  Genre.swift
//  First Challenge
//
//  Created by Santo Michael Sihombing on 06/10/21.
//

import UIKit

struct GenresResponseModel: Decodable {
    var genres: [GenreModel]
}

struct GenreModel: Codable {
    var title: String
    var id: Int
    
    enum CodingKeys: String, CodingKey {
        case title    = "name"
        case id
    }
}

struct GenreManager {
    
    func fetchGenre(completed: @escaping (_ result: [GenreModel]) -> ()) {
        
        guard let url = URL(string: "https://api.themoviedb.org/3/genre/movie/list?api_key=be8b6c8aa9a5f4e240bb6093f9849051") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            
            guard let data = data, error == nil else {
                print("Something went wrong: \(error!)")
                return
            }
            
            var result: GenresResponseModel?
            
            do {
                result = try JSONDecoder().decode(GenresResponseModel.self, from: data)
            } catch {
                print(error)
            }
            
            guard let json = result else {return}
            DispatchQueue.main.async {
                completed(json.genres)
            }
        }
        task.resume()
    }
}
