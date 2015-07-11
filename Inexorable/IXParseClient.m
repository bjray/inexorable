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
//    [self cachePolicyForQuery:query];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSLog(@"we found quotes! %@", objects);
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
            NSLog(@"we found quotes! %@", objects);
            completion(objects);
        } else {
            NSLog(@"Error: %@ %@", [error localizedDescription], [error userInfo]);
            failure(error);
        }
    }];
    
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
