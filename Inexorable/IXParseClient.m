//
//  ParseClient.m
//  Inexorable
//
//  Created by B.J. Ray on 7/8/15.
//  Copyright (c) 2015 Sitting Circles, LLC. All rights reserved.
//

#import "IXParseClient.h"


@implementation IXParseClient

+(instancetype)sharedManager {
    static id _sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    
    return _sharedManager;
}


- (id)init  {
    if (self = [super init]) {
        
    }
    
    return self;
}

#pragma mark - Read Methods -

- (void)fetchQuotesWithCompletion:(void (^)(id))completion
                          failure:(void (^)(id))failure {

    PFQuery *query = [PFQuery queryWithClassName:@"Quote"];
    [query whereKey:@"active" equalTo:@YES];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
//            NSLog(@"we found quotes! %@", objects);
            completion(objects);
        } else {
            NSLog(@"Error: %@ %@", [error localizedDescription], [error userInfo]);
            failure(error);
        }
    }];
    
}

- (void)fetchRatingWithCompletion:(void (^)(id))completion
                          failure:(void (^)(id))failure {

    PFQuery *query = [PFQuery queryWithClassName:@"Rating"];
    [query orderByAscending:@"value"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
//            NSLog(@"we found quotes! %@", objects);
            completion(objects);
        } else {
            NSLog(@"Error: %@ %@", [error localizedDescription], [error userInfo]);
            failure(error);
        }
    }];
    
}

- (void)fetchActivitiesWithCompletion:(void (^)(id))completion failure:(void (^)(id))failure {
    PFQuery *query = [PFQuery queryWithClassName:@"DailyActivityRating"];
    [query orderByAscending:@"date"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
//            NSLog(@"we found activities! %@", objects);
            completion(objects);
        } else {
            NSLog(@"Error: %@ %@", [error localizedDescription], [error userInfo]);
            failure(error);
        }
    }];
}

- (void)fetchActivityForDate:(NSDate *)date
                        user:(PFUser *)user
              withCompletion:(void (^)(id))completion
                     failure:(void (^)(id))failure {
    
    PFQuery *query = [PFQuery queryWithClassName:@"DailyActivityRating"];
    [query whereKey:@"user" equalTo:user];
    
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:( NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:date];
    [components setHour:-[components hour]];
    [components setMinute:-[components minute]];
    [components setSecond:-[components second]];
    
    
    NSDate *startOfDay = [cal dateByAddingComponents:components toDate:date options:0];
    
    [components setHour:23];
    [components setMinute:59];
    [components setSecond:59];
    
    NSDate *endOfDay = [cal dateByAddingComponents:components toDate:startOfDay options:0];
    NSLog(@"find between days: %@ to %@", startOfDay, endOfDay);
    
    [query whereKey:@"date" greaterThanOrEqualTo:startOfDay];
    [query whereKey:@"date" lessThan:endOfDay];
    
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSLog(@"we found an activity! %@", objects);
            completion(objects);
        } else {
            NSLog(@"Error: %@ %@", [error localizedDescription], [error userInfo]);
            failure(error);
        }
    }];
    
//    PFQuery *userQuery = [PFQuery queryWithClassName:@"DailyActivityRating"];
//    [userQuery whereKey:@"user" equalTo:user];
//    
//    
//    NSCalendar *cal = [NSCalendar currentCalendar];
//    NSDateComponents *components = [cal components:( NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:date];
//    [components setHour:-[components hour]];
//    [components setMinute:-[components minute]];
//    [components setSecond:-[components second]];
//    
//    
//    NSDate *startOfDay = [cal dateByAddingComponents:components toDate:date options:0];
//    
//    [components setHour:23];
//    [components setMinute:59];
//    [components setSecond:59];
//    
//    NSDate *endOfDay = [cal dateByAddingComponents:components toDate:startOfDay options:0];
//    NSLog(@"find between days: %@ to %@", startOfDay, endOfDay);
//    
//    PFQuery *startDateQuery = [PFQuery queryWithClassName:@"DailyActivityRating"];
//    [startDateQuery whereKey:@"date" greaterThanOrEqualTo:startOfDay];
//    
//    PFQuery *endDateQuery = [PFQuery queryWithClassName:@"DailyActivityRating"];
//    [endDateQuery whereKey:@"date" lessThan:endOfDay];
//    
//    PFQuery *query = [PFQuery orQueryWithSubqueries:@[userQuery,startDateQuery, endDateQuery]];
//    
//    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        if (!error) {
//            NSLog(@"we found an activity! %@", objects);
//            completion(objects);
//        } else {
//            NSLog(@"Error: %@ %@", [error localizedDescription], [error userInfo]);
//            failure(error);
//        }
//    }];

}

#pragma mark - Write Methods -

- (void)saveActivityWithDictionary:(NSDictionary *)dict completion:(void (^)())completion failure:(void (^)(id))failure {
    PFObject *dailyActivity = [PFObject objectWithClassName:@"DailyActivityRating" dictionary:dict];
    [dailyActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            NSLog(@"saved!!!");
            completion();
        } else {
            NSLog(@"error!");
            failure(error);
        }
    }];
}



#pragma mark - Helper Methods -

- (void)cachePolicyForQuery:(PFQuery *)aQuery {
    if ([aQuery hasCachedResult]) {
        aQuery.cachePolicy = kPFCachePolicyCacheThenNetwork;
        NSLog(@"pull from cache first");
    } else {
        aQuery.cachePolicy = kPFCachePolicyNetworkOnly;
        NSLog(@"no cache - pull from network");
    }
    
    aQuery.maxCacheAge = 60 * 60 * 24; //one day
}
@end
