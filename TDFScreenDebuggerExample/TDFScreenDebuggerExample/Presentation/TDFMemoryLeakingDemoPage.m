//
//  TDFMemoryLeakingDemoPage.m
//  TDFScreenDebuggerExample
//
//  Created by 开不了口的猫 on 2018/6/21.
//  Copyright © 2018年 TDF. All rights reserved.
//

#import "TDFMemoryLeakingDemoPage.h"
#import "TDFMemoryLeakingDemoPage+Cate.h"
#import <Masonry/Masonry.h>

@interface Shared : NSObject

+ (instancetype)sharedInstance;
@property (nonatomic, strong) id obj;

@end

@implementation Shared

static Shared *sharedInstance = nil;

+ (instancetype)sharedInstance {
    static dispatch_once_t once = 0;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    if (!sharedInstance) {
        sharedInstance = [super allocWithZone:zone];
    }
    return sharedInstance;
}

@end

@interface TDFMemoryLeakingDemoPage ()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UILabel *tipLabel;

@end

@implementation TDFMemoryLeakingDemoPage

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self.view addSubview:self.tipLabel];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.obj = [MyObject new];
    [Shared sharedInstance].obj = self.obj;
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(timerHandler) userInfo:nil repeats:YES];
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        [_tipLabel setBackgroundColor:[UIColor clearColor]];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.numberOfLines = 1;
        _tipLabel.textColor = [UIColor lightGrayColor];
        _tipLabel.font = [UIFont systemFontOfSize:14];
        _tipLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _tipLabel.text = @"now we create a timer for causing a leaking..";
    }
    return _tipLabel;
}

- (void)dealloc {
    NSLog(@"page invoke dealloc");
}

- (void)timerHandler {
    NSLog(@"timer is still alive");
}

@end
