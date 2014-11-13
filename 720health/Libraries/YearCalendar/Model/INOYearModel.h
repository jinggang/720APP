//
//  720health
//
//  Created by rock on 14-10-14.
//  Copyright (c) 2014年 jinggang. All rights reserved.
//


#import <Foundation/Foundation.h>

typedef void(^Completion)(BOOL success, id data);

@interface INOYearModel : NSObject

- (NSDate *)yearWithOffsetFromCurrentDate:(NSUInteger)offset;

- (void)makeMonthsImagesWithDate:(NSDate *)yearDate ofSize:(CGSize)size cancelTag:(NSUInteger)cancelTag completion:(Completion)completion;

- (void)suspendLoadingOperations;
- (void)proceedLoadingOperations;

@end
