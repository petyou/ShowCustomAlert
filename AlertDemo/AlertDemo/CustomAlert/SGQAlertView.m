//
//  SGQAlertView.m
//  funnyTry
//
//  Created by SGQ on 2018/10/26.
//  Copyright © 2018年 GQ. All rights reserved.
//

#import "SGQAlertView.h"
#import "UIView+AnimatedShow.h"

@interface SGQAlertView ()
@property (nonatomic, strong) NSMutableArray *allButtons;
@property (nonatomic, strong) NSMutableArray *lines;
@property (nonatomic, copy) void (^clickBlock)(UIButton *button, NSInteger index);
@end

@implementation SGQAlertView

#pragma mark - Life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        _allButtons = [NSMutableArray array];
        _lines = [NSMutableArray array];
    }
    return self;
}

#pragma mark - Public

- (instancetype)initWithTitle:(NSString *)title subTitle:(NSString *)subTitle message:(NSString *)message buttonTitles:(NSArray *)buttonTitles buttonsClickBlock:(void (^)(UIButton *, NSInteger))clickBlock{
    if (self = [self initWithFrame:CGRectZero]) {
        self.clickBlock = clickBlock;
        // 标题
        if (title.length > 0) {
            _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            _titleLabel.backgroundColor = self.backgroundColor;
            _titleLabel.text = title;
            _titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
            _titleLabel.textColor = [UIColor colorWithRed:42/250.0 green:42/250.0 blue:42/250.0 alpha:1.0];
            [self addSubview:_titleLabel];
        }
        
        // 子标题
        if (subTitle.length > 0) {
            _subTitleLalel = [[UILabel alloc] initWithFrame:CGRectZero];
            _subTitleLalel.backgroundColor = self.backgroundColor;
            _subTitleLalel.text = subTitle;
            _subTitleLalel.font = [UIFont systemFontOfSize:15.0f];
            _subTitleLalel.textColor = [UIColor blackColor];
            [self addSubview:_subTitleLalel];
        }
        
        // 头部信息
        if (message.length > 0) {
            _messageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            _messageLabel.backgroundColor = self.backgroundColor;
            _messageLabel.numberOfLines = 0;
            _messageLabel.font = [UIFont systemFontOfSize:15.0f];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle setLineSpacing:4];
            NSMutableAttributedString *attriMessage = [[NSMutableAttributedString alloc] initWithString:message attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:42/250.0 green:42/250.0 blue:42/250.0 alpha:1.0],NSParagraphStyleAttributeName:paragraphStyle, NSFontAttributeName:_messageLabel.font}];
            _messageLabel.attributedText = attriMessage;
            _messageLabel.textAlignment = NSTextAlignmentLeft;
            [self addSubview:_messageLabel];
        }
        
        // buttons
        UIColor *separatorColor = [UIColor colorWithRed:216/250.0 green:216/250.0 blue:216/250.0 alpha:1.0];
        UIImage *buttonHighlightedImage = [SGQAlertView imageWithColor:[UIColor colorWithRed:235/250.0 green:235/250.0 blue:235/250.0 alpha:1.0]];
        UIColor *titleColor = [UIColor colorWithRed:21/250.0 green:126/250.0 blue:251/250.0 alpha:1.0];
        for (NSInteger i = 0; i < buttonTitles.count; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:buttonTitles[i] forState:UIControlStateNormal];
            [button setTitleColor:titleColor forState:UIControlStateNormal];
            button.backgroundColor = self.backgroundColor;
            [button setBackgroundImage:buttonHighlightedImage forState:UIControlStateHighlighted];
            [button.titleLabel setFont:[UIFont systemFontOfSize:18]];
            [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
            [_allButtons addObject:button];
            
            CALayer *line = [CALayer layer];
            line.backgroundColor = separatorColor.CGColor;
            [self.layer addSublayer:line];
            [_lines addObject:line];
        }
        
        self.layer.cornerRadius = 12;
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (void)forceLayoustSubViews {
    CGFloat width = [UIScreen mainScreen].bounds.size.width - 50;
    width = MIN(270, width);
    CGFloat leftMargin = 18;
    
    if (_titleLabel) {
        [_titleLabel sizeToFit];
        _titleLabel.frame = CGRectMake((width - _titleLabel.bounds.size.width) / 2.0, 19, _titleLabel.bounds.size.width, _titleLabel.bounds.size.height);
    }
    
    if (_subTitleLalel) {
        [_subTitleLalel sizeToFit];
        _subTitleLalel.frame = CGRectMake(18 , _titleLabel ? CGRectGetMaxY(_titleLabel.frame) + 15 : 18, _subTitleLalel.bounds.size.width, _subTitleLalel.bounds.size.height);
    }
    
    if (_messageLabel) {
        if (_messageLabel.attributedText.length > 0) {
            CGSize messageLabelSize = [_messageLabel.attributedText boundingRectWithSize:CGSizeMake(width - 2 * leftMargin, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
            _messageLabel.frame = CGRectMake(leftMargin, CGRectGetMaxY(_subTitleLalel.frame) + 7, messageLabelSize.width, messageLabelSize.height);
            
        } else {
            CGSize messageLabelSize = [_messageLabel.text boundingRectWithSize:CGSizeMake(width - 2 * leftMargin, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:_messageLabel.font} context:nil].size;
            _messageLabel.frame = CGRectMake(leftMargin, CGRectGetMaxY(_subTitleLalel.frame) + 7, messageLabelSize.width, messageLabelSize.height);
        }
        
        if (!_subTitleLalel) {
            _messageLabel.frame = CGRectMake(leftMargin, CGRectGetMaxY(_titleLabel.frame) + 15, _messageLabel.frame.size.width, _messageLabel.frame.size.height);
            
        }
        
        if (!_subTitleLalel && !_titleLabel) {
            _messageLabel.frame = CGRectMake(leftMargin, 25, _messageLabel.frame.size.width, _messageLabel.frame.size.height);
        }
    }
    
    // buttons
    CGFloat separatorHeight = 1 / [UIScreen mainScreen].scale;
    CGFloat btnHight = 45;
    if ([UIScreen mainScreen].bounds.size.width == 320) {
        btnHight = 40;
    }
    NSInteger top = CGRectGetMaxY(_messageLabel.frame) + 17;
    for (NSInteger i = 0; i < _allButtons.count; i++) {
        CALayer *line = _lines[i];
        line.frame = CGRectMake(0, top, width, separatorHeight);
        
        UIButton *button = _allButtons[i];
        button.frame = CGRectMake(0, top, width, btnHight);
        top += btnHight;
    }
    
    self.frame = CGRectMake(0, 0, width, top);
    self.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2.0 , [UIScreen mainScreen].bounds.size.height / 2.0);
}

- (void)showWithAnimation {
    [self forceLayoustSubViews];
    [self showInWindowWithType:SGQShowInCenter];
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
    [self hideInWindowWithType:SGQShowInCenter];
    if (self.clickBlock) {
        self.clickBlock(button, [_allButtons indexOfObject:button]);
    }
}

@end
