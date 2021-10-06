//
//  GenreViewController.swift
//  First Challenge
//
//  Created by Santo Michael Sihombing on 06/10/21.
//

import UIKit

class GenreViewController: UIViewController {
    let genreManager = GenreManager()
    var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(UITableViewCell.self, forCellReuseIdentifier: "GenreCell")
        table.tableHeaderView = .none
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    var genres: [GenreModel] = [GenreModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Genre"
        view.backgroundColor = .white
        
        genreManager.fetchGenre { response in
            self.genres = response
            self.tableView.reloadData()
        }
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: 0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 0).isActive = true
    }
}


extension GenreViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return genres.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "GenreCell")
        cell.textLabel?.text = genres[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DiscoverViewController()
        let genre = genres[indexPath.row]
        vc.title = "Movies by \(genre.title)"
        vc.genreId = genre.id
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var cellHeight: CGFloat = CGFloat()
        cellHeight = 60
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
}
