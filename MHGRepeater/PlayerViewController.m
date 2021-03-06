//
//  PlayerViewController.m
//  MHGRepeater
//
//  Created by 缪 和光 on 13-11-4.
//  Copyright (c) 2013年 Hokuang. All rights reserved.
//

#import "PlayerViewController.h"
#import "NSString+AppExt.h"
#import <MediaPlayer/MediaPlayer.h>

@interface PlayerViewController ()

@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, unsafe_unretained) NSTimeInterval repeatStartTime;
@property (nonatomic, unsafe_unretained) NSTimeInterval repeatEndTime;

@property (nonatomic, unsafe_unretained) BOOL repeatStart;


@end

@implementation PlayerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithFileName:(NSString *)fileName
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _fileName = [fileName copy];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.titleLabel.text = self.fileName;
    
    
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",USER_DOCUMENT_PATH,self.fileName];
    NSURL *audioURL = [NSURL URLWithString:[filePath URLEncoding]];
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive: YES error: nil];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    NSError *error;
    self.player = [[AVAudioPlayer alloc]initWithContentsOfURL:audioURL error:&error];
    self.player.delegate = self;
    if (error != nil || ![self.player prepareToPlay]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"无法播放该音频" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    self.progressSlider.maximumValue = self.player.duration;
    int totalMinutes = floor(self.player.duration/60);
    int totalSeconds = round(self.player.duration - totalMinutes * 60);
    if (totalSeconds >= 60) {
        totalSeconds = 0;
    }
    self.currentTimeLabel.text = @"0:00";
    self.totalTimeLabel.text = [NSString stringWithFormat:@"%d:%02d",totalMinutes,totalSeconds];
    
    [self resetRepeatRange];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self.player stop];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)ABrepeatButtonOnTouch:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    btn.tag = (btn.tag+1)%3;
    
    static UIColor *defaultColor = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultColor = [btn titleColorForState:UIControlStateNormal];
    });
    
    if (btn.tag == 0) {
        //未开始
        [btn setTitleColor:defaultColor forState:UIControlStateNormal];
        btn.selected = NO;
        [self resetRepeatRange];
        self.repeatStart = NO;
    }else if (btn.tag == 1){
        //记录A
        [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        btn.selected = NO;
        self.repeatStartTime = self.player.currentTime;
        self.repeatStart = NO;
    }else if (btn.tag == 2){
        //记录B
        btn.selected = YES;
        self.repeatEndTime = self.player.currentTime;
        self.repeatStart = YES;
    }
}
- (IBAction)backwardButtonOnTouch:(id)sender
{
    NSTimeInterval currentTime = self.player.currentTime - 1;
    
    BOOL isPlaying = self.player.isPlaying;
    if (isPlaying) {
        [self.player pause];
    }
    if (currentTime < 0) {
        currentTime = 0;
    }
	[self.player setCurrentTime:currentTime];
    self.progressSlider.value = currentTime;
    [self updateMediaInfo];
    
    if (isPlaying) {
        [self.player play];
    }
    
    [self updateSlider];
    
}
- (IBAction)playButtonOnTouch:(id)sender
{
    [self resumeOrPause];
}

- (void)updateSlider
{
    self.progressSlider.value = self.player.currentTime;
    int currMinutes = floor(self.player.currentTime/60);
    int currSeconds = round(self.player.currentTime - currMinutes * 60);
    if (currSeconds >= 60) {
        currSeconds = 0;
    }
    self.currentTimeLabel.text = [NSString stringWithFormat:@"%d:%02d",currMinutes,currSeconds];
    if (self.repeatStart && self.progressSlider.value >= self.repeatEndTime) {
        [self finishPlaying];
    }
}

- (IBAction)sliderChanged:(UISlider *)sender {
	// Fast skip the music when user scroll the UISlider
    if ([self.player isPlaying]) {
        [self.player pause];
        [self.player setCurrentTime:sender.value];
        [self updateMediaInfo];
        [self.player play];
    }else {
        [self.player setCurrentTime:sender.value];
    }
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
	// Music completed
	if (flag) {
		[self finishPlaying];
	}
}

- (void)resetRepeatRange
{
    self.repeatStartTime = self.progressSlider.value;
    self.repeatEndTime = self.player.duration;
}

- (void)startPlay
{
	[self.player play];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateSlider) userInfo:nil repeats:YES];
    self.playButton.selected = YES;
}

- (void)finishPlaying
{
    [self.timer invalidate];
    [self.player pause];
    self.playButton.selected = NO;
}

- (void)resumeOrPause
{
    if (!self.player.isPlaying) {
        if (self.repeatStart) {
            if (self.progressSlider.value >= self.repeatEndTime) {
                [self.player setCurrentTime:self.repeatStartTime];
            }
        }
        [self updateMediaInfo];
        [self startPlay];
    }else{
        [self finishPlaying];
    }
}

#pragma mark - remote
- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
	if (event.type == UIEventTypeRemoteControl) {
        switch (event.subtype) {
            case UIEventSubtypeRemoteControlTogglePlayPause:
                [self resumeOrPause]; // 切换播放、暂停按钮
                break;
            case UIEventSubtypeRemoteControlPlay:
                [self resumeOrPause];
                break;
            case UIEventSubtypeRemoteControlPause:
                [self resumeOrPause];
                break;
            default:
                break;
        }
    }
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)updateMediaInfo
{
    [MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo = nil;
    Class playingInfoCenter = NSClassFromString(@"MPNowPlayingInfoCenter");
    if (playingInfoCenter) {
        NSMutableDictionary *songInfo = [ [NSMutableDictionary alloc] init];
        [songInfo setObject:self.fileName forKey:MPMediaItemPropertyTitle];
        [songInfo setObject:@(self.player.duration) forKey:MPMediaItemPropertyPlaybackDuration];
        [songInfo setObject:@(self.player.currentTime) forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
        [songInfo setObject:@(1.0) forKey:MPNowPlayingInfoPropertyPlaybackRate];
        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:songInfo];
        
    }
}

@end
