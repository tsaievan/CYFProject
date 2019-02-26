//
//  UIButton+CYF.m
//  CYFProject
//
//  Created by tsaievan on 20/2/2019.
//  Copyright © 2019 tsaievan. All rights reserved.
//

#import "UIButton+CYF.h"
#import <objc/message.h>
#import "UIView+GestureCallback.h"

static const void *UIButtonBlockKey = &UIButtonBlockKey;

@implementation UIButton (CYF)

- (void)addActionHandler:(TouchedBlock)touchHandler {
    objc_setAssociatedObject(self, UIButtonBlockKey, touchHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(actionTouched:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)actionTouched:(UIButton *)btn {
    TouchedBlock block = objc_getAssociatedObject(self, UIButtonBlockKey);
    if (block) {
        block(btn.tag);
    }
}


/**
 使用颜色设置按钮背景
 
 @param backgroundColor 背景颜色
 @param state 按钮状态
 */
- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state {
    [self setBackgroundImage:[UIButton imageWithColor:backgroundColor] forState:state];
}


+ (UIImage *)imageWithColor:(UIColor *)color {
    ///< 一个点
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    
    ///< 开启图形上下文
    UIGraphicsBeginImageContext(rect.size);
    
    ///< 获取当前上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    ///< 上下文的填充颜色
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    ///< 在图形上下文中填充
    CGContextFillRect(context, rect);
    
    ///< 从当前上下文中获取图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    ///< 关闭图形上下文
    UIGraphicsEndImageContext();
    
    ///< 返回图片
    return image;
}

- (instancetype)initWithFrame:(CGRect)frame buttonTitle:(NSString *)buttonTitle normalBGColor:(UIColor *)normalBGColor selectBGColor:(UIColor *)selectBGColor normalColor:(UIColor *)normalColor selectColor:(UIColor *)selectColor buttonFont:(UIFont *)buttonFont cornerRadius:(CGFloat)cornerRadius doneBlock:(void (^)(UIButton * _Nonnull))doneBlock {
    self = [self initWithFrame:frame];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = cornerRadius;
    
    self.titleLabel.font = buttonFont;
    [self setTitle:buttonTitle forState:UIControlStateNormal];
    [self setTitleColor:normalColor forState:UIControlStateNormal];
    [self setTitleColor:selectColor forState:UIControlStateHighlighted];
    [self setBackgroundImage:[UIImage imageWithColor:normalBGColor] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageWithColor:selectBGColor] forState:UIControlStateHighlighted];
    
    CYFWeak(self);
    
    [self addTapGestureRecognizer:^(UITapGestureRecognizer * _Nonnull recognizer, NSString * _Nonnull gestureId) {
        !doneBlock ? : doneBlock(weakself);
    }];
    
    return self;
}

+ (UIButton *)initWithFrame:(CGRect)frame buttonTitle:(NSString *)buttonTitle normalBGColor:(UIColor *)normalBGColor selectBGColor:(UIColor *)selectBGColor normalColor:(UIColor *)normalColor selectColor:(UIColor *)selectColor buttonFont:(UIFont *)buttonFont cornerRadius:(CGFloat)cornerRadius doneBlock:(void (^)(UIButton * _Nonnull))doneBlock {
    UIButton *solidColorButton = [[self alloc] initWithFrame:frame buttonTitle:buttonTitle normalBGColor:normalBGColor selectBGColor:selectBGColor normalColor:normalColor selectColor:selectColor buttonFont:buttonFont cornerRadius:cornerRadius doneBlock:doneBlock];
    return solidColorButton;
}

@end


@implementation CYFRoundedButton

- (void)makeCorner {
    UIRectCorner corners;
    switch (self.style) {
        case 0:
            corners = UIRectCornerBottomLeft;
            break;
        case 1:
            corners = UIRectCornerTopRight;
            break;
        case 2:
            corners = UIRectCornerTopLeft;
            break;
        case 3:
            corners = UIRectCornerTopRight;
            break;
        case 4:
            corners = UIRectCornerBottomLeft | UIRectCornerBottomRight;
            break;
        case 5:
            corners = UIRectCornerTopLeft | UIRectCornerTopRight;
            break;
        case 6:
            corners = UIRectCornerBottomLeft | UIRectCornerTopLeft;
            break;
        case 7:
            corners = UIRectCornerBottomRight | UIRectCornerTopRight;
            break;
        case 8:
            corners = UIRectCornerBottomRight | UIRectCornerTopRight | UIRectCornerTopLeft;
            break;
        case 9:
            corners = UIRectCornerBottomRight | UIRectCornerTopRight | UIRectCornerBottomLeft;
            break;
        default:
            corners = UIRectCornerAllCorners;
            break;
    }
    _yf_cornerRadius = _yf_cornerRadius ? : 10.0f;
    ///< cornerRadii : 每个角椭圆的半径
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(_yf_cornerRadius, _yf_cornerRadius)];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUIOnce];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setupUIOnce];
    }
    return self;
}

- (void)setupUIOnce {
    [self makeCorner];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self makeCorner];
}

@end
