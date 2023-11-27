//
//  CRTouchButton.m
//  SoundWaves
//
//  Created by roger wu on 2023/11/4.
//

#import "CRTouchButton.h"

@implementation CRTouchButton

/// 向下传递
- (UIView *)transfer:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self.recorderView];
    UIView *receivingView = [self.recorderView hitTest:touchPoint withEvent:event];
    return receivingView;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // 1.开始点击
//    NSLog(@"CRTouchButton-touchesBegan");
    [[self transfer:touches withEvent:event] touchesBegan:touches withEvent:event];
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
//    NSLog(@"CRTouchButton-touchesMoved");
    [[self transfer:touches withEvent:event] touchesMoved:touches withEvent:event];
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    // 4.手指结束触摸
//    NSLog(@"CRTouchButton-touchesEnded");
    [[self transfer:touches withEvent:event] touchesEnded:touches withEvent:event];
    self.recorderView.status = CRRecorderViewStatusRecordedCancel;
    [super touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    NSLog(@"CRTouchButton-touchesCancelled");
    [[self transfer:touches withEvent:event] touchesCancelled:touches withEvent:event];
    [super touchesCancelled:touches withEvent:event];
}

@end
