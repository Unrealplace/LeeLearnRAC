//
//  ViewController.m
//  LeeLearnRAC
//
//  Created by LiYang on 17/5/23.
//  Copyright © 2017年 LiYang. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveCocoa.h>

@interface ViewController ()

@property (nonatomic,copy)NSString * userName;
@property (weak, nonatomic) IBOutlet UIButton *button;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [RACObserve(self, userName) subscribeNext:^(id x) {
        NSLog(@"***----->>%@",x);
    }];
    
    [[RACObserve(self, userName) filter:^BOOL(id value) {
        return [value hasPrefix:@"oliver"];
    } ] subscribeNext:^(id x) {
        NSLog(@"------>>>>%@",x);
    }];
    
 
    RAC(self, userName) = [[[RACSignal interval:3 onScheduler:[RACScheduler currentScheduler]] startWith:[NSDate date]] map:^id (NSDate *value) {
        NSLog(@"value:%@", value);
        NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSHourCalendarUnit |
                                            NSMinuteCalendarUnit |
                                            NSSecondCalendarUnit fromDate:value];
        return [NSString stringWithFormat:@"%02ld:%02ld:%02ld", (long)dateComponents.hour, (long)dateComponents.minute, (long)dateComponents.second];
    }];
    
    self.button.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        NSLog(@"button click");
        return [RACSignal empty];
    }];
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardDidShowNotification object:nil] subscribeNext:^(id x) {
        
        NSLog(@"键盘改变了");
    }];
    
    [[self rac_signalForSelector:@selector(viewWillAppear:) ] subscribeNext:^(id x) {
       
        NSLog(@"viewwillappear %@",x);
        
    }];
    
    
}

- (IBAction)btnClick:(id)sender {
    
    self.userName = [NSString stringWithFormat:@"oliver--%u",arc4random()];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
