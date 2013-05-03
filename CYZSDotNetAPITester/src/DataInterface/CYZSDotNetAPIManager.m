//
//  CYZSDotNetAPIManager.m
//  CYZS
//
//  Created by Wei Li on 02/09/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "CYZSDotNetAPIManager.h"
#import "CYZSDotNetClient.h"
#import "CYZSBaseClassesExtended.h"
#import "CYZSConfig.h"
#import "AFHTTPRequestOperation.h"
#import "AFJSONRequestOperation.h"
#import "RequestStatusData.h"
#import "OpenUDID.h"
#import "CYZSTimer.h"

@implementation CYZSDotNetAPIManager

+ (NSString *)selfUId {
    return @"1348219327";
}

+ (NSString *)selfSession {
    return @"AgoGDQFUCFALAUsDVA9WBAFXBVFbUARUD1QBXgYMUQJQDgAFAQdUWghXAE4DC1BXAwxTCQwH";
}


+ (NSDictionary *)constructNoneUidParamDictWithMethod:(NSString *)method withDictionary:(NSDictionary *)paramDict {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict safeSetObject:API_VERSION forKey:@"version"];
    [dict safeSetObject:method forKey:JSON_KEY_METHOD];
    for (NSString *key in [paramDict allKeys]) {
        [dict safeSetObject:[paramDict objectForKey:key] forKey:key];
    }
    return dict;
}

+ (NSDictionary *)constructParamWithMethod:(NSString *)method withDictionary:(NSDictionary *)paramDict {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict safeSetObject:API_VERSION forKey:@"version"];
    [dict safeSetObject:method forKey:@"method"];
    [dict safeSetObject:[self selfUId] forKey:@"userId"];
    [dict safeSetObject:[self selfSession] forKey:@"session"];
    for (NSString *key in [paramDict allKeys]) {
        [dict safeSetObject:[paramDict objectForKey:key] forKey:key];
    }
    return dict;
}

//JSON返回错误集中判断
+ (BOOL)parseResultJSON:(id)JSON error:(NSError **)error {
    NSInteger errorCode = [[JSON valueForKey:JSON_KEY_RESULT] integerValue];
    if (errorCode != NO_ERROR) {
        NSMutableDictionary *details = [NSMutableDictionary dictionary];
        if ([[JSON valueForKey:@"msg"] isKindOfClass:[NSDictionary class]]){
            [details setValue:[[JSON valueForKey:@"msg"] safeStringForKey:@"message"]
                       forKey:NSLocalizedDescriptionKey];
        } else {
            [details setValue:@"网络错误"
                       forKey:NSLocalizedDescriptionKey];
        }

        *error = [NSError errorWithDomain:DotNetErrorDomain code:errorCode userInfo:details];
        return NO;
    }
    return YES;
}


#pragma mark - User Controller API
//开应用获取版本更新信息
+ (void)getVersionWithBlock:(void (^)(RequestStatusData *result))block {
    [[CYZSDotNetClient sharedClient] getWithParam:[self constructNoneUidParamDictWithMethod:REQUEST_METHOD_GETVERSION
                                                                             withDictionary:nil]
                                        withBlock:^(RequestStatusData *resultData){
                                            if (block) {
                                                block(resultData);
                                            }
                                        }];
}

//切应用到前台init
+ (void)initInfoWithBlock:(void (^)(RequestStatusData *result))block {
    NSDictionary *paramDict = [NSDictionary dictionaryWithObjectsAndKeys:
            CLIENT_VERSION, @"clientVersion",
            [NSNumber numberWithInteger:1], @"deviceType", nil];;
    [[CYZSDotNetClient sharedClient] getWithParam:[self constructParamWithMethod:REQUEST_METHOD_INITINFO
                                                                  withDictionary:paramDict]
                                        withBlock:^(RequestStatusData *resultData){
                                            if (block) {
                                                block(resultData);
                                            }
                                        }];
}

//获取消息status (appDelegate中定时获取)
+ (void)getUnreadNotifyCountWithBlock:(void (^)(RequestStatusData *result))block {
    [[CYZSDotNetClient sharedClient] getWithParam:[self constructParamWithMethod:REQUEST_METHOD_UNREADNOTIFYCOUNT
                                                                  withDictionary:nil]
                                        withBlock:^(RequestStatusData *resultData){
                                            if (block) {
                                                block(resultData);
                                            }
                                        }];
}

//新用户注册
+ (void)registerWithBlock:(void (^)(RequestStatusData *result))block {
    NSString *userAnonymousName = [NSString stringWithFormat:@"%d%@", arc4random() % 100000, [OpenUDID value]];
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict safeSetObject:[NSString stringWithFormat:@"TEST%@@cyzs.com", userAnonymousName] forKey:JSON_KEY_EMAIL];
    [paramDict safeSetObject:[userAnonymousName substringToIndex:20] forKey:JSON_KEY_NICKNAME];
    [paramDict safeSetObject:@"111111" forKey:JSON_KEY_PASSWORD];
    [paramDict safeSetObject:nil forKey:JSON_KEY_BIRTHDAY];
    [paramDict safeSetObject:[NSNumber numberWithBool:YES] forKey:@"isAutoRegister"];
    [paramDict safeSetObject:[NSNumber numberWithInt:1] forKey:@"deviceType"];
    [paramDict safeSetObject:CLIENT_VERSION forKey:@"clientVersion"];



    RequestStatusData *statusData = [[RequestStatusData alloc] init];
    statusData.requestMethod = REQUEST_METHOD_RESIGSTER;
    CYZSTimer *timer = [[CYZSTimer alloc] init];
    [timer startTimer];


    NSMutableURLRequest *request = [[CYZSDotNetClient sharedClient]
            multipartFormRequestWithMethod:@"POST"
                                      path:API_PATH
                                parameters:[self constructNoneUidParamDictWithMethod:REQUEST_METHOD_RESIGSTER
                                                                      withDictionary:paramDict]
                 constructingBodyWithBlock:^(id <AFMultipartFormData>formData) {
                 }];

    AFJSONRequestOperation *operation = [[AFJSONRequestOperation alloc] initWithRequest:request];
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
    }];

    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation1, id JSON){
        [timer stopTimer];
        statusData.milliSeconds = [timer timeElapsedInMilliseconds];
        NSError *error = nil;
        [self parseResultJSON:JSON error:&error];
        if (block) {
            if (error) {
                statusData.resultId = error.code;
                statusData.errorMessage = [error localizedDescription];
            }
            block (statusData);
        }
    }
                                     failure:^(AFHTTPRequestOperation *operation1, NSError *error){
                                         [timer stopTimer];
                                         statusData.milliSeconds = [timer timeElapsedInMilliseconds];
                                         statusData.resultId = error.code;
                                         statusData.errorMessage = [error localizedDescription];
                                         if (block) {
                                             block(statusData);
                                         }
                                     }];

    [[CYZSDotNetClient sharedClient] enqueueHTTPRequestOperation:operation];

}

