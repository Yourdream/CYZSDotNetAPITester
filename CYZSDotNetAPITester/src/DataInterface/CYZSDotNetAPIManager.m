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

//获取版本更新信息
+ (void)getVersionWithBlock:(void (^)(RequestStatusData *result))block {
    [[CYZSDotNetClient sharedClient] getWithParam:[CYZSDotNetAPIManager constructNoneUidParamDictWithMethod:REQUEST_METHOD_GETVERSION
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
    [paramDict safeSetObject:[NSString stringWithFormat:@"%@@cyzs.com", userAnonymousName] forKey:JSON_KEY_EMAIL];
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


////检查昵称
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

//修改个人主页
+ (void)modifyUserHomepageWithBlock:(void (^)(RequestStatusData *result))block {
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

//获取所有日记ID
+ (void)getAllDiaryIdsWithBlock:(void (^)(RequestStatusData *result))block {
    [[CYZSDotNetClient sharedClient] getWithParam:[self constructParamWithMethod:REQUEST_METHOD_ALL_DIARYIDS
                                                                  withDictionary:nil]
                                        withBlock:^(RequestStatusData *resultData) {
                                            if (block) {
                                                block(resultData);
                                            }
                                        }];
}


//获取日记列表
+ (void)getDiaryListWithBlock:(void (^)(RequestStatusData *result))block{
    NSDictionary *paramDict = [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithInteger:1], @"page",
            [NSNumber numberWithInteger:20], @"pageSize", nil];
    [[CYZSDotNetClient sharedClient] getWithParam:[self constructParamWithMethod:REQUEST_METHOD_DIARY_GETLIST
                                                                  withDictionary:paramDict]
                                        withBlock:^(RequestStatusData *resultData) {
                                            if (block) {
                                                block(resultData);
                                            }
                                        }];
}

//获取标签信息
+ (void)getTagsWithBlock:(void (^)(RequestStatusData *result))block {
    [[CYZSDotNetClient sharedClient] getWithParam:[self constructParamWithMethod:REQUEST_METHOD_GETTAGS
                                                                  withDictionary:nil]
                                        withBlock:^(RequestStatusData *resultData) {
                                            if (block) {
                                                block(resultData);
                                            }
                                        }];
}


#pragma mark - Pfeed Controller

//获取最新搭配印象
+ (void)getNewDressImpressWithBlock:(void (^)(RequestStatusData *result))block {
    NSDictionary *paramDict = [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithInteger:20], JSON_KEY_IMPRESS_LIMIT, nil];
    [[CYZSDotNetClient sharedClient] getWithParam:[self constructParamWithMethod:REQUEST_METHOD_IMPRESS_GETNEW
                                                                  withDictionary:paramDict]
                                        withBlock:^(RequestStatusData *resultData) {
                                            if (block) {
                                                block(resultData);
                                            }
                                        }];
}

//获取最热搭配印象
+ (void)getHotDressImpressWithBlock:(void (^)(RequestStatusData *result))block {
    NSDictionary *paramDict = [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithInteger:20], JSON_KEY_IMPRESS_LIMIT,
            [NSNumber numberWithInteger:1],JSON_KEY_IMPRESS_PAGE, nil];
    [[CYZSDotNetClient sharedClient] getWithParam:[self constructParamWithMethod:REQUEST_METHOD_IMPRESS_GETHOT
                                                                  withDictionary:paramDict]
                                        withBlock:^(RequestStatusData *resultData) {
                                            if (block) {
                                                block(resultData);
                                            }
                                        }];
}

//获取最热搭配印象
+ (void)getHotTypeDressImpressWithBlock:(void (^)(RequestStatusData *result))block {
    NSDictionary *paramDict = [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithInteger:20], JSON_KEY_IMPRESS_LIMIT,
            [NSNumber numberWithInteger:1],JSON_KEY_IMPRESS_PAGE,
            @"复古", JSON_KEY_IMPRESS_STYLE, nil];
    [[CYZSDotNetClient sharedClient] getWithParam:[self constructParamWithMethod:REQUEST_METHOD_IMPRESS_GETHOT
                                                                  withDictionary:paramDict]
                                        withBlock:^(RequestStatusData *resultData) {
                                            if (block) {
                                                block(resultData);
                                            }
                                        }];
}


