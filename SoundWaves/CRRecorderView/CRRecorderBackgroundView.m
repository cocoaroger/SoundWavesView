//
//  CRRecorderBackgroundView.m
//  SoundWaves
//
//  Created by roger wu on 2023/11/4.
//

#import "CRRecorderBackgroundView.h"

@implementation CRRecorderBackgroundView

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    NSLog(@"CRRecorderBackgroundView-touchesBegan");
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    // 3.手指移出CRControlButton, 提示取消
//    NSLog(@"CRRecorderBackgroundView-touchesMoved");
    self.recorderView.status = CRRecorderViewStatusCancelNotice;
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    // 5.手指结束触摸，不在CRControlButton内，取消录音
//    NSLog(@"CRRecorderBackgroundView-touchesEnded");
    self.recorderView.status = CRRecorderViewStatusRecordedCancel;
    [super touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    NSLog(@"CRRecorderBackgroundView-touchesCancelled");
    [super touchesCancelled:touches withEvent:event];
}

@end
