//
//  CYZSTimer.m
//  CYZSDotNetAPITester
//
//  Created by Wei Li on 04/04/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "CYZSTimer.h"

@implementation CYZSTimer

- (id) init {
    self = [super init];
    if (self != nil) {
        start = nil;
        end = nil;
    }
    return self;
}

- (void) startTimer {
    start = [NSDate date];
}

- (void) stopTimer {
    end = [NSDate date];
}

- (double) timeElapsedInSeconds {
    return [end timeIntervalSinceDate:start];
}

- (double) timeElapsedInMilliseconds {
    return [self timeElapsedInSeconds] * 1000.0f;
}

- (double) timeElapsedInMinutes {
    return [self timeElapsedInSeconds] / 60.0f;
}

@end
