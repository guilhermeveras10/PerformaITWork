//
//  UploadTweetViewModel.swift
//  PerformTwiter
//
//  Created by Guilherme. Duarte on 01/05/20.
//  Copyright © 2020 Guilherme Duarte. All rights reserved.
//

import UIKit

enum UploadConfiguration{
    case tweet
    case reply(Tweet)
}

struct UploadTweetViewModel {
    let actionBtnTitle: String
    let placeholderText: String
    var shouldShowReplyText: Bool
    var replyText: String?
    
    init(config: UploadConfiguration) {
        switch config {
        case .tweet:
            actionBtnTitle = "Rasga"
            placeholderText = "O que mandas?"
            shouldShowReplyText = false
        case .reply(let tweet):
            actionBtnTitle = "Compartilhar"
            placeholderText = "O que mandas?"
            shouldShowReplyText = true
            replyText = "Compartilhando de @\(tweet.user.username)"
        }
    }
}