//用户修改密码
+ (void)changePasswordWithBlock:(void (^)(RequestStatusData *result))block {
    NSDictionary *paramDict = [NSDictionary dictionaryWithObjectsAndKeys:@"111111", JSON_KEY_OLDPASSWORD,
                                                                         @"111111", JSON_KEY_NEWPASSWORD, nil];
    [[CYZSDotNetClient sharedClient] getWithParam:[self constructParamWithMethod:REQUEST_METHOD_CHANGEPASSWORD
                                                                  withDictionary:paramDict]
                                        withBlock:^(RequestStatusData *resultData){
                                            block(resultData);
                                        }];
}

//用户资料修改modifyUserInfo
+ (void)modifyUserInfoWithBlock:(void (^)(RequestStatusData *result))block {
    NSMutableDictionary *fieldsDict = [NSMutableDictionary dictionary];
    [fieldsDict safeSetObject:@"http://www.baidu.com" forKey:JSON_KEY_HOMEPAGE];
    NSDictionary *paramDict = [NSDictionary dictionaryWithObjectsAndKeys:fieldsDict, JSON_KEY_FIELDS, nil];
    [[CYZSDotNetClient sharedClient] getWithParam:[self constructParamWithMethod:REQUEST_METHOD_MODIFYINFO
                                                                  withDictionary:paramDict]
                                        withBlock:^(RequestStatusData *resultData) {
                                            if (block) {
                                                block(resultData);
                                            }
                                        }];
}

//检查昵称
+ (void)checkUserNicknameWithBlock:(void (^)(RequestStatusData *result))block {
    NSDictionary *paramDict = [NSDictionary dictionaryWithObjectsAndKeys:@"asdjfaksdjflkasjdf", JSON_KEY_NICKNAME, nil];
    [[CYZSDotNetClient sharedClient] getWithParam:[self constructParamWithMethod:REQUEST_METHOD_CHECKNAME
                                                                  withDictionary:paramDict]
                                        withBlock:^(RequestStatusData *resultData) {
                                            if (block) {
                                                block(resultData);
                                            }
                                        }];
}

//用户登陆
+ (void)loginWithBlock:(void (^)(RequestStatusData *result))block {
    NSDictionary *paramDict = [NSDictionary dictionaryWithObjectsAndKeys:@"1@1.com", JSON_KEY_EMAILORNICKNAME,
                                                                         @"111111", JSON_KEY_PASSWORD, nil];
    [[CYZSDotNetClient sharedClient] getWithParam:[self constructParamWithMethod:REQUEST_METHOD_LOGIN
                                                                  withDictionary:paramDict]
                                        withBlock:^(RequestStatusData *resultData) {
                                            if (block) {
                                                block(resultData);
                                            }
                                        }];
}

//用户登出
+ (void)logoutWithBlock:(void (^)(RequestStatusData *result))block {
    [[CYZSDotNetClient sharedClient] getWithParam:[self constructParamWithMethod:REQUEST_METHOD_LOGOUT
                                                                  withDictionary:nil]
                                        withBlock:^(RequestStatusData *resultData) {
                                            if (block) {
                                                block(resultData);
                                            }
                                        }];
}

//忘记密码发送邮件
+ (void)sendPasswordToEmailWithBlock:(void (^)(RequestStatusData *result))block {
    NSDictionary *paramDict = [NSDictionary dictionaryWithObjectsAndKeys:@"1@1.com", JSON_KEY_EMAIL, nil];
    [[CYZSDotNetClient sharedClient] getWithParam:[self constructNoneUidParamDictWithMethod:REQUEST_METHOD_SENDPASSWORD
                                                                             withDictionary:paramDict]
                                        withBlock:^(RequestStatusData *resultData){
                                            if (block) {
                                                block(resultData);
                                            }
                                        }];
}

//获取用户信息
+ (void)getUserInfoWithBlock:(void (^)(RequestStatusData *result))block {
    [[CYZSDotNetClient sharedClient] getWithParam:[self constructParamWithMethod:REQUEST_METHOD_GETUSERINFO
                                                                  withDictionary:nil]
                                        withBlock:^(RequestStatusData *resultData) {
                                            if (block) {
                                                block(resultData);
                                            }
                                        }];
}

+ (void)getOtherUserInfoWithBlock:(void (^)(RequestStatusData *result))block {
    NSDictionary *paramDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:1350348392], JSON_KEY_IMPRESS_FUSERID, nil];
    [[CYZSDotNetClient sharedClient] getWithParam:[self constructParamWithMethod:REQUEST_METHOD_GETUSERINFO
                                                                  withDictionary:paramDict]
                                        withBlock:^(RequestStatusData *resultData) {
                                            if (block) {
                                                block(resultData);
                                            }
                                        }];
}

//获取反馈列表
+ (void)getFeedBackListWithBlock:(void (^)(RequestStatusData *result))block {
    NSDictionary *paramDict = [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithInteger:1], @"page",
            [NSNumber numberWithInteger:20], @"pageSize", nil];
    [[CYZSDotNetClient sharedClient] getWithParam:[self constructParamWithMethod:REQUEST_METHOD_FEEDBACK_GETLIST
                                                                  withDictionary:paramDict]
                                        withBlock:^(RequestStatusData *resultData) {
                                            if (block) {
                                                block(resultData);
                                            }
                                        }];
}

//获取友情链接
+ (void)getLinksWithBlock:(void (^)(RequestStatusData *result))block {
    NSDictionary *paramDict = [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithInteger:1], @"page",
            [NSNumber numberWithInteger:20], @"pageSize", nil];
    [[CYZSDotNetClient sharedClient] getWithParam:[self constructParamWithMethod:REQUEST_METHOD_GETLINKS
                                                                  withDictionary:paramDict]
                                        withBlock:^(RequestStatusData *resultData) {
                                            if (block) {
                                                block(resultData);
                                            }
                                        }];
}

