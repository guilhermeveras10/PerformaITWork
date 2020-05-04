//
//  TweetController.swift
//  PerformTwiter
//
//  Created by Guilherme. Duarte on 29/04/20.
//  Copyright © 2020 Guilherme Duarte. All rights reserved.
//

import UIKit

private let reuseIdentifier = "TweeterPeorile"
private let reuseIdentifierHeader = "ProcileCell"

class TweetController: UICollectionViewController {
    
    //MARK: - Propeties
    
    private let tweet: Tweet
    
    private var actionSheet: ActionSheet!
    
    private var tweets = [Tweet]() {
        didSet {collectionView.reloadData()}
    }
    
    //MARK: - Lifecycle
    
    init(tweet: Tweet) {
        self.tweet = tweet
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configuraCollection()
        fetch()
    }
    
    //MARK: - API
    
    func fetch() {
        TweetsSeervice.shared.fetchReplies(tweet: tweet) { tweets in
            self.tweets = tweets
        }
    }
    
    //MARK: - Helpers
    
    func configuraCollection() {
        collectionView.backgroundColor = .white
        
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.register(TweetHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: reuseIdentifierHeader)
    }
    
    fileprivate func showActionSheet(user: User) {
        actionSheet = ActionSheet(user: user)
        actionSheet.delegate = self
        actionSheet.show()
    }
    
}

//MARK: - CollectionViewDatasource

extension TweetController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tweets.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TweetCell
        cell.tweet = tweets[indexPath.row]
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension TweetController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let viewModel = TweetViewModel(tweet: tweet)
        let captionHeight = viewModel.size(width: view.frame.width).height
        return CGSize(width: view.frame.width, height: captionHeight + 260)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 120)
    }
}

//MARK: - CollectionViewDelegate

extension TweetController {
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: reuseIdentifierHeader, for: indexPath) as! TweetHeader
        header.tweet = tweet
        header.delegate = self
        return header
    }
}

//MARK: - TweetHeaderDelegate

extension TweetController: TweetHeaderDelegate {
    func showActionSheet() {
        if tweet.user.isCurrentUser {
            showActionSheet(user: tweet.user)
        } else {
            UserService.shared.checkIfUserIsFollowed(uid: tweet.user.uid) { isFollowed in
                var user = self.tweet.user
                user.isFollowed = isFollowed
                self.showActionSheet(user: user)
            }
        }
    }
}

//MARK: - ActionSheetDelegate

extension TweetController: ActionSheetDelegate {
    func didSelect(option: ActionCheetOption) {
        switch option {
        case .follow(let user):
            UserService.shared.followUser(uid: user.uid) { (error, ref) in
                print(user.username)
            }
        case .unfolow(let user):
            UserService.shared.unfollowUser(uid: user.uid) { (error, ref) in
                print(user.username)
            }
        case .report:
            print("reportar")
        case .delete:
            print("deletar")
        }
    }
    
    
}
