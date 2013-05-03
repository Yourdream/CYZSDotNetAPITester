//
//  CYZSDotNetClient.m
//  CYZS
//
//  Created by Wei Li on 02/09/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "CYZSDotNetClient.h"
#import "AFJSONRequestOperation.h"
#import "CYZSConfig.h"
#import "CYZSBaseClassesExtended.h"
#import "RequestStatusData.h"
#import "CYZSTimer.h"

static NSString * const kAFAppDotNetAPIBaseURLString = API_BASE_URL;

@implementation CYZSDotNetClient

@synthesize loginSuccess;
@synthesize deviceToken;

+ (CYZSDotNetClient *)sharedClient {
    static CYZSDotNetClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[CYZSDotNetClient alloc] initWithBaseURL:[NSURL URLWithString:kAFAppDotNetAPIBaseURLString]];
    });

    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }

    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    // Accept HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
    [self setDefaultHeader:@"Accept" value:@"text/html"];

    loginSuccess = NO;

    return self;
}

//JSON返回错误集中判断
- (BOOL)parseResultJSON:(id)JSON error:(NSError **)error {
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

- (void)getPath:(NSString *)path
     parameters:(NSDictionary *)parameters
        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSURLRequest *request = [self requestWithMethod:@"GET" path:path parameters:parameters];
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request
                                                                      success:^(AFHTTPRequestOperation *operation1, id responseObject){
                                                                          NSLog(@"Request url = %@ \nResult = %@", operation1.request.URL.absoluteString, responseObject);
                                                                          if (success) {
                                                                              success(operation1, responseObject);
                                                                          }
                                                                      }
                                                                      failure:^(AFHTTPRequestOperation *operation1, NSError *error){
                                                                          if (failure) {

                                                                              failure(operation1, error);
                                                                          }
                                                                      }];
    [self enqueueHTTPRequestOperation:operation];
}

- (void)getWithParam:(NSDictionary *)paramDict
           withBlock:(void (^)(RequestStatusData *result))block {

    RequestStatusData *statusData = [[RequestStatusData alloc] init];
    statusData.requestMethod = [paramDict objectForKey:JSON_KEY_METHOD];

    CYZSTimer *timer = [[CYZSTimer alloc] init];
    [timer startTimer];

    [self getPath:API_PATH
       parameters:paramDict
          success:^(AFHTTPRequestOperation *operation, id JSON){
              NSError *error = nil;
              [self parseResultJSON:JSON error:&error];
              NSDictionary *resultDict = [JSON valueForKey:JSON_KEY_DATA];
              [timer stopTimer];
              statusData.milliSeconds = [timer timeElapsedInMilliseconds];
              if (error) {
                  statusData.resultId = error.code;
                  statusData.errorMessage = [error localizedDescription];
              }
              if (block) {
                  if ([resultDict isKindOfClass:[NSDictionary class]]) {
                      statusData.errorMessage = [resultDict safeStringForKey:@"msg"];
                      block(statusData);
                  } else {
                      block(statusData);
                  }
              }
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error){
              [timer stopTimer];
              statusData.milliSeconds = [timer timeElapsedInMilliseconds];
              statusData.resultId = error.code;
              statusData.errorMessage = [error localizedDescription];
              if (block) {
                  block(statusData);
              }
          }];
}

@end
