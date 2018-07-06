//
//  ViewController.m
//  LikeButtonDemo
//
//  Created by 刘永杰 on 2018/7/6.
//  Copyright © 2018年 刘永杰. All rights reserved.
//

#import "ViewController.h"
#import "LikeAnimationButton.h"

@interface ViewController () <LikeAnimationButtonDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //赞
    LikeAnimationButton *likeButton = [LikeAnimationButton animationButtonWithType:LikeAnimationButtonTypeTop];
    likeButton.delegate = self;
    likeButton.frame = CGRectMake(100, 200, 100, 40);
    [likeButton setTitle:@"78" forState:UIControlStateNormal];
    [self.view addSubview:likeButton];
    
    //踩
    LikeAnimationButton *treadButton = [LikeAnimationButton animationButtonWithType:LikeAnimationButtonTypeTread];
    treadButton.delegate = self;
    treadButton.frame = CGRectMake(200, 200, 100, 40);
    [treadButton setTitle:@"28" forState:UIControlStateNormal];
    [self.view addSubview:treadButton];
    
}

#pragma mark - LikeAnimationButtonDelegate
- (void)didClickAnimationButton:(LikeAnimationButton *)animationButton type:(LikeAnimationButtonType)animationType {
    
    [animationButton setTitle:[NSString stringWithFormat:@"%ld", animationButton.titleLabel.text.integerValue + (animationButton.selected ? 1 : -1)] forState:UIControlStateNormal];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
