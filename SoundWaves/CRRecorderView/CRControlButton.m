//
//  CRControlButton.m
//  SoundWaves
//
//  Created by roger wu on 2023/11/4.
//

#import "CRControlButton.h"

@implementation CRControlButton

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    NSLog(@"CRControlButton-touchesBegan");
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    // 2.手指在CRControlButton中，正在录音
//    NSLog(@"CRControlButton-touchesMoved");
    self.recorderView.status = CRRecorderViewStatusRecording;
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    // 5.手指结束触摸，在CRControlButton内，发送录音
//    NSLog(@"CRControlButton-touchesEnded");
    self.recorderView.status = CRRecorderViewStatusRecordedSend;
    [super touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    NSLog(@"CRControlButton-touchesCancelled");
    [super touchesCancelled:touches withEvent:event];
}

@end
