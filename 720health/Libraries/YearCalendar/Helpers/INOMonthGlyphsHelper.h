//
//  720health
//
//  Created by rock on 14-10-14.
//  Copyright (c) 2014年 jinggang. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSUInteger const kSignleFigureGlyphsCount;

@interface INOMonthGlyphsHelper : NSObject

@property (nonatomic, assign) CTFontRef  font;

@property (nonatomic, assign) CGGlyph   *glyphs;
@property (nonatomic, assign) CGRect    *glyphRects;
@property (nonatomic, assign) CGSize    *glyphAdvances;
@property (nonatomic, assign) CGFloat    glyphAdvance;

@property (nonatomic, assign) NSInteger  length;
@property (nonatomic, assign) CGRect     glyphRect;

+ (INOMonthGlyphsHelper *)glyphHelperWithFontName:(NSString *)fontName fontSize:(CGFloat)fontSize;

@end
