//
//  CRControlButton.h
//  SoundWaves
//
//  Created by roger wu on 2023/11/4.
//

#import <UIKit/UIKit.h>
#import "CRRecorderView.h"

NS_ASSUME_NONNULL_BEGIN

@interface CRControlButton : UIButton

@property (weak, nonatomic) CRRecorderView *recorderView; // 用于修改状态

@end

NS_ASSUME_NONNULL_END
