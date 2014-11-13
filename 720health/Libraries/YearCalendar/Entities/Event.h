//
//  720health
//
//  Created by rock on 14-10-14.
//  Copyright (c) 2014年 jinggang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Event : NSManagedObject

@property (nonatomic, strong) NSNumber *eventCategory;
@property (nonatomic, strong) NSDate   *eventDate;

+ (NSArray *)eventsFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate inContext:(NSManagedObjectContext *)context;

@end
