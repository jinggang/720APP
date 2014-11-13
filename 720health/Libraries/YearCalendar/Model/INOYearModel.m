//
//  720health
//
//  Created by rock on 14-10-14.
//  Copyright (c) 2014年 jinggang. All rights reserved.
//


#import "INOYearModel.h"
#import "INOMonthImageFactory.h"
#import "INOOperationQueue.h"
#import "KYCalendarController.h"

#import "Event.h"

static NSUInteger const kMonthsInSingleYear = 12;

@interface INOYearModel ()

@property (nonatomic, strong) NSDate *currentDate;

@property (nonatomic, strong) INOOperationQueue *queue;

@end

@implementation INOYearModel

- (id)init {
    self = [super init];
    
    if (self) {
        
        _currentDate = [NSDate date];
    
        _queue = [[INOOperationQueue alloc] init];
        [_queue setMaxConcurrentOperationCount:1];
        
        [[INOMonthImageFactory sharedFactory] setColorsForEventCategories:@{@(0) : [UIColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:0.4f],
                                                                            @(1) : [UIColor colorWithRed:0.0f green:1.0f blue:0.0f alpha:0.4f],
                                                                            @(2) : [UIColor colorWithRed:0.0f green:0.0f blue:1.0f alpha:0.4f],
                                                                            @(3) : [UIColor colorWithRed:1.0f green:1.0f blue:0.0f alpha:0.4f]}];
        
    }
    
    return self;
}

#pragma mark - Public Methods

- (NSDate *)yearWithOffsetFromCurrentDate:(NSUInteger)offset {
    return [_currentDate dateByAddingValue:offset
                                forDateKey:@"year"];
}

- (void)makeMonthsImagesWithDate:(NSDate *)yearDate ofSize:(CGSize)size cancelTag:(NSUInteger)cancelTag completion:(Completion)completion {
    
//    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    KYCalendarController *calendar = [[KYCalendarController alloc]init];
    INOOperation *operation = [[INOOperation alloc] initWithMainManagedObjectContext:[calendar managedObjectContext]];
    
    BlockOperation block = ^id(NSManagedObjectContext *privateContext, CancelObservingBlock isCancelled) {
        
        NSDate *beginningOfYear = [yearDate beginningOfYear];
        NSDate *endOfYear = [yearDate endOfYear];
        
        NSArray *events = [Event eventsFromDate:beginningOfYear toDate:endOfYear inContext:privateContext];
        
        NSMutableDictionary *eventsForDates = [NSMutableDictionary dictionary];
        for (Event *event in events) {
            
            NSDate *searchKey = [event.eventDate beginningOfDay];
            
            NSMutableArray *eventsForDay = [eventsForDates objectForKey:searchKey];
            
            if (!eventsForDay) {
                eventsForDay = [NSMutableArray array];
            }
            
            [eventsForDay addObject:event];
            
            [eventsForDates setObject:eventsForDay forKey:searchKey];
            
            if (isCancelled()) {
                return nil;
            }
            
        }
        
        NSMutableArray *monthsImages = [NSMutableArray array];
        for (NSUInteger i = 0; i < kMonthsInSingleYear; i++) {
            NSDate *monthDate = [beginningOfYear dateByAddingValue:i forDateKey:@"month"];
            UIImage *monthImage = [[INOMonthImageFactory sharedFactory] monthImageWithDate:monthDate ofSize:size eventsForDates:eventsForDates];
            if (monthImage) {
                [monthsImages addObject:monthImage];
            }
        }
        
        return [NSArray arrayWithArray:monthsImages];
        
    };
    
    Success success = ^( NSArray *monthsImages) {
        if (completion) {
            completion(YES, monthsImages);
        }
    };
    
    Failure failure = ^() {
        if (completion) {
            completion(NO, nil);
        }
    };
    
    [operation setupOpeationWithBlock:block success:success failure:failure];
    [operation setTag:cancelTag];
    
    [_queue addOperation:operation];
    
}

- (void)suspendLoadingOperations {
    [_queue setSuspended:YES];
}

- (void)proceedLoadingOperations {
    [_queue setSuspended:NO];
}

@end
