//
//  DHAddReportViewController.m
//  DriverHelper
//
//  Created by Gordon Su on 16/4/24.
//  Copyright © 2016年 S&L. All rights reserved.
//

#import "DHAddReportViewController.h"
#import "DHLocationShareModel.h"
#import "DHUserModel.h"
#import "UIImage+DHImageExt.h"
#import "DHMapPin.h"
#import <MapKit/MapKit.h>
#import "DHPostCommentInputView.h"
#import "DHPostCommentController.h"

@interface DHAddReportViewController ()<UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MKMapViewDelegate, UITextFieldDelegate>
{
    UIImage *_selectedImage;
    BOOL _hadRegion;
}

@property (nonatomic, strong) MKMapView *mapView;

@property (nonatomic, strong) UIButton *postTypeButton;

@property (nonatomic, strong) UIPickerView *typePickView;

@property (nonatomic, strong) UIButton *donePickButton;

@property (nonatomic, copy) NSArray *pickTypes;

@property (nonatomic, strong) UIButton *selectPhotoButton;
@property (nonatomic, strong) UIImageView *selectImageView;

@property (nonatomic, strong) UIImageView *pinImageView;

@property (nonatomic) CLLocationCoordinate2D postCoordinate;

@property (nonatomic, strong) DHPostCommentInputView *commentInputView;

@property (nonatomic, strong) DHPostCommentController *commentController;

@property (nonatomic, strong)  UITextField *textField;

@property (nonatomic, strong)  UITextField *accessoryField;

@end

@implementation DHAddReportViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.type = DHReportTypePolice;
    self.view.backgroundColor = [UIColor whiteColor];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"back" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"post" style:UIBarButtonItemStylePlain target:self action:@selector(post:)];

    [self.view addSubview:self.postTypeButton];
    [self.view addSubview:self.selectPhotoButton];
    [self.view addSubview:self.selectImageView];
    [self.view addSubview:self.mapView];
    [self.view addSubview:self.pinImageView];

    self.commentController = [[DHPostCommentController alloc] init];
    [self.commentController showInView:self.view];
}

- (void)layoutSubviewsOfView
{
    [super layoutSubviewsOfView];
    self.mapView.frame = CGRectMake(0, 64, self.view.bounds.size.width, 300);
    self.pinImageView.frame = CGRectMake(self.mapView.bounds.size.width / 2 - 32 / 2, 64 + self.mapView.bounds.size.height / 2 - 32, 32, 32);
    self.postTypeButton.frame = CGRectMake(0, CGRectGetMaxY(self.mapView.frame), 100, 64);
    self.selectPhotoButton.frame = CGRectMake(0, CGRectGetMaxY(self.postTypeButton.frame), 100, 64);
}

- (UITextField *)textField
{
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 320, 320, 44)];
        _textField.backgroundColor = [UIColor whiteColor];
        _textField.delegate = self;
        _textField.placeholder = @"text file ";

        return _textField;
    }
    return _textField;
}

- (UITextField *)accessoryField
{
    if (!_accessoryField) {
        _accessoryField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        _accessoryField.backgroundColor = [UIColor whiteColor];
        _accessoryField.delegate = self;
        _accessoryField.placeholder = @"access ";
    }
    return _accessoryField;
}

#pragma mark - UITextFieldDelegate

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark -

- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)post:(id)sender
{
    if (_selectedImage) {
        NSString *url = UploadPicUrl;
        SWSHTTPRequest *request = [[SWSHTTPRequest alloc] initWithBaseUrl:url];
        [request setQueryValue:@([DHUserModel sharedManager].uid) forKey:@"user_id"];
        [request setQueryValue:@"1" forKey:@"type"];

        NSData *imgeData = UIImageJPEGRepresentation(_selectedImage, 0.1);
        request.fileData = imgeData;
        [[SWSAPIHelper defaultHelper] uploadFileWithRequest:request progress:^(NSProgress *downloadProgress) {
            NSLog(@"=== progress : %@", downloadProgress);
        } finish:^(SWSHTTPResponse *respone) {
            if (respone.isSuccess) {
                NSString *imgurl = (NSString *)respone.dataDictionary;
                [self addReportWithImageUrl:imgurl];
            }
        }];
    } else {
        [self addReportWithImageUrl:nil];
    }
}

