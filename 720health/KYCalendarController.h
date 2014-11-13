//
// KYCalendarController.h
//  KYCalendarView
//
//  Created by rock on 14-10-14.
//  Copyright (c) 2014年 jinggang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreText/CoreText.h>
@interface KYCalendarController : UIViewController

@property(nonatomic,retain) NSDate  *selectedDate;

// CoreData Helpers
@property (nonatomic, readonly) NSManagedObjectContext       *managedObjectContext;
@property (nonatomic, readonly) NSManagedObjectModel         *managedObjectModel;
@property (nonatomic, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@end
