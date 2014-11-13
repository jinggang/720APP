//
//  720health
//
//  Created by rock on 14-10-14.
//  Copyright (c) 2014年 jinggang. All rights reserved.
//

#import "INOMonthGlyphsHelper.h"

NSUInteger const kSignleFigureGlyphsCount = 9;

static NSString *const kMonthDatesChars = @"12345678910111213141516171819202122232425262728293031";

@implementation INOMonthGlyphsHelper

+ (INOMonthGlyphsHelper *)glyphHelperWithFontName:(NSString *)fontName fontSize:(CGFloat)fontSize {

    INOMonthGlyphsHelper *glyphsHelper = [[INOMonthGlyphsHelper alloc] init];
    
    glyphsHelper.length = [kMonthDatesChars length];
    UniChar characters[glyphsHelper.length];
    CFStringGetCharacters((__bridge CFStringRef)kMonthDatesChars, CFRangeMake(0, glyphsHelper.length), characters);
    
    glyphsHelper.font = CTFontCreateWithName((__bridge CFStringRef)[UIFont systemFontOfSize:fontSize].fontName, fontSize, NULL);
    glyphsHelper.glyphs =  (CGGlyph *)malloc(sizeof(CGGlyph) * glyphsHelper.length);
    CTFontGetGlyphsForCharacters(glyphsHelper.font, characters, glyphsHelper.glyphs, glyphsHelper.length);
    glyphsHelper.glyphRects = (CGRect *)malloc(sizeof(CGRect) * glyphsHelper.length);
    glyphsHelper.glyphRect = CTFontGetBoundingRectsForGlyphs(glyphsHelper.font, kCTFontHorizontalOrientation, glyphsHelper.glyphs, glyphsHelper.glyphRects, glyphsHelper.length);
    
    glyphsHelper.glyphAdvances = (CGSize *)malloc(sizeof(CGSize) * glyphsHelper.length);
    glyphsHelper.glyphAdvance = CTFontGetAdvancesForGlyphs(glyphsHelper.font, kCTFontHorizontalOrientation, glyphsHelper.glyphs, glyphsHelper.glyphAdvances, glyphsHelper.length);

    return glyphsHelper;

}

@end
