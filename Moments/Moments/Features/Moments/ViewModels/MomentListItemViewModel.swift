//
//  MomentListItemViewModel.swift
//  Moments
//
//  Created by wjw on 2025/5/28.
//

import Foundation
import RxSwift

struct MomentListItemViewModel: ListItemViewModel {
    let userAvatarURL: URL?
    let userName: String
    let title: String?
    let photoURL: URL?  //
    let postDateDescription: String?
    let isLiked: Bool
    let likes:[URL]
    
    private let momentID: String
    private let momentsRepo: MomentsRepoType
    //todo 埋点
//    private let trackingRepo: TrackingRepoType
    
    init(moment: MomentsDetails.Moment, momentsRepo: MomentsRepoType = MomentsRepo.shared,
//         trackingRepo: TrackingRepoType = TrackingRepo.shared,
         now: Date = Date(),
         relativeDateTimeFormatter: RelativeDateTimeFormatterType = RelativeDateTimeFormatter()
    ){
        momentID =  String(moment.id)
        self.momentsRepo = momentsRepo
//        self.trackingRepo = trackingRepo
        userAvatarURL = URL(string: moment.avatarUrl ?? "https://img2.baidu.com/it/u=2134545535,769157496&fm=253&fmt=auto&app=120&f=JPEG?w=500&h=500")
        userName = moment.userName
        title = String(moment.title)
        isLiked = true// moment.isLiked ?? false
        likes = []// moment.likes?.compactMap { URL(string: $0.avatar )} ?? []
        
//        if let firstPhoto = moment.photo?.first {
//            photoURL = URL(string: firstPhoto)
//        }else {
//            photoURL = nil
//        }
        photoURL = URL(string: "https://img2.baidu.com/it/u=2148062273,1464870050&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=500")
        
        var formatter = relativeDateTimeFormatter
        formatter.unitsStyle = .full
        if let timeInterval = TimeInterval(moment.createdDate) {
            let createdDate = Date(timeIntervalSince1970: timeInterval)
            postDateDescription = formatter.localizedString(for: createdDate, relativeTo: now)
        }else {
            postDateDescription = nil
        }
    }
    
    func like(from userID: String) -> Observable<Void> {
        //todo - event tracking
//        trackingRepo.trackAction(LikeActionTrackingEvent(momentID: momentID, userID: userID))
        return momentsRepo.updateLike(isLiked: true, momentID: momentID, fromUserID: userID)
    }
    
    func unlike(from userID: String) -> Observable<Void> {
//        trackingRepo.trackAction(UnlikeActionTrackingEvent(momentID: momentID, userID: userID))
        return momentsRepo.updateLike(isLiked: false, momentID: momentID, fromUserID: userID)
    }

}
