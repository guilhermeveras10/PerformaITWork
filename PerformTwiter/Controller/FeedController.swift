//
//  FeedController.swift
//  PerformTwiter
//
//  Created by Guilherme. Duarte on 23/04/20.
//  Copyright © 2020 Guilherme Duarte. All rights reserved.
//

import UIKit
import SDWebImage

private let reuseIdentifier = "TweetCell"

class FeedController: UICollectionViewController {
    
    //MARK: - Propeties
    
    private var tweets = [Tweet]() {
        didSet{ collectionView.reloadData() }
    }
    
    var user: User? {
        didSet { configurateNav() }
    }

    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureInterface()
        fetch()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.isHidden = false
        collectionView.reloadData()
    }
    
    //MARK: - API
    
    func fetch() {
        TweetsSeervice.shared.fetchTweets { tweets in
            self.tweets = tweets
        }
    }
    
    //MARK: - Helpers
    
    func configureInterface() {
        view.backgroundColor = .white
        
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.backgroundColor = .white
        
        let imageView = UIImageView(image: UIImage(named: "PerformaICO-1"))
        imageView.contentMode = .scaleAspectFit
        navigationItem.titleView = imageView
        
    }
    
    func configurateNav() {
        guard let user = user else { return }
        
        let profileImage = UIImageView()
        profileImage.backgroundColor = .black
        profileImage.setDimensions(width: 32, height: 32)
        profileImage.layer.cornerRadius = 32 / 2
        profileImage.layer.masksToBounds = true
        
        profileImage.sd_setImage(with: user.profileImageUrl, completed: nil)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: profileImage)
    }
}
//MARK: - CollectionView Datasource

extension FeedController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tweets.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: 	reuseIdentifier, for: indexPath) as! TweetCell
        cell.delegate = self
        cell.tweet = tweets[indexPath.row]
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = TweetController(tweet: tweets[indexPath.row])
        navigationController?.pushViewController(controller, animated: true)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension FeedController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let tweet = tweets[indexPath.row]
        let viewModel = TweetViewModel(tweet: tweet)
        let height = viewModel.size(width: view.frame.width).height
        return CGSize(width: view.frame.width, height: height + 80)
    }
}

//MARK: - TweetCellDelegate

extension FeedController: TweetCellDelegate {
    func handleReply(_ cell: TweetCell) {
        guard let tweet = cell.tweet else { return }
        let controller = UploadTwiiterController(user: tweet.user, config: .reply(tweet))
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    func handleProfileImageTapped(_ cell: TweetCell) {
        guard let user = cell.tweet?.user else { return }
        let controller = ProfilleController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
}
