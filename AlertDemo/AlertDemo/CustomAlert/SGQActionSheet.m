//
//  SGQActionSheet.m
//  funnyTry
//
//  Created by SGQ on 2018/10/26.
//  Copyright © 2018年 GQ. All rights reserved.
//

#import "SGQActionSheet.h"
#import "UIView+AnimatedShow.h"

@interface SGQActionSheet ()
@property (nonatomic, strong) NSMutableArray *allButtons;
@property (nonatomic, strong) NSMutableArray *lines;
@property (nonatomic, copy) void (^clickBlock)(UIButton *button, NSInteger index);
@end

@implementation SGQActionSheet

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        _allButtons = [NSMutableArray array];
    }
    return self;
}

#pragma mark - Life cycle

- (instancetype)initWithMessage:(NSString *)message attributedMessage:(NSAttributedString *)attributedMessage cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles otherButtonsClickBlock:(void (^)(UIButton *, NSInteger))clickBlock {
    if (self = [self initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 1)]) {
        self.clickBlock = clickBlock;
        CGFloat lefeMagin = 22.0f;
        CGFloat top = 0;
        CGFloat width = CGRectGetWidth(self.bounds);
        
        // 顶部提示
        if (attributedMessage.length > 0 || message.length > 0) {
            UILabel *promptLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            if (attributedMessage.length > 0) {
                CGSize promptLabelSize = [attributedMessage boundingRectWithSize:CGSizeMake(width - 2 * lefeMagin, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
                promptLabel.frame = CGRectMake(lefeMagin, 0, promptLabelSize.width, promptLabelSize.height + 21 * 2);
                promptLabel.attributedText = attributedMessage;
            } else {
                promptLabel.font = [UIFont systemFontOfSize:13];
                CGSize promptLabelSize = [message boundingRectWithSize:CGSizeMake(width - 2 * lefeMagin, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:promptLabel.font} context:nil].size;
                promptLabel.frame = CGRectMake(lefeMagin, 0, promptLabelSize.width, promptLabelSize.height + 21 * 2);
                promptLabel.textColor = [UIColor colorWithRed:117/250.0 green:117/250.0 blue:117/250.0 alpha:1.0];
                promptLabel.text = message;
                
            }
            promptLabel.numberOfLines = 0;
            promptLabel.textAlignment = NSTextAlignmentCenter;
            promptLabel.backgroundColor = [UIColor clearColor];
            [self addSubview:promptLabel];
            top =CGRectGetMaxY(promptLabel.frame);
        }
        
        // 中间按钮
        UIColor *separatorColor = [UIColor colorWithRed:207/250.0 green:207/250.0 blue:207/250.0 alpha:1.0];
        CGFloat separatorHeight = 1 / [UIScreen mainScreen].scale;
        UIImage *buttonHighlightedImage = [SGQActionSheet imageWithColor:[UIColor colorWithRed:230/250.0 green:230/250.0 blue:230/250.0 alpha:1.0]];
        CGFloat btnWidth = width;
        CGFloat btnHeight = 48;
        for (NSInteger i = 0; i < otherButtonTitles.count; i++) {
            CALayer *line = [CALayer layer];
            line.backgroundColor = separatorColor.CGColor;
            line.frame = CGRectMake(0, top, width, separatorHeight);
            [self.layer addSublayer:line];
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:otherButtonTitles[i] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            button.backgroundColor = [UIColor clearColor];
            [button setBackgroundImage:buttonHighlightedImage forState:UIControlStateHighlighted];
            [button.titleLabel setFont:[UIFont systemFontOfSize:17]];
            [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            button.frame = CGRectMake(0, top, btnWidth, btnHeight);
            [self addSubview:button];
            [_allButtons addObject:button];
            top = CGRectGetMaxY(button.frame);
        }
        
        // 上下分割
        CALayer *riverLayer = [CALayer layer];
        riverLayer.backgroundColor = [UIColor colorWithRed:223/250.0 green:222/250.0 blue:226/250.0 alpha:1.0].CGColor;
        [self.layer addSublayer:riverLayer];
        riverLayer.frame = CGRectMake(0, top, width, 6);
        top += 6;
        
        // 取消按钮
        CGFloat moreHeight = [UIApplication sharedApplication].statusBarFrame.size.height == 44 ? 34 : 0;
        UIButton *cancleBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, top, btnWidth, btnHeight + moreHeight)];
        [cancleBtn setTitle:cancelButtonTitle forState:UIControlStateNormal];
        [cancleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cancleBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
        [cancleBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        cancleBtn.backgroundColor = [UIColor whiteColor];
        [cancleBtn setBackgroundImage:buttonHighlightedImage forState:UIControlStateHighlighted];
        if (moreHeight > 0) {
            [cancleBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, moreHeight, 0)];
        }
        [self addSubview:cancleBtn];
        [_allButtons addObject:cancleBtn];
        
        self.frame = CGRectMake(0, 0, width, CGRectGetMaxY(cancleBtn.frame));
    }
    
    return self;
}

- (void)showWithAnimation {
    [self showInWindowWithType:SGQShowFromBottom];
}

- (NSArray *)allButtons {
    return _allButtons.copy;
}

- (UIButton *)buttonAtIndex:(NSInteger)index {
    if (index < _allButtons.count) {
        return _allButtons[index];
    }
    return nil;
}

#pragma mark - Private

+ (UIImage * _Nonnull)imageWithColor:(UIColor * _Nonnull)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)buttonClicked:(UIButton *)button {
    [self hideInWindowWithType:SGQShowFromBottom];
    if (self.clickBlock) {
        self.clickBlock(button, [_allButtons indexOfObject:button]);
    }
}

@end
