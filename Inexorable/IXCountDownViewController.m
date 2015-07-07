//
//  IXCountDownViewController.m
//  Inexorable
//
//  Created by B.J. Ray on 7/6/15.
//  Copyright (c) 2015 Sitting Circles, LLC. All rights reserved.
//

#import "IXCountDownViewController.h"


@interface IXCountDownViewController ()

@end

@implementation IXCountDownViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIImage *anImage = [self selectRandomImage];
    self.backgroundImage.image = anImage;
    NSLog(@"hello");
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    PFLogInViewController *login = [[PFLogInViewController alloc] init];
    login.fields = (PFLogInFieldsUsernameAndPassword
                              | PFLogInFieldsLogInButton
                              | PFLogInFieldsSignUpButton
                              | PFLogInFieldsPasswordForgotten
                              | PFLogInFieldsDismissButton
                              | PFLogInFieldsFacebook
                              | PFLogInFieldsTwitter);
    login.delegate = self;
    login.facebookPermissions = @[@"friends_about_me"];
    UIImageView *logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    login.logInView.logo = logoView;
    login.logInView.logo.contentMode = UIViewContentModeScaleAspectFit;
    
    [self presentViewController:login animated:YES completion:^{
        NSLog(@"done presenting...");
    }];
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (UIImage *)selectRandomImage {
    int r = arc4random_uniform(5);
    NSString *name = [NSString stringWithFormat:@"mtn%d", r];
    NSLog(@"returning image: %@", name);
    return [UIImage imageNamed:name];
}

@end
