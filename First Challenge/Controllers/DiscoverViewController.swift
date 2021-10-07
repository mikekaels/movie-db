//
//  DiscoverViewController.swift
//  First Challenge
//
//  Created by Santo Michael Sihombing on 06/10/21.
//

import UIKit

class DiscoverViewController: UIViewController {
    
    let discoverManager = DiscoverManager()
    
    var myCollectionView: UICollectionView?
    
    var totalPage = 100
    var currentPage = 1
    var genreId: Int = 99
    var movies: [MovieModel] = [MovieModel]()
    
    var spinerView: UIView = {
       let view = UIView()
//        view.backgroundColor = .red
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        spinner.isHidden = true
        return spinner //90.960
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        fetchMovies(currentPage: self.currentPage)
        collectionViewSetup()
        
        view.addSubview(spinerView)
        spinerView.topAnchor.constraint(equalTo: myCollectionView!.bottomAnchor, constant: -UIScreen.main.bounds.height/5).isActive = true
        spinerView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        spinerView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/5).isActive = true
        
        spinerView.addSubview(spinner)
        spinner.centerXAnchor.constraint(equalTo: spinerView.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: spinerView.centerYAnchor).isActive = true
        
        myCollectionView?.dataSource = self
        myCollectionView?.delegate = self
    }
    
    func fetchMovies(currentPage: Int) {
        discoverManager.fetchMovies(page: currentPage, genreId: self.genreId) { result in
            self.currentPage = result.0
            if result.0 > 1 {
                self.movies.append(contentsOf: result.1)
                self.myCollectionView?.reloadData()
            } else {
                self.movies = result.1
                self.myCollectionView?.reloadData()
            }
        }
    }
    
    func collectionViewSetup() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 150, right: 20)
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 2.4,
                                 height: UIScreen.main.bounds.width / 1.7)
        layout.minimumLineSpacing = 20
        
        myCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        self.view.addSubview(myCollectionView!)
        myCollectionView?.register(MovieCell.self, forCellWithReuseIdentifier: "CollectionCell")
        myCollectionView?.register(LoadingCell.self, forCellWithReuseIdentifier: "LoadingCell")
        myCollectionView?.backgroundColor = UIColor.systemBackground
        myCollectionView?.translatesAutoresizingMaskIntoConstraints = false
        myCollectionView?.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        myCollectionView?.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        myCollectionView?.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        myCollectionView?.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        
    }
}

extension DiscoverViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! MovieCell
        cell.title.text = self.movies[indexPath.row].movieTitle
        cell.image.loadImageUsingUrlString(urlString: "http://image.tmdb.org/t/p/w500\(self.movies[indexPath.row].movieImageUrl)")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DetailsViewController()
        vc.movieId = self.movies[indexPath.row].movieId
        vc.moreLikeTheseUrl = [
            (self.movies[indexPath.row + 1].movieImageUrl, self.movies[indexPath.row + 1].movieId),
            (self.movies[indexPath.row + 2].movieImageUrl, self.movies[indexPath.row + 2].movieId),
            (self.movies[indexPath.row + 3].movieImageUrl, self.movies[indexPath.row + 3].movieId),
            (self.movies[indexPath.row + 4].movieImageUrl, self.movies[indexPath.row + 4].movieId),
            (self.movies[indexPath.row + 5].movieImageUrl, self.movies[indexPath.row + 5].movieId),
            (self.movies[indexPath.row + 6].movieImageUrl, self.movies[indexPath.row + 6].movieId)
        ]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if currentPage < totalPage && indexPath.row == movies.count - 1 {
            self.spinner.isHidden = false
            self.currentPage += 1
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.fetchMovies(currentPage: self.currentPage)
                self.spinner.isHidden = true
            }
        }
    }
}

class MovieCell: UICollectionViewCell {
    
    let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis  = NSLayoutConstraint.Axis.vertical
        sv.alignment = UIStackView.Alignment.center
        sv.distribution = UIStackView.Distribution.fillProportionally
        sv.translatesAutoresizingMaskIntoConstraints = false;
        return sv
    }()
    
    var image: CustomImageView = {
        let image = CustomImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    var titleView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var title: UILabel = {
        var title = UILabel()
        title.textColor = .label
        title.textAlignment = .center
        title.lineBreakMode = .byWordWrapping
        title.numberOfLines = 2
        title.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = self.frame.height / 20
        self.layer.masksToBounds = true
        addViews()
    }
    
    func addViews() {
        
        addSubview(stackView)
        stackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        stackView.addArrangedSubview(image)
        image.heightAnchor.constraint(equalToConstant: contentView.frame.height - 100).isActive = true
        image.widthAnchor.constraint(equalToConstant: contentView.frame.width).isActive = true
        image.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
        
        stackView.addArrangedSubview(titleView)
        titleView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        titleView.widthAnchor.constraint(equalToConstant: contentView.frame.width).isActive = true
        
        titleView.addSubview(title)
        title.widthAnchor.constraint(equalTo: titleView.widthAnchor).isActive = true
        title.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
        title.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class LoadingCell: UICollectionViewCell {
    
    let spinner : UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        
        return spinner
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
    }
    
    func addViews() {
        spinner.center = contentView.center
        addSubview(spinner)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