- (void)addReportWithImageUrl:(NSString *)imageString
{
    NSString *url = AddReportUrl;
    SWSHTTPRequest *request = [[SWSHTTPRequest alloc] initWithBaseUrl:url];
    request.queries = @{
        @"title": @"中文title",
        @"type": @(self.type),
        @"desc": self.commentController.accessoryView.text,
        @"user_id": @([DHUserModel sharedManager].uid),
        @"create_time": @([[NSDate date] timeIntervalSince1970])
    };
    if ([self getPostCoordinateString]) {
        [request setQueryValue:[self getPostCoordinateString] forKey:@"location"];
    }
    if ([[DHLocationShareModel sharedModel] getPostRepotAddressString]) {
        [request setQueryValue:[[DHLocationShareModel sharedModel] getPostRepotAddressString] forKey:@"address"];
    }
    if (imageString.length) {
        [request setQueryValue:imageString forKey:@"imgs"];
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        SWSHTTPResponse *response = [[SWSAPIHelper defaultHelper] callRequest:request];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (response.isSuccess) {
            }
            [JDStatusBarNotification showWithStatus:[NSString stringWithFormat:@"上传 ：%d , error: %td", response.isSuccess, response.error.code] dismissAfter:1.0];
        });
    });
}

- (void)selectPostType
{
    self.typePickView.hidden = !self.typePickView.hidden;

    self.donePickButton.hidden = self.typePickView.hidden;
}

- (void)changeTypeDoe:(id)sender
{
    self.typePickView.hidden = YES;
    self.donePickButton.hidden = YES;
}

- (void)openPhotoPick
{
    UIImagePickerController *imagePick = [[UIImagePickerController alloc] init];
    imagePick.delegate = self;
    imagePick.allowsEditing = YES;
    [self.navigationController presentViewController:imagePick animated:YES completion:nil];
}

#pragma mark -UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *, id> *)info
{
    __block UIImage *img = [info objectForKey:UIImagePickerControllerEditedImage];
    if (!img) img = [info objectForKey:UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        if (img) {
            img = [img scaleToSize:img size:CGSizeMake(100, 100)];
        }
        self.selectImageView.image = img;
        _selectedImage = img;
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma makr - UIPickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.pickTypes.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSNumber *type = self.pickTypes[row];
    NSString *title = [self titleWithType:[type integerValue]];
    return title;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSNumber *type = self.pickTypes[row];
    NSString *title = [self titleWithType:[type integerValue]];
    [self.postTypeButton setTitle:title forState:UIControlStateNormal];
    self.type = [type integerValue];
    NSLog(@"===  type : %td", self.type);
}

- (NSString *)titleWithType:(DHReportType)type
{
    NSString *title = nil;
    switch (type) {
        case DHReportTypePolice:
            title = @"警察";
            break;
        case DHReportTypeJam:
            title = @"交通拥堵";
            break;
        case DHReportTypeCrashes:
            title = @"交通事故";
            break;
        case DHReportTypeClosure:
            title = @"封路";
            break;
        case DHReportTypeConstruction:
            title = @"施工";
            break;
        default:
            break;
    }
    return title;
}

#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    NSLog(@"=== regionDidChangeAnimated : %lf , %lf", mapView.region.center.latitude, mapView.region.center.longitude);
    self.postCoordinate = mapView.region.center;
}

- (void)mapViewWillStartLoadingMap:(MKMapView *)mapView
{
    NSLog(@"=== mapViewWillStartLoadingMap");
}

- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView
{
    NSLog(@"=== mapViewDidFinishLoadingMap");
}

- (void)mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error
{
    NSLog(@"=== mapViewDidFailLoadingMap");
}

- (void)mapViewWillStartRenderingMap:(MKMapView *)mapView NS_AVAILABLE(10_9, 7_0)
{
    NSLog(@"=== mapViewWillStartRenderingMap");
}

- (void)mapViewDidFinishRenderingMap:(MKMapView *)mapView fullyRendered:(BOOL)fullyRendered NS_AVAILABLE(10_9, 7_0)
{
    NSLog(@"=== mapViewDidFinishRenderingMap");
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    NSLog(@"=== didUpdateUserLocation : %@", userLocation.location);
    CLLocationCoordinate2D userCoor = userLocation.location.coordinate;

    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userCoor, 500, 500);

    if (!_hadRegion) {
        self.mapView.region = region;
        self.postCoordinate = userCoor;
        _hadRegion = YES;
    }
}

#pragma mark - property

- (NSString *)getPostCoordinateString
{
    return [NSString stringWithFormat:@"%lf-%lf", self.postCoordinate.latitude, self.postCoordinate.longitude];
}

- (MKMapView *)mapView
{
    if (!_mapView) {
        _mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 100)];
        _mapView.showsUserLocation = YES;
        _mapView.delegate = self;
    }
    return _mapView;
}

- (UIImageView *)pinImageView
{
    if (!_pinImageView) {
        _pinImageView = [[UIImageView alloc] init];
        _pinImageView.image = [UIImage imageNamed:@"pin_map"];
    }
    return _pinImageView;
}

