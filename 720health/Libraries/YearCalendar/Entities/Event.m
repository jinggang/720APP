//
//  720health
//
//  Created by rock on 14-10-14.
//  Copyright (c) 2014年 jinggang. All rights reserved.
//


#import "Event.h"

@implementation Event

@dynamic eventCategory;
@dynamic eventDate;

+ (NSArray *)eventsFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate inContext:(NSManagedObjectContext *)context {
 
    NSEntityDescription *eventEntity = [NSEntityDescription entityForName:NSStringFromClass([Event class]) inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:eventEntity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"eventDate >= %@ AND eventDate <= %@", fromDate, toDate];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *events = [context executeFetchRequest:request error:&error];
    
    if (error) {
        NSLog(@"Error during %@ objects fetch: %@", [Event class], [error userInfo]);
    }
    return events;
}

@end
