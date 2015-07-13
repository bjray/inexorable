//
//  DailyTrackerViewController.m
//  Inexorable
//
//  Created by B.J. Ray on 7/7/15.
//  Copyright (c) 2015 Sitting Circles, LLC. All rights reserved.
//

#import "IXDailyTrackerViewController.h"
#import "IXParseClient.h"
#import "MBProgressHUD.h"
#import "TSMessage.h"
#import <Parse/Parse.h>

@interface IXDailyTrackerViewController ()
@property (nonatomic, retain) NSArray *ratings;
@property (nonatomic) NSUInteger ratingIndex;
@property (nonatomic, retain) NSDate *displayDate;
@end

@implementation IXDailyTrackerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.displayDate = [NSDate date];
    self.currentDateBtn.title = [self formattedDateForDate:[NSDate date]];
//    self.nextDateBtn.enabled = NO;
    [self fetchRatingsData];
    [self fetchActivityDate];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - User Methods -

- (IBAction)rateExercise:(id)sender {
    [self updateUI];
}

-(IBAction)cancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)save:(id)sender {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Saving...";
    
    NSDictionary *dict = @{
                           @"rating" : [NSNumber numberWithUnsignedInteger: self.ratingIndex],
                           @"description" : [self getRatingByValue:self.ratingIndex],
                           @"date" : [NSDate date],
                           @"user": [PFUser currentUser]
                           };
    
    IXParseClient *client = [IXParseClient sharedManager];
    [client saveActivityWithDictionary:dict completion:^{
        [hud hide:YES];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *err) {
        [hud hide:YES];
        [self displayError:err optionalMsg:@"Ah shit..."];
    }];
}

- (IBAction)activityForPreviousDate:(id)sender {
    self.displayDate = [self.displayDate dateByAddingTimeInterval:-24*60*60];
    [self checkDateRange];
    [self updateUI];
}

- (IBAction)activityForNextDate:(id)sender {
    NSDate *nextDate = [self.displayDate dateByAddingTimeInterval:24*60*60];
    NSComparisonResult result = [nextDate compare:[NSDate date]];
    if (result == NSOrderedAscending) {
        self.displayDate = nextDate;
        [self checkDateRange];
    } else {
        NSLog(@"this ain't a delorian!");
    }
    [self updateUI];
}

- (IBAction)activityForToday:(id)sender {
    self.displayDate = [NSDate date];
    [self updateUI];
}

- (IBAction)switchChanged:(UISwitch *)sender {
    BOOL setting = sender.isOn;
    if (setting) {
        self.questionLabel.hidden = NO;
        self.ratingSlider.hidden = NO;
        self.ratingLabel.hidden = NO;
    } else {
        self.questionLabel.hidden = YES;
        self.ratingSlider.hidden = YES;
        self.ratingLabel.hidden = YES;
    }
    
    
}


#pragma mark - Helper Methods -
- (void)fetchRatingsData {
    self.ratings = [NSArray array];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Loading...";
    
    IXParseClient *client = [IXParseClient sharedManager];
    [client fetchRatingWithCompletion:^(NSArray *objects) {
        self.ratings = objects;
        [self updateUI];
        [hud hide:YES];
    } failure:^(NSError *err) {
        NSLog(@"error received");
        [self displayError:err optionalMsg:nil];
        [hud hide:YES];
    }];
}

- (void)fetchActivityDate {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Loading...";
    
    IXParseClient *client = [IXParseClient sharedManager];
    [client fetchActivityForDate:self.displayDate user:[PFUser currentUser] withCompletion:^(NSArray *objects) {
        if ((objects != nil) && (objects.count == 1)) {
            PFObject *activity = objects[0];
            self.ratingSlider.value = [activity[@"rating"] floatValue];
            [self updateUI];
        }
        
        [hud hide:YES];
    } failure:^(NSError *err) {
        NSLog(@"error received");
        [self displayError:err optionalMsg:nil];
        [hud hide:YES];
    }];
}

- (void)fetchAll {
    
}



- (void)displayError:(NSError *)error optionalMsg:(NSString *)optionalMsg{
    NSString *msg = [NSString stringWithFormat:@"%@ %@", [error localizedDescription], optionalMsg];
    
    [TSMessage showNotificationWithTitle:@"Error" subtitle:msg type:TSMessageNotificationTypeError];
}

- (NSString *)getRatingByValue:(NSInteger)value {
    NSString *rating = @"";
    
    if (self.ratings.count >= value-1) {
        rating = [self.ratings[value-1] objectForKey:@"description"];
    }
    
    return rating;
}

- (void)updateUI {
    self.ratingIndex = (NSUInteger)(self.ratingSlider.value + 0.5);
    [self.ratingSlider setValue:self.ratingIndex animated:NO];
    self.ratingLabel.text = [self getRatingByValue:self.ratingIndex];
    self.currentDateBtn.title = [self formattedDateForDate:self.displayDate];
//    if ([self.displayDate compare:[NSDate date]] == NSOrderedSame) {
//        self.nextDateBtn.enabled = NO;
//    } else {
//        self.nextDateBtn.enabled = YES;
//    }
}


- (NSString *)formattedDateForDate:(NSDate *)date {
    static NSDateFormatter *formatter;
    if (formatter == nil) {
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"MM/dd/yyyy";
    }
    
    return [formatter stringFromDate: date];
}

-(void)checkDateRange {
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:( NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:self.displayDate];
    [components setHour:-[components hour]];
    [components setMinute:-[components minute]];
    [components setSecond:-[components second]];
    
    
    NSDate *startOfDay = [cal dateByAddingComponents:components toDate:self.displayDate options:0];
    
    [components setHour:23];
    [components setMinute:59];
    [components setSecond:59];
    
    NSDate *endOfDay = [cal dateByAddingComponents:components toDate:startOfDay options:0];
    NSLog(@"find between days: %@ to %@", startOfDay, endOfDay);
}

@end
