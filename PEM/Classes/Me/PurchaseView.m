//
//  PurchaseView.m
//  PEM
//
//  Created by tianj on 14-8-25.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "PurchaseView.h"
#import "FileManager.h"

@implementation PurchaseView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        CGFloat width = [[UIScreen mainScreen] bounds].size.width-(24+23.5);
        
        UIView *bgView1 = [[UIView alloc] initWithFrame:CGRectMake(24, 11, width, 105)];
        bgView1.backgroundColor = HexRGB(0xffffff);
        bgView1.layer.masksToBounds = YES;
        bgView1.layer.cornerRadius = 6.0;
        bgView1.layer.borderColor = HexRGB(0xd5d5d5).CGColor;
        bgView1.layer.borderWidth = 0.5f;
        for (int i =1;i<3; i++) {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 35*i, width, 0.5)];
            lineView.backgroundColor = HexRGB(0xd5d5d5);
            [bgView1 addSubview:lineView];
        }
        [self addSubview:bgView1];

        _categoryView = [[CellView alloc] initWithFrame:CGRectMake(0, 0, width, 35)];
        _categoryView.nameLabel.text = @"分  类";
        _categoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, _categoryView.frame.size.width-60, 35)];
        _categoryLabel.backgroundColor = [UIColor clearColor];
        [_categoryView addSubview:_categoryLabel];
        UIImageView *img1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_Jump_Black_btn.png"]];
        img1.frame = CGRectMake(width-10-7, 11, 7, 13);
        [_categoryView addSubview:img1];
        
        UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn1.frame = CGRectMake(0, 0, _categoryView.frame.size.width, _categoryView.frame.size.height);
        btn1.backgroundColor = [UIColor clearColor];
        btn1.tag = 10000;
        [btn1 addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_categoryView addSubview:btn1];
        [bgView1 addSubview:_categoryView];
        
        

        
        _titleView = [[CellView alloc] initWithFrame:CGRectMake(0, 35, width, 35)];
        _titleView.nameLabel.text = @"标  题";
        _titleTextField = [[UITextField alloc] initWithFrame:CGRectMake(60, 0, _titleView.frame.size.width-60, 35)];
        _titleTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _titleTextField.tag = PC_TITLE_TYPE;
        _titleTextField.font = [UIFont systemFontOfSize:PxFont(20)];
        _titleTextField.placeholder = @"15字以内";
        _titleTextField.delegate = self;
        [_titleView addSubview:_titleTextField];
        [bgView1 addSubview:_titleView];
        
        _descriptionView = [[CellView alloc] initWithFrame:CGRectMake(0, 70, width, 35)];
        _descriptionView.nameLabel.text = @"描  述";
        _descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, width-60-25, 35)];
        _descriptionLabel.font = [UIFont systemFontOfSize:PxFont(20)];
        _descriptionLabel.textColor = HexRGB(0x666666);
        _descriptionLabel.backgroundColor = [UIColor clearColor];
        _descriptionLabel.text = @"10字以上";
        [_descriptionView addSubview:_descriptionLabel];
        UIImageView *img2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_Jump_Black_btn.png"]];
        img2.frame = CGRectMake(width-10-7, 11, 7, 13);
        [_descriptionView addSubview:img2];

        UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn2.frame = CGRectMake(0, 0, _categoryView.frame.size.width, _categoryView.frame.size.height);
        btn2.backgroundColor = [UIColor clearColor];
        btn2.tag = 10001;
        [btn2 addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_descriptionView addSubview:btn2];
        [bgView1 addSubview:_descriptionView];
        
        UIView *bgView2 = [[UIView alloc] initWithFrame:CGRectMake(24, 137, width, 140)];
        bgView2.backgroundColor = HexRGB(0xffffff);
        bgView2.layer.masksToBounds = YES;
        bgView2.layer.cornerRadius = 6.0;
        bgView2.layer.borderColor = HexRGB(0xd5d5d5).CGColor;
        bgView2.layer.borderWidth = 0.5f;
        for (int i =1;i<4; i++) {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 35*i, width, 0.5)];
            lineView.backgroundColor = HexRGB(0xd5d5d5);
            [bgView2 addSubview:lineView];
        }
        [self addSubview:bgView2];

        _purchaseNum = [[CellView alloc] initWithFrame:CGRectMake(0, 0, width, 35)];
        _purchaseNum.lineView.frame = CGRectMake(70,(_purchaseNum.frame.size.height-20)/2, 1, 20);
        _purchaseNum.nameLabel.text = @"求购数量";
        _purchaseNum.nameLabel.frame =CGRectMake(5,0,65,35);
        _purchaseNumField = [[UITextField alloc] initWithFrame:CGRectMake(75, 0, _purchaseNum.frame.size.width-75, 35)];
        _purchaseNumField.tag = PC_PURCHASE_TYPE;
        _purchaseNumField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _purchaseNumField.keyboardType = UIKeyboardTypeNumberPad;
        _purchaseNumField.font = [UIFont systemFontOfSize:PxFont(20)];
        _purchaseNumField.placeholder = @"求购物品的数量";
        _purchaseNumField.delegate = self;
        [_purchaseNum addSubview:_purchaseNumField];
        [bgView2 addSubview:_purchaseNum];
        
        _unitView = [[CellView alloc] initWithFrame:CGRectMake(0,35, width, 35)];
        _unitView.lineView.frame = CGRectMake(70,(_purchaseNum.frame.size.height-20)/2, 1, 20);
        _unitView.nameLabel.text = @"单     位";
        _unitView.nameLabel.frame =CGRectMake(5,0,65,35);
        _unitField = [[UITextField alloc] initWithFrame:CGRectMake(75, 0, _purchaseNum.frame.size.width-75, 35)];
        _unitField.tag = PC_UNIT_TYPE;
        _unitField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _unitField.font = [UIFont systemFontOfSize:PxFont(20)];
        _unitField.placeholder = @"求购物品的计量单位";
        _unitField.delegate = self;
        [_unitView addSubview:_unitField];
        [bgView2 addSubview:_unitView];

        
        _linkmanView = [[CellView alloc] initWithFrame:CGRectMake(0, 70, width, 35)];
        _linkmanView.nameLabel.text = @"联 系 人";
        _linkmanView.lineView.frame = CGRectMake(70,(_linkmanView.frame.size.height-20)/2, 1, 20);
        _linkmanView.nameLabel.frame =CGRectMake(5,0,65,35);
        _linkManTextField = [[UITextField alloc] initWithFrame:CGRectMake(75, 0, _linkmanView.frame.size.width-75, 35)];
        _linkManTextField.tag = PC_LINKMAN_TYPE;
        _linkManTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _linkManTextField.placeholder = @"2-4个字符";
        _linkManTextField.font = [UIFont systemFontOfSize:PxFont(20)];
        _linkManTextField.delegate = self;
        [_linkmanView addSubview:_linkManTextField];
        [bgView2 addSubview:_linkmanView];
        
        _phoneNumView = [[CellView alloc] initWithFrame:CGRectMake(0, 105, width, 35)];
        _phoneNumView.nameLabel.text = @"电     话";
        _phoneNumView.lineView.frame = CGRectMake(70,(_phoneNumView.frame.size.height-20)/2, 1, 20);
        _phoneNumView.nameLabel.frame =CGRectMake(5,0,65,35);

        _phoneNumTextField = [[UITextField alloc] initWithFrame:CGRectMake(75, 0, _phoneNumView.frame.size.width-75, 35)];
        _phoneNumTextField.tag = PC_PHONENUM_TYPE;
        _phoneNumTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _phoneNumTextField.font = [UIFont systemFontOfSize:PxFont(20)];
        _phoneNumTextField.placeholder = @"请输入正确的手机号码";
        _phoneNumTextField.delegate = self;
        [_phoneNumView addSubview:_phoneNumTextField];
        [bgView2 addSubview:_phoneNumView];
        
        UIView *bgView3 = [[UIView alloc] initWithFrame:CGRectMake(24, 298, width, 35)];
        bgView3.backgroundColor = HexRGB(0xffffff);
        bgView3.layer.masksToBounds = YES;
        bgView3.layer.cornerRadius = 6.0;
        bgView3.layer.borderColor = HexRGB(0xd5d5d5).CGColor;
        bgView3.layer.borderWidth = 0.5f;
        for (int i =1;i<1; i++) {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 35*i, width, 0.5)];
            lineView.backgroundColor = HexRGB(0xd5d5d5);
            [bgView3 addSubview:lineView];
        }
        [self addSubview:bgView3];

        
        _markView = [[CellView alloc] initWithFrame:CGRectMake(0, 0, width, 35)];
        _markView.nameLabel.text = @"标  签";
        _markLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, _markView.frame.size.width-60-17, 35)];
        _markLabel.backgroundColor = [UIColor clearColor];
        [_markView addSubview:_markLabel];
        UIImageView *img3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_Jump_Black_btn.png"]];
        img3.frame = CGRectMake(width-10-7, 11, 7, 13);
        [_markView addSubview:img3];
        UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn3.frame = CGRectMake(0, 0, _categoryView.frame.size.width, _categoryView.frame.size.height);
        btn3.backgroundColor = [UIColor clearColor];
        btn3.tag = 10002;
        [btn3 addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_markView addSubview:btn3];
        [bgView3 addSubview:_markView];
        
        
        
        UIButton *publishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        publishBtn.frame = CGRectMake(24, 361,width, 35);
        [publishBtn setTitle:@"发 布" forState:UIControlStateNormal];
        publishBtn.titleLabel.font = [UIFont systemFontOfSize:PxFont(25)];
        [publishBtn setTitleColor:HexRGB(0xffffff) forState:UIControlStateNormal];
        [publishBtn setBackgroundImage:[UIImage imageNamed:@"finish.png"] forState:UIControlStateNormal];
        [publishBtn setBackgroundImage:[UIImage imageNamed:@"finish_pre.png"] forState:UIControlStateHighlighted];
        publishBtn.tag = 3001;
        [publishBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:publishBtn];
        
    }
    return self;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSCharacterSet *cs;
    BOOL basic;
    switch (textField.tag){
        case PC_TITLE_TYPE:
        {
            NSUInteger length = textField.text.length;
            if (length>=30&&string.length > 0){
                return NO;
            }
        }
            break;
        case PC_LINKMAN_TYPE:
        {
            
        }
            break;
        case PC_PHONENUM_TYPE:
        {
            cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789-\n"] invertedSet];
            NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
            basic = [string isEqualToString:filtered];
            if (!basic){
                return NO;
            }

        }
            break;
        case PC_PURCHASE_TYPE:
        {
            cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789\n"] invertedSet];
            NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
            basic = [string isEqualToString:filtered];
            NSUInteger length = textField.text.length;
            if (!basic||(length >= 12 && string.length > 0)){
                return NO;
            }
        }
        default:
            break;
    }
    return YES;
}


