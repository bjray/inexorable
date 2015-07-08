//
//  DailyTrackerViewController.m
//  Inexorable
//
//  Created by B.J. Ray on 7/7/15.
//  Copyright (c) 2015 Sitting Circles, LLC. All rights reserved.
//

#import "IXDailyTrackerViewController.h"

@interface IXDailyTrackerViewController ()

@end

@implementation IXDailyTrackerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    NSUInteger index = (NSUInteger)(self.ratingSlider.value + 0.5);
    [self.ratingSlider setValue:index animated:NO];
    
    self.ratingLabel.text = [NSString stringWithFormat:@"%ld", index];
}

-(IBAction)cancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)save:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
