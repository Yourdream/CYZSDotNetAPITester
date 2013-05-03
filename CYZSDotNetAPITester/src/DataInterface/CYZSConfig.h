//
//  CYZSConfig.h
//  CYZS
//
//  Created by Wei Li on 12-8-1.
//  Copyright (c) 2012年 Yourdream. All rights reserved.
//

#ifndef CYZS_CYZSConfig_h
#define CYZS_CYZSConfig_h


#if DEBUG
    #define API_URL                             @"http://apitest.yourdream.cc/api.php"
    #define API_BASE_URL                        @"http://apitest.yourdream.cc/"
    #define IMAGE_SERVER_URL                    @"http://test.image.yourdream.cc/"
#else
#define API_URL                             @"http://cyzs.yourdream.cc/api.php"
#define API_BASE_URL                        @"http://cyzs.yourdream.cc/"
#define IMAGE_SERVER_URL                    @"http://image.yourdream.cc/"
#endif

#define API_PATH                            @"api.php"

#define CLIENT_VERSION                      @"2.2.0"
#define API_VERSION                         @"2.0"

#define ITUNES_URL                          @"https://itunes.apple.com/app/chuan-yi-zhu-shou-shi-shang/id577700263?ls=1&mt=8"
#define ITUNES_EVALUATE_URL                 @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=577700263"
#define CAMERA360_URL                       @"http://t.cn/zlbjLNg"
#define WEIXIN_CYZS_URL                     @"http://weixin.qq.com/r/PHUnKM3ErvPRh9xLnyAY"

#define TAOBAO_TTID                         @"400000_21267574@cyzs_iPhone_2.2.0"

#pragma mark - NSUserDefaults Key
#define USER_DEFAULTS_KEY_IMAGE_URL         @"imageBaseURL"
#define USER_DEFAULTS_KEY_EMAIL             @"email"
#define USER_DEFAULTS_KEY_UID               @"uerId"
#define USER_DEFAULTS_KEY_SESSION           @"session"
#define USER_DEFAULTS_KEY_UID_ANONYMOUS     @"uerIdAnonymous"
#define USER_DEFAULTS_KEY_SESSION_ANONYMOUS @"sessionAnonymous"
#define USER_DEFAULTS_KEY_PASSWORD          @"password"
#define USER_DEFAULTS_KEY_NEW_VERSION       @"newVersion"  //新的版本号
#define USER_DEFAULTS_KEY_CAMERA_TYPE       @"cameraType"  //拍照时摄像头状态，是前置还是后置摄像头
#define USER_DEFAULTS_KEY_ANONYMOUS_FAILED  @"USER_DEFAULTS_KEY_ANONYMOUS_FAILED"

#define USER_DEFAULTS_KEY_ANONYMOUS_HAPPENED @"USER_DEFAULTS_KEY_ANONYMOUS_HAPPENED"

#pragma mark - NSNotificationCenter Names
#define NETWORK_CONNECTION_ERROR            @"NETWORK_CONNECTION_ERROR"
//tutorial key
#define TUTORIAL_HAVE_POSTED_IMPRESS        @"TUTORIAL_HAVE_POSTED_IMPRESS"
#define TUTORIAL_DESIGN_COUNT_is_0          @"TUTORIAL_DESIGN_COUNT_is_0"
#define TUTORIAL_DESIGN_COUNT_is_1          @"TUTORIAL_DESIGN_COUNT_is_1"
#define TUTORIAL_HAVE_RECORDED_DIARY        @"TUTORIAL_HAVE_RECORDED_DIARY"

//媒体主题上传搭配后通知
#define UPLOAD_MEDIA_IMPRESS_DONE           @"UPLOAD_MEDIA_IMPRESS_DONE"

//每日提醒key
#define DIARY_NOTICE_STATUS                 @"DIARY_NOTICE_STATUS"

//活动通知key
#define LAST_ADVERTISEMENT_ID               @"LAST_ADVERTISEMENT_ID"
#define LAST_HOT_ADV_ID                     @"LAST_HOT_ADV_ID"

//标签key
#define DRESS_TAGS_UPDATED                  @"tagsUpdated"
#define DRESS_TAGS_LOCAL_UPDATED            @"tagsLocalUpdated"
#define DRESS_TAGS_SYNC_DONE                @"DRESS_TAGS_SYNC_DONE"

#define GET_HOT_TAGS                        @"get_hot_tags"
// anonymous
#define ANONYMOUS_LOGIN_DONE                @"ANONYMOUS_LOGIN_DONE"

// login
#define SESSION_WRONG                       @"SESSION_WRONG"