#pragma mark - Suit Controller
//获取自己或他人的suit List
+ (void)getSuitListWithBlock:(void (^)(RequestStatusData *result))block {
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict safeSetObject:[NSNumber numberWithInteger:1] forKey:JSON_KEY_PAGE];
    [paramDict safeSetObject:[NSNumber numberWithInteger:20] forKey:JSON_KEY_PAGESIZE];

    [[CYZSDotNetClient sharedClient] getWithParam:[self constructParamWithMethod:REQUEST_METHOD_SUIT_GETLIST
                                                                  withDictionary:paramDict]
                                        withBlock:^(RequestStatusData *resultData) {
                                            if (block) {
                                                block(resultData);
                                            }
                                        }];
}

//获取所有SuitID(日记)
+ (void)getAllSuitIdsWithBlock:(void (^)(RequestStatusData *result))block {
    [[CYZSDotNetClient sharedClient] getWithParam:[self constructParamWithMethod:REQUEST_METHOD_SUIT_ALLIDS
                                                                  withDictionary:nil]
            withBlock:^(RequestStatusData *resultData) {
                if (block) {
                    block(resultData);
                }
            }];
}

//上传或修改日记
+ (void)addOrModifySuitWithBlock:(void (^)(RequestStatusData *result))block {
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict safeSetObject:[NSNumber numberWithInteger:1350348392] forKey:JSON_KEY_SUIT_SUITID];
    [paramDict safeSetObject:@"test" forKey:JSON_KEY_SUIT_CONTENT];

    [paramDict safeSetObject:@"甜美" forKey:JSON_KEY_SUIT_COLORS];
    [paramDict safeSetObject:[NSNumber numberWithInteger:1350348392] forKey:JSON_KEY_SUIT_CREATETIME];
    [paramDict safeSetObject:[NSNumber numberWithInteger:1350348392] forKey:JSON_KEY_SUIT_UPDATETIME];
    [paramDict safeSetObject:[NSNumber numberWithBool:YES] forKey:JSON_KEY_SUIT_ISPRIVATE];


    RequestStatusData *statusData = [[RequestStatusData alloc] init];
    statusData.requestMethod = REQUEST_METHOD_RESIGSTER;
    CYZSTimer *timer = [[CYZSTimer alloc] init];
    [timer startTimer];

    NSMutableURLRequest *request = [[CYZSDotNetClient sharedClient]
            multipartFormRequestWithMethod:@"POST"
                                      path:API_PATH
                                parameters:[self constructParamWithMethod:REQUEST_METHOD_SUIT_SET
                                                           withDictionary:paramDict]
                 constructingBodyWithBlock:^(id <AFMultipartFormData>formData) {
                     [formData appendPartWithFileData:UIImageJPEGRepresentation([UIImage imageNamed:@"test.png"], 1.0)
                                                 name:JSON_KEY_SUIT_IMAGEFILE
                                             fileName:JSON_KEY_SUIT_IMAGEFILE
                                             mimeType:@"image/jpeg"];
                 }];

    AFJSONRequestOperation *operation = [[AFJSONRequestOperation alloc] initWithRequest:request];
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
    }];

    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation1, id JSON){
        [timer stopTimer];
        statusData.milliSeconds = [timer timeElapsedInMilliseconds];
        NSError *error = nil;
        [self parseResultJSON:JSON error:&error];
        if (block) {
            if (error) {
                statusData.resultId = error.code;
                statusData.errorMessage = [error localizedDescription];
            }
            block (statusData);
        }
    }
                                     failure:^(AFHTTPRequestOperation *operation1, NSError *error){
                                         [timer stopTimer];
                                         statusData.milliSeconds = [timer timeElapsedInMilliseconds];
                                         statusData.resultId = error.code;
                                         statusData.errorMessage = [error localizedDescription];
                                         if (block) {
                                             block(statusData);
                                         }
                                     }];

    [[CYZSDotNetClient sharedClient] enqueueHTTPRequestOperation:operation];
}

//删除搭配(日记)
+ (void)deleteSuitsWithBlock:(void (^)(RequestStatusData *result))block {
    NSDictionary *paramDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithObjects:[NSNumber numberWithInteger:1350348392], nil], JSON_KEY_SUIT_ALLIDS, nil];
    [[CYZSDotNetClient sharedClient] getWithParam:[self constructParamWithMethod:REQUEST_METHOD_SUIT_DELETE
                                                                  withDictionary:paramDict]
                                        withBlock:^(RequestStatusData *resultData) {
                                            if (block) {
                                                block(resultData);
                                            }
                                        }];
}


#pragma mark - Pfeed Controller

//获取热门搭配 （包括热门风格）
+ (void)getHotSuitWithBlock:(void (^)(RequestStatusData *result))block {
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict safeSetObject:[NSNumber numberWithInteger:20] forKey:JSON_KEY_IMPRESS_LIMIT];
    [paramDict safeSetObject:[NSNumber numberWithInteger:1] forKey:JSON_KEY_IMPRESS_PAGE];
    [[CYZSDotNetClient sharedClient] getWithParam:[self constructParamWithMethod:REQUEST_METHOD_SUIT_GETHOT
                                                                  withDictionary:paramDict]
                                        withBlock:^(RequestStatusData *resultData) {
                                            if (block) {
                                                block(resultData);
                                            }
                                        }];
}

//获取最新搭配印象
+ (void)getNewSuitListWithBlock:(void (^)(RequestStatusData *result))block {
    NSDictionary *paramDict = [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithInteger:1], JSON_KEY_IMPRESS_PAGE,
            [NSNumber numberWithInteger:20], JSON_KEY_PAGESIZE,
            nil];
    [[CYZSDotNetClient sharedClient] getWithParam:[self constructParamWithMethod:REQUEST_METHOD_SUIT_GETNEW
                                                                  withDictionary:paramDict]
                                        withBlock:^(RequestStatusData *resultData) {
                                            if (block) {
                                                block(resultData);
                                            }
                                        }];
}

