//
//  CYZSTimer.h
//  CYZSDotNetAPITester
//
//  Created by Wei Li on 04/04/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//



@interface CYZSTimer : NSObject {
    NSDate *start;
    NSDate *end;
}

- (void) startTimer;
- (void) stopTimer;
- (double) timeElapsedInSeconds;
- (double) timeElapsedInMilliseconds;
- (double) timeElapsedInMinutes;

@end
