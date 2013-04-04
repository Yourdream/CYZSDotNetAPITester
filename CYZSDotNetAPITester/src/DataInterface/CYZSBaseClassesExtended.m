//
//  PYBaseClassesExtended.m
//  ProjectYIos
//
//  Created by ChenXiao Jiang on 12-3-20.
//  Copyright (c) 2012年 FiveMinutes. All rights reserved.
//

#import "CYZSBaseClassesExtended.h"

@implementation NSObject(PYExtended)

- (BOOL)isNull {
    if (self != nil && ![self isKindOfClass:[NSNull class]]) {
        return NO;
    }
    return YES;
}
- (BOOL)isValid {
    return ![self isNull];
}
//- (NSInteger)length
//{
//    YDLog(@"type =%@", [[self class] description]);
//    return 0;
//}
@end

@implementation NSNull(PYExtended)

- (BOOL)isNull {
    return YES;
}

- (BOOL)isValid {
    return NO;
}

@end

@implementation NSMutableDictionary(PYExtended)

- (void)safeSetObject:(id)anObject forKey:(id)aKey {
    if ([anObject isValid] && aKey && [aKey isKindOfClass:[NSString class]]) {
        [self setObject:anObject forKey:aKey];
    }
}

@end

@implementation NSDictionary(PYExtended)

- (BOOL)isNull {
    if (self != nil && ![self isKindOfClass:[NSNull class]]) {
        if (self.count > 0) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)isValid {
    return ![self isNull];
}

- (BOOL)isValidString:(id)object{
    if (object && [object isKindOfClass:[NSString class]] && [object length]>0) {
        if (NSOrderedSame != [object caseInsensitiveCompare:@"null"]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)isValidNumber:(id)object{
    if (object && [object isKindOfClass:[NSNumber class]]){
        return YES;
    }
    return NO;
}

- (BOOL)isValidDigital:(id)object{
    if ([self isValidNumber:object] || [self isValidString:object]) {
        return YES;
    }
    return NO;
}

- (NSDictionary*)safeDictionaryForKey:(NSString *)key{
    if ([self isValidString:key]) {
        id value = [self objectForKey:key];
        if (value!=nil && [value isKindOfClass:[NSDictionary class]]) {
            return value;
        }
    }
    return nil;
}

- (NSString*)safeStringForKey:(NSString *)key{
    if ([self isValidString:key]) {
        id value = [self objectForKey:key];
        if ([self isValidString:value]) {
            return value;
        }
    }
    return nil;
}

- (int)safeIntForKey:(NSString *)key{
    if ([self isValidString:key]) {
        id value = [self objectForKey:key];
        if ([self isValidDigital:value]) {
            return [value intValue];
        }
    }
    return 0;
}

- (BOOL)safeBoolForKey:(NSString *)key{
    if ([self isValidString:key]) {
        id value = [self objectForKey:key];
        if ([self isValidDigital:value]) {
            return [value boolValue];
        }
    }
    return NO;    
}

- (float)safeFloatForKey:(NSString *)key{
    if ([self isValidString:key]) {
        id value = [self objectForKey:key];
        if ([self isValidDigital:value]) {
            return [value floatValue];
        }
    }
    return 0.0;    
}

- (long long)safeLongLongForKey:(NSString *)key{
    if ([self isValidString:key]) {
        id value = [self objectForKey:key];
        if ([self isValidDigital:value]) {
            return [value longLongValue];
        }
    }
    return 0;
}

- (id)getObjectForKey:(NSString *)key {
    if (![key isNull] && ![self isNull]) {
        id value = [self objectForKey:key];
        if (value != nil && ![value isKindOfClass:[NSNull class]]) {
            if (![value isNull]) {
                return value;
            }
        }
    }
    return nil;
}

@end


@implementation NSMutableArray(PYExtended)
- (void)safeAddObject:(id)anObject{
    if (anObject != nil) {
        [self addObject:anObject];
    }
//#if DEBUG
//    else {
//        YDLog(@"try to add nil object here");
//    }
//#endif
}
- (void)safeInsertObject:(id)anObject atIndex:(NSUInteger)index{
     if (anObject != nil) {
         [self insertObject:anObject atIndex:index];
     }
//#if DEBUG
//     else {
//         YDLog(@"try to indert nil object here");
//     }
//#endif
}
@end

@implementation NSArray(PYExtended)

- (BOOL)isNull {
    if (self != nil && ![self isKindOfClass:[NSNull class]]) {
        if (self.count > 0) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)isValid {
    return ![self isNull];
}

- (id)getObjectAtIndex:(NSUInteger)index {
    if (![self isNull]) {
        if (index < self.count) {
            id value = [self objectAtIndex:index];
            if (value != nil && ![value isKindOfClass:[NSNull class]]) {
                if (![value isNull]) {
                    return value;
                }
            }
        }
    }
    return nil;
}

@end

@implementation NSString(PYExtended)

- (BOOL)isNull {
    if (self != nil && ![self isKindOfClass:[NSNull class]]) {
        if (self.length > 0) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)isValid {
    return ![self isNull];
}

- (NSString *)stringByDecodingURLFormat {
    NSString *result = [(NSString *)self stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    result = [result stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return result;
}

- (NSString *)trimWhitespace
{
    NSMutableString *str = [self mutableCopy];
    CFStringTrimWhitespace((__bridge CFMutableStringRef)str);
    return str;
}

@end

@implementation NSNumber(PYExtended)

- (BOOL)isNull {
    if (self != nil && ![self isKindOfClass:[NSNull class]]) {
        return NO;
    }
    return YES;
}

- (BOOL)isValid {
    return ![self isNull];
}

@end

@implementation UIViewController(PYExtended)

- (void)resetViewSize {
}

@end

@implementation UIView(PYExtended)

- (void)resetViewSize {
}

@end
