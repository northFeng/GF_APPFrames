//
//  GFAudioPlayerViewController.h
//  GFAPP
//
//  Created by XinKun on 2017/12/8.
//  Copyright © 2017年 North_feng. All rights reserved.
//

#import "APPBaseViewController.h"

@interface GFAudioPlayerViewController : APPBaseViewController

@property (weak, nonatomic) IBOutlet UILabel *labelCurrent;

@property (weak, nonatomic) IBOutlet UISlider *silder;

@property (weak, nonatomic) IBOutlet UILabel *labelTotal;

@property (weak, nonatomic) IBOutlet UIButton *btnPrevious;

@property (weak, nonatomic) IBOutlet UIButton *btnPlay;

@property (weak, nonatomic) IBOutlet UIButton *btnNext;


@end
