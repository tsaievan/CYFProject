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

#pragma mark - remove pan gestures
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

#pragma mark - pan handler
- (void)panHandler:(UIPanGestureRecognizer *)recognizer {
    GestureCallbackValues *v = [self.gestureKeysHash objectForKey:[NSString stringWithFormat:@"%lu", (unsigned long)recognizer.hash]];
    if (v != nil) {
        if (v.panCallback) {
            v.panCallback((UIPanGestureRecognizer *)v.gesture, v.gestureId);
        }
    }
}

#pragma mark - #####SWIPE
#pragma mark - add swipe gestures
- (NSString *)addSwipeGestureRecognizer:(void(^)(UISwipeGestureRecognizer *recognizer, NSString *gestureId))swipeCallback direction:(UISwipeGestureRecognizerDirection)direction {
    NSString *rand;
    do {
        rand = [self randomStringWithLength:12];
    } while ([self.gestures objectForKey:rand] != nil);
    [self addSwipeGestureRecognizer:swipeCallback swipeGestureId:rand direction:direction numberOfTouchesRequired:1];
    return rand;
}

- (NSString *)addSwipeGestureRecognizer:(void(^)(UISwipeGestureRecognizer *recognizer, NSString *gestureId))swipeCallback direction:(UISwipeGestureRecognizerDirection)direction numberOfTouchesRequired:(NSInteger)numberOfTouchesRequired {
    NSString *rand;
    do {
        [self addSwipeGestureRecognizer:swipeCallback swipeGestureId:rand direction:direction numberOfTouchesRequired:numberOfTouchesRequired];
    } while ([self.gestures objectForKey:rand] != nil);
    return rand;
}

- (void)addSwipeGestureRecognizer:(void(^)(UISwipeGestureRecognizer *recognizer, NSString *gestureId))swipeCallback swipeGestureId:(NSString *)swipeGestureId direction:(UISwipeGestureRecognizerDirection)direction numberOfTouchesRequired:(NSInteger)numberOfTouchesRequired {
    GestureCallbackValues *v = [self.gestures objectForKey:swipeGestureId];
    if (v != nil) {
        [self removeSwipeGesture:swipeGestureId];
    }
    GestureCallbackValues *r = [GestureCallbackValues new];
    UISwipeGestureRecognizer *tg = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeHandler:)];
    tg.direction = direction;
    tg.numberOfTouchesRequired = numberOfTouchesRequired;
    r.gestureId = swipeGestureId;
    r.gesture = tg;
    r.swipeCallback = [swipeCallback copy];
    [self.gestures setValue:r forKey:swipeGestureId];
    [self.gestureKeysHash setValue:r forKey:[NSString stringWithFormat:@"%lu", (unsigned long)tg.hash]];
    [self addGestureRecognizer:tg];
}

#pragma mark - remove swipe gestures
- (void)removeSwipeGesture:(NSString *)swipeGestureId {
    GestureCallbackValues *v = [self.gestures objectForKey:swipeGestureId];
    if (v != nil) {
        [self.gestures removeObjectForKey:swipeGestureId];
        [self.gestureKeysHash removeObjectForKey:[NSString stringWithFormat:@"%lu", (unsigned long)v.gesture.hash]];
        [self removeGestureRecognizer:v.gesture];
    }
}

- (void)removeAllSwipeGestures {
    NSArray *arr = self.gestures.allValues;
    for (GestureCallbackValues *v in arr) {
        if (v != nil) {
            [self removeSwipeGesture:v.gestureId];
        }
    }
}

#pragma mark - swipe handler
- (void)swipeHandler:(UISwipeGestureRecognizer *)recognizer {
    GestureCallbackValues *v = [self.gestureKeysHash objectForKey:[NSString stringWithFormat:@"%lu", (unsigned long)recognizer.hash]];
    if (v != nil) {
        if (v.swipeCallback != nil) {
            v.swipeCallback((UISwipeGestureRecognizer *)v.gesture, v.gestureId);
        }
    }
}

#pragma mark - #####ROTATION
#pragma mark - add rotation gestures
- (NSString *)addRotationGestureRecognizer:(void(^)(UIRotationGestureRecognizer *recognizer, NSString *gestureId))rotationCallback {
    NSString *rand;
    do {
        rand = [self randomStringWithLength:12];
    } while ([self.gestures objectForKey:rand] != nil);
    [self addRotationGestureRecognizer:rotationCallback rotationGestureId:rand];
    return rand;
}

- (void)addRotationGestureRecognizer:(void(^)(UIRotationGestureRecognizer *recognizer, NSString *gestureId))rotationCallback rotationGestureId:(NSString *)rotationGestureId {
    GestureCallbackValues *v = [self.gestures objectForKey:rotationGestureId];
    if (v != nil) {
        [self removeRotationGesture:v.gestureId];
    }
    GestureCallbackValues *r = [GestureCallbackValues new];
    UIRotationGestureRecognizer *tg = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotationHandler:)];
    r.gesture = tg;
    r.gestureId = rotationGestureId;
    r.rotationCallback = [rotationCallback copy];
    [self.gestures setValue:r forKey:rotationGestureId];
    [self.gestureKeysHash setValue:r forKey:[NSString stringWithFormat:@"%lu", (unsigned long)tg.hash]];
    [self addGestureRecognizer:tg];
}

