//
//  CommunitySendViewController.m
//  WGForSmile
//
//  Created by tarena on 15/11/13.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "CommunitySendViewController.h"
#import <BmobSDK/Bmob.h>
#import <BmobSDK/BmobProFile.h>
#import "MBProgressHUD.h"
#import "Masonry.h"
#import <QuartzCore/QuartzCore.h>

@interface CommunitySendViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,strong) UITextField * textField;
@property (nonatomic,strong) UITextView * textView;
@property (nonatomic,strong) UIImageView * imageView;
@end

@implementation CommunitySendViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UILabel* label=[UILabel new];
    label.text=@"标题";
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(40);
        make.top.equalTo(self.view).with.offset(40+44);
        make.width.mas_equalTo(@60);
        make.height.mas_equalTo(@30);
    }];
    
    UITextField* textField=[UITextField new];
    textField.borderStyle=UITextBorderStyleRoundedRect;
    self.textField=textField;
    [self.view addSubview:textField];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label.mas_right).with.offset(0);
        make.right.equalTo(self.view).with.offset(-40);
        make.top.equalTo(self.view).with.offset(40+44);
        make.height.mas_equalTo(@30);
    }];
    
    UIButton* button=[UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"添加图片" forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(chooseImage:) forControlEvents:UIControlEventTouchUpInside];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(40);
        make.top.equalTo(label.mas_bottom).with.offset(20);
        make.width.mas_equalTo(@80);
        make.height.mas_equalTo(@30);
    }];
    
    UIImageView* imageView=[UIImageView new];
    self.imageView=imageView;
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(button.mas_right).with.offset(0);
        make.top.equalTo(label.mas_bottom).with.offset(20);
        make.width.mas_equalTo(@150);
        make.height.mas_equalTo(@150);
    }];
    
    UILabel* contentlabel=[UILabel new];
    contentlabel.text=@"内容";
    [self.view addSubview:contentlabel];
    [contentlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(40);
        make.top.equalTo(imageView.mas_bottom).with.offset(0);
        make.width.mas_equalTo(@80);
        make.height.mas_equalTo(@30);
    }];

    UITextView* textView=[UITextView new];
    self.textView=textView;
    textView.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    textView.layer.borderWidth =1.0;
    textView.layer.cornerRadius =5.0;
    [self.view addSubview:textView];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(40);
        make.top.equalTo(contentlabel.mas_bottom).with.offset(0);
        make.right.equalTo(self.view).with.offset(-40);
        make.height.mas_equalTo(@80);
    }];
    
    UIBarButtonItem* item=[[UIBarButtonItem alloc]initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(sendmess:)];
    self.navigationItem.rightBarButtonItem=item;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)chooseImage:(UIButton*)sender
{
    [self.view endEditing:YES];    
    //UIAlertControllerStyleActionSheet取代下边，暂时还用
    //
    UIActionSheet* sheet;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        sheet=[[UIActionSheet alloc]initWithTitle:@"选择" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从相册选择", nil];
    }
    else
    {
        sheet=[[UIActionSheet alloc]initWithTitle:@"选择" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"从相册选择", nil];
    }
    sheet.tag = 255;
    [sheet showInView:self.view];
    
}

#pragma mark - actionsheet delegate


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 255) {
        NSUInteger sourceType = 0;
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            switch (buttonIndex) {
                case 0:
                    // 取消
                    return;
                case 1:
                    // 相机
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    break;
                case 2:
                    // 相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
            }
        }
        else {
            if (buttonIndex == 0) {
                
                return;
            }
            else {
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            }
        }
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = sourceType;
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
}

#pragma mark===image picker delegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    self.imageView.image=image;
    
}




