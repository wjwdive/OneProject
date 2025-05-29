//
//  UserProfileListItemViewModel.swift
//  Moments
//
//  Created by wjw on 2025/5/28.
//

import Foundation

struct UserProfileListItemViewModel: ListItemViewModel {
    let name: String
    let avatarURL: URL?
    let backgroundImageURL: URL?

    init(userDetails: MomentsDetails.UserDetail) {
        name = userDetails.name
        avatarURL = URL(string: "https://img2.baidu.com/it/u=2148062273,1464870050&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=500" )//userDetails.avatar ?? "")
        backgroundImageURL = URL(string: "https://img0.baidu.com/it/u=1580032289,499658214&fm=253&fmt=auto&app=120&f=JPEG?w=500&h=500")//userDetails.backgroundImage ?? "")
    }
}
