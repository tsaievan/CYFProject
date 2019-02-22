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

#pragma mark - ##### TAP
#pragma mark - add tap gestures
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
    GestureCallbackValues *r = [self.gestures objectForKey:tapGestureId];
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

#pragma mark - tap handler

- (void)tapHandler:(UITapGestureRecognizer *)recognizer {
    GestureCallbackValues *v = [self.gestureKeysHash objectForKey:[NSString stringWithFormat:@"%lu", (unsigned long)recognizer.hash]];
    if (v != nil) {
        if (v.tapCallback) {
            v.tapCallback((UITapGestureRecognizer *)v.gesture, v.gestureId);
        }
    }
}

#pragma mark - ##### PINCH
#pragma mark - add pinch gestures
- (NSString *)addPinchGestureRecognizer:(void(^)(UIPinchGestureRecognizer *recognizer, NSString *gestureId))pinchCallback {
    NSString *rand;
    do {
        rand = [self randomStringWithLength:12];
    } while ([self.gestures objectForKey:rand] != nil);
    [self addPinchGestureRecognizer:pinchCallback pinchGestureId:rand];
    return rand;
}


- (void)addPinchGestureRecognizer:(void(^)(UIPinchGestureRecognizer *recognizer, NSString *gestureId))pinchCallback pinchGestureId:(NSString *)pinchGestureId {
    GestureCallbackValues *r = [self.gestures objectForKey:pinchGestureId];
    if (r != nil) {
        [self removePinchGesture:pinchGestureId];
    }
    UIPinchGestureRecognizer *tg = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchHandler:)];
    GestureCallbackValues *v = [GestureCallbackValues new];
    v.gesture = tg;
    v.pinchCallback = [pinchCallback copy];
    v.gestureId = pinchGestureId;
    
    [self.gestureKeysHash setValue:v forKey:[NSString stringWithFormat:@"%lu", (unsigned long)v.gesture.hash]];
    [self.gestures setValue:v forKey:pinchGestureId];
    [self addGestureRecognizer:tg];
}

#pragma mark - remove pinch gestures
- (void)removePinchGesture:(NSString *)pinchGestureId {
    GestureCallbackValues *v = [self.gestures objectForKey:pinchGestureId];
    if (v != nil) {
        [self.gestures removeObjectForKey:pinchGestureId];
        [self.gestureKeysHash removeObjectForKey:[NSString stringWithFormat:@"%lu", (unsigned long)v.gesture.hash]];
        [self removeGestureRecognizer:v.gesture];
    }
}

- (void)removeAllPinchGestures {
    NSArray *arr = self.gestures.allValues;
    for (GestureCallbackValues *v in arr) {
        if ([v isMemberOfClass:[UIPinchGestureRecognizer class]]) {
            [self removePinchGesture:v.gestureId];
        }
    }
}

#pragma mark - pinch handler
- (void)pinchHandler:(UIPinchGestureRecognizer *)recognizer {
    GestureCallbackValues *v = [self.gestureKeysHash objectForKey:[NSString stringWithFormat:@"%lu", (unsigned long)recognizer.hash]];
    if (v != nil) {
        if (v.pinchCallback) {
            v.pinchCallback((UIPinchGestureRecognizer *)v.gesture, v.gestureId);
        }
    }
}

#pragma mark - #####PAN
#pragma mark - add pan gestures
- (NSString *)addPanGestureRecognizer:(void(^)(UIPanGestureRecognizer *recognizer, NSString *gestureId))panCallback {
    NSString *rand;
    do {
        rand = [self randomStringWithLength:12];
    } while ([self.gestures objectForKey:rand] != nil);
    [self addPanGestureRecognizer:panCallback panGestureId:rand];
    return rand;
}

- (NSString *)addPanGestureRecognizer:(void(^)(UIPanGestureRecognizer *recognizer, NSString *gestureId))panCallback minimumNumberOfTouches:(NSUInteger)minimumNumberOfTouches maximumNumberOfTouches:(NSUInteger)maximumNumberOfTouches {
    NSString *rand;
    do {
        rand = [self randomStringWithLength:12];
    } while ([self.gestures objectForKey:rand] != nil);
    [self addPanGestureRecognizer:panCallback panGestureId:rand minimumNumberOfTouches:minimumNumberOfTouches maximumNumberOfTouches:maximumNumberOfTouches];
    return rand;
}

- (void)addPanGestureRecognizer:(void(^)(UIPanGestureRecognizer *recognizer, NSString *gestureId))panCallback panGestureId:(NSString *)panGestureId {
    [self addPanGestureRecognizer:panCallback panGestureId:panGestureId minimumNumberOfTouches:1 maximumNumberOfTouches:1];
}

- (void)addPanGestureRecognizer:(void(^)(UIPanGestureRecognizer *recognizer, NSString *gestureId))panCallback panGestureId:(NSString *)panGestureId minimumNumberOfTouches:(NSUInteger)minimumNumberOfTouches maximumNumberOfTouches:(NSUInteger)maximumNumberOfTouches {
    GestureCallbackValues *r = [self.gestures objectForKey:panGestureId];
    if (r != nil) {
        [self removePanGesture:panGestureId];
    }
    UIPanGestureRecognizer *tg = [[UIPanGestureRecognizer alloc] initWithTarget:self action: @selector(panHandler:)];
    tg.minimumNumberOfTouches = minimumNumberOfTouches;
    tg.maximumNumberOfTouches = maximumNumberOfTouches;
    
    GestureCallbackValues *v = [GestureCallbackValues new];
    v.gesture = tg;
    v.gestureId = panGestureId;
    v.panCallback = [panCallback copy];
    [self.gestures setValue:v forKey:panGestureId];
    [self.gestureKeysHash setValue:v forKey:[NSString stringWithFormat:@"%lu", (unsigned long)v.gesture.hash]];
    [self addGestureRecognizer:v.gesture];
}

- (void)removePanGesture:(NSString *)panGestureId {
    GestureCallbackValues *v = [self.gestures objectForKey:panGestureId];
    if (v != nil) {
        [self.gestures removeObjectForKey:panGestureId];
        [self.gestureKeysHash removeObjectForKey:[NSString stringWithFormat:@"%lu", (unsigned long)v.gesture.hash]];
        [self removeGestureRecognizer:v.gesture];
    }
}

- (void)removeAllPanGestures {
    NSArray *arr = self.gestures.allValues;
    for (GestureCallbackValues *v in arr) {
        if ([v.gesture isMemberOfClass:[UIPanGestureRecognizer class]]) {
            [self removePanGesture:v.gestureId];
        }
    }
}

- (void)panHandler:(UIPanGestureRecognizer *)recognizer {
    GestureCallbackValues *v = [self.gestureKeysHash objectForKey:[NSString stringWithFormat:@"%lu", (unsigned long)recognizer.hash]];
    if (v != nil) {
        if (v.panCallback) {
            v.panCallback((UIPanGestureRecognizer *)v.gesture, v.gestureId);
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
