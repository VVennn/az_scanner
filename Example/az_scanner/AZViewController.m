//
//  AZViewController.m
//  az_scanner
//
//  Created by Az on 09/20/2023.
//  Copyright (c) 2023 Az. All rights reserved.
//

#import "AZViewController.h"
#import <AZScanner.h>
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width

@interface AZViewController ()
@property (nonatomic, strong) AZScanner *scanner;

@end

@implementation AZViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH - 100, SCREEN_HEIGHT - 100);
    self.scanner = [[AZScanner alloc] initWithPreviewView:self.view];
    [self.scanner startScanningWithResultBlock:^(NSDictionary * _Nonnull codeInfo) {
        NSLog(@"codeInfo:%@", codeInfo);
    }];
}
@end
