//
//  RegisterViewController.m
//  WGForSmile
//
//  Created by tarena on 15/11/8.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "RegisterViewController.h"
#import <BmobSDK/Bmob.h>
@interface RegisterViewController ()
@property (nonatomic,strong) UITextField * nameTextField;
@property (nonatomic,strong) UITextField * pwdTextField;
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    /* vfl语法
     
     vfl是一种特殊语法格式的字符串 使用一些特定的符号来完成对约束的描述
     ｜ 代表父视图边缘
     H:| 代表父视图左边缘
     V:| 代表父视图上边缘
     []  代表一个子视图
     ()  代表一个条件（== >= <=） ==可以忽略
     － 代表标准间距8像素
     －xx－ 代表间距有xx个点
     例如 三个按钮 距离左边缘20 间距10 右边缘20 等宽
     VFL:|-20-[btn1]-10-[btn2(btn1)]-10-[btn3(btn1)]-20-|
     
     */
    
    
    //加对应的注册按钮
    UIButton* button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor=[UIColor blueColor];
    [button setTitle:@"注册" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(back2Login:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    button.translatesAutoresizingMaskIntoConstraints=NO;
    
    UITextField* nameTextField=[UITextField new];
    nameTextField.placeholder=@"帐号/邮箱";
    nameTextField.borderStyle=UITextBorderStyleRoundedRect;
    nameTextField.translatesAutoresizingMaskIntoConstraints=NO;
    [self.view addSubview:nameTextField];

    UITextField* pwdTextField=[UITextField new];
    pwdTextField.placeholder=@"密码";
    pwdTextField.borderStyle=UITextBorderStyleRoundedRect;
    pwdTextField.translatesAutoresizingMaskIntoConstraints=NO;
    [self.view addSubview:pwdTextField];

    self.nameTextField=nameTextField;
    self.pwdTextField=pwdTextField;
    
    NSDictionary* diction1=NSDictionaryOfVariableBindings(nameTextField,pwdTextField,button);
    NSDictionary* diction2=@{@"top":@(thisScreenHeight/4),@"left":@50,@"right":@50,@"space":@(thisScreenHeight/13),@"bottom":@(thisScreenHeight/2.2)};
    
    NSString *namehorizontalvfl=@"|-left-[nameTextField]-right-|";
    NSArray* namehorizontalvflArray=[NSLayoutConstraint constraintsWithVisualFormat:namehorizontalvfl options:0 metrics:diction2 views:diction1];
    [self.view addConstraints:namehorizontalvflArray];
    
    NSString *pwdhorizontalvfl=@"|-left-[pwdTextField]-right-|";
    NSArray* pwdhorizontalvflArray=[NSLayoutConstraint constraintsWithVisualFormat:pwdhorizontalvfl options:0 metrics:diction2 views:diction1];
    [self.view addConstraints:pwdhorizontalvflArray];
    
    NSString *buttonhorizontalvfl=@"|-left-[button]-right-|";
    NSArray* buttonhorizontalvflArray=[NSLayoutConstraint constraintsWithVisualFormat:buttonhorizontalvfl options:0 metrics:diction2 views:diction1];
    [self.view addConstraints:buttonhorizontalvflArray];
    
    NSString *verticalvfl=@"V:|-top-[nameTextField]-space-[pwdTextField(nameTextField)]-space-[button(nameTextField)]-bottom-|";
    NSArray* verticalvflArray=[NSLayoutConstraint constraintsWithVisualFormat:verticalvfl options:NSLayoutFormatAlignAllCenterX metrics:diction2 views:diction1];
    [self.view addConstraints:verticalvflArray];
    
    
    
    
    
}

-(void)back2Login:(UIButton*)sender
{
    if ([self.nameTextField.text isEqualToString:@""]) {
        self.nameTextField.placeholder=@"用户名不能为空";
        return;
    }
    if ([self.pwdTextField.text isEqualToString:@""]) {
        self.pwdTextField.placeholder=@"密码不能为空";
        return;
    }
    NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL isValid = [predicate evaluateWithObject:self.nameTextField.text];
    if (isValid) {
        BmobUser *bUser=[[BmobUser alloc]init];
        [self makeValue:bUser];
        [bUser signUpInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
            if (isSuccessful) {
                NSLog(@"成功");
                [BmobUser logout];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                self.nameTextField.text=@"";
                self.pwdTextField.text=@"";
                self.nameTextField.placeholder=@"用户名已存在，请反回登录";
                NSLog(@"error");
            }
        }];
    }
    else
    {
        self.nameTextField.text=@"";
        self.nameTextField.placeholder=@"请输入正确的邮箱";
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)makeValue:(BmobUser*)bmobUser
{
    bmobUser.username=self.nameTextField.text;
    bmobUser.password=self.pwdTextField.text;
    bmobUser.email=self.nameTextField.text;
    [bmobUser setObject:@"昵称" forKey:@"nickName"];
    [bmobUser setObject:@"头像" forKey:@"headImage"];
    [bmobUser setObject:@[@"相册"] forKey:@"pictures"];
    [bmobUser setObject:@[@"动态"] forKey:@"dynamic"];
    [bmobUser setObject:@[@"关注"] forKey:@"attention"];
    [bmobUser setObject:@[@"粉丝"] forKey:@"fans"];
    [bmobUser setObject:[NSNumber numberWithBool:NO] forKey:@"isLogin"];
    [bmobUser setObject:@[@"我的发布"] forKey:@"publish"];
    [bmobUser setObject:@[@"我的收藏"] forKey:@"collection"];
    [bmobUser setObject:@[@"我的评论"] forKey:@"comment"];
}


//点击屏幕空白处 收起键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end

