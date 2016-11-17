//
//  LALPlaceholderTextView.h
//  LALTextViewDemo
//
//  Created by 卢安林 on 2016/11/16.
//  Copyright © 2016年 LAL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LALPlaceholderTextView : UITextView

@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, strong) UIColor *placeholderColor;
@property (nonatomic, strong) UIFont *placeholderFont;

//允许输入的最大长度
@property (nonatomic, assign) NSInteger maxLength;
//是否显示 计数器 label
@property (nonatomic, assign) BOOL showWordCountLabel;

@end