#pragma mark - remove rotation gestures
- (void)removeRotationGesture:(NSString *)rotationGestureId {
    GestureCallbackValues *v = [self.gestures objectForKey:rotationGestureId];
    if (v != nil) {
        [self.gestures removeObjectForKey:rotationGestureId];
        [self.gestureKeysHash removeObjectForKey:[NSString stringWithFormat:@"%lu", (unsigned long)v.gesture]];
        [self removeGestureRecognizer:v.gesture];
    }
}

- (void)removeAllRotationGestures {
    NSArray *arr = self.gestures.allValues;
    for (GestureCallbackValues *v in arr) {
        if (v != nil) {
            [self removeRotationGesture:v.gestureId];
        }
    }
}

#pragma mark - rotation handler
- (void)rotationHandler:(UIRotationGestureRecognizer *)recognizer {
    GestureCallbackValues *v = [self.gestureKeysHash objectForKey:[NSString stringWithFormat:@"%lu", (unsigned long)recognizer.hash]];
    if (v != nil) {
        if (v.rotationCallback != nil) {
            v.rotationCallback((UIRotationGestureRecognizer *)v.gesture, v.gestureId);
        }
    }
}

#pragma mark - #####LONG PRESS
#pragma mark - add long press gestures
- (NSString *)addLongPressGestureRecognizer:(void(^)(UILongPressGestureRecognizer *recognizer, NSString *gestureId))longPressCallback {
    ///< allowableMovement 是手指长按时允许的移动范围, 默认是以点为单位, 不超过10个点
    return [self addLongPressGestureRecognizer:longPressCallback numberOfTapsRequired:0 numberOfTouchesRequired:1 minimumPressDuration:0.5 allowableMovement:10];
}

- (NSString *)addLongPressGestureRecognizer:(void(^)(UILongPressGestureRecognizer *recognizer, NSString *gestureId))longPressCallback
                       numberOfTapsRequired:(NSInteger)numberOfTapsRequired
                    numberOfTouchesRequired:(NSInteger)numberOfTouchesRequired
                       minimumPressDuration:(NSTimeInterval)minimumPressDuration
                          allowableMovement:(CGFloat)allowableMovement {
    
    NSString *rand;
    do {
        rand = [self randomStringWithLength:12];
    } while ([self.gestures objectForKey:rand] != nil);
    [self addLongPressGestureRecognizer:longPressCallback numberOfTapsRequired:numberOfTapsRequired numberOfTouchesRequired:numberOfTouchesRequired minimumPressDuration:minimumPressDuration allowableMovement:allowableMovement];
    return rand;
    
}

- (void)addLongPressGestureRecognizer:(void(^)(UILongPressGestureRecognizer *recognizer, NSString *gestureId))longPressCallback
                   longPressGestureId:(NSString *)longPressGestureId
                 numberOfTapsRequired:(NSInteger)numberOfTapsRequired
              numberOfTouchesRequired:(NSInteger)numberOfTouchesRequired
                 minimumPressDuration:(NSTimeInterval)minimumPressDuration
                    allowableMovement:(CGFloat)allowableMovement {
    GestureCallbackValues *v = [self.gestures objectForKey:longPressGestureId];
    if (v != nil) {
        [self removeLongPressGestureRecognizer:v.gestureId];
    }
    GestureCallbackValues *r = [GestureCallbackValues new];
    UILongPressGestureRecognizer *tg = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressHandler:)];
    tg.numberOfTapsRequired = numberOfTapsRequired;
    tg.numberOfTouchesRequired = numberOfTouchesRequired;
    tg.minimumPressDuration = minimumPressDuration;
    tg.allowableMovement = allowableMovement;
    r.gestureId = longPressGestureId;
    r.gesture = tg;
    r.longPressCallback = [longPressCallback copy];
    [self.gestures setValue:r forKey:longPressGestureId];
    [self.gestureKeysHash setValue:r forKey:[NSString stringWithFormat:@"%lu", (unsigned long)tg.hash]];
    [self addGestureRecognizer:tg];
}

- (void)removeLongPressGestureRecognizer:(NSString *)longPressGestureId {
    GestureCallbackValues *v = [self.gestures objectForKey:longPressGestureId];
    if (v != nil) {
        [self.gestures removeObjectForKey:v.gestureId];
        [self.gestureKeysHash removeObjectForKey:[NSString stringWithFormat:@"%lu", (unsigned long)v.gesture.hash]];
        [self removeGestureRecognizer:v.gesture];
    }
}

- (void)removeAllLongPressGestures {
    NSArray *arr = self.gestures.allValues;
    for (GestureCallbackValues *v in arr) {
        if (v != nil) {
            [self removeLongPressGestureRecognizer:v.gestureId];
        }
    }
}

- (void)longPressHandler:(UILongPressGestureRecognizer *)recognizer {
    GestureCallbackValues *v = [self.gestureKeysHash objectForKey:[NSString stringWithFormat:@"%lu", (unsigned long)recognizer.hash]];
    if (v != nil) {
        if (v.longPressCallback != nil) {
            v.longPressCallback((UILongPressGestureRecognizer *)v.gesture, v.gestureId);
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
