//
//  ProfilleController.swift
//  PerformTwiter
//
//  Created by Guilherme. Duarte on 28/04/20.
//  Copyright © 2020 Guilherme Duarte. All rights reserved.
//

import UIKit

private let reuseIdentifier = "TweeterPeorile"
private let reuseIdentifierHeader = "ProcileCell"

class ProfilleController: UICollectionViewController {
    
    //MARK: - Propeties
    
    private var tweets = [Tweet]() {
        didSet{ collectionView.reloadData() }
    }
    
    private var user: User
    
    //MARK: - Lifecycle
    
    init(user: User) {
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUserStats()
        fetch()
        checkFollowing()
        configureCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    //MARK: - API
    
    func fetch() {
        TweetsSeervice.shared.fetchUserTweets(user: user) { tweets in
            self.tweets = tweets
        }
    }
    
    func checkFollowing() {
        UserService.shared.checkIfUserIsFollowed(uid: user.uid) { isUserFollow in
            self.user.isFollowed = isUserFollow
            self.collectionView.reloadData()
        }
    }
    
    func fetchUserStats() {
        UserService.shared.fetchUserStats(uid: user.uid) { stats in
            self.user.stats = stats
            self.collectionView.reloadData()
        }
    }
    
    //MARK: - Helpers
    
    func configureCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.contentInsetAdjustmentBehavior = .never
        navigationController?.navigationBar.barStyle = .black
        
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.register(ProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: reuseIdentifierHeader)
    }
    
}

//MARK: - CollectionViewDatasource

extension ProfilleController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tweets.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TweetCell
        cell.tweet = tweets[indexPath.row]
        return cell
    }
}

//MARK: - CollectionViewDelegate

extension ProfilleController {
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: reuseIdentifierHeader, for: indexPath) as! ProfileHeader
        header.user = user
        header.delegate = self
        return header
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension ProfilleController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 350)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 120)
    }
}

//MARK: - ProfileHeaderDelegate

extension ProfilleController: ProfileHeaderDelegate {
    func handlProfile(_ header: ProfileHeader) {
        
        if user.isCurrentUser {
            return
        }
        
        if user.isFollowed {
            UserService.shared.unfollowUser(uid: user.uid) { (error, ref) in
                self.user.isFollowed = false
                self.collectionView.reloadData()
            }
        } else {
            UserService.shared.followUser(uid: user.uid) { (error, ref) in
                self.user.isFollowed = true
                self.collectionView.reloadData()
                NotificationService.shared.uploadNotification(type: .follow, user: self.user)
            }
        }
    }
    
    func handleDismiss() {
        navigationController?.popViewController(animated: true)
    }
}
