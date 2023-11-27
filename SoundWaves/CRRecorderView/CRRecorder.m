//
//  CRRecorder.m
//  SoundWaves
//
//  Created by roger wu on 2023/11/4.
//

#import "CRRecorder.h"
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

static const CGFloat kCRRecorderMaxSeconds = 60.f;
static const CGFloat kCRRecorderMinSeconds = 1.f;

@interface CRRecorder ()<AVAudioRecorderDelegate>

@property (strong, nonatomic) AVAudioRecorder *recorder; // 录音对象
@property(nonatomic) NSTimer *recordingTimer; // 录音定时器
@property(nonatomic) NSTimer *updateMeterTimer; // 音量定时器
@property(nonatomic, assign) NSInteger seconds; // 录音描述
@property(nonatomic) BOOL recordCanceled; // 录音取消

@end

@implementation CRRecorder

+ (instancetype)sharedInstance {
    static CRRecorder *instance = NULL;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [CRRecorder new];
    });
    return instance;
}

- (void)startRecord {
    __weak typeof(self)ws = self;
    [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
        if (granted) {
            AVAudioSession *session = [AVAudioSession sharedInstance];
            [session setCategory:AVAudioSessionCategoryRecord error:nil];
            BOOL r = [session setActive:YES error:nil];
            if (!r) {
                NSLog(@"activate audio session fail");
                return;
            }
            NSLog(@"开始录音...");
            
            NSArray *pathComponents = [NSArray arrayWithObjects:
                                       [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                                       @"voice.wav",
                                       nil];
            NSURL *outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
            
            // Define the recorder setting
            NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
            [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
            [recordSetting setValue:[NSNumber numberWithFloat:8000] forKey:AVSampleRateKey];
            [recordSetting setValue:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
            ws.recorder = [[AVAudioRecorder alloc] initWithURL:outputFileURL settings:recordSetting error:NULL];
            ws.recorder.delegate = ws;
            ws.recorder.meteringEnabled = ws;
            if (![ws.recorder prepareToRecord]) {
                NSLog(@"prepare record fail");
                return;
            }
            if (![ws.recorder record]) {
                NSLog(@"start record fail");
                return;
            }
            
            ws.recordCanceled = NO;
            ws.seconds = 0;
            ws.recordingTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                                   target:ws
                                                                 selector:@selector(timerFired:)
                                                                 userInfo:nil
                                                                  repeats:YES];
            
            ws.updateMeterTimer = [NSTimer scheduledTimerWithTimeInterval:0.05
                                                                     target:ws
                                                                   selector:@selector(updateMeter:)
                                                                   userInfo:nil
                                                                    repeats:YES];
        }
    }];
}

- (void)stopRecord {
    [self.recorder stop];
    [self.recordingTimer invalidate];
    self.recordingTimer = nil;
    [self.updateMeterTimer invalidate];
    self.updateMeterTimer = nil;
    [self.delegate recordingDuration:@"00:00"];
    [self.delegate recordingMeters:0];
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    BOOL r = [audioSession setActive:NO error:nil];
    if (!r) {
        NSLog(@"deactivate audio session fail");
    }
}

- (void)timerFired:(NSTimer*)timer {
    self.seconds = self.seconds + 1;
    NSInteger minute = self.seconds/60;
    NSInteger s = self.seconds%60;
    NSString *str = [NSString stringWithFormat:@"%02ld:%02ld", minute, s];
    [self.delegate recordingDuration:str];
    // 最大时间结束结束录音
    NSInteger countdown = kCRRecorderMaxSeconds - self.seconds;
    if (countdown <= 0) {
        [self recordEnd];
    }
}

- (void)updateMeter:(NSTimer*)timer {
    double voiceMeter = 0;
    if ([self.recorder isRecording]) {
        [self.recorder updateMeters];
        //获取音量的平均值  [recorder averagePowerForChannel:0];
        //音量的最大值  [recorder peakPowerForChannel:0];
        double lowPassResults = pow(10, (0.05 * [self.recorder peakPowerForChannel:0]));
        voiceMeter = lowPassResults;
    }
    [self.delegate recordingMeters:voiceMeter];
//    NSLog(@"音量：%f", voiceMeter);
}

-(void)recordEnd {
    if (self.recorder.recording) {
        NSLog(@"停止录音...");
        self.recordCanceled = NO;
        [self stopRecord];
    }
}

- (void)cancelRecord {
    if (self.recorder.recording) {
        NSLog(@"取消录音...");
        self.recordCanceled = YES;
        [self stopRecord];
    }
}

- (BOOL)canRecord {
    __block BOOL bCanRecord = YES;
    if ([[AVAudioSession sharedInstance]
         respondsToSelector:@selector(requestRecordPermission:)]) {
        [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
            bCanRecord = granted;
            dispatch_async(dispatch_get_main_queue(), ^{
                bCanRecord = granted;
                if (granted) {
                    bCanRecord = YES;
                } else {
                }
            });
        }];
    }
    return bCanRecord;
}

#pragma mark - AVAudioRecorderDelegate
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    NSLog(@"record finish:%d", flag);
    if (!flag) {
        return;
    }
    if (self.recordCanceled) {
        return;
    }
    if (self.seconds < kCRRecorderMinSeconds) {
        NSLog(@"录制时间太短");
        [self.delegate recordTooShort];
        return;
    }
    
    [self.delegate recordDidEnd:[recorder.url path] duration:self.seconds];
    [[NSFileManager defaultManager] removeItemAtURL:recorder.url error:nil];
}
@end
