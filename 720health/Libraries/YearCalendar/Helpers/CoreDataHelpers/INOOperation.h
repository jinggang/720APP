//
//  720health
//
//  Created by rock on 14-10-14.
//  Copyright (c) 2014年 jinggang. All rights reserved.
//


#import <Foundation/Foundation.h>

typedef BOOL(^CancelObservingBlock)();
typedef id(^BlockOperation)(NSManagedObjectContext *privateContext, CancelObservingBlock isCancelled);

typedef void(^Success)(id data);
typedef void(^Failure)();

@interface INOOperation : NSOperation

@property (nonatomic, readonly)	NSManagedObjectContext *mainContext;
@property (nonatomic, readonly) NSManagedObjectContext *privateContext;
@property (nonatomic, assign)	BOOL				    needsMergeChanges;
@property (nonatomic, assign)   BOOL                    needsSaveAfterExecution;

@property (nonatomic, readonly) id data;

@property (nonatomic, strong) BlockOperation block;
@property (nonatomic, strong) Success        success;
@property (nonatomic, strong) Failure        failure;

@property (nonatomic, assign) NSInteger tag; // is used to cancel operation together with INOOperationQueue

- (id)initWithMainManagedObjectContext:(NSManagedObjectContext *)mainManagedObjectContext;

- (void)setupOpeationWithBlock:(BlockOperation)block success:(Success)success failure:(Failure)failure;

@end
