//
//  ActivityTableViewCell.h
//  Inexorable
//
//  Created by B.J. Ray on 7/15/15.
//  Copyright (c) 2015 Sitting Circles, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ActivityTableViewCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UIImageView *icon;
@property (nonatomic, weak) IBOutlet UILabel *title;

@property (nonatomic, weak) PFObject *activity;
@end