//sync data
#define DOWNLOAD_DIARY_SUCCESS              @"DOWNLOAD_DIARY_SUCCESS"
#define SHOW_SYNC_NOTICE                    @"SHOW_SYNC_NOTICE"

//get notify
#define GET_INIT_SUCCESS                    @"GET_INIT_SUCCESS"
#define GET_UNREAD_NOTIFY_COUNT_SUCCESS     @"GET_UNREAD_NOTIFY_COUNT_SUCCESS"

//
#define JSON_KEY_RESULT                     @"result"
#define JSON_KEY_METHOD                     @"method"

// login & user info
#define REQUEST_METHOD_LOGIN                @"user.login"
#define REQUEST_METHOD_SENDPASSWORD         @"user.sendPasswordToEmail"
#define REQUEST_METHOD_SSOLOGIN             @"user.initByAccessToken"
#define REQUEST_METHOD_GETUSERINFO          @"user.getUserInfo"
#define REQUEST_METHOD_CHECKNAME            @"user.checkNickname"
#define REQUEST_METHOD_MODIFYINFO           @"user.modifyInfo"
#define REQUEST_METHOD_CHANGEPASSWORD       @"user.changeUserPassword"
#define REQUEST_METHOD_GETLINKS             @"user.getLinks"
#define REQUEST_METHOD_DATAMERGE            @"user.dataMergeIn"

#define REQUEST_METHOD_GETVERSION           @"user.preLoginInit"
#define REQUEST_METHOD_FEEDBACK             @"user.feedback"

//feedBack
#define REQUEST_METHOD_FEEDBACK_GETLIST     @"feedback.getList"

// logout
#define REQUEST_METHOD_LOGOUT               @"user.logout"

//同步数据
#define REQUEST_METHOD_GETTAGS              @"tag.getList"
#define REQUEST_METHOD_GETADVERTISEMENT     @"tag.getAdvertisement"

// register
#define REQUEST_METHOD_RESIGSTER            @"user.register"

//social
#define REQUEST_METHOD_SOCIAL_FOLLOW        @"social.follow"
#define REQUEST_METHOD_SOCIAL_UNFOLLOW      @"social.unfollow"
#define REQUEST_METHOD_SOCIAL_REMOVEFANS    @"social.removeFans"
#define REQUEST_METHOD_SOCIAL_GETFANSLIST   @"social.getFansList"
#define REQUEST_METHOD_SOCIAL_GETFOLLOWLIST @"social.getFollowList"

//social
#define REQUEST_METHOD_SOCIAL_GETSTATUSLIST             @"social.getStatusList"
#define REQUEST_METHOD_SOCIAL_GETUNREADSTATUSCOUNT      @"social.getUnreadStatusCount"

//suit
#define REQUEST_METHOD_SUIT_ALLIDS          @"suit.getAllSuitIds"
#define REQUEST_METHOD_SUIT_INFOBYIDS       @"suit.getInfoByIds"
#define REQUEST_METHOD_SUIT_GETLIST         @"suit.getList"
#define REQUEST_METHOD_SUIT_SET             @"suit.set"
#define REQUEST_METHOD_SUIT_DELETE          @"suit.delete"
#define REQUEST_METHOD_SUIT_SHARE           @"suit.share"
#define REQUEST_METHOD_SUIT_GETHOT          @"suit.getHot"
#define REQUEST_METHOD_SUIT_GETINFO         @"suit.getInfo"
#define REQUEST_METHOD_SUIT_COMMENT_LIST    @"suit.getCommentList"
#define REQUEST_METHOD_SUIT_COLLECT_USER_LIST    @"suit.getCollectUserList"
#define REQUEST_METHOD_SUIT_GETNEW          @"suit.getNew"
#define REQUEST_METHOD_SUIT_COMMENT         @"suit.comment"
#define REQUEST_METHOD_SUIT_COLLECT         @"suit.collectSuit"
#define REQUEST_METHOD_SUIT_DECOLLECT       @"suit.decollectSuit"
#define REQUEST_METHOD_SUIT_COLLECT_LIST    @"suit.getCollectSuitList"

//goods
#define REQUEST_METHOD_GOODS_GETLISTBYTAG   @"goods.getListByTag"
#define REQUEST_METHOD_GOODS_GETLIST        @"goods.getList"
#define REQUEST_METHOD_GOODS_GETINFO        @"goods.getInfo"
#define REQUEST_METHOD_GOODS_COLLECT        @"goods.collect"
#define REQUEST_METHOD_GOODS_DECOLLECT      @"goods.decollect"
#define REQUEST_METHOD_GOODS_GETCOLLECTLIST @"goods.getCollectList"
#define REQUEST_METHOD_GOODS_SHARE          @"goods.share"

