//
//  ViewController.m
//  demo
//
//  Created by 卢安林 on 2016/11/16.
//  Copyright © 2016年 LAL. All rights reserved.
//

#import "ViewController.h"
#import "LALCustomTextView.h"
@interface ViewController ()

@property (nonatomic,copy)NSString *inputText;//要输入的内容

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"textView";
    _inputText = @"";
    //textView
    LALCustomTextView *customTextView =[[NSBundle mainBundle] loadNibNamed:@"LALCustomTextView" owner:self options:nil].lastObject;
    
    [self.view addSubview:customTextView];
    customTextView.delegate = self;
    customTextView.clearButtonType = ClearButtonAppearWhenEditing;
    [customTextView setPlaceholder:@"编辑新通知,60字以内..." contentText:_inputText maxTextCount:60];
    __weak typeof (self) weakSelf = self;
    customTextView.frame = CGRectMake(weakSelf.view.frame.origin.x, 0, weakSelf.view.frame.size.width, 200);
    
}




@end
