//
//  CYZSDotNetAPIManager.h
//  CYZS
//
//  Created by Wei Li on 02/09/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//




@class RequestStatusData;

@interface CYZSDotNetAPIManager : NSObject


//生成函数数组
+ (NSArray *)createAPIFunctionsArray;



#pragma mark - User Controller API
//开应用获取版本更新信息
+ (void)getVersionWithBlock:(void (^)(RequestStatusData *result))block;

//切应用到前台init
+ (void)initInfoWithBlock:(void (^)(RequestStatusData *result))block;

//获取消息status (appDelegate中定时获取)
+ (void)getUnreadNotifyCountWithBlock:(void (^)(RequestStatusData *result))block;

////开应用注册APNS后发送Token
//+ (void)sendDeviceTokenWithToken:(NSString *)deviceToken
//                       withBlock:(void (^)(RequestStatusData *result))block;

//新用户注册
+ (void)registerWithBlock:(void (^)(RequestStatusData *result))block;

////用户修改密码
//+ (void)changePasswordFromOld:(NSString *)oldPassword
//                        toNew:(NSString *)newPassword
//                    withBlock:(void (^)(RequestStatusData *result))block;
//
////用户资料修改modifyUserInfo
//+ (void)modifyUserInfoWithEmail:(NSString *)email
//                   withNickname:(NSString *)nickname
//                   withBirthday:(NSInteger)birthday
//                     withGender:(NSInteger)gender
//                   withHomepage:(NSString *)homepage
//                withAvatarImage:(UIImage *)avatarImage
//              withAvatarBgImage:(UIImage *)avatarBgImage
//                      withBlock:(void (^)(RequestStatusData *result))block;

//检查昵称
+ (void)checkUserNicknameWithBlock:(void (^)(RequestStatusData *result))block;
////修改昵称
//+ (void)modifyUserNickname:(NSString *)nickname
//                 withBlock:(void (^)(RequestStatusData *result))block;
////修改签名
//+ (void)modifyUserSignature:(NSString *)signature
//                  withBlock:(void (^)(RequestStatusData *result))block;
////修改地区
//+ (void)modifyUserLocation:(NSString *)location
//                 withBlock:(void (^)(RequestStatusData *result))block;
//修改个人主页
+ (void)modifyUserHomepageWithBlock:(void (^)(RequestStatusData *result))block;


////修改QQ
//+ (void)modifyUserQQ:(long long)qq
//           withBlock:(void (^)(RequestStatusData *result))block;
////修改职业
//+ (void)modifyUserJob:(NSString *)job
//            withBlock:(void (^)(RequestStatusData *result))block;
////修改身高
//+ (void)modifyUserHeight:(NSInteger)height
//               withBlock:(void (^)(RequestStatusData *result))block;
////修改体重
//+ (void)modifyUserWeight:(NSInteger)weight
//               withBlock:(void (^)(RequestStatusData *result))block;
////修改性别
//+ (void)modifyUserGender:(NSInteger)gender
//               withBlock:(void (^)(RequestStatusData *result))block;
////修改生日
//+ (void)modifyUserBirthday:(NSInteger)birthday
//                 withBlock:(void (^)(RequestStatusData *result))block;


//用户登陆
+ (void)loginWithBlock:(void (^)(RequestStatusData *result))block;

//用户登出
+ (void)logoutWithBlock:(void (^)(RequestStatusData *result))block;

////忘记密码发送邮件
//+ (void)sendPasswordToEmail:(NSString *)email
//                  withBlock:(void (^)(RequestStatusData *result))block;

//获取用户信息
+ (void)getUserInfoWithBlock:(void (^)(RequestStatusData *result))block;
+ (void)getOtherUserInfoWithBlock:(void (^)(RequestStatusData *result))block;

//获取反馈列表
+ (void)getFeedBackListWithBlock:(void (^)(RequestStatusData *result))block;

//获取友情链接
+ (void)getLinksWithBlock:(void (^)(RequestStatusData *result))block;

////分享应用给朋友
//+ (void)shareAppToFriendsWithContent:(NSString *)content
//                           withBlock:(void (^)(RequestStatusData *result))block;
//
////匿名用户数据迁移
//+ (void)mergeDataWithAnonymousUserId:(NSInteger)fromUserId
//            withAnonymousUserSession:(NSString *)fromUserSessioin
//                           withBlock:(void (^)(RequestStatusData *result))block;


#pragma mark - Feed and Diary Controller
////同步日记
//+ (void)synchronizeDiaryData;