//user pic

#define REQUEST_METHOD_FEEDSHARE            @"diary.share"
#define REQUEST_METHOD_DIARY_GETLIST        @"diary.getList"

//dress impress
#define REQUEST_METHOD_IMPRESS_GETNEW       @"pfeed.getNew"
#define REQUEST_METHOD_IMPRESS_GETHOT       @"pfeed.getHot"
#define REQUEST_METHOD_IMPRESS_GETLIST      @"pfeed.getList"
#define REQUEST_METHOD_IMPRESS_DETAIL       @"pfeed.getInfo"
#define REQUEST_METHOD_IMPRESS_COMMENT      @"pfeed.comment"
#define REQUEST_METHOD_IMPRESS_VOTE         @"pfeed.vote"
#define REQUEST_METHOD_IMPRESS_UNREADCOUNT  @"pfeed.getUnreadFollowCount"
#define REQUEST_METHOD_IMPRESS_FOLLOWLIST   @"pfeed.getFollowList"
#define REQUEST_METHOD_IMPRESS_COMMENTLIST  @"pfeed.getCommentList"
#define REQUEST_METHOD_IMPRESS_VOTE_LIST    @"pfeed.getVoteList"

//notify
#define REQUEST_METHOD_INITINFO             @"user.init"
#define REQUEST_METHOD_UNREADNOTIFYCOUNT    @"user.getUnreadNotifyCount"
#define REQUEST_METHOD_GETNOTIFYLIST        @"notify.getList"
#define REQUEST_METHOD_GETUNREADNOTIFY      @"user.getUnreadNotify"
#define REQUEST_METHOD_READ_NOTIFY          @"notify.read"
#define REQUEST_METHOD_RESET_NOTIFY         @"user.resetNotify"
#define REQUEST_METHOD_NOTIFY_GETANTI       @"notify.getAntiDisturb"
#define REQUEST_METHOD_NOTIFY_SETANTI       @"notify.setAntiDisturb"

//style
#define REQUEST_METHOD_STYLE_GETHOT         @"style.getHot"

#define REQUEST_METHOD_GET_ADVERTISEMENT    @"advertisement.get"


//media
#define REQUEST_METHOD_MEDIA_LIST           @"media.getList"
#define REQUEST_METHOD_GET_MEDIA            @"media.getMedia"
#define REQUEST_METHOD_MEDIA_COLLECT        @"media.collect"
#define REQUEST_METHOD_MEDIA_REMOVECOLLECT  @"media.removeCollect"
#define REQUEST_METHOD_COLLECT_LIST         @"media.getCollectList"
#define REQUEST_METHOD_MEDIA_SHARE          @"media.share"
#define REQUEST_METHOD_GET_HOT_TAG_GOODS    @"media.getGoodsByTagSortByCollectCount"
#define REQUEST_METHOD_GET_SUIT_GOODS       @"media.getGoodsListBySuitId"
#define REQUEST_METHOD_GET_SUIT_LIST        @"media.getSuitList"
#define REQUEST_METHOD_GET_SUIT_COMMENT     @"media.getSuitCommentList"
#define REQUEST_METHOD_COMMENT_SUIT         @"media.commentSuit"
#define REQUEST_METHOD_MEDIA_SUIT_COLLECT   @"media.collectSuit"
#define REQUEST_METHOD_MEDIASUIT_SHARE      @"media.shareSuit"
#define REQUEST_METHOD_SUIT_REMOVECOLLECT   @"media.removeCollectSuit"
#define REQUEST_METHOD_COLLECT_SUIT_LIST    @"media.getCollectSuitList"
#define REQUEST_METHOD_COMMENT_MEDIA        @"media.commentMedia"
#define REQUEST_METHOD_GET_MEDIA_COMMENT    @"media.getCommentList"
#define REQUEST_METHOD_MEDIA_HOT_LIST       @"media.getHotPfeedList"
#define REQUEST_METHOD_MEDIA_NEW_LIST       @"media.getNewlyPfeedList"
#define REQUEST_METHOD_MEDIA_HOT_SUIT_LIST  @"media.getHotSuitList"
#define REQUEST_METHOD_MEDIA_NEW_SUIT_LIST  @"media.getNewlySuitList"

//hot tag
#define REQUEST_METHOD_HOT_TAGS             @"tag.getHotList"

