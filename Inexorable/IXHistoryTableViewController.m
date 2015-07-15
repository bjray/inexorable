//
//  IXHistoryTableViewController.m
//  Inexorable
//
//  Created by B.J. Ray on 7/8/15.
//  Copyright (c) 2015 Sitting Circles, LLC. All rights reserved.
//

#import "IXHistoryTableViewController.h"
#import "IXParseClient.h"
#import "MBProgressHUD.h"
#import "TSMessage.h"
#import <Parse/Parse.h>

@interface IXHistoryTableViewController ()
@property (nonatomic, retain)NSArray *activities;
@end

@implementation IXHistoryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchData];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.title = @"Whatcha done";
    self.activities = [NSArray array];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.activities.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    PFObject *activity = [self.activities objectAtIndex:indexPath.row];
    NSString *desc = activity[@"description"];
    PFUser *aUser = activity[@"user"];
    NSLog(@"name: %@", aUser.username);
//    [aUser fetchIfNeededInBackgroundWithBlock:^(PFObject *aUser, NSError *error) {
////        NSString *name = aUser.
//    }];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", aUser.username, desc];
    if ([aUser.username isEqualToString:@"bray"]) {
        cell.imageView.image = [UIImage imageNamed:@"b"];
    } else {
        cell.imageView.image = [UIImage imageNamed:@"j"];
    }
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Helper Methods -
- (void)fetchData {
    self.activities = [NSArray array];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Loading...";
    
    IXParseClient *client = [IXParseClient sharedManager];
    [client fetchActivitiesWithCompletion:^(NSArray *objects) {
        self.activities = objects;
        [self.tableView reloadData];
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

@end
