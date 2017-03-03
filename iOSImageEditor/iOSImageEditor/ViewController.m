//
//  ViewController.m
//  iOSImageEditor
//
//  Created by Lalit Kant on 3/3/17.
//  Copyright © 2017 Lalit Kant. All rights reserved.
//

#import "ViewController.h"
#import "ImageCompress.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    
    ImageCompress *object =[[ImageCompress alloc] init];
    
    // Create image with Text
    
    NSString *link = [object createImageWithTextReturnPath:@"i am testing first one." diskFolder:@"images" backgroundColor:[UIColor redColor] textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:20]];
    
    NSLog(@"%@",link);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    // Random image collected from http://www.ilikewallpaper.net/iphone-4s-wallpaper/Comics-BG/2554
    
    // Resized Image
    UIImage *resizedImage = [object imageResize:[UIImage imageNamed:@"Comics-BG-iphone-4s-wallpaper-ilikewallpaper_com.jpg"] andResizeTo:CGSizeMake(200, 100)];
    
    [object SaveImageInDocumentDirectory:resizedImage imageName:@"resizedImage" diskFolder:@"images"];
    
    // Cropped Image

    UIImage *croppedImage = [object cropImagesFromUIView:self.vw croprect:CGRectMake(0, 0, 100, 100)];
    [object SaveImageInDocumentDirectory:croppedImage imageName:@"croppedImage" diskFolder:@"images"];
    
    // Note: the hue input ranges from 0.0 to 1.0, both red.  Values outside this range will be clamped to 0.0 or 1.0.

    UIImage *hSVUpdatedImage = [object imageWithImage:[UIImage imageNamed:@"Comics-BG-iphone-4s-wallpaper-ilikewallpaper_com.jpg"] fixedHue:.2 fixedSaturation:0.5 fixedBrightness:0.7 alpha:1.0];
    [object SaveImageInDocumentDirectory:hSVUpdatedImage imageName:@"hSVUpdatedImage" diskFolder:@"images"];

    // You can see all images in document directory by getting link from below Log
    NSLog(@"%@/images",documentsDirectory);

    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
