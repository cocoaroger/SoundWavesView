//
//  CRSoundWavesLine.h
//  SoundWaves
//
//  Created by mfhj-dz-001-059 on 2021/4/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CRSoundWavesLine : UIView

/// 初始化
/// @param lineColor  声波线颜色
- (instancetype)initWithLineColor:(UIColor *)lineColor;

/// 线高度
@property (assign, nonatomic) CGFloat lineHeight;

/// 目标值
@property (assign, nonatomic) CGFloat toValue;

/// 延迟时间
@property (assign, nonatomic) CGFloat beginTime;

/// 开始动画
- (void)beginAnimation;

/// 停止动画
- (void)stopAnimation;

@end

NS_ASSUME_NONNULL_END
