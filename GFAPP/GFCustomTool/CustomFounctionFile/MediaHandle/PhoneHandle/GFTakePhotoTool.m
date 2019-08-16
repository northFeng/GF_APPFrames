//
//  GFTakePhotoTool.m
//  GFAPP
//
//  Created by 峰 on 2019/8/16.
//  Copyright © 2019 North_feng. All rights reserved.
//

#import "GFTakePhotoTool.h"
#import <AVFoundation/AVFoundation.h>

@interface GFTakePhotoTool ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIImagePickerController *imagePickerController;

/**
 控制器
 */
@property (nonatomic, strong) UIViewController *vc;

@end

@implementation GFTakePhotoTool

#pragma mark -------------------------------- UIImagePickerControllerDelegate --------------------------------

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    NSLog(@"%@",image);
    GFClipController *clip = [[GFClipController alloc] init];
    clip.image = image;
    [picker presentViewController:clip animated:YES completion:nil];
    //clip.block =
    /**
    // 上传图片
    [self.subject sendNext:x];
    [self.vc dismissViewControllerAnimated:YES completion:nil];
     */
}

#pragma mark -------------------------------- 相机 --------------------------------
- (void)showCamera:(UIViewController *)vc {
    self.vc = vc;
    [self checkCameraPermission];
}

- (void)showLibrary:(UIViewController *)vc {
    self.vc = vc;
    [self checkLibraryPermission];
}

- (void)checkLibraryPermission {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                [self selectePhoto];
            }
        }];
    } else if (status == AVAuthorizationStatusDenied || status == AVAuthorizationStatusRestricted) {
        [self alertCamear];
    } else {
        [self selectePhoto];
    }
}

- (void)selectePhoto {
    //判断相机是否可用，防止模拟器点击【相机】导致崩溃
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self.vc presentViewController:self.imagePickerController animated:YES completion:nil];
    } else {
        NSLog(@"不能使用模拟器进行拍照");
    }
}

- (void)checkCameraPermission {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                [self takePhoto];
            }
        }];
    } else if (status == AVAuthorizationStatusDenied || status == AVAuthorizationStatusRestricted) {
        [self alertCamear];
    } else {
        [self takePhoto];
    }
}

- (void)takePhoto {
    //判断相机是否可用，防止模拟器点击【相机】导致崩溃
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self.vc presentViewController:self.imagePickerController animated:YES completion:nil];
    } else {
        NSLog(@"不能使用模拟器进行拍照");
    }
}

- (void)alertCamear {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"请在设置中打开相机" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self.vc dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:cancel];
    [self.vc presentViewController:alert animated:YES completion:nil];
}

#pragma mark -------------------------------- 懒加载 --------------------------------
- (UIImagePickerController *)imagePickerController {
    if (_imagePickerController == nil) {
        _imagePickerController = [[UIImagePickerController alloc] init];
        _imagePickerController.delegate = self;
        _imagePickerController.allowsEditing = NO;
    }
    return _imagePickerController;
}

@end


#import <QuartzCore/QuartzCore.h>
#pragma mark - ************************* 裁剪图片 *************************

@interface GFClipController ()<UIScrollViewDelegate>

/**
 内容视图
 */
@property (nonatomic, strong) UIScrollView *bgScrollView;

/**
 图片
 */
@property (nonatomic, strong) UIImageView *imgView;

/**
 遮罩图层
 */
@property (nonatomic, strong) UIView *coverView;

/**
 切分位置
 */
@property (nonatomic, assign) CGRect clipRect;

/**
 标题
 */
@property (nonatomic, strong) UILabel *label;

/**
 取消
 */
@property (nonatomic, strong) UIButton *cancelButton;

/**
 确定
 */
@property (nonatomic, strong) UIButton *confirmButton;

@end

@implementation GFClipController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self constructView];
    [self setGestures];
    [self setRac];
}