//获取搭配详情
+ (void)getSuitDetailWithBlock:(void (^)(RequestStatusData *result))block {
    NSDictionary *paramDict = [NSDictionary dictionaryWithObjectsAndKeys: [NSNumber numberWithInteger:1348318539], JSON_KEY_SUIT_SUITID,
                                                                          [NSNumber numberWithInteger:1349850638],JSON_KEY_IMPRESS_VIEWUSERID,
                                                                          nil];
    [[CYZSDotNetClient sharedClient] getWithParam:[self constructParamWithMethod:REQUEST_METHOD_SUIT_GETINFO
                                                                  withDictionary:paramDict]
                                        withBlock:^(RequestStatusData *resultData) {
                                            if (block) {
                                                block(resultData);
                                            }
                                        }];
}


//评论列表
+ (void)getSuitCommentListWithBlock:(void (^)(RequestStatusData *result))block {
    NSDictionary *paramDict = [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithInteger:1348318539], JSON_KEY_SUIT_SUITID,
            [NSNumber numberWithInteger:1349850638], JSON_KEY_IMPRESS_VIEWUSERID,
            [NSNumber numberWithInteger:1], JSON_KEY_IMPRESS_PAGE,
            nil];
    [[CYZSDotNetClient sharedClient] getWithParam:[self constructParamWithMethod:REQUEST_METHOD_SUIT_COMMENT_LIST
                                                                  withDictionary:paramDict]
                                        withBlock:^(RequestStatusData *resultData) {
                                            if (block) {
                                                block(resultData);
                                            }
                                        }];
}

//获取收藏的人的列表
+ (void)getCollectUserListWithBlock:(void (^)(RequestStatusData *result))block {
    NSDictionary *paramDict = [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithInteger:1348318539], JSON_KEY_SUIT_SUITID,
            [NSNumber numberWithInteger:1349850638], JSON_KEY_IMPRESS_VIEWUSERID,
            [NSNumber numberWithInteger:1], JSON_KEY_PAGE,
            [NSNumber numberWithInteger:20], JSON_KEY_PAGESIZE, nil];
    [[CYZSDotNetClient sharedClient] getWithParam:[self constructParamWithMethod:REQUEST_METHOD_SUIT_COLLECT_USER_LIST
                                                                  withDictionary:paramDict]
                                        withBlock:^(RequestStatusData *resultData) {
                                            if (block) {
                                                block(resultData);
                                            }
                                        }];
}

//收藏与取消收藏
+ (void)collectSuitWithBlock:(void (^)(RequestStatusData *result))block {
    NSDictionary *paramDict = [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithInteger:1348318539], JSON_KEY_SUIT_SUITID,
            [NSNumber numberWithInteger:1349850638], JSON_KEY_IMPRESS_VIEWUSERID, nil];
    [[CYZSDotNetClient sharedClient] getWithParam:[self constructParamWithMethod:REQUEST_METHOD_SUIT_COLLECT
                                                                  withDictionary:paramDict]
                                        withBlock:^(RequestStatusData *resultData) {
                                            if (block) {
                                                block(resultData);
                                            }
                                        }];
}

+ (void)deCollectSuitWithBlock:(void (^)(RequestStatusData *result))block {
    NSDictionary *paramDict = [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithInteger:1348318539], JSON_KEY_SUIT_SUITID,
            [NSNumber numberWithInteger:1349850638], JSON_KEY_IMPRESS_VIEWUSERID, nil];
    [[CYZSDotNetClient sharedClient] getWithParam:[self constructParamWithMethod:REQUEST_METHOD_SUIT_DECOLLECT
                                                                  withDictionary:paramDict]
                                        withBlock:^(RequestStatusData *resultData) {
                                            if (block) {
                                                block(resultData);
                                            }
                                        }];
}

//获取关注的未读数量
+ (void)getUnreadFollowListCountWithBlock:(void (^)(RequestStatusData *result))block {
    [[CYZSDotNetClient sharedClient] getWithParam:[self constructParamWithMethod:REQUEST_METHOD_SOCIAL_GETUNREADSTATUSCOUNT
                                                                  withDictionary:nil]
                                        withBlock:^(RequestStatusData *resultData) {
                                            if (block) {
                                                block(resultData);
                                            }
                                        }];
}

//获取关注的搭配印象
+ (void)getFollowSuitListWithBlock:(void (^)(RequestStatusData *result))block {
    NSDictionary *paramDict = [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithInteger:1], JSON_KEY_PAGE,
            [NSNumber numberWithInteger:20], JSON_KEY_PAGESIZE, nil];
    [[CYZSDotNetClient sharedClient] getWithParam:[self constructParamWithMethod:REQUEST_METHOD_SOCIAL_GETSTATUSLIST
                                                                  withDictionary:paramDict]
                                        withBlock:^(RequestStatusData *resultData) {
                                            if (block) {
                                                block(resultData);
                                            }
                                        }];
}


#pragma mark - Tag Controller
//获取标签列表
+ (void)getTagsWithBlock:(void (^)(RequestStatusData *result))block {
    [[CYZSDotNetClient sharedClient] getWithParam:[self constructParamWithMethod:REQUEST_METHOD_GETTAGS
                                                                  withDictionary:nil]
                                        withBlock:^(RequestStatusData *resultData) {
                                            if (block) {
                                                block(resultData);
                                            }
                                        }];
}

//获取逛街顶部广告
+ (void)getAdvertisementInShoppingWithBlock:(void (^)(RequestStatusData *result))block {
    [[CYZSDotNetClient sharedClient] getWithParam:[self constructParamWithMethod:REQUEST_METHOD_GETADVERTISEMENT
                                                                  withDictionary:nil]
                                        withBlock:^(RequestStatusData *resultData) {
                                            if (block) {
                                                block(resultData);
                                            }
                                        }];
}


#pragma mark - Goods Controller
//按照标签获取最热或最新单品
+ (void)getGoodsListByTagWithBlock:(void (^)(RequestStatusData *result))block {
    NSDictionary *paramDict = [NSDictionary dictionaryWithObjectsAndKeys:
            @"牛仔裤", JSON_KEY_GOODS_TAG,
            [NSNumber numberWithInteger:1], JSON_KEY_PAGE,
            [NSNumber numberWithInteger:20], JSON_KEY_PAGESIZE,
            [NSNumber numberWithBool:NO], JSON_KEY_GOODS_ISHOTSORT, nil];
    [[CYZSDotNetClient sharedClient] getWithParam:[self constructParamWithMethod:REQUEST_METHOD_GOODS_GETLISTBYTAG
                                                                  withDictionary:paramDict]
                                        withBlock:^(RequestStatusData *resultData) {
                                            if (block) {
                                                block(resultData);
                                            }
                                        }];
}