//获取他人搭配印象列表
+ (void)getDressImpressListWithBlock:(void (^)(RequestStatusData *result))block {
    NSDictionary *paramDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:20], JSON_KEY_IMPRESS_LIMIT,
                                                                         [NSNumber numberWithInteger:1],JSON_KEY_IMPRESS_PAGE,
                                                                         [NSNumber numberWithInteger:1349850638],JSON_KEY_IMPRESS_FUSERID,
                                                                         nil];
    [[CYZSDotNetClient sharedClient] getWithParam:[self constructParamWithMethod:REQUEST_METHOD_IMPRESS_GETLIST
                                                                  withDictionary:paramDict]
                                        withBlock:^(RequestStatusData *resultData) {
                                            if (block) {
                                                block(resultData);
                                            }
                                        }];
}

//获取搭配印象详情
+ (void)getPfeedDetialWithBlock:(void (^)(RequestStatusData *result))block {
    NSDictionary *paramDict = [NSDictionary dictionaryWithObjectsAndKeys: [NSNumber numberWithInteger:1348318539], JSON_KEY_IMPRESS_PFEEDID,
                                                                          [NSNumber numberWithInteger:1349850638],JSON_KEY_IMPRESS_CREATERUSERID,
                                                                          nil];
    [[CYZSDotNetClient sharedClient] getWithParam:[self constructParamWithMethod:REQUEST_METHOD_IMPRESS_DETAIL
                                                                  withDictionary:paramDict]
                                        withBlock:^(RequestStatusData *resultData) {
                                            if (block) {
                                                block(resultData);
                                            }
                                        }];
}

//获取搭配印象 评论列表
+ (void)getPfeedCommentListWithBlock:(void (^)(RequestStatusData *result))block {
    NSDictionary *paramDict = [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithInteger:1348318539], JSON_KEY_IMPRESS_PFEEDID,
            [NSNumber numberWithInteger:1349850638], JSON_KEY_IMPRESS_CREATERUSERID,
            [NSNumber numberWithInteger:1], JSON_KEY_IMPRESS_PAGE,
            nil];
    [[CYZSDotNetClient sharedClient] getWithParam:[self constructParamWithMethod:REQUEST_METHOD_IMPRESS_COMMENTLIST
                                                                  withDictionary:paramDict]
                                        withBlock:^(RequestStatusData *resultData) {
                                            if (block) {
                                                block(resultData);
                                            }
                                        }];
}

//获取评论列表
+ (void)getPfeedVoteListWithBlock:(void (^)(RequestStatusData *result))block {
    NSDictionary *paramDict = [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithInteger:1348318539], JSON_KEY_IMPRESS_PFEEDID,
            [NSNumber numberWithInteger:1349850638], JSON_KEY_IMPRESS_CREATERUSERID,
            [NSNumber numberWithInteger:1], JSON_KEY_IMPRESS_PAGE,
            nil];

    [[CYZSDotNetClient sharedClient] getWithParam:[self constructParamWithMethod:REQUEST_METHOD_IMPRESS_VOTE_LIST
                                                                  withDictionary:paramDict]
                                        withBlock:^(RequestStatusData *resultData) {
                                            if (block) {
                                                block(resultData);
                                            }
                                        }];

}


//投票(读过)搭配印象
+ (void)votePfeedWithBlock:(void (^)(RequestStatusData *result))block {
    NSDictionary *paramDict = [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithInteger:1349850638], JSON_KEY_IMPRESS_FUSERID,
            [NSNumber numberWithInteger:1348318539], JSON_KEY_IMPRESS_PFEEDID,
            [NSNumber numberWithInteger:3], JSON_KEY_IMPRESS_VOTE, nil];

    [[CYZSDotNetClient sharedClient] getWithParam:[self constructParamWithMethod:REQUEST_METHOD_IMPRESS_VOTE
                                                                  withDictionary:paramDict]
                                        withBlock:^(RequestStatusData *resultData) {
                                            if (block) {
                                                block(resultData);
                                            }
                                        }];
}

//获取关注的未读数量
+ (void)getUnreadFollowListCountWithBlock:(void (^)(RequestStatusData *result))block {
    [[CYZSDotNetClient sharedClient] getWithParam:[self constructParamWithMethod:REQUEST_METHOD_IMPRESS_UNREADCOUNT
                                                                  withDictionary:nil]
                                        withBlock:^(RequestStatusData *resultData) {
                                            if (block) {
                                                block(resultData);
                                            }
                                        }];
}

