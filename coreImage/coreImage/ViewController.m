//
//  ViewController.m
//  coreImage
//
//  Created by 张广洋 on 16/2/22.
//  Copyright © 2016年 张广洋. All rights reserved.
//

#import "ViewController.h"

#import "Header.h"

#import <CoreImage/CoreImage.h>

@interface ViewController ()
{
    CIFilter * filter;
}
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //滤镜列表
    log([CIFilter filterNamesInCategory:kCICategoryBuiltIn]);
    log([CIFilter filterWithName:@"CISepiaTone"].attributes);
    
    //获取图片资源路径
    NSString *filePath =
    [[NSBundle mainBundle] pathForResource:@"a" ofType:@"png"];
    NSURL *fileNameAndPath = [NSURL fileURLWithPath:filePath];
    //读取图片到CIImage
    CIImage *beginImage =
    [CIImage imageWithContentsOfURL:fileNameAndPath];
    //创建滤镜对象filter
    filter = [CIFilter filterWithName:@"CISepiaTone"
                                  keysAndValues: kCIInputImageKey, beginImage,
                        @"inputIntensity", @0.2, nil];
    //获取输出CIImage
    CIImage *outputImage = [filter outputImage];
    //创建UIImage对象
    UIImage *newImage = [UIImage imageWithCIImage:outputImage];
    //展示
    self.imageView.image=newImage;
    
}

- (IBAction)sliderChangeValue:(UISlider *)sender {
    static float k=0;
    if ((sender.value-k>0.1)||(sender.value-k<-0.1)) {
        k=sender.value;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [filter setValue:@(sender.value) forKey:@"inputIntensity"];
            CIImage *outputImage = [filter outputImage];
            UIImage *newImage = [UIImage imageWithCIImage:outputImage];
            //返回主线程
            dispatch_async(dispatch_get_main_queue(), ^{//这里是主线程
                self.imageView.image=newImage;
            });
        });
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