//获取最热或最新单品列表
+ (void)getGoodsListWithBlock:(void (^)(RequestStatusData *result))block {
    NSDictionary *paramDict = [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithInteger:1], JSON_KEY_PAGE,
            [NSNumber numberWithInteger:20], JSON_KEY_PAGESIZE,
            [NSNumber numberWithBool:YES], JSON_KEY_GOODS_ISHOTSORT, nil];
    [[CYZSDotNetClient sharedClient] getWithParam:[self constructParamWithMethod:REQUEST_METHOD_GOODS_GETLIST
                                                                  withDictionary:paramDict]
                                        withBlock:^(RequestStatusData *resultData) {
                                            if (block) {
                                                block(resultData);
                                            }
                                        }];
}

//获取商品详情
+ (void)getGoodsInfoWithBlock:(void (^)(RequestStatusData *result))block {
    NSDictionary *paramDict = [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithLongLong:17337433637], JSON_KEY_GOODS_GOODSID, nil];
    [[CYZSDotNetClient sharedClient] getWithParam:[self constructParamWithMethod:REQUEST_METHOD_GOODS_GETINFO
                                                                  withDictionary:paramDict]
                                        withBlock:^(RequestStatusData *resultData) {
                                            if (block) {
                                                block(resultData);
                                            }
                                        }];
}

//收藏商品
+ (void)collectGoodsWithBlock:(void (^)(RequestStatusData *result))block {
    NSDictionary *paramDict = [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithLongLong:17337433637], JSON_KEY_GOODS_GOODSID, nil];
    [[CYZSDotNetClient sharedClient] getWithParam:[self constructParamWithMethod:REQUEST_METHOD_GOODS_COLLECT
                                                                  withDictionary:paramDict]
                                        withBlock:^(RequestStatusData *resultData) {
                                            if (block) {
                                                block(resultData);
                                            }
                                        }];
}

//取消收藏商品
+ (void)decollectGoodsWithBlock:(void (^)(RequestStatusData *result))block {
    NSDictionary *paramDict = [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithLongLong:17337433637], JSON_KEY_GOODS_GOODSID, nil];
    [[CYZSDotNetClient sharedClient] getWithParam:[self constructParamWithMethod:REQUEST_METHOD_GOODS_DECOLLECT
                                                                  withDictionary:paramDict]
                                        withBlock:^(RequestStatusData *resultData) {
                                            if (block) {
                                                block(resultData);
                                            }
                                        }];
}

//获取收藏商品列表
+ (void)getCollectGoodsListWithBlock:(void (^)(RequestStatusData *result))block {
    NSDictionary *paramDict = [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithInteger:1], JSON_KEY_PAGE,
            [NSNumber numberWithInteger:20], JSON_KEY_PAGESIZE,
            [NSNumber numberWithInteger:1349850638], JSON_KEY_SOCIAL_VIEWUSERID, nil];
    [[CYZSDotNetClient sharedClient] getWithParam:[self constructParamWithMethod:REQUEST_METHOD_GOODS_GETCOLLECTLIST
                                                                  withDictionary:paramDict]
                                        withBlock:^(RequestStatusData *resultData) {
                                            if (block) {
                                                block(resultData);
                                            }
                                        }];
}


#pragma mark - Media Controller

+ (void)getMediaListWithBlock:(void (^)(RequestStatusData *result))block {
    NSDictionary *paramDict = [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithInteger:1], JSON_KEY_IMPRESS_PAGE,
            [NSNumber numberWithInteger:20], JSON_KEY_PAGESIZE, nil];
    [[CYZSDotNetClient sharedClient] getWithParam:[self constructParamWithMethod:REQUEST_METHOD_MEDIA_LIST
                                                                  withDictionary:paramDict]
                                        withBlock:^(RequestStatusData *resultData) {
                                            if (block) {
                                                block(resultData);
                                            }
                                        }];
}

+ (void)getMediaWithBlock:(void (^)(RequestStatusData *result))block {
    NSDictionary *paramDict = [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithLongLong:42], JSON_KEY_MEDIA_MEDIAID, nil];
    [[CYZSDotNetClient sharedClient] getWithParam:[self constructParamWithMethod:REQUEST_METHOD_GET_MEDIA
                                                                  withDictionary:paramDict]
                                        withBlock:^(RequestStatusData *resultData) {
                                            if (block) {
                                                block(resultData);
                                            }
                                        }];
}

+ (void)getCollectSuitListWithBlock:(void (^)(RequestStatusData *result))block {
    NSDictionary *paramDict = [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithInteger:1349850638], JSON_KEY_IMPRESS_VIEWUSERID,
            [NSNumber numberWithInteger:1], JSON_KEY_PAGE,
            [NSNumber numberWithInteger:20], JSON_KEY_PAGESIZE, nil];
    [[CYZSDotNetClient sharedClient] getWithParam:[self constructParamWithMethod:REQUEST_METHOD_SUIT_COLLECT_LIST
                                                                  withDictionary:paramDict]
                                        withBlock:^(RequestStatusData *resultData) {
                                            if (block) {
                                                block(resultData);
                                            }
                                        }];
}

+ (void)getMediaCommentListWithBlock:(void (^)(RequestStatusData *result))block {
    NSDictionary *paramDict = [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithInteger:42], JSON_KEY_MEDIA_MEDIAID,
            [NSNumber numberWithInteger:1], JSON_KEY_PAGE,
            [NSNumber numberWithInteger:20], JSON_KEY_PAGESIZE, nil];
    [[CYZSDotNetClient sharedClient] getWithParam:[self constructParamWithMethod:REQUEST_METHOD_GET_MEDIA_COMMENT
                                                                  withDictionary:paramDict]
                                        withBlock:^(RequestStatusData *resultData) {
                                            if (block) {
                                                block(resultData);
                                            }
                                        }];
}
//用户相关的媒体相关搭配
+ (void)getHotSuitListWithBlock:(void (^)(RequestStatusData *result))block {
    NSDictionary *paramDict = [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithInteger:42], JSON_KEY_SUIT_MEDIAID,
            [NSNumber numberWithInteger:1], JSON_KEY_PAGE,
            [NSNumber numberWithInteger:20], JSON_KEY_PAGESIZE, nil];
    [[CYZSDotNetClient sharedClient] getWithParam:[self constructParamWithMethod:REQUEST_METHOD_MEDIA_HOT_SUIT_LIST
                                                                  withDictionary:paramDict]
                                        withBlock:^(RequestStatusData *resultData) {
                                            if (block) {
                                                block(resultData);
                                            }
                                        }];

}

