//
//  ImageCompress.h
//  ImageCompress
//
//  Created by Lalit Kant on 2/15/17.
//  Copyright © 2017 Lalit Kant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

@interface ImageCompress : NSObject


-(NSString*)createImageWithTextReturnPath:(NSString *)textStr diskFolder : (NSString*)diskFolder backgroundColor:(UIColor*)bgColor textColor:(UIColor*)textColor font:(UIFont*)font;

-(UIImage *)imageResize :(UIImage*)img andResizeTo:(CGSize)newSize;

-(UIImage *)cropImagesFromUIView:(UIView*)view croprect : (CGRect)croprect;

-(UIImage *)cropImagesFromGLKView:(GLKView*)glkView croprect : (CGRect)croprect;

// Note: the hue input ranges from 0.0 to 1.0, both red.  Values outside this range will be clamped to 0.0 or 1.0.
- (UIImage*) imageWithImage:(UIImage*) source fixedHue:(CGFloat) hue  fixedSaturation:(CGFloat) saturation   fixedBrightness:(CGFloat) brightness  alpha:(CGFloat) alpha;

-(void)SaveImageInDocumentDirectory:(UIImage *)image imageName:(NSString*)imageName diskFolder : (NSString*)diskFolder;
@end
