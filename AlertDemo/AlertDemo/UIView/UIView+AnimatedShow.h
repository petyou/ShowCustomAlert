//
//  UIView+AnimatedShow.h
//  Liaodao
//
//  Created by SGQ on 2018/10/19.
//  Copyright © 2018年 LiaodaoSports. All rights reserved.
//  offer several convenient animations

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger ,SGQShowType) {
    SGQShowFromBottom,    // show from bottom like action sheet
    SGQShowInCenter,      // show in center like alertView
};

@interface UIView (AnimatedShow)

/// create a view and set the view suitable size, then show it.
- (void)showInWindowWithType:(SGQShowType)type;

/// create a view and set the view suitable size, then show it.
- (void)showInWindowWithType:(SGQShowType)type coverAlpha:(CGFloat)coverAlpha animationInterval:(NSTimeInterval)animationInterval;

/// hideType must be equal to showType.
- (void)hideInWindowWithType:(SGQShowType)type;

/// hideType must be equal to showType.
- (void)hideInWindowWithType:(SGQShowType)type animationInterval:(NSTimeInterval)animationInterval;

@end
