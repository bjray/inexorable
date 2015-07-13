//
//  ParseClient.h
//  Inexorable
//
//  Created by B.J. Ray on 7/8/15.
//  Copyright (c) 2015 Sitting Circles, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface IXParseClient : NSObject

+(instancetype)sharedManager;
- (void)fetchQuotesWithCompletion:(void (^)(id))completion failure:(void (^)(id))failure;
- (void)fetchRatingWithCompletion:(void (^)(id))completion failure:(void (^)(id))failure;
- (void)fetchActivitiesWithCompletion:(void (^)(id))completion failure:(void (^)(id))failure;
- (void)fetchActivityForDate:(NSDate *)date
                        user:(PFUser *)user
              withCompletion:(void (^)(id))completion
                     failure:(void (^)(id))failure;

- (void)saveActivityWithDictionary:(NSDictionary *)dict completion:(void (^)())completion failure:(void (^)(id))failure;
//- (void)saveActivityWithRating:(NSInteger)index
//                   description:(NSString *)desc
//                          date:(NSDate *)date
//                          user:(PFUser *)user
//                withCompletion:(void (^)(id))completion
//                       failure:(void (^)(id))failure;
@end
