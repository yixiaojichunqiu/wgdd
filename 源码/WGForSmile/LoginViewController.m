//
//  LoginViewController.m
//  WGForSmile
//
//  Created by tarena on 15/11/7.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import <BmobSDK/Bmob.h>
@interface LoginViewController ()
@property (nonatomic,strong) UITextField * nameTextField;
@property (nonatomic,strong) UITextField * pwdTextField;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    //显示隐藏的navi
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    //加对应的登录按钮
    UIButton* button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor=[UIColor blueColor];
    [button setTitle:@"登录" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(back2Left:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    //控件默认的autoResing属性 有左 上 两条红线 会自动翻译约束
    //这会导致错误的发生 需要关闭
    button.translatesAutoresizingMaskIntoConstraints=NO;
    NSLayoutConstraint* btn2viewleft=[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:50];
    NSLayoutConstraint* btn2viewright=[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:-50];
    NSLayoutConstraint* btn2viewtop=[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:300];
    NSLayoutConstraint* btnheight=[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:30];
    [self.view addConstraints:@[btn2viewleft,btn2viewright,btn2viewtop,btnheight]];
    //帐号 邮箱
    UITextField* nameTextField=[UITextField new];
    nameTextField.placeholder=@"帐号/邮箱";
    nameTextField.borderStyle=UITextBorderStyleRoundedRect;
    nameTextField.translatesAutoresizingMaskIntoConstraints=NO;
    [self.view addSubview:nameTextField];
    NSLayoutConstraint* name2viewleft=[NSLayoutConstraint constraintWithItem:nameTextField attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:50];
    NSLayoutConstraint* name2viewright=[NSLayoutConstraint constraintWithItem:nameTextField attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:-50];
    NSLayoutConstraint* name2viewtop=[NSLayoutConstraint constraintWithItem:nameTextField attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:120];
    [self.view addConstraints:@[name2viewleft,name2viewright,name2viewtop]];
    UITextField* pwdTextField=[UITextField new];
    pwdTextField.placeholder=@"密码";
    pwdTextField.borderStyle=UITextBorderStyleRoundedRect;
    pwdTextField.translatesAutoresizingMaskIntoConstraints=NO;
    pwdTextField.secureTextEntry=YES;
    [self.view addSubview:pwdTextField];
    NSLayoutConstraint* pwd2viewleft=[NSLayoutConstraint constraintWithItem:pwdTextField attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:50];
    NSLayoutConstraint* pwd2viewright=[NSLayoutConstraint constraintWithItem:pwdTextField attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:-50];
    NSLayoutConstraint* pwd2viewtop=[NSLayoutConstraint constraintWithItem:pwdTextField attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:200];
    [self.view addConstraints:@[pwd2viewleft,pwd2viewright,pwd2viewtop]];
    //给两个框属性引用
    self.nameTextField=nameTextField;
    self.pwdTextField=pwdTextField;
    
    //忘记密码
    UIButton* buttonmisskey=[UIButton buttonWithType:UIButtonTypeCustom];
    [buttonmisskey setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [buttonmisskey setTitle:@"忘记密码" forState:UIControlStateNormal];
    [buttonmisskey addTarget:self action:@selector(gotomisskey:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonmisskey];
    //控件默认的autoResing属性 有左 上 两条红线 会自动翻译约束
    //这会导致错误的发生 需要关闭
    buttonmisskey.translatesAutoresizingMaskIntoConstraints=NO;
    NSLayoutConstraint* btnmisskey2viewleft=[NSLayoutConstraint constraintWithItem:buttonmisskey attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:20];
    NSLayoutConstraint* btnmisskey2viewtop=[NSLayoutConstraint constraintWithItem:buttonmisskey attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:button attribute:NSLayoutAttributeBottom multiplier:1 constant:20];
    NSLayoutConstraint* btnmisskeyheight=[NSLayoutConstraint constraintWithItem:buttonmisskey attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:30];
    NSLayoutConstraint* btnmisskeywidth=[NSLayoutConstraint constraintWithItem:buttonmisskey attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1 constant:80];
    [self.view addConstraints:@[btnmisskey2viewleft,btnmisskey2viewtop,btnmisskeyheight,btnmisskeywidth]];
    
    //注册按钮
    UIButton* buttongetuser=[UIButton buttonWithType:UIButtonTypeCustom];
    [buttongetuser setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [buttongetuser setTitle:@"注册用户" forState:UIControlStateNormal];
    [buttongetuser addTarget:self action:@selector(getuser:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttongetuser];
    //控件默认的autoResing属性 有左 上 两条红线 会自动翻译约束
    //这会导致错误的发生 需要关闭
    buttongetuser.translatesAutoresizingMaskIntoConstraints=NO;
    NSLayoutConstraint* btngetuser2viewright=[NSLayoutConstraint constraintWithItem:buttongetuser attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:-20];
    NSLayoutConstraint* btngetuser2viewtop=[NSLayoutConstraint constraintWithItem:buttongetuser attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:button attribute:NSLayoutAttributeBottom multiplier:1 constant:20];
    NSLayoutConstraint* btngetuserheight=[NSLayoutConstraint constraintWithItem:buttongetuser attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:buttonmisskey attribute:NSLayoutAttributeHeight multiplier:1 constant:0];;
    NSLayoutConstraint* btngetuserwidth=[NSLayoutConstraint constraintWithItem:buttongetuser attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:buttonmisskey attribute:NSLayoutAttributeWidth multiplier:1 constant:0];
    [self.view addConstraints:@[btngetuser2viewright,btngetuser2viewtop,btngetuserheight,btngetuserwidth]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark---登录成功返回主页
-(void)back2Left:(UIButton*)sender
{
    if ([self.nameTextField.text isEqualToString:@""]) {
        self.nameTextField.placeholder=@"用户名不能为空";
        return;
    }
    if ([self.pwdTextField.text isEqualToString:@""]) {
        self.pwdTextField.placeholder=@"密码不能为空";
        return;
    }
    [BmobUser loginWithUsernameInBackground:self.nameTextField.text password:self.pwdTextField.text block:^(BmobUser *user, NSError *error) {
        if (user) {
            BmobUser* bUser=[BmobUser getCurrentUser];
            [bUser setObject:[NSNumber numberWithBool:YES] forKey:@"isLogin"];
            [bUser updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                if (!error) {
                    [self.delegate refresh];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }];
        }
        else
        {
            self.nameTextField.text=@"";
            self.pwdTextField.text=@"";
            self.nameTextField.placeholder=@"用户名或密码错误";
        }
        
    }];
//    BmobUser* bUser=[BmobUser getCurrentUser];
//    NSLog(@"%@",bUser);
//    if (bUser) {
//    }
//    else
//    {
//        NSLog(@"111");
//    }
}
#pragma mark---前往忘记密码页
-(void)gotomisskey:(UIButton*)sender
{
    NSLog(@"忘记密码");
}
#pragma mark---前往注册用户页
-(void)getuser:(UIButton*)sender
{
    NSLog(@"前往注册");
    [self.navigationController pushViewController:[RegisterViewController new] animated:YES];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//点击屏幕空白处 收起键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


@end