//获取关注的搭配印象
+ (void)getPfeedFollowListWithBlock:(void (^)(RequestStatusData *result))block {
    NSDictionary *paramDict = [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithInteger:1], JSON_KEY_PAGE,
            [NSNumber numberWithInteger:20], JSON_KEY_PAGESIZE, nil];
    [[CYZSDotNetClient sharedClient] getWithParam:[self constructParamWithMethod:REQUEST_METHOD_IMPRESS_FOLLOWLIST
                                                                  withDictionary:paramDict]
                                        withBlock:^(RequestStatusData *resultData) {
                                            if (block) {
                                                block(resultData);
                                            }
                                        }];
}


#pragma mark - Tag Controller

//获取最热标签列表
+ (void)getTagHotListWithBlock:(void (^)(RequestStatusData *result))block {
    [[CYZSDotNetClient sharedClient] getWithParam:[self constructParamWithMethod:REQUEST_METHOD_HOT_TAGS
                                                                  withDictionary:nil]
                                        withBlock:^(RequestStatusData *resultData) {
                                            if (block) {
                                                block(resultData);
                                            }
                                        }];
}


#pragma mark - Media Controller

//获取标签的最热最新列表
+ (void)getNewGoodsWithBlock:(void (^)(RequestStatusData *result))block {
    NSDictionary *paramDict = [NSDictionary dictionaryWithObjectsAndKeys:
            @"连衣裙", JSON_KEY_IMPRESS_TAG,
            [NSNumber numberWithInteger:1], JSON_KEY_IMPRESS_PAGE,
            [NSNumber numberWithInteger:20], JSON_KEY_PAGESIZE, nil];
    [[CYZSDotNetClient sharedClient] getWithParam:[self constructParamWithMethod:REQUEST_METHOD_GET_TAG_GOODS
                                                                  withDictionary:paramDict]
                                        withBlock:^(RequestStatusData *resultData) {
                                            if (block) {
                                                block(resultData);
                                            }
                                        }];
}

//获取标签的最热最新列表
+ (void)getHotGoodsWithBlock:(void (^)(RequestStatusData *result))block {
    NSDictionary *paramDict = [NSDictionary dictionaryWithObjectsAndKeys:
            @"连衣裙", JSON_KEY_IMPRESS_TAG,
            [NSNumber numberWithInteger:1], JSON_KEY_IMPRESS_PAGE,
            [NSNumber numberWithInteger:20], JSON_KEY_PAGESIZE, nil];
    [[CYZSDotNetClient sharedClient] getWithParam:[self constructParamWithMethod:REQUEST_METHOD_GET_HOT_TAG_GOODS
                                                                  withDictionary:paramDict]
                                        withBlock:^(RequestStatusData *resultData) {
                                            if (block) {
                                                block(resultData);
                                            }
                                        }];
}

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


+ (void)getCollectListWithBlock:(void (^)(RequestStatusData *result))block {
    NSDictionary *paramDict = [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithInteger:1], JSON_KEY_IMPRESS_PAGE,
            [NSNumber numberWithInteger:20], JSON_KEY_PAGESIZE,
            [NSNumber numberWithInteger:1349850638], JSON_KEY_IMPRESS_VIEWUSERID,nil];
    [[CYZSDotNetClient sharedClient] getWithParam:[self constructParamWithMethod:REQUEST_METHOD_COLLECT_LIST
                                                                  withDictionary:paramDict]
                                        withBlock:^(RequestStatusData *resultData) {
                                            if (block) {
                                                block(resultData);
                                            }
                                        }];
}

+ (void)getGoodsWithBlock:(void (^)(RequestStatusData *result))block {
    NSDictionary *paramDict = [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithInteger:1], JSON_KEY_GOODS_SUITID,
            [NSNumber numberWithInteger:42], JSON_KEY_GOODS_MEDIAID, nil];
    [[CYZSDotNetClient sharedClient] getWithParam:[self constructParamWithMethod:REQUEST_METHOD_GET_SUIT_GOODS
                                                                  withDictionary:paramDict]
                                        withBlock:^(RequestStatusData *resultData) {
                                            if (block) {
                                                block(resultData);
                                            }
                                        }];
}

+ (void)getSuitListWithBlock:(void (^)(RequestStatusData *result))block {
    NSDictionary *paramDict = [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithInteger:1], JSON_KEY_IMPRESS_PAGE,
            [NSNumber numberWithInteger:20], JSON_KEY_PAGESIZE, nil];
    [[CYZSDotNetClient sharedClient] getWithParam:[self constructParamWithMethod:REQUEST_METHOD_GET_SUIT_LIST
                                                                  withDictionary:paramDict]
                                        withBlock:^(RequestStatusData *resultData) {
                                            if (block) {
                                                block(resultData);
                                            }
                                        }];
}

