//
//  ViewController.m
//  AlertDemo
//
//  Created by SGQ on 2018/10/29.
//  Copyright © 2018年 shigaoqiang. All rights reserved.
//

#import "ViewController.h"
#import "SGQAlertView.h"
#import "SGQActionSheet.h"
#import "UIView+AnimatedShow.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(50, 200, 200, 50)];
    [self.view addSubview:tf];
    tf.placeholder = @"input your name";
    tf.borderStyle = UITextBorderStyleLine;
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
//    SGQActionSheet *sheet = [[SGQActionSheet alloc] initWithMessage:@"退出后不会删除任何历史数据，下次登录依然可以使用本账号" attributedMessage:nil cancelButtonTitle:@"取消" otherButtonTitles:@[@"退出登录", @"登录遇到问题", @"联系客服"] otherButtonsClickBlock:^(UIButton *button, NSInteger index) {
//        if (index  == 0) {
//            NSLog(@"退出");
//        } else if (index == 1) {
//            NSLog(@"登录遇到问题");
//        } else if (index == 2) {
//            NSLog(@"联系客服");
//        }
//    }];
//    [sheet showWithAnimation];
    
    
    SGQAlertView *alert =  [[SGQAlertView alloc] initWithTitle:@"title" subTitle:@"subTitle" message:@"退出后不会删除任何历史数据，下次登录依然可以善用本账号" buttonTitles:@[@"button1", @"button2", @"button3", @"cancel"] buttonsClickBlock:^(UIButton *button, NSInteger index) {
        NSLog(@"%@", [button titleForState:UIControlStateNormal]);
    }];
    [alert showWithAnimation];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
