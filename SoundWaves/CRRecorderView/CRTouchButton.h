//
//  CRTouchButton.h
//  SoundWaves
//
//  Created by roger wu on 2023/11/4.
//

#import <UIKit/UIKit.h>
#import "CRRecorderView.h"

NS_ASSUME_NONNULL_BEGIN
@interface CRTouchButton : UIButton

@property (weak, nonatomic) CRRecorderView *recorderView; // 在录音视图寻找下级视图

@end

NS_ASSUME_NONNULL_END
