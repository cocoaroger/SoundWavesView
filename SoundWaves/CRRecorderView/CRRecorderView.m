//
//  CRRecorderView.m
//  SoundWaves
//
//  Created by roger wu on 2023/11/4.
//

#import "CRRecorderView.h"
#import <Masonry/Masonry.h>
#import "CRSoundWavesView.h"
#import "CRRecorder.h"
#import "UIAlertController+Blocks.h"
#import "CRRecorderBackgroundView.h"
#import "CRControlButton.h"

#define CRRecorderViewRGBA(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]

@interface CRRecorderView()<CRRecorderDelegate>

@property (assign, nonatomic) BOOL isRecording; // 是否正在录音

@property (assign, nonatomic) CGFloat duration; // 录音时长

@property (strong, nonatomic) CRRecorderBackgroundView *bgView; // 手势整个背景

@property (strong, nonatomic) UIImageView *bubbleBgImageView;
@property (strong, nonatomic) CRSoundWavesView *waveView;

@property (strong, nonatomic) UIImageView *closeImageView;
@property (strong, nonatomic) UILabel *tipLabel;

@property (strong, nonatomic) CRControlButton *controlButton; // 手势按钮背景
@property (strong, nonatomic) UIImageView *controlBgImageView;
@property (strong, nonatomic) UILabel *timerLabel;

@property (weak, nonatomic) id<CRRecorderViewDelegate> delegate;
@property (weak, nonatomic) UIViewController *parentVC;
@end

@implementation CRRecorderView

+ (CRRecorderView *)recorderInView:(UIView *)view delegate:(id<CRRecorderViewDelegate>)delegate vc:(UIViewController *)vc {
    CRRecorderView *recorderView = [[CRRecorderView alloc] initWithFrame:view.bounds];
    [view addSubview:recorderView];
    recorderView.delegate = delegate;
    recorderView.parentVC = vc;
    recorderView.hidden = YES;
    return recorderView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (void)show {
    [CRRecorder sharedInstance].delegate = self;
    self.isRecording = NO;
    self.waveView.level = CRSoundWavesLevelNormal;
    self.timerLabel.text = @"00:00";
    self.status = CRRecorderViewStatusRecording;
    
    self.hidden = NO;
    self.alpha = 0;
    [UIView animateWithDuration:0.2f animations:^{
        self.alpha = 1;
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.2f animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

- (void)setup {
    self.backgroundColor = [UIColor clearColor];
    
    _bgView = [CRRecorderBackgroundView new];
    _bgView.recorderView = self;
    _bgView.backgroundColor = CRRecorderViewRGBA(0,0,0,0.5);
    [self addSubview:_bgView];
    
    _bubbleBgImageView = [UIImageView new];
    [self addSubview:_bubbleBgImageView];
    
    _waveView = [[CRSoundWavesView alloc] init];
    [_bubbleBgImageView addSubview:_waveView];
    
    _closeImageView = [UIImageView new];
    [self addSubview:_closeImageView];

    _tipLabel = [UILabel new];
    _tipLabel.font = [UIFont systemFontOfSize:14];
    _tipLabel.textColor = [UIColor whiteColor];
    [self addSubview:_tipLabel];
    
    _controlButton = [CRControlButton new];
    _controlButton.recorderView = self;
    [self addSubview:_controlButton];
    
    _controlBgImageView = [UIImageView new];
    _controlBgImageView.image = [UIImage imageNamed:@"recorder_timer_bg"];
    [_controlButton addSubview:_controlBgImageView];
    
    _timerLabel = [UILabel new];
    _timerLabel.font = [UIFont systemFontOfSize:14];
    _timerLabel.textColor = CRRecorderViewRGBA(91,91,91,1);
    [_controlButton addSubview:_timerLabel];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [_bubbleBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.mas_equalTo(153.f);
        make.height.mas_equalTo(80.f);
    }];
    
    [_waveView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bubbleBgImageView);
        make.top.mas_equalTo(15.f);
        make.height.mas_equalTo(40.f);
    }];
    
    [_closeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.tipLabel.mas_top).offset(-28);
    }];
    
    [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.controlBgImageView.mas_top).offset(-20);
    }];
    
    [_controlButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self);
        make.height.mas_equalTo(112.5);
    }];
    
    [_controlBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.controlButton);
    }];
    
    [_timerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.controlButton);
    }];
}

// 设置状态变化
- (void)setStatus:(CRRecorderViewStatus)status {
    _status = status;
    switch (status) {
        case CRRecorderViewStatusRecording:
            _bubbleBgImageView.image = [UIImage imageNamed:@"recorder_bubble_b"];
            _closeImageView.image = [UIImage imageNamed:@"recorder_close_send"];
            _tipLabel.text = @"松开 发送";
            [self startRecording];
            break;
        case CRRecorderViewStatusCancelNotice:
            _bubbleBgImageView.image = [UIImage imageNamed:@"recorder_bubble_r"];
            _closeImageView.image = [UIImage imageNamed:@"recorder_close_cancel"];
            _tipLabel.text = @"松开 取消";
            break;
        case CRRecorderViewStatusRecordedSend:
            // 结束录音，发送, 最后会调用方法 - (void)recordDidEnd:(NSString *)url duration:(CGFloat)duration
            [[CRRecorder sharedInstance] recordEnd];
            break;
        case CRRecorderViewStatusRecordedCancel:
            // 结束录音，取消
            [[CRRecorder sharedInstance] cancelRecord];
            [self dismiss];
            break;
        default:
            break;
    }
}

#pragma mark - 各种事件
- (void)startRecording {
    if (self.isRecording) {
        return;
    }
    if ([[CRRecorder sharedInstance] canRecord]) {
        [[CRRecorder sharedInstance] startRecord];
        self.isRecording = YES;
    } else {
        [UIAlertController showAlertInViewController:self.parentVC
                                           withTitle:@"警告"
                                             message:@"无法录音,请到设置-隐私-麦克风,允许程序访问"
                                   cancelButtonTitle:nil
                              destructiveButtonTitle:@"确定"
                                   otherButtonTitles:nil
                                            tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        }];
    }
}

#pragma - CRRecorderDelegate
- (void)recordingDuration:(NSString *)duration {
    _timerLabel.text = duration;
}

- (void)recordingMeters:(CGFloat)voiceMeter {
    if (voiceMeter <= 0.1) {
        _waveView.level = CRSoundWavesLevelNormal;
    } else if (voiceMeter <= 0.2) {
        _waveView.level = CRSoundWavesLevelWeak;
    } else if (voiceMeter <= 0.3) {
        _waveView.level = CRSoundWavesLevelMedium;
    } else {
        _waveView.level = CRSoundWavesLevelStrong;
    }
}

- (void)recordTooShort {
    [UIAlertController showAlertInViewController:self.parentVC
                                       withTitle:@"警告"
                                         message:@"录制时间太短了"
                               cancelButtonTitle:nil
                          destructiveButtonTitle:@"确定"
                               otherButtonTitles:nil
                                        tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
    }];
    [self dismiss];
}

- (void)recordDidEnd:(NSString *)url duration:(CGFloat)duration {
    [self.delegate recordDidEnd:url duration:duration];
    [self dismiss];
}

@end
