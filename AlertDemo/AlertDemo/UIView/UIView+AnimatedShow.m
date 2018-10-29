//
//  UIView+AnimatedShow.m
//  Liaodao
//
//  Created by SGQ on 2018/10/19.
//  Copyright © 2018年 LiaodaoSports. All rights reserved.
//

#import "UIView+AnimatedShow.h"
#import "UIView+Show.h"

@implementation UIView (AnimatedShow)

- (void)showInWindowWithType:(SGQShowType)type {
    switch (type) {
        case SGQShowFromBottom:
            [self showFromBottomWithCoverAlpha:0.7 animationInterval:0.25];
            break;
        case SGQShowInCenter:
            [self showInCenterWithcoverAlpha:0.35 animationInterval:0.25];
            break;
    }
}

- (void)hideInWindowWithType:(SGQShowType)type {
    switch (type) {
        case SGQShowFromBottom:
            [self hideFromBottomWithAnimationInterval:0.25];
            break;
        case SGQShowInCenter:
            [self hideInCenterWithAnimationInterval:0.35];
            break;
    }
}

- (void)showInWindowWithType:(SGQShowType)type coverAlpha:(CGFloat)coverAlpha animationInterval:(NSTimeInterval)animationInterval {
    switch (type) {
        case SGQShowFromBottom:
            [self showFromBottomWithCoverAlpha:coverAlpha animationInterval:animationInterval];
            break;
        case SGQShowInCenter:
            [self showInCenterWithcoverAlpha:coverAlpha animationInterval:animationInterval];
            break;
    }
}

- (void)hideInWindowWithType:(SGQShowType)type animationInterval:(NSTimeInterval)animationInterval {
    switch (type) {
        case SGQShowFromBottom:
            [self hideFromBottomWithAnimationInterval:animationInterval];
            break;
        case SGQShowInCenter:
            [self hideInCenterWithAnimationInterval:animationInterval];
            break;
    }
}

#pragma mark - SGQShowFromBottom
- (void)showFromBottomWithCoverAlpha:(CGFloat)coverAlpha animationInterval:(NSTimeInterval)animationInterval {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;

    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    
    self.frame = CGRectMake(0, CGRectGetHeight(window.bounds) - height, width, height);
    self.transform = CGAffineTransformMakeTranslation(0, height);
    
    __weak typeof(self) weakSelf = self;
    [window showDisplayView:self
                 coverAlpha:coverAlpha
            coverTapedBlock:^{
                [weakSelf hideFromBottomWithAnimationInterval:animationInterval];
                
            }
              showAnimation:^{
                  weakSelf.transform = CGAffineTransformIdentity;
                  
              }
      showAnimationInterval:animationInterval
              finishedBlock:nil];
}

- (void)hideFromBottomWithAnimationInterval:(NSTimeInterval)animationInterval {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    __weak typeof(self) weakSelf = self;
    [window hideDisplayView:self
              hideAnimation:^{
                  weakSelf.transform = CGAffineTransformMakeTranslation(0, CGRectGetHeight(self.bounds));
              }
      hideAnimationInterval:animationInterval
              finishedBlock:nil];
}

#pragma mark - SGQShowInCenter
- (void)showInCenterWithcoverAlpha:(CGFloat)coverAlpha animationInterval:(NSTimeInterval)animationInterval{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    self.center = window.center;
    CGFloat scale = CGRectGetWidth(window.bounds) / CGRectGetWidth(self.bounds);
    self.transform = CGAffineTransformMakeScale(scale, scale);
    self.alpha = 0;
    
    __weak typeof(self) weakSelf = self;
    [window showDisplayView:self
                 coverAlpha:coverAlpha
            coverTapedBlock:nil
              showAnimation:^{
                  weakSelf.alpha = 1;
                  weakSelf.transform = CGAffineTransformIdentity;
              }
      showAnimationInterval:animationInterval
              finishedBlock:nil];
}

- (void)hideInCenterWithAnimationInterval:(NSTimeInterval)animationInterval {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    __weak typeof(self) weakSelf = self;
    [window hideDisplayView:self
              hideAnimation:^{
                  weakSelf.alpha = 0;
              }
      hideAnimationInterval:animationInterval
              finishedBlock:nil];
}

@end
