//
//  720health
//
//  Created by rock on 14-10-14.
//  Copyright (c) 2014年 jinggang. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "INOOperation.h"

@interface INOOperationQueue : NSOperationQueue

@property (nonatomic, assign) BOOL needsCancelOperationsWithEqualTag;

- (void)addOperation:(INOOperation *)op;
- (void)cancelOperationsWithTag:(NSInteger)tag;

@end
