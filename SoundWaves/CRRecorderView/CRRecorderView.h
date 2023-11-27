//
//  CRRecorderView.h
//  SoundWaves
//
//  Created by roger wu on 2023/11/4.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    CRRecorderViewStatusRecording = 1, // 录音中
    CRRecorderViewStatusCancelNotice = 2, // 提示取消
    CRRecorderViewStatusRecordedSend = 3, // 录音结束->发送
    CRRecorderViewStatusRecordedCancel = 4, // 录音结束->取消
} CRRecorderViewStatus;

NS_ASSUME_NONNULL_BEGIN

@protocol CRRecorderViewDelegate<NSObject>

/// 录制完成
/// - Parameters:
///   - url: 音频url
///   - duration: 音频时长
- (void)recordDidEnd:(NSString *)url duration:(CGFloat)duration;

@end

@interface CRRecorderView : UIView

+ (CRRecorderView *)recorderInView:(UIView *)view delegate:(id<CRRecorderViewDelegate>)delegate vc:(UIViewController *)vc;

/// 显示录音视图
- (void)show;

/// 交给其他控件改变状态
@property (assign, nonatomic) CRRecorderViewStatus status;

@end

NS_ASSUME_NONNULL_END
