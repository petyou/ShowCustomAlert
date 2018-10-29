//
//  UIView+Show.h
//  Liaodao
//
//  Created by SGQ on 2018/10/19.
//  Copyright © 2018年 LiaodaoSports. All rights reserved.
//  用于显示上浮或者中间弹窗视图等场景

#import <UIKit/UIKit.h>

@interface UIView (Show)

/// 蒙层透明度渐变显示, 蒙层颜色黑色
- (void)showDisplayView:(UIView *)displayView
             coverAlpha:(CGFloat)coverAlpha
        coverTapedBlock:(void(^)(void))tapedBlock
          showAnimation:(void(^)(void))showAnimation
  showAnimationInterval:(NSTimeInterval)showAnimationInterval
          finishedBlock:(void(^)(BOOL finished))finishedBlock;

/// 蒙层透明度直接以a直接显示出来, 蒙层颜色可选
- (void)showDisplayView:(UIView *)displayView
             coverAlpha:(CGFloat)coverAlpha
             coverColor:(UIColor*)coverColor
     coverTapedBlock:(void(^)(void))tapedBlock
          showAnimation:(void(^)(void))showAnimation
  showAnimationInterval:(NSTimeInterval)showAnimationInterval
          finishedBlock:(void(^)(BOOL finished))finishedBlock;

/// 移除 动画可选
- (void)hideDisplayView:(UIView *)displayView
          hideAnimation:(void(^)(void))hideAnimation
  hideAnimationInterval:(NSTimeInterval)hideAnimationInterval
          finishedBlock:(void(^)(BOOL finished))finishedBlock;

/// 移除 无动画
- (void)removeDisplayView:(UIView *)displayView;

@end