//talent
#define REQUEST_METHOD_TALENT_SQUARE        @"talent.square"
#define REQUEST_METHOD_TALENT_RECENTLIST    @"talent.getRecentList"
#define REQUEST_METHOD_TALENT_GETSTATUS     @"talent.getApplyStatus"
#define REQUEST_METHOD_TALENT_APPLY         @"talent.apply"
#define REQUEST_METHOD_TALENT_NEWLIST       @"talent.getNewUserList"
#define REQUEST_METHOD_TALENT_WEEKLYLIST    @"talent.getWeekTopUserList"
#define REQUEST_METHOD_TALENT_OVERALLIST    @"talent.getTopUserList"
#define REQUEST_METHOD_TALENT_STYLELIST     @"talent.getStyleList"
#define REQUEST_METHOD_TALENT_ROLELIST      @"talent.getRoleList"
#define REQUEST_METHOD_TALENT_DAILY_LIST    @"talent.getDailyRecommendList"

// weibo

#define REQUEST_METHOD_APPSSHARE            @"platform.share"
#define BIND_APP_SUCCESS                    @"BIND_APP_SUCCESS"
#define BIND_APP_FAILED                     @"BIND_APP_FAILED"
#define BIND_APP_EXISTED                    @"BIND_APP_EXISTED"
#define CANCEL_APP_AUTH                     @"CANCEL_APP_AUTH"
#define SSO_AUTH_FAILED                     @"SSO_AUTH_FAILED"
#define SSO_GET_UID_FAILED                  @"SSO_GET_UID_FAILED"
#define SHARE_PIC_UNBIND                    @"SHARE_PIC_UNBIND"
#define SHARE_PIC_SUCCESS                   @"SHARE_PIC_SUCCESS"
#define SHARE_PIC_FAILED                    @"SHARE_PIC_FAILED"
#define SHARE_PIC_REPEATE                   @"SHARE_PIC_REPEATE"

#pragma mark - JsonKey

#define JSON_KEY_UID                        @"userId"
#define JSON_KEY_ADMIN_UID                  @"adminUserId"
#define JSON_KEY_NICKNAME                   @"userNickname"
#define JSON_KEY_NAME                       @"username"
#define JSON_KEY_ISTALENT                   @"isTalent"
#define JSON_KEY_TALENTDESCRIPTION          @"talentDescription"
#define JSON_KEY_EMAIL                      @"userEmail"
#define JSON_KEY_EMAILORNICKNAME            @"userEmailOrNickname"
#define JSON_KEY_PASSWORD                   @"userPassword"
#define JSON_KEY_BIRTHDAY                   @"userBirthday"
#define JSON_KEY_GENDER                     @"userSex"
#define JSON_KEY_HEAD_PIC                   @"userAvatar"
#define JSON_KEY_AVATAR                     @"avatar"
#define JSON_KEY_BG_PIC                     @"userAvatarBackground"
#define JSON_KEY_HOMEPAGE                   @"homepage"
#define JSON_KEY_DEVICE                     @"device"
#define JSON_KEY_SESSION                    @"session"
#define JSON_KEY_FIELDS                     @"fields"
#define JSON_KEY_CONTENT                    @"content"
#define JSON_KEY_OLDPASSWORD                @"oldUserPassword"
#define JSON_KEY_NEWPASSWORD                @"newUserPassword"
#define JSON_KEY_SIGNATURE                  @"userSignature"
#define JSON_KEY_PFEEDCOUNT                 @"pfeedCount"
#define JSON_KEY_COMMENTCOUNT               @"commentCount"
#define JSON_KEY_OAUTHINFO                  @"oauthInfo"
#define JSON_KEY_LOCATION                   @"location"
#define JSON_KEY_JOB                        @"job"
#define JSON_KEY_QQ                         @"qq"
#define JSON_KEY_PFEEDALLVOTECOUNT          @"pfeedBeGoodCount"
#define JSON_KEY_GOODCOUNT                  @"goodCount"
#define JSON_KEY_COLLECTGOODSCOUNT          @"collectCount"
#define JSON_KEY_COLLECTSUITCOUNT           @"collectSuitCount"
#define JSON_KEY_HEIGHT                     @"height"
#define JSON_KEY_WEIGHT                     @"weight"
#define JSON_KEY_FOLLOWCOUNT                @"followCount"
#define JSON_KEY_FANSCOUNT                  @"fansCount"
#define JSON_KEY_UNREAD_FANSCOUNT           @"unreadFansCount"
#define JSON_KEY_FOLLOWLIST                 @"followList"
#define JSON_KEY_FANSLIST                   @"fansList"
#define JSON_KEY_CREATETIME                 @"createTime"
#define JSON_KEY_CREATED                    @"created"
#define JSON_KEY_ISFOLLOWED                 @"isFollowed"
#define JSON_KEY_ISFANS                     @"isFans"

#define JSON_KEY_SOCIAL_TARGETUSERID        @"targetUserId"
#define JSON_KEY_SOCIAL_VIEWUSERID          @"viewUserId"