+ (void)getNewlySuitListWithBlock:(void (^)(RequestStatusData *result))block {
    NSDictionary *paramDict = [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithInteger:42], JSON_KEY_SUIT_MEDIAID,
            [NSNumber numberWithInteger:1], JSON_KEY_PAGE,
            [NSNumber numberWithInteger:20], JSON_KEY_PAGESIZE, nil];
    [[CYZSDotNetClient sharedClient] getWithParam:[self constructParamWithMethod:REQUEST_METHOD_MEDIA_NEW_SUIT_LIST
                                                                  withDictionary:paramDict]
                                        withBlock:^(RequestStatusData *resultData) {
                                            if (block) {
                                                block(resultData);
                                            }
                                        }];
}

#pragma mark - Talent Controller

//达人广场
+ (void)getTalentSquareWithBlock:(void (^)(RequestStatusData *result))block {
    [[CYZSDotNetClient sharedClient] getWithParam:[self constructParamWithMethod:REQUEST_METHOD_TALENT_SQUARE
                                                                  withDictionary:nil]
                                        withBlock:^(RequestStatusData *resultData) {
                                            if (block) {
                                                block(resultData);
                                            }
                                        }];
}

//获取达人申请状态
+ (void)getApplyTalentStatusWithBlock:(void (^)(RequestStatusData *result))block {
    [[CYZSDotNetClient sharedClient] getWithParam:[self constructParamWithMethod:REQUEST_METHOD_TALENT_GETSTATUS
                                                                  withDictionary:nil]
                                        withBlock:^(RequestStatusData *resultData) {
                                            if (block) {
                                                block(resultData);
                                            }
                                        }];
}

//新晋达人列表
+ (void)getTalentNewListWithBlock:(void (^)(RequestStatusData *result))block {
    NSDictionary *paramDict = [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithInteger:1], JSON_KEY_PAGE,
            [NSNumber numberWithInteger:20], JSON_KEY_PAGESIZE, nil];
    [[CYZSDotNetClient sharedClient] getWithParam:[self constructParamWithMethod:REQUEST_METHOD_TALENT_NEWLIST
                                                                  withDictionary:paramDict]
                                        withBlock:^(RequestStatusData *resultData) {
                                            if (block) {
                                                block(resultData);
                                            }
                                        }];
}

//一周人气达人
+ (void)getTalentWeekyListWithBlock:(void (^)(RequestStatusData *result))block {
    NSDictionary *paramDict = [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithInteger:1], JSON_KEY_PAGE,
            [NSNumber numberWithInteger:20], JSON_KEY_PAGESIZE, nil];
    [[CYZSDotNetClient sharedClient] getWithParam:[self constructParamWithMethod:REQUEST_METHOD_TALENT_WEEKLYLIST
                                                                  withDictionary:paramDict]
                                        withBlock:^(RequestStatusData *resultData) {
                                            if (block) {
                                                block(resultData);
                                            }
                                        }];
}

//达人总榜
+ (void)getTalentOveralListWithBlock:(void (^)(RequestStatusData *result))block {
    NSDictionary *paramDict = [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithInteger:1], JSON_KEY_PAGE,
            [NSNumber numberWithInteger:20], JSON_KEY_PAGESIZE, nil];
    [[CYZSDotNetClient sharedClient] getWithParam:[self constructParamWithMethod:REQUEST_METHOD_TALENT_OVERALLIST
                                                                  withDictionary:paramDict]
                                        withBlock:^(RequestStatusData *resultData) {
                                            if (block) {
                                                block(resultData);
                                            }
                                        }];
}

//风格达人列表
+ (void)getStyleListWithBlock:(void (^)(RequestStatusData *result))block {
    NSDictionary *paramDict = [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithInteger:1], JSON_KEY_TALENT_STYLE,
            [NSNumber numberWithInteger:1], JSON_KEY_PAGE,
            [NSNumber numberWithInteger:20], JSON_KEY_PAGESIZE, nil];
    [[CYZSDotNetClient sharedClient] getWithParam:[self constructParamWithMethod:REQUEST_METHOD_TALENT_STYLELIST
                                                                  withDictionary:paramDict]
                                        withBlock:^(RequestStatusData *resultData) {
                                            if (block) {
                                                block(resultData);
                                            }
                                        }];
}

//时尚店主、时尚红人
+ (void)getRoleListWithBlock:(void (^)(RequestStatusData *result))block {
    NSDictionary *paramDict = [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithInteger:1], JSON_KEY_TALENT_ROLE,
            [NSNumber numberWithInteger:1], JSON_KEY_PAGE,
            [NSNumber numberWithInteger:20], JSON_KEY_PAGESIZE, nil];
    [[CYZSDotNetClient sharedClient] getWithParam:[self constructParamWithMethod:REQUEST_METHOD_TALENT_ROLELIST
                                                                  withDictionary:paramDict]
                                        withBlock:^(RequestStatusData *resultData) {
                                            if (block) {
                                                block(resultData);
                                            }
                                        }];

}

//每日推荐达人
+ (void)getDailyRecommendListWithBlock:(void (^)(RequestStatusData *result))block {
    NSDictionary *paramDict = [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithInteger:1], JSON_KEY_PAGE,
            [NSNumber numberWithInteger:20], JSON_KEY_PAGESIZE, nil];
    [[CYZSDotNetClient sharedClient] getWithParam:[self constructParamWithMethod:REQUEST_METHOD_TALENT_DAILY_LIST
                                                                  withDictionary:paramDict]
                                        withBlock:^(RequestStatusData *resultData) {
                                            if (block) {
                                                block(resultData);
                                            }
                                        }];
}

#pragma mark - Social Controller
//关注某人
+ (void)followWithBlock:(void (^)(RequestStatusData *result))block {
    NSDictionary *paramDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:1349850638], JSON_KEY_SOCIAL_TARGETUSERID, nil];
    [[CYZSDotNetClient sharedClient] getWithParam:[self constructParamWithMethod:REQUEST_METHOD_SOCIAL_FOLLOW
                                                                  withDictionary:paramDict]
                                        withBlock:^(RequestStatusData *resultData) {
                                            if (block) {
                                                block(resultData);
                                            }
                                        }];
}