#pragma mark -------------------------------- RAC --------------------------------
- (void)setRac {
    /**
    [[self.cancelButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSError *error = [NSError errorWithDomain:@"AAAAA" code:3333 userInfo:nil];
        [weakSelf.subject sendError:error];
    }];
    
    [[self.confirmButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [weakSelf clipImage];
    }];
     */
}

- (void)clipImage {
    
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, 0.0);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenShotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIGraphicsBeginImageContext(self.clipRect.size);
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, self.clipRect.size.width, self.clipRect.size.width)];
    [path addClip];
    [screenShotImage drawAtPoint:CGPointMake(-self.clipRect.origin.x, -self.clipRect.origin.y)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //[self.subject sendNext:newImage];//回调图片
    UIGraphicsEndImageContext();
}

#pragma mark -------------------------------- Action --------------------------------
- (void)setGestures {
    UIPinchGestureRecognizer *pinGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(changeScale:)];
    [self.imgView addGestureRecognizer:pinGesture];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(changePoint:)];
    [self.imgView addGestureRecognizer:panGesture];
}

- (void)changeScale:(UIPinchGestureRecognizer *)sender {
    UIView *view = sender.view;
    if (sender.state == UIGestureRecognizerStateBegan || sender.state == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformScale(view.transform, sender.scale, sender.scale);
        sender.scale = 1.0;
    }
}

- (void)changePoint:(UIPanGestureRecognizer *)sender {
    UIView *view = sender.view;
    if (sender.state == UIGestureRecognizerStateBegan || sender.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [sender translationInView:view.superview];
        [view setCenter:CGPointMake(view.centerX+translation.x, view.centerY+translation.y)];
        [sender setTranslation:CGPointZero inView:view.superview];
    }
}

#pragma mark -------------------------------- 初始化页面 --------------------------------
- (void)constructView {
    /**
    self.imgView  = [[UIImageView alloc] initWithFrame:self.view.bounds];
    self.imgView.contentMode = UIViewContentModeScaleAspectFit;
    self.imgView.image = self.image;
    self.imgView.userInteractionEnabled = YES;
    [self.view addSubview:self.imgView];
    
    self.coverView = [[UIView alloc] initWithFrame:self.view.bounds];
    //self.coverView.backgroundColor = [[UIColor blackColor] ;
    self.coverView.userInteractionEnabled = NO;
    [self.view addSubview:self.coverView];
    
    UIBezierPath *rectPath = [UIBezierPath bezierPathWithRoundedRect:self.coverView.bounds cornerRadius:0];
    CGFloat gif_x = 20;
    CGFloat gif_y = (ScreenHeight - (ScreenWidth - 40)) / 2.0;
    self.clipRect = CGRectMake(gif_x, gif_y, fit(ScreenWidth - 40), fit(ScreenWidth - 40));
    
    UIBezierPath *cireclePath = [UIBezierPath bezierPathWithRoundedRect:self.clipRect cornerRadius:self.clipRect.size.width / 2];
    [rectPath appendPath:cireclePath];
    [rectPath setUsesEvenOddFillRule:YES];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = rectPath.CGPath;
    shapeLayer.fillRule = kCAFillRuleEvenOdd;
    shapeLayer.opaque = 0.5;
    [self.coverView.layer setMask:shapeLayer];
    
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 10 + (TopMargin), ScreenWidth, 24)];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.font = [UIFont systemFontOfSize:17];
    self.label.textColor = [UIColor whiteColor];
    self.label.text = @"移动和缩放";
    [self.view addSubview:self.label];
    
    self.cancelButton = [[ESBaseButton alloc] initWithFrame:CGRectMake(23, ScreenHeight - 20 - (BottomMargin) - 44, 44, 44)];
    [self.cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    self.cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:self.cancelButton];
    
    self.confirmButton = [[ESBaseButton alloc] initWithFrame:CGRectMake(ScreenWidth - 23 - 44, ScreenHeight - 20 - (BottomMargin) - 44, 44, 44)];
    [self.confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.confirmButton setTitle:@"完成" forState:UIControlStateNormal];
    self.confirmButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:self.confirmButton];
     */
    
}


@end

