//
//  UIView+GestureCallback.m
//  CYFProject
//
//  Created by tsaievan on 21/2/2019.
//  Copyright © 2019 tsaievan. All rights reserved.
//

#import "UIView+GestureCallback.h"
#import <objc/message.h>

const NSString *UIView_GestureCallback_gesturesKey = @"UIView_GestureCallback_gestureKeys";
const NSString *UIView_GestureCallback_gestureKeysHashKey = @"UIView_GestureCallback_gestureKeysHashKey";

@implementation GestureCallbackValues
@end

@implementation UIView (GestureCallback)

- (NSString *)addTapGestureRecognizer:(void (^)(UITapGestureRecognizer * _Nonnull, NSString * _Nonnull))tapCallback {
    NSString *rand;
    do {
        
    } while ([self.gestures objectForKey:rand] != nil);
    [self addTapGestureRecognizer:tapCallback tapGestureId:rand];
    return rand;
}

- (void)addTapGestureRecognizer:(void (^)(UITapGestureRecognizer * _Nonnull, NSString * _Nonnull))tapCallback tapGestureId:(NSString *)tapGestureId {
    
}

#pragma mark - 生成随机字符串 
- (NSString *)randomStringWithLength:(int)length {
    const NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity:length];
    for (int i = 0; i < length; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex:arc4random_uniform((uint32_t)[letters length])]];
    }
    return randomString;
}

#pragma mark - getters & setters
- (void)setGestures:(NSMutableDictionary *)gestures {
    objc_setAssociatedObject(self, &UIView_GestureCallback_gesturesKey, gestures, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableDictionary *)gestures {
    NSMutableDictionary *dict = objc_getAssociatedObject(self, &UIView_GestureCallback_gesturesKey);
    if (dict == nil) {
        dict = [NSMutableDictionary new];
        self.gestures = dict;
    }
    return dict;
}

- (void)setGestureKeysHash:(NSMutableDictionary *)gestureKeysHash {
    objc_setAssociatedObject(self, &UIView_GestureCallback_gestureKeysHashKey, gestureKeysHash, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableDictionary *)gestureKeysHash {
    NSMutableDictionary *dict = objc_getAssociatedObject(self, &UIView_GestureCallback_gestureKeysHashKey);
    if (dict == nil) {
        dict = [NSMutableDictionary new];
        self.gestureKeysHash = dict;
    }
    return dict;
}


@end
