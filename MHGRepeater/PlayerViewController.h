//
//  PlayerViewController.h
//  MHGRepeater
//
//  Created by 缪 和光 on 13-11-4.
//  Copyright (c) 2013年 Hokuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@interface PlayerViewController : UIViewController<AVAudioPlayerDelegate>

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *currentTimeLabel;
@property (nonatomic, weak) IBOutlet UILabel *totalTimeLabel;
@property (nonatomic, weak) IBOutlet UISlider *progressSlider;
@property (nonatomic, weak) IBOutlet UIButton *ABRepeatButton;
@property (nonatomic, weak) IBOutlet UIButton *playButton;

- (id)initWithFileName:(NSString *)fileName;

- (IBAction)ABrepeatButtonOnTouch:(id)sender;
- (IBAction)backwardButtonOnTouch:(id)sender;
- (IBAction)playButtonOnTouch:(id)sender;
- (IBAction)sliderChanged:(UISlider *)sender;

@end
