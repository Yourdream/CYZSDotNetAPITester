//
//  RequestStatusData.h
//  CYZSDotNetAPITester
//
//  Created by Wei Li on 04/04/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//



@interface RequestStatusData : NSObject

@property (nonatomic, strong) NSString *requestMethod;
@property (nonatomic, strong) NSString *errorMessage;
@property (nonatomic, assign) NSInteger resultId;

@property (nonatomic, assign) double milliSeconds;

@end
