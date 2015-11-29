//
//  MyGameViewController.m
//  uiday0405
//
//  Created by tarena on 15/11/13.
//  Copyright © 2015年 tarena. All rights reserved.
//
#define kScreenSize           [[UIScreen mainScreen] bounds].size
#define kScreenWidth          [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight         [[UIScreen mainScreen] bounds].size.height
#define x  (kScreenWidth-40)/8

#import "MyGameViewController.h"
#import "Game.h"
@interface MyGameViewController ()
@property (strong,nonatomic) Game* game;
@property (nonatomic,strong) NSArray * buttons;
@end

@implementation MyGameViewController

-(NSArray *)buttons
{
    if (!_buttons) {
        NSMutableArray* array=[NSMutableArray array];
        for (int i=0; i<8; i++) {
            for (int j=0; j<6; j++) {
                UIButton* button=[UIButton buttonWithType:UIButtonTypeCustom];
                [button setBackgroundImage:[UIImage imageNamed:@"cardfront"] forState:UIControlStateNormal];
                button.frame=CGRectMake(20+i*x,64+j*x, x, x);
                [button addTarget:self action:@selector(touchcard:) forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:button];
                [array addObject:button];
            }
        }
        _buttons=[array copy];
    }
    return _buttons;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor greenColor];
    self.game=[[Game alloc]initWithCardCount:self.buttons.count];
    [self showcards];
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(nextcolor:) userInfo:nil repeats:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchcard:(UIButton*)sender
{
    NSUInteger i=[self.buttons indexOfObject:sender];
    //NSLog(@"%ld",i);
    [self.game tapCardAtIndex:i];
    //sender.selected=YES; 疑问如何让其他的按钮不是选中状态！！！
    [self showcards];//update
}

//- (IBAction)touchcard:(UIButton *)sender {
//    NSUInteger i=[self.buttons indexOfObject:sender];
//    NSLog(@"%ld",i);
//    [self.game tapCardAtIndex:i];
//    //sender.selected=YES; 疑问如何让其他的按钮不是选中状态！！！
//    [self showcards];//update
//
//}
-(void)showcards
{
    for (NSUInteger i=0; i<self.buttons.count; i++) {
        Card* card=self.game.randomCards[i];
        UIButton* button=self.buttons[i];
        [button setTitle:card.suit forState:UIControlStateNormal];
        if (card.matched) {
            [button setTitle:@"" forState:UIControlStateNormal];
        }
        if (card.selected) {//这个解决办吧比较笨拙
            [button setBackgroundImage:nil/*[UIImage imageNamed:@"cardback"] */forState:UIControlStateNormal];
        }
        else{
            [button setBackgroundImage:[UIImage imageNamed:@"cardfront"] forState:UIControlStateNormal];
        }
        button.hidden=card.matched;
        button.enabled=!card.matched;
    }
}

-(void)nextcolor:(id)sender
{
    self.view.backgroundColor=[UIColor colorWithRed:arc4random_uniform(100) / 100.f green:arc4random_uniform(100) / 100.f blue:arc4random_uniform(100) / 100.f alpha:1.0f];
}

@end
