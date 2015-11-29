//
//  EditViewController.h
//  WGForSmile
//
//  Created by tarena on 15/11/9.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EditViewControllerDelegate <NSObject>

-(void)addText:(NSString*)didEditText andin:(NSInteger)index;
-(void)addText:(NSString *)didAddText;

@end

@interface EditViewController : UIViewController
@property (nonatomic,strong) NSString * behaviour;
@property (nonatomic,copy) NSString* textViewString;
@property (nonatomic,unsafe_unretained) NSInteger textIndex;
@property (nonatomic) id<EditViewControllerDelegate> delegate;

@end
