//
//  ParseClient.h
//  Inexorable
//
//  Created by B.J. Ray on 7/8/15.
//  Copyright (c) 2015 Sitting Circles, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IXParseClient : NSObject

+(instancetype)sharedManager;
- (void)fetchQuotesWithCompletion:(void (^)(id))completion failure:(void (^)(id))failure;

@end