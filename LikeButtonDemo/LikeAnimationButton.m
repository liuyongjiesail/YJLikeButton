//
//  LikeAnimationButton.m
//  LikeButtonDemo
//
//  Created by 刘永杰 on 2018/7/6.
//  Copyright © 2018年 刘永杰. All rights reserved.
//

#import "LikeAnimationButton.h"

@interface LikeAnimationButton ()

@property (assign, nonatomic) LikeAnimationButtonType animationType;

@end

@implementation LikeAnimationButton

+ (instancetype)animationButtonWithType:(LikeAnimationButtonType)animationType {

    LikeAnimationButton *animationButton = [LikeAnimationButton buttonWithType:UIButtonTypeCustom];
    animationButton.animationType = animationType;
    return animationButton;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.titleLabel.font = [UIFont systemFontOfSize:12];
        self.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 0);
        [self setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [self setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)buttonAction:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        [self likeAnimation];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickAnimationButton:type:)]) {
        [self.delegate didClickAnimationButton:self type:self.animationType];
    }
}

- (void)likeAnimation {
    
    //缩放回弹动画
    CAKeyframeAnimation *scale = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    scale.values = @[@1.8,@1.0,@1.1,@1.0];
    scale.duration = 1.0;
    scale.calculationMode = kCAAnimationCubic;
    
    //旋转动画
    CABasicAnimation *rotation = [CABasicAnimation animation];
    rotation.keyPath = @"transform.rotation";
    rotation.toValue =@(-M_PI * 0.15); // 旋转多少角度
    rotation.duration = 0.15;
    
    //上移或下移动画
    CAKeyframeAnimation *translation = [CAKeyframeAnimation animation];
    
    CGFloat offset;
    if (self.animationType == LikeAnimationButtonTypeTop) {
        offset = -10;
    } else {
        offset = 10;
    };
    
    translation.keyPath = @"transform.translation";
    NSValue *v1 = [NSValue valueWithCGPoint:CGPointZero];
    NSValue *v2 = [NSValue valueWithCGPoint:CGPointMake(0, offset)];
    NSValue *v3 = [NSValue valueWithCGPoint:CGPointMake(0, 0)];
    translation.values = @[v1, v2, v3];
    translation.duration = 0.2;
    translation.removedOnCompletion = NO;
    translation.fillMode = kCAFillModeForwards;
    
    //将所有的动画添加到动画组中
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[rotation,scale,translation];
    group.duration = 2;
    
    [self.imageView.layer addAnimation:group forKey:nil];
    
}

#pragma mark - Setter

- (void)setAnimationType:(LikeAnimationButtonType)animationType {
    _animationType = animationType;
    
    NSString *normalStr;
    NSString *selectedStr;
    
    if (animationType == LikeAnimationButtonTypeTop) {
        normalStr = @"detail_comment_like";
        selectedStr = @"detail_comment_like_red";
    } else {
        normalStr = @"home_stepon_normal";
        selectedStr = @"home_stepon_higlight";
    }
    [self setImage:[UIImage imageNamed:normalStr] forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:selectedStr] forState:UIControlStateSelected];
    
}

@end