//获取所有日记ID
+ (void)getAllDiaryIdsWithBlock:(void (^)(RequestStatusData *result))block;

////获取一组日记信息
//+ (void)getFeedsInfoWithFeedIds:(NSArray *)feedIds
//                      withBlock:(void (^)(RequestStatusData *result))block;

//获取日记列表
+ (void)getDiaryListWithBlock:(void (^)(RequestStatusData *result))block;

////上传或修改日记
//+ (void)addOrModifyFeed:(NSNumber *)feedId
//              withImage:(UIImage *)image
//            withContent:(NSString *)content
//               withTags:(NSString *)tags
//           withColorIds:(NSString *)colorIds
//              withStyle:(NSString *)style
//            withCreated:(NSNumber *)created
//            withUpdated:(NSNumber *)updated
//          withIsPrivate:(BOOL)isPrivate
//            withMediaId:(NSInteger)mediaId
//              withBlock:(void (^)(RequestStatusData *result))block;
//
////删除日记
//+ (void)deleteFeeds:(NSArray *)feedIdsArray
//          withBlock:(void (^)(RequestStatusData *result))block;
//
////分享日记
//+ (void)shareDiaryWithFeedId:(NSNumber *)feedId
//                   withImage:(UIImage *)image
//                withPlatform:(NSArray *)platformArray
//                   withBlock:(void (^)(RequestStatusData *result))block;

//获取标签信息
+ (void)getTagsWithBlock:(void (^)(RequestStatusData *result))block;

#pragma mark - Pfeed Controller

//获取最新搭配印象
+ (void)getNewDressImpressWithBlock:(void (^)(RequestStatusData *result))block;

//获取最热搭配印象
+ (void)getHotDressImpressWithBlock:(void (^)(RequestStatusData *result))block;

//获取最热搭配印象
+ (void)getHotTypeDressImpressWithBlock:(void (^)(RequestStatusData *result))block;


//获取他人搭配印象列表
+ (void)getDressImpressListWithBlock:(void (^)(RequestStatusData *result))block;

//获取搭配印象详情
+ (void)getPfeedDetialWithBlock:(void (^)(RequestStatusData *result))block;

//获取搭配印象 评论列表
+ (void)getPfeedCommentListWithBlock:(void (^)(RequestStatusData *result))block;

//获取评论列表
+ (void)getPfeedVoteListWithBlock:(void (^)(RequestStatusData *result))block;

//评论搭配印象
//+ (void)commentPfeedWithFuserId:(NSInteger)fuserId
//                    withPfeedId:(NSInteger)pfeedId
//                    withContent:(NSString *)content
//              withReplyToUserId:(NSInteger)replyToUserId
//                      withBlock:(void (^)(RequestStatusData *result))block;

//投票(读过)搭配印象
+ (void)votePfeedWithBlock:(void (^)(RequestStatusData *result))block;

//分享搭配
//+ (void)sharePfeedWithImage:(UIImage *)image
//                withPfeedId:(NSNumber *)pfeedId
//          withCreaterUserId:(NSNumber *)userId
//            withPlatformIds:(NSArray *)platformIds
//                withContent:(NSString *)content
//                  withBlock:(void (^)(RequestStatusData *result))block;

//获取关注的未读数量
+ (void)getUnreadFollowListCountWithBlock:(void (^)(RequestStatusData *result))block;

//获取关注的搭配印象
+ (void)getPfeedFollowListWithBlock:(void (^)(RequestStatusData *result))block;


#pragma mark - Tag Controller

//获取最热标签列表
+ (void)getTagHotListWithBlock:(void (^)(RequestStatusData *result))block;

#pragma mark - Media Controller