#define JSON_KEY_TALENT_SQUARE_DAILY        @"dailyRecommendTalent"
#define JSON_KEY_TALENT_SQUARE_POPULAR      @"fashionPopular"
#define JSON_KEY_TALENT_SQUARE_SHOPKEEPER   @"fashionHost"
#define JSON_KEY_TALENT_SQUARE_SWEET        @"sweet"
#define JSON_KEY_TALENT_SQUARE_RETRO        @"ancient"
#define JSON_KEY_TALENT_SQUARE_KOREA        @"eastAsian"
#define JSON_KEY_TALENT_SQUARE_WESTERN      @"western"
#define JSON_KEY_TALENT_SQUARE_SOFTLY       @"softly"

#define JSON_KEY_TALENT_USERID              @"userId"
#define JSON_KEY_TALENT_SORT                @"sort"
#define JSON_KEY_TALENT_USERNICKNAME        @"username"
#define JSON_KEY_TALENT_USERAVATAR          @"avatar"
#define JSON_KEY_TALENT_JOINTIME            @"beTalentTime"
#define JSON_KEY_TALENT_SCORE               @"score"
#define JSON_KEY_TALENT_GOODCOUNT           @"goodCount"
#define JSON_KEY_TALENT_SUITCOUNT           @"suitCount"
#define JSON_KEY_TALENT_COMMENTCOUNT        @"commentCount"
#define JSON_KEY_TALENT_VOTECOUNT           @"voteCount"
#define JSON_KEY_TALENT_REGISTERTIME        @"registerTime"
#define JSON_KEY_TALENT_FANSCOUNT           @"fansCount"
#define JSON_KEY_TALENT_SUITNEWLIST         @"newSuitList"
#define JSON_KEY_TALENT_SUITHOTLIST         @"hotSuitList"
#define JSON_KEY_TALENT_IMAGE               @"image"
#define JSON_KEY_TALENT_STYLE               @"style"
#define JSON_KEY_TALENT_ROLE                @"role"
#define JSON_KEY_TALENT_RECOMMENT_COMMENT   @"recommendComment"
#define JSON_KEY_TALENT_SIGNATURE           @"signature"

#define JSON_KEY_PIC_ID                     @"picId"
#define JSON_KEY_PIC_WIDTH                  @"picWidth"
#define JSON_KEY_PIC_HEIGHT                 @"picHeight"

#define JSON_KEY_DIARY_ID                   @"feedId"
#define JSON_KEY_SUIT_ALLIDS                @"suitIds"
#define JSON_KEY_SUIT_IMAGEFILE             @"image"
#define JSON_KEY_DIARY_CONTENT              @"content"
#define JSON_KEY_DIARY_TAGS                 @"tag"
#define JSON_KEY_DIARY_COLORIDS             @"colors"
#define JSON_KEY_DIARY_STYLE                @"style"
#define JSON_KEY_DIARY_CREATED              @"created"
#define JSON_KEY_DIARY_UPDATED              @"updated"
#define JSON_KEY_DIARY_ISPRIVATE            @"isPrivate"
#define JSON_KEY_DIARY_MEDIAID              @"mediaId"
#define JSON_KEY_DIARY_ISHOT                @"isHot"
#define JSON_KEY_SUIT_PLATFORMIDS           @"shareToPlatformIds"
#define JSON_KEY_DIARY_PAGE                 @"page"
#define JSON_KEY_DIARY_PAGESIZE             @"pageSize"
#define JSON_KEY_DIARY_STATUS               @"status"
#define JSON_KEY_DIARY_VID                  @"vId"
#define JSON_KEY_DIARY_PFEEDID              @"pfeedId"
#define JSON_KEY_DIARY_COMMENTCOUNT         @"commentCount"
#define JSON_KEY_DIARY_VOTEONECOUNT         @"vote1Count"
#define JSON_KEY_DIARY_VOTETWOCOUNT         @"vote2Count"
#define JSON_KEY_DIARY_READCOUNT            @"readCount"
#define JSON_KEY_DIARY_PIC_DESCRIPTION      @"pic"
#define JSON_KEY_DIARY_PIC_ADDRESS          @"picAddress"
#define JSON_KEY_DIARY_SHAREDPIC_ADDRESS    @"sharedPicAddress"

