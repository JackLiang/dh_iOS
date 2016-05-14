//
//  ViewController.m
//  DriverHelper
//
//  Created by Gordon Su on 16/4/10.
//  Copyright © 2016年 S&L. All rights reserved.
//

#import "ViewController.h"
#import "DHLocationTracker.h"
#import <AudioToolbox/AudioToolbox.h>
#import <iflyMSC/iflyMSC.h>
#import "DHMapViewController.h"
#import "DHLoginViewController.h"
#import "SWSKit.h"
#import "DHLocationShareModel.h"
#import "DHUserModel.h"
#import "JTNavigationController.h"
#import "DHAddReportViewController.h"
#import "DHReportModel.h"
#import "DHMessageCenter.h"
#import "AppDelegate.h"

@interface ViewController ()<IFlySpeechSynthesizerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) IFlySpeechSynthesizer *iflySpeechSynthesizer;

@property (nonatomic, strong) NSArray *reportArray;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self iniIfly];

//    [[DHMessageCenter curCenter] initServer];
}

- (void)iniIfly
{
    self.iflySpeechSynthesizer = [[IFlySpeechSynthesizer alloc] init];
    [self.iflySpeechSynthesizer setDelegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)start:(id)sender
{
    UIButton *bnt = sender;
    bnt.selected = !bnt.selected;
    if (bnt.selected) {
        [((AppDelegate *)[UIApplication sharedApplication].delegate).locationTracker startUpdateLocationToServer];
    } else {
        [((AppDelegate *)[UIApplication sharedApplication].delegate).locationTracker stopUpdateLocationToServer];
    }
}

- (void)play
{
    SystemSoundID soundID = 0;
    NSString *soundFilepath = [[NSBundle mainBundle] pathForResource:@"sou" ofType:@"caf"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL URLWithString:soundFilepath], &soundID);

    AudioServicesPlaySystemSound(soundID);
}

- (IBAction)post:(id)sender
{
    DHAddReportViewController *addReportVC = [[DHAddReportViewController alloc] init];
    JTNavigationController *nav = [[JTNavigationController alloc] initWithRootViewController:addReportVC];
    [self presentViewController:nav animated:YES completion:nil];
}

- (IBAction)login:(id)sender
{
    SWSHTTPRequest *request = [[SWSHTTPRequest alloc] initWithBaseUrl:AuthenticateUrl];
    request.queries = @{
        @"account": @"test",
        @"password": @"123456"
    };
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        SWSHTTPResponse *response = [[SWSAPIHelper defaultHelper] callRequest:request];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (response.isSuccess) {
                NSString *uid = (NSString *)response.dataDictionary;
                [DHUserModel sharedManager].uid = [uid integerValue];
            }
            [JDStatusBarNotification showWithStatus:[NSString stringWithFormat:@"登陆：%d , uid: %td", response.isSuccess, [DHUserModel sharedManager].uid] dismissAfter:2.0];
        });
    });
}

- (IBAction)clickGetRwport:(id)sender
{
    [self getReportList];
}

- (void)getReportList
{
    SWSHTTPRequest *request = [[SWSHTTPRequest alloc] initWithBaseUrl:GetReportUrl];
    request.POST = YES;
    [request setQueryValue:@"2" forKey:@"interest"];
    [request setQueryValue:[[DHLocationShareModel sharedModel] getLocationString] forKey:@"location"];
//    [request setQueryValue:[[DHLocationShareModel sharedModel] getPostRepotAddressString] forKey:@"address"];
    [request setQueryValue:@"广州" forKey:@"address"];
    [request setQueryValue:@([DHUserModel sharedManager].uid) forKey:@"user_id"];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        SWSHTTPResponse *response = [[SWSAPIHelper defaultHelper] callRequest:request];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (response.isSuccess) {
                self.reportArray = [NSArray yy_modelArrayWithClass:[DHReportModel class] json:response.dataDictionary];

                [self.tableView reloadData];
            }
            [JDStatusBarNotification showWithStatus:[NSString stringWithFormat:@"获取消息 ：%d", response.isSuccess] dismissAfter:1.];
        });
    });
}

- (DHReportModel *)reportModel
{
    DHReportModel *report = [[DHReportModel alloc] init];
    report.title = @"tilte";
    report.type = @"type";
//    report.desc = @"desc";
    report.imgs = @"imgs";
    report.location = @"location";
    report.address = @"广州市-海珠区-赤岗";
//    report.create_time = @"create_time";

    return report;
}

- (NSArray *)reports
{
    NSMutableArray *array = [NSMutableArray array];
    for (NSInteger index = 0; index < 1; index++) {
        DHReportModel *report =  [self reportModel];
        report.title = [NSString stringWithFormat:@"%@%td", report.title, index];
        [array addObject:report];
    }
    return array.copy;
}

#pragma mark - IFlySpeechSynthesizerDelegate;
- (void)onCompleted:(IFlySpeechError *)error
{
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.reportArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    DHReportModel *report = self.reportArray[indexPath.row];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:report.imgs]];
    if (report.descripte.length) {
        cell.textLabel.text = report.descripte;
    } else {
        cell.textLabel.text = report.title;
    }
    return cell;
}

@end
