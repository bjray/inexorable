//
//  DailyTrackerViewController.h
//  Inexorable
//
//  Created by B.J. Ray on 7/7/15.
//  Copyright (c) 2015 Sitting Circles, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IXDailyTrackerViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UISlider *ratingSlider;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;

-(IBAction)cancel:(id)sender;
-(IBAction)save:(id)sender;
- (IBAction)rateExercise:(id)sender;

@end