- (UIButton *)postTypeButton
{
    if (!_postTypeButton) {
        _postTypeButton = [[UIButton alloc] init];
        [_postTypeButton setTitle:[self titleWithType:self.type] forState:UIControlStateNormal];
        [_postTypeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_postTypeButton addTarget:self action:@selector(selectPostType) forControlEvents:UIControlEventTouchUpInside];
    }
    return _postTypeButton;
}

- (UIPickerView *)typePickView
{
    if (!_typePickView) {
        _typePickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(self.postTypeButton.frame), self.view.bounds.size.width, 100)];
        _typePickView.delegate = self;
        _typePickView.dataSource = self;
        _typePickView.hidden = YES;
        [self.view addSubview:_typePickView];
    }
    return _typePickView;
}

- (UIButton *)donePickButton
{
    if (!_donePickButton) {
        _donePickButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 100, CGRectGetMinY(self.postTypeButton.frame), 100, 44)];
        [_donePickButton setTitle:@"done" forState:UIControlStateNormal];
        [_donePickButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_donePickButton addTarget:self action:@selector(changeTypeDoe:) forControlEvents:UIControlEventTouchUpInside];
        [self.view insertSubview:_donePickButton aboveSubview:self.typePickView];
    }
    return _donePickButton;
}

- (NSArray *)pickTypes
{
    if (!_pickTypes) {
        _pickTypes = [[NSArray alloc] initWithObjects:
                      @(DHReportTypePolice),
                      @(DHReportTypeJam),
                      @(DHReportTypeCrashes),
                      @(DHReportTypeClosure),
                      @(DHReportTypeConstruction),
                      nil];
    }
    return _pickTypes;
}

- (UIButton *)selectPhotoButton
{
    if (!_selectPhotoButton) {
        _selectPhotoButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 64 + 64 + 64, 100, 44)];
        [_selectPhotoButton setTitle:@"photo" forState:UIControlStateNormal];
        [_selectPhotoButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_selectPhotoButton addTarget:self action:@selector(openPhotoPick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectPhotoButton;
}

- (UIImageView *)selectImageView
{
    if (!_selectImageView) {
        _selectImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.selectPhotoButton.frame), 64 + 100, 100, 100)];
    }
    return _selectImageView;
}

- (DHPostCommentInputView *)commentInputView
{
    if (!_commentInputView) {
        _commentInputView = [[DHPostCommentInputView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 44, self.view.bounds.size.width, 44)];
        [_commentInputView sui_addBorderWithColor:[UIColor redColor]];
    }
    return _commentInputView;
}

#pragma mark - 图片上传
//注意是同步上传，阻塞线程
+ (NSString *)uploadImage:(UIImage *)image withName:(NSString *)name mimeType:(NSString *)mimeType
{
//    NSString *url = [kHost stringByAppendingFormat:@"/common/uploadPicUrl.don/uploadPicUrl.don/uploadPicUrl.do?player_id=%@&type=1",[DBUser sharedInstance].player_id];
    NSString *url = [NSString stringWithFormat:@"%@?user_id=12345678&type=1", UploadPicUrl];
//    NSString *url = UploadPicUrl;
    //2建立NSMutableRequest
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    //1)设置request的属性，设置方法
    [request setHTTPMethod:@"POST"];

    //2)设置数据体
    //1> 设置boundary的字符串，可以复用
    NSString *boundary = @"uploadBoundary";
    //2>头部字符串 分界标示，固有格式
    NSString *strTop = [NSString stringWithFormat:@"--%@\r\nContent-Disposition: form-data; name=\"file\"; filename=\"%@\"\r\nContent-Type: %@\r\n\r\n", boundary, name, mimeType];

    //3>尾部字符串
    NSString *strBottom = [NSString stringWithFormat:@"\r\n--%@--", boundary];

    //4>拼接数据体
    NSMutableData *bodyData = [NSMutableData data];

    NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
    [bodyData appendData:[strTop dataUsingEncoding:NSUTF8StringEncoding]];
    [bodyData appendData:imageData];
    [bodyData appendData:[strBottom dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:bodyData];

    //5>指定Content-Type,在上传文件时，需要指定content-type和content-length
    NSString *contentStr = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentStr forHTTPHeaderField:@"Content-Type"];

    //6>指定Content-Length
    [request setValue:[NSString stringWithFormat:@"%td", [bodyData length]] forHTTPHeaderField:@"Content-Length"];

    //3使用NSURLConnection的同步方法上传文件，因为需要用户确认文件是否上传成功。
    //在使用http上传文件时，通常是有大小限制的。一般不会超过2M.
    NSError *error = nil;
    NSData *resultData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    if (!error) {
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableLeaves error:&error];
        return json[@"object"];
    }
    return nil;
}

@end
