//
//  UIButton+CYF.h
//  CYFProject
//
//  Created by tsaievan on 20/2/2019.
//  Copyright © 2019 tsaievan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^TouchedBlock)(NSInteger tag);

@interface UIButton (CYF)

/**
 添加 addTarget
 */
- (void)addActionHandler:(TouchedBlock)touchHandler;


/**
 使用颜色设置按钮背景

 @param backgroundColor 背景颜色
 @param state 按钮状态
 */
- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state;


/**
 @param frame frame
 @param buttonTitle 标题
 @param normalBGColor 未选中的背景色
 @param selectBGColor 选中的背景色
 @param normalColor 未选中的文字色
 @param selectColor 选中的文字色
 @param buttonFont 文字字体
 @param cornerRadius 圆角值 没有则为0
 @param doneBlock 点击事件
 */
- (instancetype)initWithFrame:(CGRect)frame
                  buttonTitle:(NSString *)buttonTitle
                normalBGColor:(UIColor *)normalBGColor
                selectBGColor:(UIColor *)selectBGColor
                  normalColor:(UIColor *)normalColor
                  selectColor:(UIColor *)selectColor
                   buttonFont:(UIFont *)buttonFont
                 cornerRadius:(CGFloat)cornerRadius
                    doneBlock:(void(^)(UIButton *))doneBlock;


+ (UIButton *)initWithFrame:(CGRect)frame
                  buttonTitle:(NSString *)buttonTitle
                normalBGColor:(UIColor *)normalBGColor
                selectBGColor:(UIColor *)selectBGColor
                  normalColor:(UIColor *)normalColor
                  selectColor:(UIColor *)selectColor
                   buttonFont:(UIFont *)buttonFont
                 cornerRadius:(CGFloat)cornerRadius
                    doneBlock:(void(^)(UIButton *))doneBlock;
@end

NS_ASSUME_NONNULL_END
