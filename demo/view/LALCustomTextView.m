//
//  LALCustomTextView.m
//  LALTextViewDemo
//
//  Created by 卢安林 on 2016/11/16.
//  Copyright © 2016年 LAL. All rights reserved.
//

#import "LALCustomTextView.h"
@interface LALCustomTextView()<UITextViewDelegate>
@property (strong, nonatomic) IBOutlet LALPlaceholderTextView *textView;
@property (strong, nonatomic) IBOutlet UIButton *clearButton;

@property (strong, nonatomic) IBOutlet UILabel *countLabel;
@property (nonatomic,assign) NSUInteger maxTextCount;

@end
@implementation LALCustomTextView
-(void)awakeFromNib
{
    [super awakeFromNib];
    self.textView.delegate = self;
}

-(void)setTextCountLabelHidden:(BOOL)hidden
{
    _countLabel.hidden = hidden;
}

-(void)setPlaceholder:(NSString *)placeText contentText:(NSString *)contentText maxTextCount:(NSUInteger)maxTextCount{
    
    _textView.text = contentText;
    _maxTextCount = maxTextCount;
    if (placeText.length > 0) {
        self.textView.placeholder = placeText;
    }
    else {
        self.textView.placeholder = [NSString stringWithFormat:@"请输入您的内容, %ld字以内", _maxTextCount];
    }
    [self textViewDidChange:_textView];
}
-(void)textViewDidChange:(UITextView *)textView
{
    [self textViewTextLengthChange:textView.text.length];
    
    self.maxTextCount = 60;
    
    NSString *toBeString = textView.text;
    
    NSString *lang = [(UITextInputMode*)[[UITextInputMode activeInputModes] firstObject] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textView markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length >= self.maxTextCount) {
                textView.text = [toBeString substringToIndex:self.maxTextCount];
            }
            self.countLabel.text=[NSString stringWithFormat:@"(%lu/%@)",(unsigned long)_textView.text.length, @(self.maxTextCount)];
            [self changeTextWithTextColor:[UIColor orangeColor] OfLabel:self.countLabel withLocation:1 andLength:self.countLabel.text.length-5];
            
            
        } // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length >= self.maxTextCount) {
            textView.text = [toBeString substringToIndex:self.maxTextCount];
        }
        self.countLabel.text=[NSString stringWithFormat:@"(%lu/%@)",(unsigned long)_textView.text.length, @(self.maxTextCount)];
        [self changeTextWithTextColor:[UIColor orangeColor] OfLabel:self.countLabel withLocation:1 andLength:self.countLabel.text.length-5];
    }
    
    if ([_delegate respondsToSelector:@selector(textViewDidChange:)]) {
        [_delegate textViewDidChange:textView];
    }
}
- (void)setClearButtonType:(ClearButtonType)clearButtonType
{
    _clearButtonType = clearButtonType;
}
- (void)textViewTextLengthChange:(NSInteger)length
{
    
    
    if ((length == 0 && _clearButtonType == ClearButtonAppearWhenEditing) ||
        _clearButtonType == ClearButtonNeverAppear) {
        _clearButton.hidden = YES;
    }
    else if ((length > 0 && _clearButtonType == ClearButtonAppearWhenEditing) || _clearButtonType == ClearButtonAppearAlways){
        _clearButton.hidden = NO;
    }
    else {
        _clearButton.hidden = YES;
    }
}


- (IBAction)clearButtonClicked:(id)sender {
    
    _textView.text = nil;
}
/**
 *  改变label部分字体颜色
 *
 */
-(NSMutableAttributedString *)changeTextWithTextColor:(UIColor *)color OfLabel:(UILabel *)label withLocation:(NSInteger)loc andLength:(NSInteger)len
{
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:label.text];
    //改变label某一部分字体颜色
    [string addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(loc, len)];
    label.attributedText = string;
    
    return string;
    
}
@end