#define JSON_KEY_IMPRESS_TYPE               @"type"
#define JSON_KEY_IMPRESS_CONTENT            @"content"
#define JSON_KEY_IMPRESS_REPLYTOUSERID      @"replyToUserId"
#define JSON_KEY_IMPRESS_PICFILE            @"pic"
#define JSON_KEY_IMPRESS_LIMIT              @"limit"
#define JSON_KEY_IMPRESS_PAGE               @"page"
#define JSON_KEY_IMPRESS_EXCLUDEPFEEDIDS    @"excludePfeedIds"
#define JSON_KEY_IMPRESS_PFEEDID            @"pfeedId"
#define JSON_KEY_IMPRESS_FEEDID             @"feedId"
#define JSON_KEY_IMPRESS_CREATERUSERID      @"creatorUserId"
#define JSON_KEY_IMPRESS_PICURL             @"pic"
#define JSON_KEY_IMPRESS_IMAGE              @"image"
#define JSON_KEY_IMPRESS_READCOUNT          @"readCount"
#define JSON_KEY_IMPRESS_COMMENTCOUNT       @"commentCount"
#define JSON_KEY_IMPRESS_ISVOTED            @"isVoted"
#define JSON_KEY_IMPRESS_VOTEONECOUNT       @"vote1Count"
#define JSON_KEY_IMPRESS_GOODCOUNT          @"goodCount"
#define JSON_KEY_IMPRESS_VOTETWOCOUNT       @"vote2Count"
#define JSON_KEY_IMPRESS_CREATED            @"created"
#define JSON_KEY_IMPRESS_COMMENTLIST        @"commentList"
#define JSON_KEY_IMPRESS_VOTEONELIST        @"vote1List"
#define JSON_KEY_IMPRESS_GOODLIST           @"goodList"
#define JSON_KEY_IMPRESS_VOTETWOLIST        @"vote2List"
#define JSON_KEY_IMPRESS_FUSERID            @"fuserId"
#define JSON_KEY_IMPRESS_VIEWUSERID         @"viewUserId"
#define JSON_KEY_IMPRESS_VOTE               @"vote"
#define JSON_KEY_IMPRESS_COLORIDS           @"colors"
#define JSON_KEY_IMPRESS_TAG                @"tag"
#define JSON_KEY_IMPRESS_ISHOT              @"isHot"
#define JSON_KEY_IMPRESS_STYLE              @"style"
#define JSON_KEY_IMPRESS_MEDIAID            @"mediaId"
#define JSON_KEY_IMPRESS_MEDIASUBJECT       @"mediaSubject"
#define JSON_KEY_IMPRESS_UNREADCOUNT        @"unreadCount"
#define JSON_KEY_IMPRESS_GOODS              @"goods"
#define JSON_KEY_IMPRESS_GOODS_COUNT        @"goodsCount"

#define JSON_KEY_NOTIFY_PARAM               @"param"
#define JSON_KEY_NOTIFY_COUNT               @"count"
#define JSON_KEY_NOTIFY_SUMMARY             @"noticeSummary"
#define JSON_KEY_NOTIFY_CONTENT             @"content"
#define JSON_KEY_NOTIFY_CREATED             @"created"
#define JSON_KEY_NOTIFY_TYPE                @"type"
#define JSON_KEY_NOTIFY_ACME1               @"acme1"
#define JSON_KEY_NOTIFY_PIC                 @"pic"
#define JSON_KEY_NOTIFY_LINK                @"link"
#define JSON_KEY_NOTIFY_NOTICEID            @"noticeId"
#define JSON_KEY_NOTIFY_ISREAD              @"isRead"

#define JSON_KEY_NOTIFY_ISRECEIVEOFFICIAL   @"isReceiveOfficial"
#define JSON_KEY_NOTIFY_ISRECEIVECOMMENT    @"isReceiveComment"
#define JSON_KEY_NOTIFY_ISRECEIVEFANS       @"isReceiveNewFans"
#define JSON_KEY_NOTIFY_ISANTIDISTURB       @"isAntiDisturb"
#define JSON_KEY_NOTIFY_STARTTIME           @"startTime"
#define JSON_KEY_NOTIFY_ENDTIME             @"endTime"

#define JSON_KEY_NOTIFY_PFEEDID             @"pfeedId"
#define JSON_KEY_NOTIFY_FUSERID             @"userId"
#define JSON_KEY_NOTIFY_MEDIAID             @"mediaId"
#define JSON_KEY_NOTIFY_TAG                 @"tag"

#define JSON_KEY_DATA                       @"data"

