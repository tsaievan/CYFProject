//
//  UIButton+CYF.m
//  CYFProject
//
//  Created by tsaievan on 20/2/2019.
//  Copyright © 2019 tsaievan. All rights reserved.
//

#import "UIButton+CYF.h"
#import <objc/message.h>

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
    
    
    return self;
}

@end
