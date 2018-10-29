//
//  SGQActionSheet.h
//  funnyTry
//
//  Created by SGQ on 2018/10/26.
//  Copyright © 2018年 GQ. All rights reserved.
//  仿微信退出登录的底部弹窗

#import <UIKit/UIKit.h>

@interface SGQActionSheet : UIView

/**
 默认的构建视图方法

 @param message 显示在顶部的提示信息
 @param attributedMessage 显示在顶部的提示信息,优先级高于message
 @param cancelButtonTitle 最底部的取消按钮
 @param otherButtonTitles 其他选项按钮
 @param clickBlock 其他选项按钮的点击事件
 @return 视图
 */
- (instancetype)initWithMessage:(NSString *)message attributedMessage:(NSAttributedString *)attributedMessage cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles otherButtonsClickBlock:(void (^)(UIButton *button, NSInteger index))clickBlock;

/**
 以window为superView从底部显示出来
 */
- (void)showWithAnimation;

/**
 返回除所有按钮,以便修UI

 @return 所有按钮
 */
- (NSArray *)allButtons;

/**
 返回除指定button,以便修UI

 @param index 按钮位置
 @return 对应按钮
 */
- (UIButton *)buttonAtIndex:(NSInteger)index;

@end
