# LikeAnimationButton

使用核心动画实现点赞和踩动效

![image](https://raw.githubusercontent.com/liuyongjiesail/LikeAnimationButton/master/Like&Tread.gif)

### sample code

```

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

```

#### LikeAnimationButton.h

```

typedef NS_ENUM(NSInteger, LikeAnimationButtonType) {
    LikeAnimationButtonTypeTop    = 0,
    LikeAnimationButtonTypeTread  = 1,
};

@class LikeAnimationButton;

@protocol LikeAnimationButtonDelegate <NSObject>

- (void)didClickAnimationButton:(LikeAnimationButton *)animationButton type:(LikeAnimationButtonType)animationType;

@end

@interface LikeAnimationButton : UIButton

@property (strong, nonatomic) id<LikeAnimationButtonDelegate> delegate;

+ (instancetype)animationButtonWithType:(LikeAnimationButtonType)animationType;

@end

```

#### LikeAnimationButton.m

```

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

```