//取消关注
+ (void)unfollowWithBlock:(void (^)(RequestStatusData *result))block {
    NSDictionary *paramDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:1349850638], JSON_KEY_SOCIAL_TARGETUSERID, nil];
    [[CYZSDotNetClient sharedClient] getWithParam:[self constructParamWithMethod:REQUEST_METHOD_SOCIAL_UNFOLLOW
                                                                  withDictionary:paramDict]
                                        withBlock:^(RequestStatusData *resultData) {
                                            if (block) {
                                                block(resultData);
                                            }
                                        }];
}

//获得关注列表
+ (void)getFollowListWithBlock:(void (^)(RequestStatusData *result))block {
    NSDictionary *paramDict = [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithInteger:1], JSON_KEY_PAGE,
            [NSNumber numberWithInteger:20], JSON_KEY_PAGESIZE,
            [NSNumber numberWithInteger:1349850638], JSON_KEY_SOCIAL_VIEWUSERID, nil];
    [[CYZSDotNetClient sharedClient] getWithParam:[self constructParamWithMethod:REQUEST_METHOD_SOCIAL_GETFOLLOWLIST
                                                                  withDictionary:paramDict]
                                        withBlock:^(RequestStatusData *resultData) {
                                            if (block) {
                                                block(resultData);
                                            }
                                        }];
}

//获得粉丝列表
+ (void)getFansListWithBlock:(void (^)(RequestStatusData *result))block {
    NSDictionary *paramDict = [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithInteger:1], JSON_KEY_PAGE,
            [NSNumber numberWithInteger:20], JSON_KEY_PAGESIZE,
            [NSNumber numberWithInteger:1349850638], JSON_KEY_SOCIAL_VIEWUSERID, nil];
    [[CYZSDotNetClient sharedClient] getWithParam:[self constructParamWithMethod:REQUEST_METHOD_SOCIAL_GETFANSLIST
                                                                  withDictionary:paramDict]
                                        withBlock:^(RequestStatusData *resultData) {
                                            if (block) {
                                                block(resultData);
                                            }
                                        }];
}

#pragma mark - Notify Controller
//获取消息列表
+ (void)getNotifyListWithBlock:(void (^)(RequestStatusData *result))block {
    NSDictionary *paramDict = [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithInteger:1], JSON_KEY_PAGE,
            [NSNumber numberWithInteger:20], JSON_KEY_PAGESIZE, nil];
    [[CYZSDotNetClient sharedClient] getWithParam:[self constructParamWithMethod:REQUEST_METHOD_GETNOTIFYLIST
                                                                  withDictionary:paramDict]
                                        withBlock:^(RequestStatusData *resultData) {
                                            if (block) {
                                                block(resultData);
                                            }
                                        }];
}

//获取未读消息列表
+ (void)getUnreadNotifyWithBlock:(void (^)(RequestStatusData *result))block {
    [[CYZSDotNetClient sharedClient] getWithParam:[self constructParamWithMethod:REQUEST_METHOD_GETUNREADNOTIFY
                                                                  withDictionary:nil]
                                        withBlock:^(RequestStatusData *resultData) {
                                            if (block) {
                                                block(resultData);
                                            }
                                        }];
}

//消息全部已读
+ (void)resetNotifyWithBlock:(void (^)(RequestStatusData *result))block {
    [[CYZSDotNetClient sharedClient] getWithParam:[self constructParamWithMethod:REQUEST_METHOD_RESET_NOTIFY
                                                                  withDictionary:nil]
                                        withBlock:^(RequestStatusData *resultData) {
                                            if (block) {
                                                block(resultData);
                                            }
                                        }];
}

//获取消息防打扰状态
+ (void)getNotifyAntiDisturbWithBlock:(void (^)(RequestStatusData *result))block {
    [[CYZSDotNetClient sharedClient] getWithParam:[self constructParamWithMethod:REQUEST_METHOD_NOTIFY_GETANTI
                                                                  withDictionary:nil]
                                        withBlock:^(RequestStatusData *resultData) {
                                            if (block) {
                                                block(resultData);
                                            }
                                        }];
}

//设置消息防打扰状态
+ (void)setNotifyAntiDisterbWithBlock:(void (^)(RequestStatusData *result))block {
    NSDictionary *paramDict = [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithBool:NO], JSON_KEY_NOTIFY_ISRECEIVEOFFICIAL,
            [NSNumber numberWithBool:YES], JSON_KEY_NOTIFY_ISRECEIVEFANS,
            [NSNumber numberWithBool:YES], JSON_KEY_NOTIFY_ISRECEIVECOMMENT,
            [NSNumber numberWithBool:NO], JSON_KEY_NOTIFY_ISANTIDISTURB,
            [NSNumber numberWithInteger:0], JSON_KEY_NOTIFY_STARTTIME,
            [NSNumber numberWithInteger:0], JSON_KEY_NOTIFY_ENDTIME, nil];
    [[CYZSDotNetClient sharedClient] getWithParam:[self constructParamWithMethod:REQUEST_METHOD_NOTIFY_SETANTI
                                                                  withDictionary:paramDict]
                                        withBlock:^(RequestStatusData *resultData) {
                                            if (block) {
                                                block(resultData);
                                            }
                                        }];
}

#pragma mark - styleController
//获取热门style
+ (void)getHotStyleListWithBlock:(void (^)(RequestStatusData *result))block {
    [[CYZSDotNetClient sharedClient] getWithParam:[self constructParamWithMethod:REQUEST_METHOD_STYLE_GETHOT
                                                                  withDictionary:nil]
                                        withBlock:^(RequestStatusData *resultData) {
                                            if (block) {
                                                block(resultData);
                                            }
                                        }];
}


