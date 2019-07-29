//
//  ViewController.m
//  LZWidgets
//
//  Created by benjaminlmz@qq.com on 2019/7/19.
//  Copyright © 2019 Tony. All rights reserved.
//

#import "ViewController.h"
#import "LZPopMenuView.h"
@interface ViewController ()<LZPopMenuDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // popView 依赖于UIView
    
    // AlertView
    
    // Loading View
}

- (IBAction)btnClick:(id)sender {
    NSArray *array = @[@"Channel1",@"Channel2",@"Channel3",@"Channel4"];
    [LZPopMenuView initPopViewRelayOn:sender titles:array dirction:DOWN style:DARK width:120 delegate:self];
}

@end
