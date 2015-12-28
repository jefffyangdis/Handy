//
//  CoreTextArcView.m
//  handy
//
//  Created by 方阳 on 15/12/17.
//  Copyright © 2015年 dw_fangyang. All rights reserved.
//

#import "CoreTextArcView.h"
#import <CoreText/CoreText.h>

#define ARCVIEW_DEFAULT_FONT_NAME   @"Didot"
#define ARCVIEW_DEFAULT_FONT_SIZE   64.0
#define ARCVIEW_DEFAULT_RADIUS      120.0

typedef struct GlyphArcInfo {
    CGFloat         width;
    CGFloat         angle;  // in radians
} GlyphArcInfo;

static void PrepareGlyphArcInfo(CTLineRef line, CFIndex glyphCount, GlyphArcInfo *glyphArcInfo)
{
    NSArray *runArray = (__bridge NSArray *)CTLineGetGlyphRuns(line);
    
    // Examine each run in the line, updating glyphOffset to track how far along the run is in terms of glyphCount.
    CFIndex glyphOffset = 0;
    for (id run in runArray) {
        CFIndex runGlyphCount = CTRunGetGlyphCount((__bridge CTRunRef)run);
        
        // Ask for the width of each glyph in turn.
        CFIndex runGlyphIndex = 0;
        for (; runGlyphIndex < runGlyphCount; runGlyphIndex++) {
            glyphArcInfo[runGlyphIndex + glyphOffset].width = CTRunGetTypographicBounds((__bridge CTRunRef)run, CFRangeMake(runGlyphIndex, 1), NULL, NULL, NULL);
        }
        
        glyphOffset += runGlyphCount;
    }
    
    double lineLength = CTLineGetTypographicBounds(line, NULL, NULL, NULL);
    
    CGFloat prevHalfWidth = glyphArcInfo[0].width / 2.0;
    glyphArcInfo[0].angle = (prevHalfWidth / lineLength) * M_PI;
    
    // Divide the arc into slices such that each one covers the distance from one glyph's center to the next.
    CFIndex lineGlyphIndex = 1;
    for (; lineGlyphIndex < glyphCount; lineGlyphIndex++) {
        CGFloat halfWidth = glyphArcInfo[lineGlyphIndex].width / 2.0;
        CGFloat prevCenterToCenter = prevHalfWidth + halfWidth;
        
        glyphArcInfo[lineGlyphIndex].angle = (prevCenterToCenter / lineLength) * M_PI;
        
        prevHalfWidth = halfWidth;
    }
}

@implementation CoreTextArcView
- (void)awakeFromNib
{
    [super awakeFromNib];
    _font = [UIFont fontWithName:ARCVIEW_DEFAULT_FONT_NAME size:ARCVIEW_DEFAULT_FONT_SIZE];
    _string = @"Merry Chrismas";
    _radius = ARCVIEW_DEFAULT_RADIUS;
    _showsGlyphBounds = NO;
    _showsLineMetrics = NO;
    _dimsSubstitutedGlyphs = NO;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _font = [UIFont fontWithName:ARCVIEW_DEFAULT_FONT_NAME size:ARCVIEW_DEFAULT_FONT_SIZE];
        _string = @"Merry Chrismas";
        _radius = ARCVIEW_DEFAULT_RADIUS;
        _showsGlyphBounds = NO;
        _showsLineMetrics = NO;
        _dimsSubstitutedGlyphs = NO;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    // Don't draw if we don't have a font or string
    if (self.font == NULL || self.string == NULL)
        return;
    
    // Initialize the text matrix to a known value

    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Draw a white background
    [[UIColor whiteColor] set];
    UIRectFill(rect);
    
    CTLineRef line = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)self.attributedString);
    assert(line != NULL);
    
    CFIndex glyphCount = CTLineGetGlyphCount(line);
    if (glyphCount == 0) {
        CFRelease(line);
        return;
    }
    
//    CGContextSetTextPosition(context, 0, self.radius/2);
//    CTRunRef frun = (CTRunRef)CFArrayGetValueAtIndex(CTLineGetGlyphRuns(line), 0);
//    CTRunDraw(frun, context, CFRangeMake(0, 2));
    
    GlyphArcInfo *  glyphArcInfo = (GlyphArcInfo*)calloc(glyphCount, sizeof(GlyphArcInfo));
    PrepareGlyphArcInfo(line, glyphCount, glyphArcInfo);
    
    CTRunRef frun = (CTRunRef)CFArrayGetValueAtIndex(CTLineGetGlyphRuns(line), 0);
    CGPoint p = CGContextGetTextPosition(context);
    
    CTRunDraw(frun, context, CFRangeMake(0, 2));
    
    // Move the origin from the lower left of the view nearer to its center.
    CGContextSaveGState(context);
    
    CGContextTranslateCTM(context, CGRectGetMidX(rect), CGRectGetMidY(rect) );
//    CGContextSetTextMatrix(context, CGAffineTransformMake(1, 0, -1, -1, CGRectGetMidX(rect), CGRectGetMidY(rect)));
    
    
    // Stroke the arc in red for verification.
    CGContextBeginPath(context);
    CGContextAddArc(context, 0.0, 0.0, self.radius, 0, M_PI*2, 0);
    CGContextSetRGBStrokeColor(context, 1.0, 0.0, 0.0, 1.0);
    CGContextStrokePath(context);
    CTRunDraw(frun, context, CFRangeMake(0, 2));
    // Rotate the context 90 degrees clockwise.
