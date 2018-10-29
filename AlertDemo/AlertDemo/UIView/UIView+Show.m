//
//  UIView+Show.m
//  Liaodao
//
//  Created by SGQ on 2018/10/19.
//  Copyright © 2018年 LiaodaoSports. All rights reserved.
//

#import "UIView+Show.h"
#import <objc/runtime.h>

@implementation UIView (Show)

#pragma mark - Show

- (void)showDisplayView:(UIView *)displayView
             coverAlpha:(CGFloat)coverAlpha
        coverTapedBlock:(void(^)(void))tapedBlock
          showAnimation:(void(^)(void))showAnimation
  showAnimationInterval:(NSTimeInterval)showAnimationInterval
          finishedBlock:(void(^)(BOOL finished))finishedBlock
{
    if (![UIApplication sharedApplication].isIgnoringInteractionEvents) {
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    }
    
    [self p_showDisplayView:displayView coverAlpha:0 coverColor:[UIColor blackColor] coverTapedBlock:tapedBlock];
    
    [UIView animateWithDuration:showAnimationInterval animations:^{
        self.coverView.alpha = coverAlpha;
        showAnimation ? showAnimation():nil;
    } completion:^(BOOL finished) {
        if ([UIApplication sharedApplication].isIgnoringInteractionEvents) {
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        }
        
        finishedBlock ? finishedBlock(finished):nil;
    }];
}

- (void)showDisplayView:(UIView *)displayView
             coverAlpha:(CGFloat)coverAlpha
             coverColor:(UIColor*)coverColor
             coverTapedBlock:(void(^)(void))tapedBlock
          showAnimation:(void(^)(void))showAnimation
  showAnimationInterval:(NSTimeInterval)showAnimationInterval
          finishedBlock:(void(^)(BOOL finished))finishedBlock
{
    if (![UIApplication sharedApplication].isIgnoringInteractionEvents) {
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    }
    
    [self p_showDisplayView:displayView coverAlpha:coverAlpha coverColor:coverColor coverTapedBlock:tapedBlock];
    
    [UIView animateWithDuration:showAnimationInterval animations:^{
        self.coverView.alpha = coverAlpha;
        showAnimation ? showAnimation():nil;
    } completion:^(BOOL finished) {
        if ([UIApplication sharedApplication].isIgnoringInteractionEvents) {
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        }
        
        finishedBlock ? finishedBlock(finished):nil;
    }];
}

#pragma mark - Hide

- (void)hideDisplayView:(UIView *)displayView
          hideAnimation:(void(^)(void))hideAnimation
  hideAnimationInterval:(NSTimeInterval)hideAnimationInterval
          finishedBlock:(void(^)(BOOL finished))finishedBlock
{
    if (self.currentFirstResponder) {
        [self.currentFirstResponder becomeFirstResponder];
        self.currentFirstResponder = nil;
    }
    
    [UIView animateWithDuration:hideAnimationInterval animations:^{
        self.coverView.alpha = 0;
        hideAnimation ? hideAnimation():nil;
    } completion:^(BOOL finished) {
        [self removeDisplayView:displayView];
        finishedBlock ? finishedBlock(finished):nil;
    }];
}

- (void)removeDisplayView:(UIView *)displayView {
    if (self.currentFirstResponder) {
        [self.currentFirstResponder becomeFirstResponder];
        self.currentFirstResponder = nil;
    }
    UIView *coverView = [self coverView];
    [coverView removeFromSuperview];
    [displayView removeFromSuperview];
    [self setCoverView:nil];
}

#pragma mark - Private

- (void)p_showDisplayView:(UIView *)displayView
               coverAlpha:(CGFloat)coverAlpha
               coverColor:(UIColor*)coverColor
          coverTapedBlock:(void(^)(void))tapedBlock
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.currentFirstResponder = [self findFirstResponderInView:window];
    [window endEditing:YES];
    
    self.tapedBlock = tapedBlock;
    
    if (![self coverView]) {
        UIView *coverView = [[UIView alloc] initWithFrame:self.bounds];
        coverView.backgroundColor = coverColor;
        coverView.alpha = coverAlpha;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(coverViewTaped)];
        [coverView addGestureRecognizer:tapGesture];
        [self setCoverView:coverView];
        [self addSubview:coverView];
    }
    
    [self addSubview:displayView];
}

- (void)coverViewTaped {
    self.tapedBlock ? self.tapedBlock():nil;
}

- (UIView*)findFirstResponderInView:(UIView*)topView {
    if ([topView isFirstResponder]) {
        return topView;
    }
    
    for (UIView* subView in topView.subviews) {
        if ([subView isFirstResponder]) {
            return subView;
        }
        
        UIView* firstResponderCheck = [self findFirstResponderInView:subView];
        if (nil != firstResponderCheck) {
            return firstResponderCheck;
        }
    }
    return nil;
}

#pragma mark - Getter & Setter
-  (UIView *)coverView {
    return  objc_getAssociatedObject(self, _cmd);
}

- (void)setCoverView:(UIView *)coverView {
    objc_setAssociatedObject(self, @selector(coverView), coverView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void (^)(void))tapedBlock {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setTapedBlock:(void (^)(void))tapedBlock {
      objc_setAssociatedObject(self, @selector(tapedBlock), tapedBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (UIView *)currentFirstResponder {
    return  objc_getAssociatedObject(self, _cmd);
}

- (void)setCurrentFirstResponder:(UIView *)currentFirstResponder {
      objc_setAssociatedObject(self, @selector(currentFirstResponder), currentFirstResponder, OBJC_ASSOCIATION_ASSIGN);
}

@end
