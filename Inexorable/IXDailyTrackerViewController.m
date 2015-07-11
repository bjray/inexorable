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
@end

@implementation IXDailyTrackerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self fetchData];
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

#pragma mark - Helper Methods -
- (void)fetchData {
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
}


- (NSString *)formattedDate {
    static NSDateFormatter *formatter;
    if (formatter == nil) {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
    }
    
    return [formatter stringFromDate:[NSDate date]];
}

@end
