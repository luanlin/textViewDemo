//
//  LALCustomTextView.h
//  LALTextViewDemo
//
//  Created by 卢安林 on 2016/11/16.
//  Copyright © 2016年 LAL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LALPlaceholderTextView.h"

typedef NS_ENUM(NSUInteger, ClearButtonType) {
    ClearButtonNeverAppear,     // 默认隐藏
    ClearButtonAppearWhenEditing,   // 编辑时显示
    ClearButtonAppearAlways,        // 一直显示
};
@protocol HKCustomTextViewDelegate <NSObject>

-(void)textViewDidChange:(UITextView *)textView;

@end

@interface LALCustomTextView : UIView
@property (nonatomic,assign)id delegate;
@property (nonatomic,assign)ClearButtonType clearButtonType;
//设置是否显示输入字数
- (void)setTextCountLabelHidden:(BOOL)hidden;
//设置显示的文字以及输入最多字数
- (void)setPlaceholder:(NSString *)placeText
           contentText:(NSString *)contentText
          maxTextCount:(NSUInteger)maxTextCount;
@end
