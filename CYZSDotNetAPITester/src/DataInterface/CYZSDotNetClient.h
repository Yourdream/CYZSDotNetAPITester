//
//  CYZSDotNetClient.h
//  CYZS
//
//  Created by Wei Li on 02/09/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//



#import "AFHTTPClient.h"

@class RequestStatusData;

@interface CYZSDotNetClient : AFHTTPClient

@property (nonatomic, assign)BOOL loginSuccess;
@property (nonatomic, retain)NSString *deviceToken;

+ (CYZSDotNetClient *)sharedClient;

- (void)getWithParam:(NSDictionary *)paramDict
           withBlock:(void (^)(RequestStatusData *result))block;

@end