//express Data
#define JSON_KEY_EXPRESS_SUBJECT            @"subject"
#define JSON_KEY_EXPRESS_BRIEF              @"brief"
#define JSON_KEY_EXPRESS_CONTENT            @"content"
#define JSON_KEY_EXPRESS_BIGCOVERURL        @"bigCoverImage"
#define JSON_KEY_EXPRESS_SMALLCOVERURL      @"smallCoverImage"
#define JSON_KEY_EXPRESS_STATUS             @"status"
#define JSON_KEY_EXPRESS_ISONTOP            @"isOnTop"
#define JSON_KEY_EXPRESS_SORT               @"sort"
#define JSON_KEY_EXPRESS_CREATETIME         @"publishTime"
#define JSON_KEY_EXPRESS_MEDIAID            @"mediaId"
#define JSON_KEY_EXPRESS_HAVE_READ          @"haveRead"

#define JSON_KEY_EXPRESS_TYPE               @"type"
#define JSON_KEY_EXPRESS_PARSELINK          @"link"

#define JSON_KEY_ADV_LATEST                 @"latestAdvertisement"
#define JSON_KEY_ADV_IMAGE                  @"image"
#define JSON_KEY_ADV_LINK                   @"link"
#define JSON_KEY_ADV_SORT                   @"sort"
#define JSON_KEY_ADV_STATUS                 @"status"
#define JSON_KEY_ADV_CREATETIME             @"createTime"
#define JSON_KEY_ADV_UPDATETIME             @"updateTime"
#define JSON_KEY_ADV_CLOSEMODE              @"closeMode"

//hotStyleList
#define JSON_KEY_STYLE_LIST                 @"hotStyleList"
#define JSON_KEY_STYLE_SORT                 @"sort"
#define JSON_KEY_STYLE_NAME                 @"name"

//media/suit/goods Data
#define JSON_KEY_MEDIA_MEDIAID              @"mediaId"
#define JSON_KEY_MEDIA_SUBJECT              @"subject"
#define JSON_KEY_MEDIA_CONTENT              @"content"
#define JSON_KEY_MEDIA_CREATETIME           @"publishTime"
#define JSON_KEY_MEDIA_SUIT                 @"suit"

#define JSON_KEY_MEDIA_COMMENTCOUNT         @"commentCount"
#define JSON_KEY_MEDIA_CANUPLOAD            @"canUpload"
#define JSON_KEY_MEDIA_CANCOMMENT           @"canComment"
#define JSON_KEY_MEDIA_UPLOADBUTTONTEXT     @"uploadButtonText"
#define JSON_KEY_MEDIA_PFEEDTITLE           @"pfeedTitle"
#define JSON_KEY_MEDIA_PFEEDLIST            @"pfeedList"
#define JSON_KEY_MEDIA_COMMENT              @"comment"

#define JSON_KEY_SUIT_SUITLIST              @"suitList"
#define JSON_KEY_SUIT_USERID                @"userId"
#define JSON_KEY_SUIT_SUITID                @"suitId"
#define JSON_KEY_SUIT_IMAGE                 @"image"
#define JSON_KEY_SUIT_IMAGE_HEIGHT          @"height"
#define JSON_KEY_SUIT_IMAGE_WIDTH           @"width"
#define JSON_KEY_SUIT_CONTENT               @"content"
#define JSON_KEY_SUIT_ISPRIVATE             @"isPrivate"
#define JSON_KEY_SUIT_READCOUNT             @"readCount"
#define JSON_KEY_SUIT_COLLECTCOUNT          @"collectCount"
#define JSON_KEY_SUIT_COMMENTCOUNT          @"commentCount"
#define JSON_KEY_SUIT_ISHOT                 @"isHot"
#define JSON_KEY_SUIT_MEDIAID               @"mediaId"
#define JSON_KEY_SUIT_CREATETIME            @"created"
#define JSON_KEY_SUIT_UPDATETIME            @"updated"
#define JSON_KEY_SUIT_PUBLISHTIME           @"publishTime"
#define JSON_KEY_SUIT_COLORS                @"colors"
#define JSON_KEY_SUIT_TAGS                  @"tags"
#define JSON_KEY_SUIT_STYLE                 @"style"
#define JSON_KEY_SUIT_SUBJECT_NAME          @"mediaSubject"
#define JSON_KEY_SUIT_GOODSCOUNT            @"goodsCount"
#define JSON_KEY_SUIT_USERNAME              @"username"
#define JSON_KEY_SUIT_AVATAR                @"avatar"
#define JSON_KEY_SUIT_ISTALENT              @"isTalent"
#define JSON_KEY_SUIT_ISCOLLECTED           @"isCollected"
#define JSON_KEY_SUIT_GOODS                 @"goods"
#define JSON_KEY_SUIT_COMMENT_LIST          @"commentList"
#define JSON_KEY_SUIT_COLLECT_LIST          @"collectList"
#define JSON_KEY_SUIT_NEEDCOMMENTCOUNT      @"needCommentCount"
#define JSON_KEY_SUIT_NEEDCOLLECTCOUNT      @"needCollectCount"

