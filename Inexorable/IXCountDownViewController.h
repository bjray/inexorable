//
//  IXCountDownViewController.h
//  Inexorable
//
//  Created by B.J. Ray on 7/6/15.
//  Copyright (c) 2015 Sitting Circles, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>

@interface IXCountDownViewController : UIViewController <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UIButton *goalBtn;
@property (weak, nonatomic) IBOutlet UIButton *historyBtn;
@property (weak, nonatomic) IBOutlet UILabel *daysLeftLabel;
@property (weak, nonatomic) IBOutlet UIButton *msgBtn;


- (IBAction)didTapHistoryBtn:(id)sender;
- (IBAction)didTapMsgBtn:(id)sender;
- (IBAction)didTapGoalBtn:(id)sender;
@end
