//
//  CRSoundWavesView.h
//  SoundWaves
//
//  Created by mfhj-dz-001-059 on 2021/4/29.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, CRSoundWavesLevel) {
    /// 静音
    CRSoundWavesLevelMute = 0,
    /// 默认状态
    CRSoundWavesLevelNormal = 1,
    /// 弱
    CRSoundWavesLevelWeak = 2,
    /// 中
    CRSoundWavesLevelMedium = 3,
    /// 强
    CRSoundWavesLevelStrong = 4,
};

@interface CRSoundWavesView : UIView

/// 声波浮动等级
@property(assign, nonatomic) CRSoundWavesLevel level;

@end

NS_ASSUME_NONNULL_END
