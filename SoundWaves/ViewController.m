//
//  ViewController.m
//  SoundWaves
//
//  Created by mfhj-dz-001-059 on 2021/4/29.
//

#import "ViewController.h"
#import "CRSoundWavesView.h"
#import <Masonry/Masonry.h>
#import "CRRecorderView.h"
#import "CRTouchButton.h"
#import <AudioToolbox/AudioToolbox.h>

@interface ViewController ()<CRRecorderViewDelegate>

@property(strong, nonatomic) NSArray<UIButton *> *buttons;
@property(strong, nonatomic) CRSoundWavesView *soundWavesView;
@property (strong, nonatomic) CRTouchButton *testButton;
@property (strong, nonatomic) CRRecorderView *recordView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    static const CGFloat kHeight = 100.f;
    
    UIView *bgView = [UIView new];
    
    bgView.backgroundColor = [UIColor colorWithRed:0 green:0.48 blue:1 alpha:1];
    self.soundWavesView = [[CRSoundWavesView alloc] init];
    [bgView addSubview:self.soundWavesView];
    [self.view addSubview:bgView];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.mas_equalTo(100);
        make.width.equalTo(self.view);
        make.height.mas_equalTo(kHeight);
    }];
    
    [self.soundWavesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(bgView);
        make.height.mas_equalTo(kHeight/2);
    }];
    
    UIButton *muteButton = [self createButtonWithTitle:@"静音"];
    muteButton.tag = 10000;
    muteButton.selected = true;
    UIButton *normalButton = [self createButtonWithTitle:@"普通"];
    normalButton.tag = 10001;
    UIButton *weakButton = [self createButtonWithTitle:@"弱强度"];
    weakButton.tag = 10002;
    UIButton *mediumButton = [self createButtonWithTitle:@"中强度"];
    mediumButton.tag = 10003;
    UIButton *strongButton = [self createButtonWithTitle:@"高强度"];
    strongButton.tag = 10004;
    self.buttons = @[muteButton, normalButton, weakButton, mediumButton, strongButton];
    [self.buttons mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:10 leadSpacing:10 tailSpacing:10];
    [self.buttons mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_bottom).offset(30);
        make.height.equalTo(@40);
    }];
    
    CRTouchButton *testButton = [CRTouchButton new];
    _testButton = testButton;
    [testButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:testButton];
    [testButton setTitle:@"长按说话" forState:UIControlStateNormal];
    [testButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.mas_equalTo(-40);
    }];
    
    _recordView = [CRRecorderView recorderInView:self.view delegate:self vc:self];
    testButton.recorderView = _recordView;
    [testButton addTarget:self action:@selector(testRecorder:) forControlEvents:UIControlEventTouchDown];
}

- (void)testRecorder:(UIButton *)button {
    AudioServicesPlaySystemSound(1519); // 发起振动
    [_recordView show];
}

- (void)changeSoundWavesLevel:(UIButton *)sender {
    [self.buttons enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.selected = false;
    }];
    sender.selected = true;
    self.soundWavesView.level = sender.tag - 10000;
}

- (UIButton *)createButtonWithTitle:(NSString *)title {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[[UIColor blackColor] colorWithAlphaComponent:0.3] forState:UIControlStateHighlighted];
    [button setTitleColor:[[UIColor blackColor] colorWithAlphaComponent:0.3] forState:UIControlStateHighlighted | UIControlStateSelected];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(changeSoundWavesLevel:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    return button;
}

/// 返回录音结果, 取消则不返回
- (void)recordDidEnd:(NSString *)url duration:(CGFloat)duration {
    NSLog(@"录音结果%@, %@", url, @(duration));
}

@end
