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
        rand = [self randomStringWithLength:12];
    } while ([self.gestures objectForKey:rand] != nil);
    [self addTapGestureRecognizer:tapCallback tapGestureId:rand];
    return rand;
}

- (NSString *)addTapGestureRecognizer:(void (^)(UITapGestureRecognizer * _Nonnull, NSString * _Nonnull))tapCallback numberOfTapsRequired:(NSUInteger)numberOfTapsRequired numberOfTouchesRequired:(NSUInteger)numberOfTouchesRequired {
    NSString *rand;
    do {
        rand = [self randomStringWithLength:12];
    } while ([self.gestures objectForKey:rand] != nil);
    [self addTapGestureRecognizer:tapCallback numberOfTapsRequired:numberOfTapsRequired numberOfTouchesRequired:numberOfTouchesRequired];
    return rand;
}

- (void)addTapGestureRecognizer:(void (^)(UITapGestureRecognizer * _Nonnull, NSString * _Nonnull))tapCallback tapGestureId:(NSString *)tapGestureId {
    [self addTapGestureRecognizer:tapCallback tapGestureId:tapGestureId numberOfTapsRequired:1 numberOfTouchesRequired:1];
}

- (void)addTapGestureRecognizer:(void (^)(UITapGestureRecognizer * _Nonnull, NSString * _Nonnull))tapCallback tapGestureId:(NSString *)tapGestureId numberOfTapsRequired:(NSInteger)numberOfTapsRequired numberOfTouchesRequired:(NSInteger)numberOfTouchesRequired {
    UIGestureRecognizer *r = [self.gestures objectForKey:tapGestureId];
    if (r != nil) {
        [self removeTapGesture:tapGestureId];
    }
    
    UITapGestureRecognizer *tg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler:)];
    tg.numberOfTouchesRequired = numberOfTouchesRequired;
    tg.numberOfTapsRequired = numberOfTapsRequired;
    
    GestureCallbackValues *v = [GestureCallbackValues new];
    v.gestureId = tapGestureId;
    v.gesture = tg;
    v.tapCallback = [tapCallback copy];
    
    [self.gestureKeysHash setValue:v forKey:[NSString stringWithFormat:@"%lu", (unsigned long)v.gesture.hash]];
    [self.gestures setValue:v forKey:tapGestureId];
    [self addGestureRecognizer:tg];
}

#pragma mark - remove tap gestures

- (void)removeTapGesture:(NSString *)tapGestureId {
    GestureCallbackValues *v = [self.gestures objectForKey:tapGestureId];
    if (v != nil) {
        [self.gestures removeObjectForKey:tapGestureId];
        [self.gestureKeysHash removeObjectForKey:[NSString stringWithFormat:@"%lu", (unsigned long)v.gesture.hash]];
        [self removeGestureRecognizer:v.gesture];
    }
}

- (void)removeAllTapGestures {
    NSArray *arr = self.gestures.allValues;
    for (GestureCallbackValues *v in arr) {
        if ([v.gesture isMemberOfClass:[UITapGestureRecognizer class]]) {
            [self removeTapGesture:v.gestureId];
        }
    }
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
