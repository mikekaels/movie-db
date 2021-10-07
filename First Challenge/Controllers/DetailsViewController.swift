//
//  DetailsViewController.swift
//  First Challenge
//
//  Created by Santo Michael Sihombing on 07/10/21.
//

import UIKit

class DetailsViewController: UIViewController {
    
    let detailManager = DetailManager()
    
    var posterUrl: String = ""
    var movieId: Int = 0
    var movieDetail: MovieDetailModel?
    
    var moreLikeTheseUrl: [(String, Int)] = [(String, Int)]()
    
    let poster: CustomImageView = {
        let image = CustomImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = UIView.ContentMode.scaleAspectFill
        return image
    }()
    
    let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 500)
        view.contentSize = CGSize(width: view.frame.width, height: view.frame.height + 200)
        view.backgroundColor = .systemBackground
        view.contentInsetAdjustmentBehavior = .automatic
        view.isScrollEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let movieTitle: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let movieRating: UILabel = {
        let label = UILabel()
        label.textColor = .systemGreen
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let movieRated: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis  = NSLayoutConstraint.Axis.horizontal
        sv.alignment = UIStackView.Alignment.leading
        sv.distribution = UIStackView.Distribution.fillProportionally
        sv.translatesAutoresizingMaskIntoConstraints = false;
        return sv
    }()
    
    let playButton: UIButton = {
        let bt = UIButton()
        bt.backgroundColor = .label
        bt.layer.cornerRadius = 5
        bt.layer.masksToBounds = true
        bt.setTitleColor(.systemBackground, for: .normal)
        bt.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        bt.translatesAutoresizingMaskIntoConstraints = false;
        return bt
    }()
    
    let downloadButton: UIButton = {
        let bt = UIButton()
        bt.backgroundColor = .systemGray5
        bt.layer.cornerRadius = 5
        bt.layer.masksToBounds = true
        bt.setTitleColor(.label, for: .normal)
        bt.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        bt.translatesAutoresizingMaskIntoConstraints = false;
        return bt
    }()
    
    let movieOverview: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 3
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var movieGenres: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 12, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let moreLikeThis: UILabel = {
        let label = UILabel()
        label.text = "More Like This"
        label.textColor = .label
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    let colView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var collectionView:UICollectionView?

    override func viewDidLoad() {
        super.viewDidLoad()
        print("::VIEW DID LOAD::")
        viewSetup()
        view.backgroundColor = .systemBackground
        fetchMovieDetail()

        playButton.setTitle("Play", for: .normal)
        downloadButton.setTitle("Download", for: .normal)
        movieGenres.text = "Genre: Action, Thriler, Adventure, Science Fiction"
        
        collectionView?.dataSource = self
        collectionView?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("::VIEW WILL APPEAR::")
    }
    
    func fetchMovieDetail() {
        detailManager.fetchMovies(movieId: self.movieId) { result in
            print("RESULT: ", result)
            DispatchQueue.main.async {
                self.movieDetail = result
                self.movieTitle.text = result.movieTitle
                self.movieOverview.text = result.movieOverview
                self.movieRated.text = result.adult ? "Adult" : ""
//                self.poster.load(url: URL(string: "http://image.tmdb.org/t/p/w500\(result.movieImageUrl)")!)
//                self.poster.downloaded(from: "http://image.tmdb.org/t/p/w500\(result.movieImageUrl)")
                self.poster.loadImageUsingUrlString(urlString: "http://image.tmdb.org/t/p/w500\(result.movieImageUrl)")
                self.movieRating.text = String(result.voteAverage)
                self.movieGenres.text = "Genre: \(result.genres.map{$0.name }.map{String($0)}.joined(separator: ", "))"
                self.collectionView?.reloadData()
            }
        }
    }
    
    func viewSetup() {
        view.addSubview(poster)
        poster.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        poster.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        poster.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -300).isActive = true
        
        view.addSubview(scrollView)
        scrollView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        scrollView.topAnchor.constraint(equalTo: poster.bottomAnchor, constant: 0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
        scrollView.addSubview(movieTitle)
        movieTitle.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10).isActive = true
        movieTitle.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -10).isActive = true
        movieTitle.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        
        scrollView.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: movieTitle.bottomAnchor, constant: 0).isActive = true
        stackView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        stackView.addSubview(movieRating)
        movieRating.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10).isActive = true
        
        stackView.addSubview(movieRated)
        movieRated.leftAnchor.constraint(equalTo: movieRating.rightAnchor, constant: 10).isActive = true
        
        scrollView.addSubview(playButton)
        playButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 0).isActive = true
        playButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10).isActive = true
        playButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -10).isActive = true
        playButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        scrollView.addSubview(downloadButton)
        downloadButton.topAnchor.constraint(equalTo: playButton.bottomAnchor, constant: 10).isActive = true
        downloadButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10).isActive = true
        downloadButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -10).isActive = true
        downloadButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        scrollView.addSubview(movieOverview)
        movieOverview.topAnchor.constraint(equalTo: downloadButton.bottomAnchor, constant: 20).isActive = true
        movieOverview.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10).isActive = true
        movieOverview.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -10).isActive = true
        
        scrollView.addSubview(movieGenres)
        movieGenres.topAnchor.constraint(equalTo: movieOverview.bottomAnchor, constant: 10).isActive = true
        movieGenres.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10).isActive = true
        movieGenres.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -10).isActive = true
        
        scrollView.addSubview(moreLikeThis)
        moreLikeThis.topAnchor.constraint(equalTo: movieGenres.bottomAnchor, constant: 20).isActive = true
        moreLikeThis.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10).isActive = true
        moreLikeThis.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -10).isActive = true
        
        scrollView.addSubview(colView)
        colView.topAnchor.constraint(equalTo: moreLikeThis.bottomAnchor, constant: 0).isActive = true
        colView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10).isActive = true
        colView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -10).isActive = true
        colView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height).isActive = true
        
        collectionViewSetup()
    }
    
    func collectionViewSetup() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3.4,
                                 height: UIScreen.main.bounds.width / 2.4)
        layout.minimumLineSpacing = 12
        
        collectionView = UICollectionView(frame: colView.frame, collectionViewLayout: layout)
        collectionView?.isScrollEnabled = false
        collectionView?.translatesAutoresizingMaskIntoConstraints = false
        collectionView?.register(moreLikeTheseCell.self, forCellWithReuseIdentifier: "cell")
        collectionView?.backgroundColor = UIColor.systemBackground
        colView.addSubview(collectionView!)
        collectionView?.topAnchor.constraint(equalTo: moreLikeThis.bottomAnchor, constant: 0).isActive = true
        collectionView?.leftAnchor.constraint(equalTo: colView.leftAnchor, constant: 0).isActive = true
        collectionView?.rightAnchor.constraint(equalTo: colView.rightAnchor, constant: 0).isActive = true
        collectionView?.bottomAnchor.constraint(equalTo: colView.bottomAnchor, constant: 0).isActive = true
    }
}

extension DetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! moreLikeTheseCell
        cell.backgroundColor = .red
        cell.image.load(url: URL(string: "http://image.tmdb.org/t/p/w500\(self.moreLikeTheseUrl[indexPath.row].0)")!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = DetailsViewController()
        vc.movieId = self.moreLikeTheseUrl[indexPath.row].1
        vc.moreLikeTheseUrl = self.moreLikeTheseUrl
        print("INDEX: ",indexPath.row)
        print("MOVIE: ",self.moreLikeTheseUrl[indexPath.row].1, self.moreLikeTheseUrl[indexPath.row].0)
        print("MORE LIKE THIS: ",self.moreLikeTheseUrl)
        navigationController?.pushViewController(vc, animated: true)
    }
}


class moreLikeTheseCell: UICollectionViewCell {
    
    
    let image: CustomImageView = {
        let image = CustomImageView()
        image.image = UIImage(named: "dog")
        image.contentMode = UIView.ContentMode.scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = self.frame.height / 20
        self.layer.masksToBounds = true
        addViews()
    }
    
    func addViews() {
        addSubview(image)
        image.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
        image.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0).isActive = true
        image.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
        image.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 0).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
