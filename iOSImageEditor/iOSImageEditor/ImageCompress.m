//
//  ImageCompress.m
//  ImageCompress
//
//  Created by Lalit Kant on 2/15/17.
//  Copyright © 2017 Lalit Kant. All rights reserved.
//

#import "ImageCompress.h"

@implementation ImageCompress


#pragma mark - Create Image With text

-(NSString*)createImageWithTextReturnPath:(NSString *)textStr imageWidth : (CGFloat)width diskFolder : (NSString*)diskFolder backgroundColor:(UIColor*)bgColor textColor:(UIColor*)textColor font:(UIFont*)font
{
    textStr =[NSString stringWithFormat:@"%@",textStr];
    
    UIImage *image = [self imageFromString:textStr width :width backgroundColor:bgColor textColor:textColor font:(UIFont*)font];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@", diskFolder]];
    NSError *errorCreateDir = nil;
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:YES attributes:nil error:&errorCreateDir];
        
        if(errorCreateDir != nil)
        {
            NSLog(@"Error creating panorama folder");
        }
    }
   
    textStr = [textStr stringByReplacingOccurrencesOfString:@"/" withString:@"_Slash_"];
    NSString *saveTo = [NSString stringWithFormat:@"%@/%@.png", dataPath,textStr];
    NSError *errorSaveFile = nil;
    NSData *imgData0 = UIImagePNGRepresentation(image);
    
    [imgData0 writeToFile:saveTo options:NSDataWritingAtomic error:&errorSaveFile];
    if(errorSaveFile != nil)
    {
        NSLog(@"Error saving image");
    }
    NSString *pathInDocumentDirectoryStr = [NSString stringWithFormat:@"%@/%@.png", diskFolder,textStr];
    
    /**  You can  get image from document directory using below conbination of string. **/
   // NSLog(@"%@/%@",documentsDirectory,pathInDocumentDirectoryStr);
    
    return  pathInDocumentDirectoryStr;
}

- (UIImage *)imageFromString:(NSString *)string width : (CGFloat)width backgroundColor:(UIColor*)bgColor textColor:(UIColor*)textColor font:(UIFont*)font
{
    CGFloat height = [self heightForLabel:font width:width withText:string];
    
    UILabel *lbl =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, height)];

    UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, height), NO, 1);
    
    lbl.text =string;
    lbl.backgroundColor =bgColor;
    lbl.textColor =textColor;
    lbl.numberOfLines = MAXFLOAT;
    lbl.lineBreakMode = NSLineBreakByWordWrapping;
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.font = font;
    
    [lbl.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

-(CGFloat)heightForLabel:(UIFont *)font width : (CGFloat)width withText:(NSString *)text{
    
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName:font}];
    CGRect rect = [attributedText boundingRectWithSize:(CGSize){width, CGFLOAT_MAX}
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    
    return ceil(rect.size.height);
}

#pragma mark - resize image
-(UIImage *)imageResize :(UIImage*)img andResizeTo:(CGSize)newSize
{
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 1);
    [img drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - Crop an image in a view

-(UIImage *)cropImagesFromUIView:(UIView*)view croprect : (CGRect)croprect
{
    UIGraphicsBeginImageContext(view.bounds.size);
    
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *img_screenShot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Create rect for image
    UIImage *imageNew = [self getSubImageFrom:img_screenShot WithRect:croprect];
    return imageNew;
}

#pragma mark - Crop an image from GLKView

-(UIImage *)cropImagesFromGLKView:(GLKView*)glkView croprect : (CGRect)croprect
{
    UIImage *img_screenShot =  [glkView snapshot];
    // Create rect for image
    UIImage *imageNew = [self getSubImageFrom:img_screenShot WithRect:croprect];
    return imageNew;
}

// get sub image
- (UIImage*) getSubImageFrom: (UIImage*) img WithRect: (CGRect) rect {
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // translated rectangle for drawing sub image
    CGRect drawRect = CGRectMake(-rect.origin.x, -rect.origin.y, img.size.width, img.size.height);
    
    // clip to the bounds of the image context
    // not strictly necessary as it will get clipped anyway?
    CGContextClipToRect(context, CGRectMake(0, 0, rect.size.width, rect.size.height));
    
    // draw image
    [img drawInRect:drawRect];
    
    // grab image
    UIImage* subImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return subImage;
}

#pragma mark - Set hue saturation brightness of an image

- (UIImage*) imageWithImage:(UIImage*) source fixedHue:(CGFloat) hue  fixedSaturation:(CGFloat) saturation   fixedBrightness:(CGFloat) brightness  alpha:(CGFloat) alpha;
// Note: the hue input ranges from 0.0 to 1.0, both red.  Values outside this range will be clamped to 0.0 or 1.0.
{
    // Find the image dimensions.
    CGSize imageSize = [source size];
    CGRect imageExtent = CGRectMake(0,0,imageSize.width,imageSize.height);
    
    // Create a context containing the image.
    UIGraphicsBeginImageContext(imageSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [source drawAtPoint:CGPointMake(0,0)];
    
    // Draw the hue on top of the image.
    CGContextSetBlendMode(context, kCGBlendModeHue);
    [[UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:alpha] set];
    UIBezierPath *imagePath = [UIBezierPath bezierPathWithRect:imageExtent];
    [imagePath fill];
    
    // Retrieve the new image.
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;
}

-(void)SaveImageInDocumentDirectory:(UIImage *)image imageName:(NSString*)imageName diskFolder : (NSString*)diskFolder {
    
    NSString *stringPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:diskFolder];
    // New Folder is your folder name
    NSError *error = nil;
    if (![[NSFileManager defaultManager] fileExistsAtPath:stringPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:stringPath withIntermediateDirectories:NO attributes:nil error:&error];
    
    NSString *fileName = [stringPath stringByAppendingFormat:@"/%@.png",imageName];
    NSData *data = UIImagePNGRepresentation(image);
    [data writeToFile:fileName atomically:YES];
    
}

@end
