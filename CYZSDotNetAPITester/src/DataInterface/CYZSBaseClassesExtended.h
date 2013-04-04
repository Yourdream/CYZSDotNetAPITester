//
//  PYBaseClassesExtended.h
//  ProjectYIos
//
//  Created by ChenXiao Jiang on 12-3-20.
//  Copyright (c) 2012年 FiveMinutes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject(CYZSExtended)
//- (NSInteger)length;
- (BOOL)isNull;
- (BOOL)isValid;

@end

@interface NSNull(CYZSExtended)

- (BOOL)isNull;
- (BOOL)isValid;

@end

@interface NSDictionary(CYZSExtended)

- (BOOL)isNull;
- (BOOL)isValid;

// this is a safe method, you can just call this method
// if there's no key existed in dictionary or the value of key isNull, it will return nil
- (id)getObjectForKey:(NSString*)key;

- (NSDictionary*)safeDictionaryForKey:(NSString *)key;
- (NSString*)safeStringForKey:(NSString *)key;
- (int)safeIntForKey:(NSString *)key;
- (BOOL)safeBoolForKey:(NSString *)key;
- (float)safeFloatForKey:(NSString *)key;
- (long long)safeLongLongForKey:(NSString *)key;
    
@end

@interface NSMutableDictionary(CYZSExtended)

- (void)safeSetObject:(id)anObject forKey:(id)aKey;

@end

@interface NSMutableArray(CYZSExtended)
- (void)safeAddObject:(id)anObject;
- (void)safeInsertObject:(id)anObject atIndex:(NSUInteger)index;
@end

@interface NSArray(CYZSExtended)

- (BOOL)isNull;
- (BOOL)isValid;

// this is a safe method, you can just call this method
// if index is larger than count or the value of index isNull, it will return nil
- (id)getObjectAtIndex:(NSInteger)index;

@end

@interface NSString(CYZSExtended)

- (BOOL)isNull;
- (BOOL)isValid;

- (NSString *)stringByDecodingURLFormat;
- (NSString *)trimWhitespace;

@end

@interface NSNumber(CYZSExtended)

- (BOOL)isNull;
- (BOOL)isValid;

@end

@interface UIViewController(CYZSExtended)

- (void)resetViewSize;

@end

@interface UIView(CYZSExtended)

- (void)resetViewSize;

@end