//获取标签的最热最新列表
+ (void)getNewGoodsWithBlock:(void (^)(RequestStatusData *result))block;
+ (void)getHotGoodsWithBlock:(void (^)(RequestStatusData *result))block;
+ (void)getMediaListWithBlock:(void (^)(RequestStatusData *result))block;
+ (void)getMediaWithBlock:(void (^)(RequestStatusData *result))block;
//+ (void)collectWithMediaId:(NSInteger)mediaId
//                withSuitId:(NSInteger)suitId
//               withGoodsId:(NSInteger)goodsId
//                 withBlock:(void (^)(RequestStatusData *result))block;
//+ (void)removeWithMediaId:(NSInteger)mediaId
//               withSuitId:(NSInteger)suitId
//              withGoodsId:(NSInteger)goodsId
//                withBlock:(void (^)(RequestStatusData *result))block;
+ (void)getCollectListWithBlock:(void (^)(RequestStatusData *result))block;
//+ (void)shareMedia:(NSInteger)mediaid
//   withPlatformIds:(NSArray *)platformIds
//         withBlock:(void (^)(NSError *error))block;
+ (void)getGoodsWithBlock:(void (^)(RequestStatusData *result))block;
+ (void)getSuitListWithBlock:(void (^)(RequestStatusData *result))block;
+ (void)getSuitCommentListWithBlock:(void (^)(RequestStatusData *result))block;
//+ (void)commentSuitWithMediaId:(NSInteger)mediaId
//                    withSuitId:(NSInteger)suitId
//                   withComment:(NSString *)comment
//             withReplyToUserId:(NSInteger)replyToUserId
//                     withBlock:(void (^)(RequestStatusData *result))block;
//+ (void)collectSuitWithMediaId:(NSInteger)mediaId
//                    withSuitId:(NSInteger)suitId
//                     withBlock:(void (^)(RequestStatusData *result))block;
//+ (void)removeCollectSuitWithMediaId:(NSInteger)mediaId
//                          withSuitId:(NSInteger)suitId
//                           withBlock:(void (^)(RequestStatusData *result))block;
+ (void)getCollectSuitListWithBlock:(void (^)(RequestStatusData *result))block;
//+ (void)shareSuitWithMediaId:(NSInteger)mediaId
//                  withSuitId:(NSInteger)suitId
//             withPlatformIds:(NSArray *)platformIds
//                   withBlock:(void (^)(RequestStatusData *result))block;
//+ (void)commentMediaWithMediaId:(NSInteger)mediaId
//                    withComment:(NSString *)comment
//              withReplyToUserId:(NSInteger)replyToUserId
//                      withBlock:(void (^)(RequestStatusData *result))block;
+ (void)getMediaCommentListWithBlock:(void (^)(RequestStatusData *result))block;
+ (void)getHotPfeedListWithBlock:(void (^)(RequestStatusData *result))block;
+ (void)getNewlyPfeedListWithBlock:(void (^)(RequestStatusData *result))block;

#pragma mark - Talent Controller

//达人广场
+ (void)getTalentSquareWithBlock:(void (^)(RequestStatusData *result))block;

//获取最新达人列表
+ (void)getRecentTalentListWithBlock:(void (^)(RequestStatusData *result))block;

//获取达人申请状态
+ (void)getApplyTalentStatusWithBlock:(void (^)(RequestStatusData *result))block;

//申请达人
//+ (void)applyTalentWithBlock:(void (^)(RequestStatusData *result))block;

//新晋达人列表
+ (void)getTalentNewListWithBlock:(void (^)(RequestStatusData *result))block;

//一周人气达人
+ (void)getTalentWeekyListWithBlock:(void (^)(RequestStatusData *result))block;

//达人总榜
+ (void)getTalentOveralListWithBlock:(void (^)(RequestStatusData *result))block;

//风格达人列表
+ (void)getStyleListWithBlock:(void (^)(RequestStatusData *result))block;

//时尚店主、时尚红人
+ (void)getRoleListWithBlock:(void (^)(RequestStatusData *result))block;

//每日推荐达人
+ (void)getDailyRecommendListWithBlock:(void (^)(RequestStatusData *result))block;

#pragma mark - Social Controller
//关注某人
//+ (void)followWithUserId:(NSInteger)targetUserId
//               withBlock:(void (^)(RequestStatusData *result))block;

//取消关注
//+ (void)unfollowWithUserId:(NSInteger)targetUserId
//                 withBlock:(void (^)(RequestStatusData *result))block;

//移除粉丝
//+ (void)removeFansWithUserId:(NSInteger)targetUserId
//                   withBlock:(void (^)(RequestStatusData *result))block;

//获得关注列表
+ (void)getFollowListWithBlock:(void (^)(RequestStatusData *result))block;

//获得粉丝列表
+ (void)getFansListWithBlock:(void (^)(RequestStatusData *result))block;

#pragma mark - Notify Controller
//获取消息列表
+ (void)getNotifyListWithBlock:(void (^)(RequestStatusData *result))block;

//获取未读消息列表
+ (void)getUnreadNotifyWithBlock:(void (^)(RequestStatusData *result))block;

//读某条消息
//+ (void)readNotifyWithNoticeId:(NSInteger)noticeId
//                     withBlock:(void (^)(RequestStatusData *result))block;

//消息全部已读
+ (void)resetNotifyWithBlock:(void (^)(RequestStatusData *result))block;



@end
