//
//  IXCountDownViewController.m
//  Inexorable
//
//  Created by B.J. Ray on 7/6/15.
//  Copyright (c) 2015 Sitting Circles, LLC. All rights reserved.
//

#import "IXCountDownViewController.h"
#import "UIImage+ImageEffects.h"

@interface IXCountDownViewController ()

@end

@implementation IXCountDownViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.backgroundImage.image = [self selectRandomImage];
    NSLog(@"hello");
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSString *title = [NSString stringWithFormat:@"%ld", [self daysLeft]];
    [self.historyBtn setTitle:title forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (![PFUser currentUser]) {
        PFLogInViewController *loginController = [[PFLogInViewController alloc] init];
        loginController.delegate = self;
        
        
        PFSignUpViewController *signUpViewController = [[PFSignUpViewController alloc] init];
        signUpViewController.delegate = self;
        
        
        [loginController setSignUpController:signUpViewController];
        [self presentViewController:loginController animated:YES completion:nil];
    }
}

#pragma mark - User Events - 
- (IBAction)didTapHistoryBtn:(id)sender {
    NSLog(@"show history");
}

- (IBAction)didTapMsgBtn:(id)sender {
    NSLog(@"show messages");
}

- (IBAction)didTapGoalBtn:(id)sender {
    NSLog(@"show quotes");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Helper Methods -

- (UIImage *)selectRandomImage {
    int r = arc4random_uniform(5);
    NSString *name = [NSString stringWithFormat:@"mtn%d", r];
    NSLog(@"returning image: %@", name);
    UIImage *anImage = [UIImage imageNamed:name];
    UIColor *tintColor = [UIColor colorWithWhite:0.27 alpha:0.52];
    anImage = [anImage applyBlurWithRadius:5.0 tintColor:tintColor saturationDeltaFactor:1.0 maskImage:nil];
    
    return anImage;
}

- (void)configureLoginController:(PFLogInViewController *)login {
    login.fields = (PFLogInFieldsUsernameAndPassword
                    | PFLogInFieldsLogInButton
                    | PFLogInFieldsSignUpButton
                    | PFLogInFieldsPasswordForgotten
                    | PFLogInFieldsDismissButton
                    | PFLogInFieldsFacebook
                    | PFLogInFieldsTwitter);
    login.facebookPermissions = @[@"friends_about_me"];
    UIImageView *logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    login.logInView.logo = logoView;
    login.logInView.logo.contentMode = UIViewContentModeScaleAspectFit;
    login.logInView.backgroundColor = [UIColor colorWithRed:200.0 green:200.0 blue:200.0 alpha:1.0];
}

- (NSInteger)daysLeft {
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *startDate = [NSDate date];
    NSDate *endDate = [f dateFromString:@"2015-07-31"];
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay
                                                        fromDate:startDate
                                                          toDate:endDate
                                                         options:NSCalendarWrapComponents];
    return components.day;
}


#pragma mark - PFLogIn View Controller Delegate Methods -

- (void)logInViewController:(PFLogInViewController *)controller didLogInUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

// Sent to the delegate when the log in attempt fails.
- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
    NSLog(@"Failed to log in...");
}

// Sent to the delegate to determine whether the log in request should be submitted to the server.
- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username
                   password:(NSString *)password {
    
    // Check if both fields are completed
    if (username && password && username.length != 0 && password.length != 0) {
        return YES; // Begin login process
    }
    
    [[[UIAlertView alloc] initWithTitle:@"Missing Information"
                                message:@"Make sure you fill out all of the information!"
                               delegate:nil
                      cancelButtonTitle:@"ok"
                      otherButtonTitles:nil] show];
    return NO; // Interrupt login process
}


#pragma mark - PFSignUp View Controller Delegate Methods -
// Sent to the delegate to determine whether the sign up request should be submitted to the server.
- (BOOL)signUpViewController:(PFSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info {
    BOOL informationComplete = YES;
    
    // loop through all of the submitted data
    for (id key in info) {
        NSString *field = [info objectForKey:key];
        if (!field || field.length == 0) { // check completion
            informationComplete = NO;
            break;
        }
    }
    
    // Display an alert if a field wasn't completed
    if (!informationComplete) {
        [[[UIAlertView alloc] initWithTitle:@"Missing Information"
                                    message:@"Make sure you fill out all of the information!"
                                   delegate:nil
                          cancelButtonTitle:@"ok"
                          otherButtonTitles:nil] show];
    }
    
    return informationComplete;
}

// Sent to the delegate when a PFUser is signed up.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:nil]; // Dismiss the PFSignUpViewController
}

// Sent to the delegate when the sign up attempt fails.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error {
    NSLog(@"Failed to sign up...");
}

// Sent to the delegate when the sign up screen is dismissed.
- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {
    NSLog(@"User dismissed the signUpViewController");
}

@end
