//
//  IXCountDownViewController.h
//  Inexorable
//
//  Created by B.J. Ray on 7/6/15.
//  Copyright (c) 2015 Sitting Circles, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ParseUI/ParseUI.h>

@interface IXCountDownViewController : UIViewController <PFLogInViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UILabel *topTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *countDownLabel;
@property (weak, nonatomic) IBOutlet UILabel *daysLeftLabel;
@property (weak, nonatomic) IBOutlet UILabel *prepareMsgLabel;

@end