#pragma mark textField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if ([self.delegate respondsToSelector:@selector(textFieldBeganEditting:)]) {
        [self.delegate textFieldBeganEditting:textField];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if ([self.delegate respondsToSelector:@selector(textFieldEndEditting:)]) {
        [self.delegate textFieldEndEditting:textField];
    }
//    switch (textField.tag) {
//        case PC_TITLE_TYPE:
//        {
//            _purchaseItem.title = textField.text;
//        }
//            break;
//        case PC_LINKMAN_TYPE:
//        {
//            _purchaseItem.linkMan = textField.text;
//        }
//            break;
//        case PC_PHONENUM_TYPE:
//        {
//            _purchaseItem.phoneNum = textField.text;
//        }
//            break;
//        case PC_PURCHASE_TYPE:
//        {
//            _purchaseItem.purchaseNum = textField.text;
//        }
//        case PC_UNIT_TYPE:
//        {
//            _purchaseItem.unit = textField.text;
//        }
//        default:
//            break;
//    }
}



//- (void)reloadView{
//    self.categoryLabel.text = _purchaseItem.categoryItem.name;
//    self.descriptionLabel.text = _purchaseItem.description;
//    NSMutableString *tagStr = [NSMutableString stringWithString:@""];
//    for (int i = 0; i< self.purchaseItem.tagArray.count; i++) {
//        [tagStr appendString:[self.purchaseItem.tagArray objectAtIndex:i]];
//        if (i < [self.purchaseItem.tagArray count]-1) {
//            [tagStr appendString:@","];
//        }
//    }
//    self.markLabel.text = tagStr;
//}


- (void)btnClicked:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(buttonDown:)]) {
        [self.delegate buttonDown:btn];
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
