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
@property (weak, nonatomic) IBOutlet UILabel *workoutLabel;
@property (weak, nonatomic) IBOutlet UISwitch *didWorkout;
@property (strong, nonatomic) NSString *objectId;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *previousDateBtn;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextDateBtn;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *currentDateBtn;

-(IBAction)cancel:(id)sender;
-(IBAction)save:(id)sender;
- (IBAction)rateExercise:(id)sender;
- (IBAction)activityForPreviousDate:(id)sender;
- (IBAction)activityForNextDate:(id)sender;
- (IBAction)activityForToday:(id)sender;

- (IBAction)switchChanged:(UISwitch *)sender;
@end
