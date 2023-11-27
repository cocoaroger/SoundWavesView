//
//  CRSoundWavesLine.m
//  SoundWaves
//
//  Created by mfhj-dz-001-059 on 2021/4/29.
//

#import "CRSoundWavesLine.h"

@interface CRSoundWavesLine()<CAAnimationDelegate>

@property(strong, nonatomic) CAShapeLayer *shapeLayer;

/// 声波线颜色
@property(strong, nonatomic) UIColor *lineColor;

/// 启用动画
@property(assign, nonatomic) BOOL animationEnable;

@end

@implementation CRSoundWavesLine

- (instancetype)initWithLineColor:(UIColor *)lineColor {
    self = [super init];
    if (self) {
        self.lineColor = lineColor;
        [self initialization];
        [self addCustomControl];
    }
    return self;
}

- (void)layoutSubviews {
    self.shapeLayer.frame = self.bounds;
}

- (void)initialization {
    self.backgroundColor = [UIColor clearColor];
    self.toValue = 1.f;
    self.beginTime = 0.f;
    if (!self.lineColor) {
        self.lineColor = [UIColor grayColor];
    }
}

- (void)addCustomControl {
    self.shapeLayer = CAShapeLayer.layer;
    self.shapeLayer.anchorPoint = CGPointMake(.5, .5);
    self.shapeLayer.backgroundColor = [self.lineColor CGColor];
    self.shapeLayer.cornerRadius = 1.f;
    self.shapeLayer.masksToBounds = YES;
    [self.layer addSublayer:self.shapeLayer];
}

- (CABasicAnimation *)getScaleAnimationToValue:(CGFloat)toValue {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"bounds.size.height"];
    animation.duration = 0.2;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.fromValue = [NSNumber numberWithFloat:self.lineHeight];
    animation.toValue = [NSNumber numberWithFloat:toValue];
    animation.autoreverses = YES;
    animation.beginTime = CACurrentMediaTime() + self.beginTime;
    animation.delegate = self;
//    animation.repeatCount = MAXFLOAT;
    return animation;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (self.animationEnable) {
        [self addAnimation];
    }
}

- (void)addAnimation {
    [self.shapeLayer addAnimation:[self getScaleAnimationToValue:self.toValue] forKey:@"animation"];
}

- (void)beginAnimation {
    if (self.animationEnable) {
        return;
    }
    self.animationEnable = true;
    [self addAnimation];
}

- (void)stopAnimation {
    self.animationEnable = false;
}

@end