//    CGContextRotateCTM(context, M_PI_2);
    
    /*
     Now for the actual drawing. The angle offset for each glyph relative to the previous glyph has already been calculated; with that information in hand, draw those glyphs overstruck and centered over one another, making sure to rotate the context after each glyph so the glyphs are spread along a semicircular path.
     */
    CGPoint textPosition = CGPointMake(0.0, self.radius);
//    CGContextSetTextPosition(context, 0,  0);
//        CTRunRef frun = (CTRunRef)CFArrayGetValueAtIndex(CTLineGetGlyphRuns(line), 0);
//        CTRunDraw(frun, context, CFRangeMake(2, 2));
    
    CFArrayRef runArray = CTLineGetGlyphRuns(line);
    CFIndex runCount = CFArrayGetCount(runArray);
    
    CFIndex glyphOffset = 0;
    CFIndex runIndex = 0;
    for (; runIndex < runCount; runIndex++) {
        CTRunRef run = (CTRunRef)CFArrayGetValueAtIndex(runArray, runIndex);
        CFIndex runGlyphCount = CTRunGetGlyphCount(run);
        Boolean drawSubstitutedGlyphsManually = false;
        CTFontRef runFont = CFDictionaryGetValue(CTRunGetAttributes(run), kCTFontAttributeName);
        
        /*
         Determine if we need to draw substituted glyphs manually. Do so if the runFont is not the same as the overall font.
         */
        if (self.dimsSubstitutedGlyphs && ![self.font isEqual:(__bridge UIFont *)runFont]) {
            drawSubstitutedGlyphsManually = true;
        }
        
        CFIndex runGlyphIndex = 0;
        for (; runGlyphIndex < runGlyphCount; runGlyphIndex++) {
            CFRange glyphRange = CFRangeMake(runGlyphIndex, 1);
            CGContextRotateCTM(context, -(glyphArcInfo[runGlyphIndex + glyphOffset].angle));
            
            // Center this glyph by moving left by half its width.
            CGFloat glyphWidth = glyphArcInfo[runGlyphIndex + glyphOffset].width;
            CGFloat halfGlyphWidth = glyphWidth / 2.0;
            CGPoint positionForThisGlyph = CGPointMake(textPosition.x - halfGlyphWidth, textPosition.y );
//            CGPoint positionForThisGlyph = CGPointMake(textPosition.x, textPosition.y);
            // Glyphs are positioned relative to the text position for the line, so offset text position leftwards by this glyph's width in preparation for the next glyph.
            textPosition.x -= glyphWidth;
            
            p = CGContextGetTextPosition(context);
            CGAffineTransform textMatrix = CTRunGetTextMatrix(run);
            textMatrix.tx = positionForThisGlyph.x;
            textMatrix.ty = positionForThisGlyph.y;
            textMatrix.d = -textMatrix.d;
            CGContextSetTextMatrix(context, textMatrix);
            
            if (!drawSubstitutedGlyphsManually) {
                CTRunDraw(run, context, glyphRange);
            }
            else {
                /*
                 We need to draw the glyphs manually in this case because we are effectively applying a graphics operation by setting the context fill color. Normally we would use kCTForegroundColorAttributeName, but this does not apply as we don't know the ranges for the colors in advance, and we wanted demonstrate how to manually draw.
                 */
                CGFontRef cgFont = CTFontCopyGraphicsFont(runFont, NULL);
                CGGlyph glyph;
                CGPoint position;
                
                CTRunGetGlyphs(run, glyphRange, &glyph);
                CTRunGetPositions(run, glyphRange, &position);
                
                CGContextSetFont(context, cgFont);
                CGContextSetFontSize(context, CTFontGetSize(runFont));
                CGContextSetRGBFillColor(context, 0.25, 0.25, 0.25, 0.5);
                CGContextShowGlyphsAtPositions(context, &glyph, &position, 1);
                
                CFRelease(cgFont);
            }
            
            // Draw the glyph bounds
            if ((self.showsGlyphBounds) != 0) {
                CGRect glyphBounds = CTRunGetImageBounds(run, context, glyphRange);
                
                CGContextSetRGBStrokeColor(context, 0.0, 0.0, 1.0, 1.0);
                CGContextStrokeRect(context, glyphBounds);
            }
            // Draw the bounding boxes defined by the line metrics
            if ((self.showsLineMetrics) != 0) {
                CGRect lineMetrics;
                CGFloat ascent, descent;
                
                CTRunGetTypographicBounds(run, glyphRange, &ascent, &descent, NULL);
                
                // The glyph is centered around the y-axis
                lineMetrics.origin.x = -halfGlyphWidth;
                lineMetrics.origin.y = positionForThisGlyph.y - descent;
                lineMetrics.size.width = glyphWidth;
                lineMetrics.size.height = ascent + descent;
                
                CGContextSetRGBStrokeColor(context, 0.0, 1.0, 0.0, 1.0);
                CGContextStrokeRect(context, lineMetrics);
            }
        }
        
        glyphOffset += runGlyphCount;
    }
    
    CGContextRestoreGState(context);
    
    free(glyphArcInfo);
    CFRelease(line);
}

- (NSAttributedString *)attributedString {
    // Create an attributed string with the current font and string.
    assert(self.font != nil);
    assert(self.string != nil);
    
    // Create our attributes.
    NSDictionary *attributes = @{NSFontAttributeName: self.font, NSLigatureAttributeName: @0};
    assert(attributes != nil);
    
    // Create the attributed string.
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:self.string attributes:attributes];
    return attrString;
}

@end