+ (void)getSuitCommentListWithBlock:(void (^)(RequestStatusData *result))block {
    NSDictionary *paramDict = [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithInteger:42], JSON_KEY_SUIT_MEDIAID,
            [NSNumber numberWithInteger:1], JSON_KEY_SUIT_SUITID,
            [NSNumber numberWithInteger:1], JSON_KEY_IMPRESS_PAGE,
            [NSNumber numberWithInteger:20], JSON_KEY_PAGESIZE, nil];
    [[CYZSDotNetClient sharedClient] getWithParam:[self constructParamWithMethod:REQUEST_METHOD_GET_SUIT_COMMENT
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
            [NSNumber numberWithInteger:1], JSON_KEY_IMPRESS_PAGE,
            [NSNumber numberWithInteger:20], JSON_KEY_PAGESIZE, nil];
    [[CYZSDotNetClient sharedClient] getWithParam:[self constructParamWithMethod:REQUEST_METHOD_COLLECT_SUIT_LIST
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

+ (void)getHotPfeedListWithBlock:(void (^)(RequestStatusData *result))block {
    NSDictionary *paramDict = [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithInteger:42], JSON_KEY_MEDIA_MEDIAID,
            [NSNumber numberWithInteger:1], JSON_KEY_PAGE,
            [NSNumber numberWithInteger:20], JSON_KEY_PAGESIZE, nil];
    [[CYZSDotNetClient sharedClient] getWithParam:[self constructParamWithMethod:REQUEST_METHOD_MEDIA_HOT_LIST
                                                                  withDictionary:paramDict]
                                        withBlock:^(RequestStatusData *resultData) {
                                            if (block) {
                                                block(resultData);
                                            }
                                        }];
}

+ (void)getNewlyPfeedListWithBlock:(void (^)(RequestStatusData *result))block {
    NSDictionary *paramDict = [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithInteger:42], JSON_KEY_MEDIA_MEDIAID,
            [NSNumber numberWithInteger:1], JSON_KEY_PAGE,
            [NSNumber numberWithInteger:20], JSON_KEY_PAGESIZE, nil];
    [[CYZSDotNetClient sharedClient] getWithParam:[self constructParamWithMethod:REQUEST_METHOD_MEDIA_NEW_LIST
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

//获取最新达人列表
+ (void)getRecentTalentListWithBlock:(void (^)(RequestStatusData *result))block {
    NSDictionary *paramDict = [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithInteger:1], JSON_KEY_PAGE,
            [NSNumber numberWithInteger:20], JSON_KEY_PAGESIZE, nil];
    [[CYZSDotNetClient sharedClient] getWithParam:[self constructParamWithMethod:REQUEST_METHOD_TALENT_RECENTLIST
                                                                  withDictionary:paramDict]
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

//达人周榜
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



//生成函数数组
+ (NSArray *)createAPIFunctionsArray {
    NSMutableArray *selectorArray = [NSMutableArray array];
    [selectorArray addObject:[NSValue valueWithPointer:@selector(getVersionWithBlock:)]];
    [selectorArray addObject:[NSValue valueWithPointer:@selector(initInfoWithBlock:)]];
    [selectorArray addObject:[NSValue valueWithPointer:@selector(getUnreadNotifyCountWithBlock:)]];
    [selectorArray addObject:[NSValue valueWithPointer:@selector(registerWithBlock:)]];
    [selectorArray addObject:[NSValue valueWithPointer:@selector(checkUserNicknameWithBlock:)]];

    [selectorArray addObject:[NSValue valueWithPointer:@selector(modifyUserHomepageWithBlock:)]];
    [selectorArray addObject:[NSValue valueWithPointer:@selector(loginWithBlock:)]];
    [selectorArray addObject:[NSValue valueWithPointer:@selector(logoutWithBlock:)]];
    [selectorArray addObject:[NSValue valueWithPointer:@selector(getUserInfoWithBlock:)]];
    [selectorArray addObject:[NSValue valueWithPointer:@selector(getOtherUserInfoWithBlock:)]];

    [selectorArray addObject:[NSValue valueWithPointer:@selector(getFeedBackListWithBlock:)]];
    [selectorArray addObject:[NSValue valueWithPointer:@selector(getLinksWithBlock:)]];
    [selectorArray addObject:[NSValue valueWithPointer:@selector(getAllDiaryIdsWithBlock:)]];
    [selectorArray addObject:[NSValue valueWithPointer:@selector(getDiaryListWithBlock:)]];
    [selectorArray addObject:[NSValue valueWithPointer:@selector(getTagsWithBlock:)]];

    [selectorArray addObject:[NSValue valueWithPointer:@selector(getNewDressImpressWithBlock:)]];
    [selectorArray addObject:[NSValue valueWithPointer:@selector(getHotDressImpressWithBlock:)]];
    [selectorArray addObject:[NSValue valueWithPointer:@selector(getHotTypeDressImpressWithBlock:)]];
    [selectorArray addObject:[NSValue valueWithPointer:@selector(getDressImpressListWithBlock:)]];
    [selectorArray addObject:[NSValue valueWithPointer:@selector(getPfeedDetialWithBlock:)]];

    [selectorArray addObject:[NSValue valueWithPointer:@selector(getPfeedCommentListWithBlock:)]];
    [selectorArray addObject:[NSValue valueWithPointer:@selector(getPfeedVoteListWithBlock:)]];
    [selectorArray addObject:[NSValue valueWithPointer:@selector(votePfeedWithBlock:)]];
    [selectorArray addObject:[NSValue valueWithPointer:@selector(getUnreadFollowListCountWithBlock:)]];
    [selectorArray addObject:[NSValue valueWithPointer:@selector(getPfeedFollowListWithBlock:)]];

    [selectorArray addObject:[NSValue valueWithPointer:@selector(getTagHotListWithBlock:)]];
    [selectorArray addObject:[NSValue valueWithPointer:@selector(getNewGoodsWithBlock:)]];
    [selectorArray addObject:[NSValue valueWithPointer:@selector(getHotGoodsWithBlock:)]];
    [selectorArray addObject:[NSValue valueWithPointer:@selector(getMediaListWithBlock:)]];
    [selectorArray addObject:[NSValue valueWithPointer:@selector(getMediaWithBlock:)]];

    [selectorArray addObject:[NSValue valueWithPointer:@selector(getCollectListWithBlock:)]];
    [selectorArray addObject:[NSValue valueWithPointer:@selector(getGoodsWithBlock:)]];
    [selectorArray addObject:[NSValue valueWithPointer:@selector(getSuitListWithBlock:)]];
    [selectorArray addObject:[NSValue valueWithPointer:@selector(getSuitCommentListWithBlock:)]];
    [selectorArray addObject:[NSValue valueWithPointer:@selector(getCollectSuitListWithBlock:)]];

    [selectorArray addObject:[NSValue valueWithPointer:@selector(getMediaCommentListWithBlock:)]];
    [selectorArray addObject:[NSValue valueWithPointer:@selector(getHotPfeedListWithBlock:)]];
    [selectorArray addObject:[NSValue valueWithPointer:@selector(getNewlyPfeedListWithBlock:)]];
    [selectorArray addObject:[NSValue valueWithPointer:@selector(getTalentSquareWithBlock:)]];
    [selectorArray addObject:[NSValue valueWithPointer:@selector(getRecentTalentListWithBlock:)]];

    [selectorArray addObject:[NSValue valueWithPointer:@selector(getApplyTalentStatusWithBlock:)]];
    [selectorArray addObject:[NSValue valueWithPointer:@selector(getTalentNewListWithBlock:)]];
    [selectorArray addObject:[NSValue valueWithPointer:@selector(getTalentOveralListWithBlock:)]];
    [selectorArray addObject:[NSValue valueWithPointer:@selector(getTalentWeekyListWithBlock:)]];
    [selectorArray addObject:[NSValue valueWithPointer:@selector(getStyleListWithBlock:)]];

    [selectorArray addObject:[NSValue valueWithPointer:@selector(getRoleListWithBlock:)]];
    [selectorArray addObject:[NSValue valueWithPointer:@selector(getDailyRecommendListWithBlock:)]];
    [selectorArray addObject:[NSValue valueWithPointer:@selector(getFollowListWithBlock:)]];
    [selectorArray addObject:[NSValue valueWithPointer:@selector(getFansListWithBlock:)]];
    [selectorArray addObject:[NSValue valueWithPointer:@selector(getNotifyListWithBlock:)]];

    [selectorArray addObject:[NSValue valueWithPointer:@selector(getUnreadNotifyWithBlock:)]];
    [selectorArray addObject:[NSValue valueWithPointer:@selector(resetNotifyWithBlock:)]];


    return selectorArray;
}

@end
