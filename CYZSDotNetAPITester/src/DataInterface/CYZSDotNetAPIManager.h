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

//新用户注册
+ (void)registerWithBlock:(void (^)(RequestStatusData *result))block;

//用户修改密码
+ (void)changePasswordWithBlock:(void (^)(RequestStatusData *result))block;

//用户资料修改modifyUserInfo
+ (void)modifyUserInfoWithBlock:(void (^)(RequestStatusData *result))block;

//检查昵称
+ (void)checkUserNicknameWithBlock:(void (^)(RequestStatusData *result))block;

//用户登陆
+ (void)loginWithBlock:(void (^)(RequestStatusData *result))block;

//用户登出
+ (void)logoutWithBlock:(void (^)(RequestStatusData *result))block;

//忘记密码发送邮件
+ (void)sendPasswordToEmailWithBlock:(void (^)(RequestStatusData *result))block;

//获取用户信息
+ (void)getUserInfoWithBlock:(void (^)(RequestStatusData *result))block;
+ (void)getOtherUserInfoWithBlock:(void (^)(RequestStatusData *result))block;

//获取反馈列表
+ (void)getFeedBackListWithBlock:(void (^)(RequestStatusData *result))block;

//获取友情链接
+ (void)getLinksWithBlock:(void (^)(RequestStatusData *result))block;

#pragma mark - Suit Controller
//获取自己或他人的suit List
+ (void)getSuitListWithBlock:(void (^)(RequestStatusData *result))block;

//获取所有SuitID(日记)
+ (void)getAllSuitIdsWithBlock:(void (^)(RequestStatusData *result))block;

//上传或修改日记
+ (void)addOrModifySuitWithBlock:(void (^)(RequestStatusData *result))block;

//删除搭配(日记)
+ (void)deleteSuitsWithBlock:(void (^)(RequestStatusData *result))block;


#pragma mark - Pfeed Controller

//获取热门搭配 （包括热门风格）
+ (void)getHotSuitWithBlock:(void (^)(RequestStatusData *result))block;

//获取最新搭配印象
+ (void)getNewSuitListWithBlock:(void (^)(RequestStatusData *result))block;

//获取搭配详情
+ (void)getSuitDetailWithBlock:(void (^)(RequestStatusData *result))block;


//评论列表
+ (void)getSuitCommentListWithBlock:(void (^)(RequestStatusData *result))block;

//获取收藏的人的列表
+ (void)getCollectUserListWithBlock:(void (^)(RequestStatusData *result))block;

//收藏与取消收藏
+ (void)collectSuitWithBlock:(void (^)(RequestStatusData *result))block;

+ (void)deCollectSuitWithBlock:(void (^)(RequestStatusData *result))block;

//获取关注的未读数量
+ (void)getUnreadFollowListCountWithBlock:(void (^)(RequestStatusData *result))block;;

//获取关注的搭配印象
+ (void)getFollowSuitListWithBlock:(void (^)(RequestStatusData *result))block;


#pragma mark - Tag Controller
//获取标签列表
+ (void)getTagsWithBlock:(void (^)(RequestStatusData *result))block;

//获取逛街顶部广告
+ (void)getAdvertisementInShoppingWithBlock:(void (^)(RequestStatusData *result))block;


#pragma mark - Goods Controller
//按照标签获取最热或最新单品
+ (void)getGoodsListByTagWithBlock:(void (^)(RequestStatusData *result))block;

//获取最热或最新单品列表
+ (void)getGoodsListWithBlock:(void (^)(RequestStatusData *result))block;

//获取商品详情
+ (void)getGoodsInfoWithBlock:(void (^)(RequestStatusData *result))block;

//收藏商品
+ (void)collectGoodsWithBlock:(void (^)(RequestStatusData *result))block;

//取消收藏商品
+ (void)decollectGoodsWithBlock:(void (^)(RequestStatusData *result))block;

//获取收藏商品列表
+ (void)getCollectGoodsListWithBlock:(void (^)(RequestStatusData *result))block;


#pragma mark - Media Controller

+ (void)getMediaListWithBlock:(void (^)(RequestStatusData *result))block;
+ (void)getMediaWithBlock:(void (^)(RequestStatusData *result))block;
+ (void)getCollectSuitListWithBlock:(void (^)(RequestStatusData *result))block;
+ (void)getMediaCommentListWithBlock:(void (^)(RequestStatusData *result))block;
//用户相关的媒体相关搭配
+ (void)getHotSuitListWithBlock:(void (^)(RequestStatusData *result))block;

+ (void)getNewlySuitListWithBlock:(void (^)(RequestStatusData *result))block;

#pragma mark - Talent Controller

//达人广场
+ (void)getTalentSquareWithBlock:(void (^)(RequestStatusData *result))block;

//获取达人申请状态
+ (void)getApplyTalentStatusWithBlock:(void (^)(RequestStatusData *result))block;

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
+ (void)followWithBlock:(void (^)(RequestStatusData *result))block;

//取消关注
+ (void)unfollowWithBlock:(void (^)(RequestStatusData *result))block;

//获得关注列表
+ (void)getFollowListWithBlock:(void (^)(RequestStatusData *result))block;

//获得粉丝列表
+ (void)getFansListWithBlock:(void (^)(RequestStatusData *result))block;

#pragma mark - Notify Controller
//获取消息列表
+ (void)getNotifyListWithBlock:(void (^)(RequestStatusData *result))block;

//获取未读消息列表
+ (void)getUnreadNotifyWithBlock:(void (^)(RequestStatusData *result))block;

//消息全部已读
+ (void)resetNotifyWithBlock:(void (^)(RequestStatusData *result))block;

//获取消息防打扰状态
+ (void)getNotifyAntiDisturbWithBlock:(void (^)(RequestStatusData *result))block;

//设置消息防打扰状态
+ (void)setNotifyAntiDisterbWithBlock:(void (^)(RequestStatusData *result))block;

#pragma mark - styleController
//获取热门style
+ (void)getHotStyleListWithBlock:(void (^)(RequestStatusData *result))block;

@end
