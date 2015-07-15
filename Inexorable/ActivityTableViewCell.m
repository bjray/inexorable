//
//  ActivityTableViewCell.m
//  Inexorable
//
//  Created by B.J. Ray on 7/15/15.
//  Copyright (c) 2015 Sitting Circles, LLC. All rights reserved.
//

#import "ActivityTableViewCell.h"

@interface ActivityTableViewCell ()
@property (nonatomic, copy) NSString *name;
@property (nonatomic, retain) NSString *activityDesc;
@end

@implementation ActivityTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Custom Properties -
- (void)setActivity:(PFObject *)activity {
    
}

@end
