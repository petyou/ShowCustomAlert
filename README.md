### 前言
每一个app少不了需要以自定义弹窗的方式展示一些视图, 比如从app底部弹出自定义的分享视图, 或者在app中间弹出一个自定义的alert视图. 此时如果没有细致处理的话, app可能会遭遇一些尴尬, 比如类似从app底部弹出视图可能会这样:
![Keep点击邀请好友后再点击返回](https://upload-images.jianshu.io/upload_images/4103407-c9684b0d29c5fe51.gif?imageMogr2/auto-orient/strip)
而类似从app中间弹出alert可能会这样: 
![键盘被弹窗遮住.gif](https://upload-images.jianshu.io/upload_images/4103407-681a5e8bef6cb621.gif?imageMogr2/auto-orient/strip)
也可能没有实现自动隐藏和呼出键盘功能. 像这样
![自动收起和呼出键盘.gif](https://upload-images.jianshu.io/upload_images/4103407-b1c87687f8506ca2.gif?imageMogr2/auto-orient/strip)
为了统一解决这个问题, 建议一个app使用统一的接口用于弹出自定义的视图. 且在这个接口中处理好这些潜在的问题.  


### 弹窗步骤
一般而言, 弹窗的步骤为  

 1. 构建视图并设置合适大小
 2. 将视图和蒙层(可选)添加到父视图(一般为window或者控制器的view, 且一般以动画的方式展示), 即显示出来.
 3. 点击按钮或者蒙层移除视图和蒙层 


### 面临的问题 
而面临的问题总结为  

1. 视图在出现的过程中(以动画的方式或者没有动画)点击了控制器的返回按钮, 导致视图展示在了前一个界面
2. 视图和键盘重合在一起
3. 在移除视图后未将之前的键盘呼出来(如果显示alert之前界面有键盘显示的, 那么在移除alert后自动显示键盘用户体验更加. 系统alert也是这么做的)

### 解决之道
   对于问题1, 我们在弹出视图之前禁止用户交互, 视图完全显示后再允许用户交互. 对于问题2, 我们在显示弹窗之前收起键盘即可, 但为了能够解决问题3, 我们在收起键盘之前需要获取到当前的第一响应者, 弱引用它, 并在移除视图后再将它设置为第一响应者即可呼出键盘.
 
因为控制器view和window等视图都可能需要弹出视图, 于是我们构建UIView的分类, 使之具备弹出视图和移除视图的能力. 即提供统一的接口应用于显示和移除弹窗, 且在内部处理好相关的问题.

* 接口设计
	
```
@interface UIView (Show)

/// 显示 蒙层透明度渐变显示, 蒙层颜色黑色
- (void)showDisplayView:(UIView *)displayView
             coverAlpha:(CGFloat)coverAlpha
        coverTapedBlock:(void(^)(void))tapedBlock
          showAnimation:(void(^)(void))showAnimation
  showAnimationInterval:(NSTimeInterval)showAnimationInterval
          finishedBlock:(void(^)(BOOL finished))finishedBlock;

/// 移除 动画可选
- (void)hideDisplayView:(UIView *)displayView
          hideAnimation:(void(^)(void))hideAnimation
  hideAnimationInterval:(NSTimeInterval)hideAnimationInterval
          finishedBlock:(void(^)(BOOL finished))finishedBlock;


@end

```

* 实现

```
@implementation UIView (Show)

#pragma mark - Show

- (void)showDisplayView:(UIView *)displayView
             coverAlpha:(CGFloat)coverAlpha
        coverTapedBlock:(void(^)(void))tapedBlock
          showAnimation:(void(^)(void))showAnimation
  showAnimationInterval:(NSTimeInterval)showAnimationInterval
          finishedBlock:(void(^)(BOOL finished))finishedBlock
{
	// 显示之前禁止用户交互
    if (![UIApplication sharedApplication].isIgnoringInteractionEvents) {
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    }
    
    [self p_showDisplayView:displayView coverAlpha:0 coverColor:[UIColor blackColor] coverTapedBlock:tapedBlock];
    
    [UIView animateWithDuration:showAnimationInterval animations:^{
        self.coverView.alpha = coverAlpha;
        showAnimation ? showAnimation():nil;
    } completion:^(BOOL finished) {
        // 完全显示后再开启交互
        if ([UIApplication sharedApplication].isIgnoringInteractionEvents) {
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        }
        
        finishedBlock ? finishedBlock(finished):nil;
    }];
}

- (void)p_showDisplayView:(UIView *)displayView
               coverAlpha:(CGFloat)coverAlpha
               coverColor:(UIColor*)coverColor
          coverTapedBlock:(void(^)(void))tapedBlock
{
    // 获取第一响应者, 收起键盘
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

#pragma mark - Hide

- (void)hideDisplayView:(UIView *)displayView
          hideAnimation:(void(^)(void))hideAnimation
  hideAnimationInterval:(NSTimeInterval)hideAnimationInterval
          finishedBlock:(void(^)(BOOL finished))finishedBlock
{
	 // 将第一响应者复原 
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
```
至此所面临的问题已经完美的解决了. 若果要做的更好, 我们可以想象, 一个app的弹窗方式其实是有限的, 且相关参数也应该是一致. 比如蒙层的颜色, 透明度, 显示和隐藏时动画的时间等. 所以有必要再构建一个UIView的分类, 提供接口, 使得项目的开发人员在需要弹窗时, 只需要认真去构建视图本身即可, 再去调用统一的接口弹出来, 使得做出来的弹窗具有一致性且可靠.

* 接口设计

```
typedef NS_ENUM(NSInteger ,SGQShowType) {
    SGQShowFromBottom,    // show from bottom like action sheet
    SGQShowInCenter,      // show in center like alertView
};

#import <UIKit/UIKit.h>

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
```	

* 使用时

```
// example0
   SGQActionSheet *sheet = [[SGQActionSheet alloc] initWithMessage:@"退出后不会删除任何历史数据，下次登录依然可以使用本账号" attributedMessage:nil cancelButtonTitle:@"取消" otherButtonTitles:@[@"退出登录", @"登录遇到问题", @"联系客服"] otherButtonsClickBlock:^(UIButton *button, NSInteger index) {
        if (index  == 0) {
            NSLog(@"退出");
        } else if (index == 1) {
            NSLog(@"登录遇到问题");
        } else if (index == 2) {
            NSLog(@"联系客服");
        }
    }];
    [sheet showInWindowWithType:SGQShowFromBottom];

// example1
 SGQAlertView *alert =  [[SGQAlertView alloc] initWithTitle:@"title" subTitle:@"subTitle" message:@"退出后不会删除任何历史数据，下次登录依然可以善用本账号" buttonTitles:@[@"button1", @"button2", @"button3", @"cancel"] buttonsClickBlock:^(UIButton *button, NSInteger index) {
        NSLog(@"%@", [button titleForState:UIControlStateNormal]);
    }];
    [alert showInWindowWithType:SGQShowInCenter];
```	
![demo显示.gif](https://upload-images.jianshu.io/upload_images/4103407-2e4db8e369b54c90.gif?imageMogr2/auto-orient/strip)




