//
//  SGQAlertView.h
//  funnyTry
//
//  Created by SGQ on 2018/10/26.
//  Copyright © 2018年 GQ. All rights reserved.
//  因为系统的alertView头部文字是居中的,且修改其它UI属性都比较受限,故自定义

#import <UIKit/UIKit.h>

@interface SGQAlertView : UIView

/** 标题 */
@property (nonatomic, strong, readonly) UILabel *titleLabel;

/** 子标题 */
@property (nonatomic, strong, readonly) UILabel *subTitleLalel;

/** 头部文字*/
@property (nonatomic, strong, readonly) UILabel *messageLabel;


/**
 默认的构建视图方法
 
 @param title 标题
 @param subTitle 子标题, 可选
 @param message 头部文字
 @param buttonTitles 所有的按钮
 @return 视图
 */
- (instancetype)initWithTitle:(NSString*)title subTitle:(NSString *)subTitle message:(NSString*)message buttonTitles:(NSArray*)buttonTitles buttonsClickBlock:(void (^)(UIButton *button, NSInteger index))clickBlock;

/**
 update subViews frame
 */
- (void)forceLayoustSubViews;

/**
 以window为superView从底部显示出来
 */
- (void)showWithAnimation;

/**
 返回除所有otherButtons,以便修UI
 
 @return 所有otherButtons
 */
- (NSArray *)allButtons;

/**
 返回除指定otherButton,以便修UI
 
 @param index 按钮位置
 @return 对应按钮
 */
- (UIButton *)buttonAtIndex:(NSInteger)index;

@end