//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//
//    _isFullScreen = !_isFullScreen;
//    UITouch *touch = [touches anyObject];
//
//    CGPoint touchPoint = [touch locationInView:self.view];
//
//    CGPoint imagePoint = self.imageView.frame.origin;
//    //touchPoint.x ，touchPoint.y 就是触点的坐标
//
//    // 触点在imageView内，点击imageView时 放大,再次点击时缩小
//    if(imagePoint.x <= touchPoint.x && imagePoint.x +self.imageView.frame.size.width >=touchPoint.x && imagePoint.y <=  touchPoint.y && imagePoint.y+self.imageView.frame.size.height >= touchPoint.y)
//    {
//        // 设置图片放大动画
//        [UIView beginAnimations:nil context:nil];
//        // 动画时间
//        [UIView setAnimationDuration:1];
//
//        if (_isFullScreen) {
//            // 放大尺寸
//
//            self.imageView.frame = CGRectMake(0, 0, 320, 480);
//        }
//        else {
//            // 缩小尺寸
//            self.imageView.frame = CGRectMake(50, 65, 90, 115);
//        }
//
//        // commit动画
//        [UIView commitAnimations];
//    }
//}


//#pragma mark - 保存图片至沙盒
//- (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName
//{
//
//    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
//    // 获取沙盒目录
//
//    NSString *fullPath =[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject] stringByAppendingPathComponent:@"123.png"];
//
//    // 将图片写入文件
//
//    [imageData writeToFile:fullPath atomically:NO];
//}


-(void)sendmess:(id)sender
{
    if (self.textView.text.length==0||self.textField.text.length==0) {
        self.textField.placeholder=@"标题或内容不能为空";
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    BmobUser* bUser=[BmobUser getCurrentUser];
    UIImage* image=self.imageView.image;
    NSData* imagedata=UIImageJPEGRepresentation(image, 0.2);
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYYMMddmmss"];
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    NSString* imagename=[NSString stringWithFormat:@"%@_%@",[bUser objectForKey:@"nickName"],locationString];
    if (imagedata.length!=0) {
        [BmobProFile uploadFileWithFilename:imagename fileData:imagedata block:^(BOOL isSuccessful, NSError *error, NSString *filename, NSString *url, BmobFile *file) {
            if (isSuccessful) {
                BmobObject* community=[BmobObject objectWithClassName:@"Community"];
                [community setObject:self.textField.text forKey:@"title"];
                [community setObject:self.textView.text forKey:@"content"];
                [community setObject:imagename forKey:@"goimagename"];
                [community setObject:filename forKey:@"backimagename"];
                [community setObject:url forKey:@"backurl"];
                [community setObject:[bUser objectForKey:@"nickName"] forKey:@"whoSend"];
                [community setObject:file forKey:@"imagefile"];
                [community setObject:[NSNumber numberWithInt:0] forKey:@"support"];
                [community setObject:[NSNumber numberWithInt:0] forKey:@"against"];
                [community saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                    if (isSuccessful) {
                        //NSLog(@"success2");
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                    if (error) {
                        //NSLog(@"%@",error.userInfo);
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        self.textField.text=@"发布失败,网络繁忙,或图片太大";
                    }
                }];
            }
            if (error) {
                //NSLog(@"%@",error.userInfo);
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                self.textField.text=@"发布失败,网络繁忙，或图片太大";
            }
        } progress:^(CGFloat progress) {
        }];
    }
    else
    {
        BmobObject* community=[BmobObject objectWithClassName:@"Community"];
        [community setObject:self.textField.text forKey:@"title"];
        [community setObject:self.textView.text forKey:@"content"];
        [community setObject:[bUser objectForKey:@"nickName"] forKey:@"whoSend"];
        [community setObject:[NSNumber numberWithInt:0] forKey:@"support"];
        [community setObject:[NSNumber numberWithInt:0] forKey:@"against"];
        [community saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            if (isSuccessful) {
                //NSLog(@"success2");
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self.navigationController popViewControllerAnimated:YES];
            }
            if (error) {
                //NSLog(@"%@",error.userInfo);
            }
        }];
    }
        //    NSString *fullPath =[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject] stringByAppendingPathComponent:@"222.png"];
    // 将图片写入文件
    //[imagedata writeToFile:fullPath atomically:NO];
    //    BmobFile* imagefile=[[BmobFile alloc]initWithFileName:@"dd" withFileData:imagedata];
    //    [community saveAllWithDictionary:@{@"file":imagefile}];
    //  [community setObject: forKey:@"file"];
    ////    BmobFile* imagefile=[[BmobFile alloc]initWithFileName:@"123" withFileData:imagedata];
    //    //[community setObject:@"123" forKey:@"file"];
    //
    //
    //
    //
}



//点击屏幕空白处 收起键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}





@end
