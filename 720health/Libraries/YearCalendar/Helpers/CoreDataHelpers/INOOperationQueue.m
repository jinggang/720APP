//
//  720health
//
//  Created by rock on 14-10-14.
//  Copyright (c) 2014年 jinggang. All rights reserved.
//

#import "INOOperationQueue.h"

@implementation INOOperationQueue

- (id)init {
    self = [super init];
    
    if (self) {
        _needsCancelOperationsWithEqualTag = YES;
    }
    
    return self;
}

- (void)addOperation:(INOOperation *)op {
    if (_needsCancelOperationsWithEqualTag) {
        [self cancelOperationsWithTag:[op tag]];
    }
    [super addOperation:op];
}

- (void)cancelOperationsWithTag:(NSInteger)tag {
    NSArray *filteredArray = [self.operations filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"tag == %d", tag]];
    [filteredArray makeObjectsPerformSelector:@selector(cancel)];
}

@end
