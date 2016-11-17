//
//  LALPlaceholderTextView.m
//  LALTextViewDemo
//
//  Created by 卢安林 on 2016/11/16.
//  Copyright © 2016年 LAL. All rights reserved.
//

#import "LALPlaceholderTextView.h"
#define placefonttag 1001
@interface LALPlaceholderTextView()

@property (nonatomic, strong) UILabel *placeholderLabel;

@property (nonatomic, strong) UILabel *wordCountLabel;

-(void)textChanged:(NSNotification*)notification;

@end
@implementation LALPlaceholderTextView

@synthesize placeholderLabel;
@synthesize placeholder = _placeholder;
@synthesize placeholderColor = _placeholderColor;
@synthesize placeholderFont = _placeholderFont;
-(void)setup
{
    [self setPlaceholderColor:[UIColor lightGrayColor]];
    self.placeholder = [NSString string];
    self.placeholderFont = self.font;
    self.maxLength = 100;
    self.showWordCountLabel = NO;
    [self addSubview:self.wordCountLabel];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
}

-(void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    [self setNeedsDisplay];
}

-(void)setPlaceholderFont:(UIFont *)placeholderFont
{
    _placeholderFont = placeholderFont;
    [self setNeedsDisplay];
}

-(void)setPlaceholderColor:(UIColor *)placeholderColor
{
    _placeholderColor = placeholderColor;
    [self setNeedsDisplay];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark UITextView properties
- (void)setText:(NSString *)text {
    [super setText:text];
    [self textChanged:nil];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)textChanged:(NSNotification *)notification
{
    //需要解释
    if([[self placeholder] length] == 0)
    {
        return;
    }
    
    if([[self text] length] == 0)
    {
        [[self viewWithTag:placefonttag] setAlpha:1];
    }
    else
    {
        [[self viewWithTag:placefonttag] setAlpha:0];
    }
    if(self.showWordCountLabel){
        self.wordCountLabel.text = [NSString stringWithFormat:@"%lu/%ld",(unsigned long)self.text.length,(long)self.maxLength];
        [self updateWordCountLabelFrame];
    }
    
}

- (void)updateWordCountLabelFrame
{
    if(self.text.length == 0){
        _wordCountLabel.hidden = YES;
    }else{
        _wordCountLabel.hidden = NO;
    }
    
    if(self.text.length > self.maxLength){
        self.wordCountLabel.textColor = [UIColor redColor];
    }else{
        self.wordCountLabel.textColor = [UIColor lightGrayColor];
    }
    
    CGSize size = [self sizeWithString:self.wordCountLabel.text font:[UIFont systemFontOfSize:14]];
    [self.wordCountLabel setFrame:CGRectMake(self.frame.size.width - size.width, self.frame.size.height - size.height, size.width, size.height)];
}



- (UILabel *)wordCountLabel
{
    if(!_wordCountLabel){
        _wordCountLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _wordCountLabel.font = [UIFont systemFontOfSize:13];
        _wordCountLabel.textColor = [UIColor lightGrayColor];
    }
    return _wordCountLabel;
}


- (void)setShowWordCountLabel:(BOOL)showWordCountLabel
{
    _showWordCountLabel = showWordCountLabel;
    if(showWordCountLabel){
        [self updateWordCountLabelFrame];
        self.wordCountLabel.hidden = NO;
    }else{
        self.wordCountLabel.hidden = YES;
    }
    
}


- (void)drawRect:(CGRect)rect
{
    if( [[self placeholder] length] > 0 )
    {
        if ( placeholderLabel == nil )
        {
            placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,2,self.bounds.size.width,0)];
            placeholderLabel.lineBreakMode = NSLineBreakByWordWrapping;
            placeholderLabel.numberOfLines = 0;
            placeholderLabel.font = self.placeholderFont;
            placeholderLabel.backgroundColor = [UIColor clearColor];
            placeholderLabel.textColor = self.placeholderColor;
            placeholderLabel.alpha = 0;
            placeholderLabel.tag = placefonttag;
            [self addSubview:placeholderLabel];
        }
        
        placeholderLabel.text = [self.placeholder stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        [placeholderLabel sizeToFit];
        [self sendSubviewToBack:placeholderLabel];
    }
    
    if( [[self text] length] == 0 && [[self placeholder] length] > 0 )
    {
        [[self viewWithTag:placefonttag] setAlpha:1];
    }
    self.textContainerInset = UIEdgeInsetsMake(1, - 5, 0, 0);
    [super drawRect:rect];
}


-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{

    return YES;
    
}
/******label随字体改变宽度******/
- (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)//限制最大高度
                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin//采用换行模式
                                    attributes:@{NSFontAttributeName: font}//传人的字体字典
                                       context:nil];
    return rect.size;
}
@end
