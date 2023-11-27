//
//  CRRecorder.h
//  SoundWaves
//
//  Created by roger wu on 2023/11/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CRRecorderDelegate<NSObject>


/// 录制中
/// - Parameter duration: 录制中时间
- (void)recordingDuration:(NSString *)duration;

/// 录制中音量
/// - Parameter voiceMeter: 音量
- (void)recordingMeters:(CGFloat)voiceMeter;

/// 录制时间太短
- (void)recordTooShort;

/// 录制完成
/// - Parameters:
///   - url: 音频url
///   - duration: 音频时长
- (void)recordDidEnd:(NSString *)url duration:(CGFloat)duration;

@end

@interface CRRecorder : NSObject

+ (instancetype)sharedInstance;

@property (weak, nonatomic) id<CRRecorderDelegate> delegate;

/// 开始录音
- (void)startRecord;

/// 结束录音
- (void)recordEnd;

/// 取消录音
- (void)cancelRecord;

/// 判断是否有录音权限
- (BOOL)canRecord;
@end

NS_ASSUME_NONNULL_END
