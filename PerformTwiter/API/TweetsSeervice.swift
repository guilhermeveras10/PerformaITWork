//
//  TweetsSeervice.swift
//  PerformTwiter
//
//  Created by Guilherme. Duarte on 27/04/20.
//  Copyright © 2020 Guilherme Duarte. All rights reserved.
//

import Firebase

struct TweetsSeervice {
    static let shared = TweetsSeervice()
    
    func sendTweets(caption: String, type: UploadConfiguration ,completion: @escaping(DatabaseCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        var values = ["uid": uid,
                      "timestamp": Int(NSDate().timeIntervalSince1970),
                      "likes": 0,
                      "retweets": 0,
                      "caption": caption] as [String: Any]
        switch type {
        case .tweet:
            let ref = REF_TWEETS.childByAutoId()
            ref.updateChildValues(values) { (error, ref) in
                guard let tweetID = ref.key else {return}
                REF_USER_TWEETS.child(uid).updateChildValues([tweetID: 1], withCompletionBlock: completion)
            }
        case .reply(let tweet):
            values["replyingTo"] = tweet.user.username
            REF_TWEETS_REPLIES.child(tweet.tweetID).childByAutoId().updateChildValues(values) { (error, ref) in
                guard let key = ref.key else {return}
                REF_USER_REPLIES.child(uid).updateChildValues([tweet.tweetID: key], withCompletionBlock: completion)
            }
        }
    }
    
    func fetchTweets(completion: @escaping([Tweet]) -> Void){
        var tweets = [Tweet]()
        guard let currentID = Auth.auth().currentUser?.uid else { return }
        
        REF_USER_FOLLOWING.child(currentID).observe(.childAdded) { snapshot in
            let followID = snapshot.key
            REF_USER_TWEETS.child(followID).observe(.childAdded) { snapshot in
                let tweetID = snapshot.key
                self.fetchTweet(tweetID: tweetID) { tweet in
                    tweets.append(tweet)
                    completion(tweets)
                }
            }
            REF_USER_TWEETS.child(currentID).observe(.childAdded) { snapshot in
                let tweetID = snapshot.key
                
                self.fetchTweet(tweetID: tweetID) { tweet in
                    tweets.append(tweet)
                    completion(tweets)
                }
            }
        }
    }
    
    func fetchUserReplies(user: User, completion: @escaping([Tweet]) -> Void) {
        var tweets = [Tweet]()
        
        REF_USER_REPLIES.child(user.uid).observe(.childAdded) { snapshot in
            let tweetID = snapshot.key
            guard let replyKey = snapshot.value as? String else {return}
            
            REF_TWEETS_REPLIES.child(tweetID).child(replyKey).observeSingleEvent(of: .value) { snapshot in
                guard let dictionary = snapshot.value as? [String: Any] else { return }
                guard let uid = dictionary["uid"] as? String else { return }
                let replyID = snapshot.key
                
                UserService.shared.fetchUser(uid: uid) { user in
                    let tweet = Tweet(user: user, tweetID: tweetID, dictionary: dictionary)
                    tweets.append(tweet)
                    completion(tweets)
                }
            }
        }
    }
    
    func fetchUserTweets(user: User, completion: @escaping([Tweet]) -> Void){
        var tweets = [Tweet]()
        
        REF_USER_TWEETS.child(user.uid).observe(.childAdded) { snapshot in
            let tweetID = snapshot.key
            
            self.fetchTweet(tweetID: tweetID) { tweet in
                tweets.append(tweet)
                completion(tweets)
            }
        }
    }
    
    func fetchLikes(user: User, completion: @escaping([Tweet]) -> Void) {
        var tweets = [Tweet]()
        REF_USER_LIKES.child(user.uid).observe(.childAdded) { snapshot in
            let tweetID = snapshot.key
            self.fetchTweet(tweetID: tweetID) { tweetLiked in
                var tweet = tweetLiked
                tweet.didLike = true
                tweets.append(tweet)
                completion(tweets)
            }
        }
    }
    
    func fetchTweet(tweetID: String, completion: @escaping (Tweet) -> Void) {
        REF_TWEETS.child(tweetID).observeSingleEvent(of: .value) { snapshot in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            guard let uid = dictionary["uid"] as? String else { return }
            
            UserService.shared.fetchUser(uid: uid) { user in
                let tweet = Tweet(user: user, tweetID: tweetID, dictionary: dictionary)
                completion(tweet)
            }
        }
    }
    
    func fetchReplies(tweet: Tweet, completion: @escaping([Tweet]) -> Void) {
        var tweets = [Tweet]()
        
        REF_TWEETS_REPLIES.child(tweet.tweetID).observe(.childAdded) { snapshot in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            guard let uid = dictionary["uid"] as? String else { return }
            let tweetID = snapshot.key
            
            UserService.shared.fetchUser(uid: uid) { user in
                let tweet = Tweet(user: user, tweetID: tweetID, dictionary: dictionary)
                tweets.append(tweet)
                completion(tweets)
            }
        }
    }
    
    func like(tweet: Tweet, completion: @escaping(DatabaseCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let likes = tweet.didLike ? tweet.likes - 1 : tweet.likes + 1
        REF_TWEETS.child(tweet.tweetID).child("likes").setValue(likes)
        if tweet.didLike {
            REF_USER_LIKES.child(uid).child(tweet.tweetID).removeValue { (error, ref) in
                REF_TWEET_LIKES.child(tweet.tweetID).removeValue(completionBlock: completion)
            }
        } else {
            REF_USER_LIKES.child(uid).updateChildValues([tweet.tweetID: 1]) { (error, ref) in
                REF_TWEET_LIKES.child(tweet.tweetID).updateChildValues([uid: 1], withCompletionBlock: completion)
            }
        }
    }
    
    func checkUserLike(_ tweet:Tweet, completion: @escaping(Bool) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        REF_USER_LIKES.child(uid).child(tweet.tweetID).observeSingleEvent(of: .value) { snapshot in
            completion(snapshot.exists())
        }
    }
}