#define JSON_KEY_SUIT_SORT                  @"sort"

#define JSON_KEY_SUIT_COMMENT               @"comment"
#define JSON_KEY_SUIT_ISDATASHOW            @"isDataShow"


#define JSON_KEY_GOODS_GOODSID              @"outerGoodsId"
#define JSON_KEY_GOODS_CONTENT              @"content"
#define JSON_KEY_GOODS_MONTHLYSOLD          @"soldInOuter"
#define JSON_KEY_GOODS_CATEGORYID           @"categoryId"
#define JSON_KEY_GOODS_PRICE                @"price"
#define JSON_KEY_GOODS_IMAGE_WIDTH          @"width"
#define JSON_KEY_GOODS_IMAGE_HEIGHT         @"height"
#define JSON_KEY_GOODS_ISCOLLECTED          @"isCollected"
#define JSON_KEY_GOODS_NAME                 @"outerName"
#define JSON_KEY_GOODS_IMAGE                @"image"
#define JSON_KEY_GOODS_BUYLINK              @"buyLink"
#define JSON_KEY_GOODS_SUITS                @"suits"
#define JSON_KEY_GOODS_TAG                  @"tag"
#define JSON_KEY_GOODS_ISHOTSORT            @"isHotSort"
#define JSON_KEY_GOODS_GOODSLIST            @"goodsList"
#define JSON_KEY_GOODS_COLLECTCOUNT         @"collectCount"


#define JSON_KEY_GOODS_MEDIAID              @"mediaId"
#define JSON_KEY_GOODS_SUITID               @"suitId"
#define JSON_KEY_GOODS_TAOBAOLINK           @"taobaoLink"
#define JSON_KEY_GOODS_ISORIGINIMAGE        @"isOriginImage"




#define JSON_KEY_COLLECT_GOODS_NAME         @"goodsName"
#define JSON_KEY_GOODS_SORT                 @"sort"
#define JSON_KEY_GOODS_TAGS                 @"tags"
#define JSON_KEY_GOODS_CREATETIME           @"createTime"
#define JSON_KEY_GOODS_SELLCOUNT            @"soldInTaobao"


#define JSON_KEY_PAGESIZE                   @"pageSize"
#define JSON_KEY_PAGE                       @"page"

#define JSON_KEY_PLATFORM                   @"platform"
#define JSON_KEY_PUSH_ACM1                  @"acme1"


#pragma mark - upload file name
#define UPLOAD_AVATAR_IMAGE_FILE            @"upload_avatar_image_name"
#define UPLOAD_BACKGROUND_IMAGE_FILE        @"upload_background_image_name"


#define SINA_ssoCallbackScheme                   @"sinaweibosso.2759306753"

#define HIDEBAR_THRESHOLD                   100

#define HIDEBAR_SPEED_THRESHOLD_LV1         .25f
#define HIDEBAR_SPEED_THRESHOLD_LV2         1.f
#define SHOWBAR_SPEED_THRESHOLD             -.2f
#define HIDEBAR_OFFSET_THRESHOLD            50.f

#define NET_REQUEST_ERROR_CALLBACK_INTERVAL        (2)

#define DotNetErrorDomain                   @"DotNetErrorDomain"
typedef enum {
    NO_ERROR = 0,
    WRONG_SESSION = 2,
    WRONG_TOKEN = 4,
    USER_NOT_EXIST = 5
} ResultErrorId;


typedef enum eWeiboType{
    WEIBO_TYPE_NONE = 0,
    WEIBO_TYPE_SINA,
    WEIBO_TYPE_QQ,
    WEIBO_TYPE_RENREN,
    WEIBO_TYPE_DOUBAN,
    WEIBO_TYPE_TAOBAO,
    WEIBO_TYPE_MAX,
}eWeiboType;


typedef enum profileViewCurrentCellType{
    profileViewCurrentCellTypeVote = 1,
    profileViewCurrentCellTypeCollect = 2,
    profileViewCurrentCellTypeSuitCollect =3,
    profileViewCurrentCellTypeUserInfo = 4
}profileViewCurrentCellType;

typedef enum _DataSourceType {
    DataSourceTypeNew = 0,
    DataSourceTypeHot
} DataSourceType;


//Google Analytics
#define GA_Catogory_Impress     @"搭配"
#define GA_Catogory_Shopping    @"逛街"
#define GA_Catogory_Subject     @"主题"
#define GA_Catogory_Talent      @"达人"
#define GA_Catogory_Profile     @"用户"

#define GA_EVENT_CLICK          @"点击"
#define GA_EVENT_LOAD           @"加载"


#endif
