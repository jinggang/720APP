//
//  720health
//
//  Created by rock on 14-10-14.
//  Copyright (c) 2014年 jinggang. All rights reserved.
//


#import "INOMonthView.h"
#import "INOMonthGlyphsHelper.h"
#import "INOMonthImageFactory.h"

@interface INOMonthView ()

// Data
//@property (nonatomic, strong) NSDate *monthDate;

// View
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation INOMonthView

- (id)init {
    
    self = [super init];
    
    if (self) {
        
        _imageView = [[UIImageView alloc] init];
        [self addSubview:_imageView];
        
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_imageView setFrame:self.bounds];
    
}

#pragma mark - Public Methods

- (void)setupWithMonthDate:(NSDate *)monthDate {
    _monthDate = monthDate;
    [_imageView setImage:[[INOMonthImageFactory sharedFactory] monthImageWithDate:_monthDate ofSize:self.bounds.size]];
}

- (void)setupWithMonthImage:(UIImage *)monthImage {
    [_imageView setImage:monthImage];
}

@end