//生成函数数组
+ (NSArray *)createAPIFunctionsArray {
    NSMutableArray *selectorArray = [NSMutableArray array];

    [selectorArray addObject:[NSValue valueWithPointer:@selector(getVersionWithBlock:)]];
    [selectorArray addObject:[NSValue valueWithPointer:@selector(initInfoWithBlock:)]];
    [selectorArray addObject:[NSValue valueWithPointer:@selector(getUnreadNotifyCountWithBlock:)]];
    [selectorArray addObject:[NSValue valueWithPointer:@selector(registerWithBlock:)]];
    [selectorArray addObject:[NSValue valueWithPointer:@selector(changePasswordWithBlock:)]];

    [selectorArray addObject:[NSValue valueWithPointer:@selector(modifyUserInfoWithBlock:)]];
    [selectorArray addObject:[NSValue valueWithPointer:@selector(checkUserNicknameWithBlock:)]];
    [selectorArray addObject:[NSValue valueWithPointer:@selector(loginWithBlock:)]];
    [selectorArray addObject:[NSValue valueWithPointer:@selector(logoutWithBlock:)]];
    [selectorArray addObject:[NSValue valueWithPointer:@selector(sendPasswordToEmailWithBlock:)]];

    [selectorArray addObject:[NSValue valueWithPointer:@selector(getUserInfoWithBlock:)]];
    [selectorArray addObject:[NSValue valueWithPointer:@selector(getOtherUserInfoWithBlock:)]];
    [selectorArray addObject:[NSValue valueWithPointer:@selector(getFeedBackListWithBlock:)]];
    [selectorArray addObject:[NSValue valueWithPointer:@selector(getLinksWithBlock:)]];
    [selectorArray addObject:[NSValue valueWithPointer:@selector(getSuitListWithBlock:)]];

    [selectorArray addObject:[NSValue valueWithPointer:@selector(getAllSuitIdsWithBlock:)]];
    [selectorArray addObject:[NSValue valueWithPointer:@selector(addOrModifySuitWithBlock:)]];
    [selectorArray addObject:[NSValue valueWithPointer:@selector(deleteSuitsWithBlock:)]];
    [selectorArray addObject:[NSValue valueWithPointer:@selector(getHotSuitWithBlock:)]];
    [selectorArray addObject:[NSValue valueWithPointer:@selector(getNewSuitListWithBlock:)]];

    [selectorArray addObject:[NSValue valueWithPointer:@selector(getSuitDetailWithBlock:)]];
    [selectorArray addObject:[NSValue valueWithPointer:@selector(getSuitCommentListWithBlock:)]];
    [selectorArray addObject:[NSValue valueWithPointer:@selector(getCollectUserListWithBlock:)]];
    [selectorArray addObject:[NSValue valueWithPointer:@selector(collectSuitWithBlock:)]];
    [selectorArray addObject:[NSValue valueWithPointer:@selector(deCollectSuitWithBlock:)]];

    [selectorArray addObject:[NSValue valueWithPointer:@selector(getUnreadFollowListCountWithBlock:)]];
    [selectorArray addObject:[NSValue valueWithPointer:@selector(getFollowSuitListWithBlock:)]];
    [selectorArray addObject:[NSValue valueWithPointer:@selector(getTagsWithBlock:)]];
    [selectorArray addObject:[NSValue valueWithPointer:@selector(getAdvertisementInShoppingWithBlock:)]];
    [selectorArray addObject:[NSValue valueWithPointer:@selector(getGoodsListByTagWithBlock:)]];

    [selectorArray addObject:[NSValue valueWithPointer:@selector(getGoodsListWithBlock:)]];
    [selectorArray addObject:[NSValue valueWithPointer:@selector(getGoodsInfoWithBlock:)]];
    [selectorArray addObject:[NSValue valueWithPointer:@selector(collectGoodsWithBlock:)]];
    [selectorArray addObject:[NSValue valueWithPointer:@selector(decollectGoodsWithBlock:)]];
    [selectorArray addObject:[NSValue valueWithPointer:@selector(getCollectGoodsListWithBlock:)]];

    [selectorArray addObject:[NSValue valueWithPointer:@selector(getMediaListWithBlock:)]];
    [selectorArray addObject:[NSValue valueWithPointer:@selector(getMediaWithBlock:)]];
    [selectorArray addObject:[NSValue valueWithPointer:@selector(getCollectSuitListWithBlock:)]];
    [selectorArray addObject:[NSValue valueWithPointer:@selector(getMediaCommentListWithBlock:)]];
    [selectorArray addObject:[NSValue valueWithPointer:@selector(getHotSuitListWithBlock:)]];

    [selectorArray addObject:[NSValue valueWithPointer:@selector(getNewlySuitListWithBlock:)]];
    [selectorArray addObject:[NSValue valueWithPointer:@selector(getTalentSquareWithBlock:)]];
    [selectorArray addObject:[NSValue valueWithPointer:@selector(getApplyTalentStatusWithBlock:)]];
    [selectorArray addObject:[NSValue valueWithPointer:@selector(getTalentNewListWithBlock:)]];
    [selectorArray addObject:[NSValue valueWithPointer:@selector(getTalentWeekyListWithBlock:)]];

    [selectorArray addObject:[NSValue valueWithPointer:@selector(getTalentOveralListWithBlock:)]];
    [selectorArray addObject:[NSValue valueWithPointer:@selector(getStyleListWithBlock:)]];
    [selectorArray addObject:[NSValue valueWithPointer:@selector(getRoleListWithBlock:)]];
    [selectorArray addObject:[NSValue valueWithPointer:@selector(getDailyRecommendListWithBlock:)]];
    [selectorArray addObject:[NSValue valueWithPointer:@selector(followWithBlock:)]];

    [selectorArray addObject:[NSValue valueWithPointer:@selector(unfollowWithBlock:)]];
    [selectorArray addObject:[NSValue valueWithPointer:@selector(getFollowListWithBlock:)]];
    [selectorArray addObject:[NSValue valueWithPointer:@selector(getFansListWithBlock:)]];
    [selectorArray addObject:[NSValue valueWithPointer:@selector(getNotifyListWithBlock:)]];
    [selectorArray addObject:[NSValue valueWithPointer:@selector(getUnreadNotifyWithBlock:)]];

    [selectorArray addObject:[NSValue valueWithPointer:@selector(resetNotifyWithBlock:)]];
    [selectorArray addObject:[NSValue valueWithPointer:@selector(getNotifyAntiDisturbWithBlock:)]];
    [selectorArray addObject:[NSValue valueWithPointer:@selector(setNotifyAntiDisterbWithBlock:)]];
    [selectorArray addObject:[NSValue valueWithPointer:@selector(getHotStyleListWithBlock:)]];

    return selectorArray;
}

@end
