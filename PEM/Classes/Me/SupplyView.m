//
//  SupplyView.m
//  PEM
//
//  Created by tianj on 14-8-22.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "SupplyView.h"
#import "AdaptationSize.h"

#define kAlphaNum @"0123456789-\n"

@implementation SupplyView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        CGFloat width = [[UIScreen mainScreen] bounds].size.width-(24+23.5);

        UIView *bgView1 = [[UIView alloc] initWithFrame:CGRectMake(24,11, width, 105)];
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
        _categoryView.nameLabel.text = @"分 类";
        _categoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 0,width-80, 35)];
        _categoryLabel.backgroundColor = [UIColor clearColor];
        [_categoryView addSubview:_categoryLabel];
        
        UIImageView *img1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_Jump_Black_btn.png"]];
        img1.frame = CGRectMake(width-10-7, 11, 7, 13);
        [_categoryView addSubview:img1];

        UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn1.frame = CGRectMake(0, 0, width, 35);
        btn1.backgroundColor = [UIColor clearColor];
        btn1.tag = 9000;
        [btn1 addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_categoryView addSubview:btn1];
        [bgView1 addSubview:_categoryView];
        
        
        _areaView = [[CellView alloc] initWithFrame:CGRectMake(0, 35, width, 35)];
        _areaView.nameLabel.text = @"区 域";
        _areaLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 0,width-80, 35)];
        _areaLabel.backgroundColor = [UIColor clearColor];
        [_areaView addSubview:_areaLabel];
        
        UIImageView *img2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_Jump_Black_btn.png"]];
        img2.frame = CGRectMake(width-10-7, 11, 7, 13);
        [_areaView addSubview:img2];

        UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn2.frame = CGRectMake(0, 0,width,35);
        btn2.backgroundColor = [UIColor clearColor];
        btn2.tag = 9001;
        [btn2 addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_areaView addSubview:btn2];
        [bgView1 addSubview:_areaView];
        
        
        
        _titleView = [[CellView alloc] initWithFrame:CGRectMake(0, 70, width, 35)];
        _titleView.nameLabel.text = @"标 题";
        _titleTextField = [[UITextField alloc] initWithFrame:CGRectMake(60, 0,width-90, 35)];
        _titleTextField.tag = TITLE_TYPE;
        _titleTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _titleTextField.font =[UIFont systemFontOfSize:PxFont(20)];
        _titleTextField.placeholder = @"15字以内";
        _titleTextField.delegate = self;
        [_titleView addSubview:_titleTextField];
        [bgView1 addSubview:_titleView];

        
        
        UIView *bgView2 = [[UIView alloc] initWithFrame:CGRectMake(24, 137, width, 140)];
        bgView2.backgroundColor = HexRGB(0xffffff);
        bgView2.layer.masksToBounds = YES;
        bgView2.layer.cornerRadius = 6.0;
        bgView2.layer.borderColor = HexRGB(0xd5d5d5).CGColor;
        bgView2.layer.borderWidth = 0.5f;
        for (int i =1;i<4; i++) {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 35*i, width,0.5)];
            lineView.backgroundColor = HexRGB(0xd5d5d5);
            [bgView2 addSubview:lineView];
        }
        [self addSubview:bgView2];
        
        _priceView = [[CellView alloc] initWithFrame:CGRectMake(0, 0, width, 35)];
        _priceView.nameLabel.text = @"价    格";
        UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(width-10-20, 0, 20, 35)];
        priceLabel.text = @"元";
        _priceView.lineView.frame = CGRectMake(70,(_priceView.frame.size.height-20)/2, 1, 20);
        _priceView.nameLabel.frame =CGRectMake(5,0,65,35);
        priceLabel.backgroundColor = [UIColor clearColor];
        [_priceView addSubview:priceLabel];
        _priceTextField = [[UITextField alloc] initWithFrame:CGRectMake(75, 0,width-75-20, 35)];
        _priceTextField.delegate = self;
        _priceTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _priceTextField.keyboardType = UIKeyboardTypeNumberPad;
        _priceTextField.font = [UIFont systemFontOfSize:PxFont(20)];
        _priceTextField.tag = PRICE_TYPE;
        [_priceView addSubview:_priceTextField];
        [bgView2 addSubview:_priceView];
        
        _unitView = [[CellView alloc] initWithFrame:CGRectMake(0,35, width, 35)];
        _unitView.lineView.frame = CGRectMake(70,(_unitView.frame.size.height-20)/2, 1, 20);
        _unitView.nameLabel.text = @"单    位";
        _unitView.nameLabel.frame =CGRectMake(5,0,65,35);

        _unitField = [[UITextField alloc] initWithFrame:CGRectMake(75, 0, _unitView.frame.size.width-75, 35)];
        _unitField.tag = UNIT_TYPE;
        _unitField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _unitField.font = [UIFont systemFontOfSize:PxFont(20)];
        _unitField.placeholder = @"供应物品的计量单位";
        _unitField.delegate = self;
        [_unitView addSubview:_unitField];
        [bgView2 addSubview:_unitView];
        
        _standardView = [[CellView alloc] initWithFrame:CGRectMake(0,70, width, 35)];
        _standardView.nameLabel.text = @"起定标准";
        _standardView.lineView.frame = CGRectMake(70,(_standardView.frame.size.height-20)/2, 1, 20);
        _standardView.nameLabel.frame =CGRectMake(5,0,65,35);
        
        _standardTextField = [[UITextField alloc] initWithFrame:CGRectMake(75, 0, _standardView.frame.size.width-75, 35)];
        _standardTextField.tag = STANDARD_TYPE;
        _standardTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _standardTextField.keyboardType = UIKeyboardTypeNumberPad;
        _standardTextField.font = [UIFont systemFontOfSize:PxFont(20)];
        _standardTextField.delegate = self;
        [_standardView addSubview:_standardTextField];
        [bgView2 addSubview:_standardView];
        
        _descriptionView = [[CellView alloc] initWithFrame:CGRectMake(0, 105, width, 35)];
        _descriptionView.nameLabel.text = @"描    述";
        _descriptionView.lineView.frame = CGRectMake(70,(_descriptionView.frame.size.height-20)/2, 1, 20);
        _descriptionView.nameLabel.frame =CGRectMake(5,0,65,35);

        _descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 0,width-75-10-7, 35)];
        _descriptionLabel.backgroundColor = [UIColor clearColor];
        _descriptionLabel.textColor = HexRGB(0x666666);
        _descriptionLabel.font = [UIFont systemFontOfSize:PxFont(20)];
        _descriptionLabel.text = @"10字以上";
        [_descriptionView addSubview:_descriptionLabel];
        UIImageView *img4 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_Jump_Black_btn.png"]];
        img4.frame = CGRectMake(width-10-7, 11, 7, 13);
        [_descriptionView addSubview:img4];



        
        UIButton *btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn4.frame = CGRectMake(0, 0, width, 35);
        btn4.backgroundColor = [UIColor clearColor];
        btn4.tag = 9003;
        [btn4 addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_descriptionView addSubview:btn4];
        [bgView2 addSubview:_descriptionView];
        
                
        UIView *bgView3 = [[UIView alloc] initWithFrame:CGRectMake(24, 298, width, 105)];
        bgView3.backgroundColor = HexRGB(0xffffff);
        bgView3.layer.masksToBounds = YES;
        bgView3.layer.cornerRadius = 6.0;
        bgView3.layer.borderColor = HexRGB(0xd5d5d5).CGColor;
        bgView3.layer.borderWidth = 0.5f;
        for (int i =1;i<4; i++) {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 35*i, width,0.5)];
            lineView.backgroundColor = HexRGB(0xd5d5d5);
            [bgView3 addSubview:lineView];
        }
        [self addSubview:bgView3];
        
        
        
        _linkmanView = [[CellView alloc] initWithFrame:CGRectMake(0,0, width, 35)];
        _linkmanView.nameLabel.text = @"联系人";
        _linkmanView.lineView.frame = CGRectMake(55,(_linkmanView.frame.size.height-20)/2, 1, 20);
        _linkmanView.nameLabel.frame =CGRectMake(5,0,50,35);
        _linkManTextField = [[UITextField alloc] initWithFrame:CGRectMake(60, 0, _linkmanView.frame.size.width-60, 35)];
        _linkManTextField.tag = LINKMAN_TYPE;
        _linkManTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _linkManTextField.placeholder = @"2-4个字符";
        _linkManTextField.font = [UIFont systemFontOfSize:PxFont(20)];
        _linkManTextField.delegate = self;
        [_linkmanView addSubview:_linkManTextField];
        [bgView3 addSubview:_linkmanView];
        
        
        _phoneNumView = [[CellView alloc] initWithFrame:CGRectMake(0, 35, width, 35)];
        _phoneNumView.nameLabel.text = @"电   话";
        _phoneNumView.lineView.frame = CGRectMake(55,(_phoneNumView.frame.size.height-20)/2, 1, 20);
        _phoneNumView.nameLabel.frame =CGRectMake(5,0,50,35);
        _phoneNumTextField = [[UITextField alloc] initWithFrame:CGRectMake(60, 0, _phoneNumView.frame.size.width-60, 35)];
        _phoneNumTextField.tag = PHONENUM_TYPE;
        _phoneNumTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _phoneNumTextField.font = [UIFont systemFontOfSize:PxFont(20)];
        _phoneNumTextField.delegate = self;
        [_phoneNumView addSubview:_phoneNumTextField];
        [bgView3 addSubview:_phoneNumView];
        
        
        
        _imageView = [[CellView alloc] initWithFrame:CGRectMake(0,70, width, 35)];
        _imageView.nameLabel.text = @"图   片";
        _imageView.lineView.frame = CGRectMake(55,(_phoneNumView.frame.size.height-20)/2, 1, 20);
        _imageView.nameLabel.frame =CGRectMake(5,0,50,35);
        UILabel *imgLabel = [[UILabel alloc] initWithFrame:CGRectMake(60,0, 60, 35)];
        imgLabel.font = [UIFont systemFontOfSize:PxFont(20)];
        imgLabel.backgroundColor = [UIColor clearColor];
        imgLabel.text = @"一张";
        imgLabel.textColor = HexRGB(0x666666);
        [_imageView addSubview:imgLabel];
        UIImageView *img3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_Jump_Black_btn.png"]];
        img3.frame = CGRectMake(width-10-7, 11, 7, 13);
        [_imageView addSubview:img3];
        
        
        UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn3.frame = CGRectMake(0, 0,width, 35);
        btn3.backgroundColor = [UIColor clearColor];
        btn3.tag = 9002;
        [btn3 addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_imageView addSubview:btn3];
        [bgView3 addSubview:_imageView];

        
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(36,433, 150, 20)];
        label.text = @"是否上传3D图片";
        label.textColor = HexRGB(0x666666);
        label.font = [UIFont systemFontOfSize:PxFont(20)];
        label.backgroundColor = [UIColor clearColor];
        [self addSubview:label];
        
        UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        selectBtn.frame = CGRectMake(kWidth-33-25,426, 25, 25);
        selectBtn.tag = 3003;
        [selectBtn setBackgroundImage:[UIImage imageNamed:@"off.png"] forState:UIControlStateNormal];
        [selectBtn setBackgroundImage:[UIImage imageNamed:@"on.png"] forState:UIControlStateSelected];
        [selectBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:selectBtn];
        
        _remindView = [[UIView alloc] initWithFrame:CGRectMake(20, 460, kWidth-20*2, 30)];
        
        NSString *string = @"上传3D图片需要大量素材，发布成功后请等待我们与您联系，或现在";
        CGSize size = [AdaptationSize getSizeFromString:string Font:[UIFont systemFontOfSize:12] withHight:15 withWidth:CGFLOAT_MAX];
        
        CGSize btnSize = [AdaptationSize getSizeFromString:@"联系我们" Font:[UIFont systemFontOfSize:12] withHight:15 withWidth:CGFLOAT_MAX];

        
        UILabel *remindLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _remindView.frame.size.width, 30)];
        remindLabel.backgroundColor = [UIColor clearColor];
        remindLabel.numberOfLines = 0;
        remindLabel.text = string;
        remindLabel.font = [UIFont systemFontOfSize:12];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"联系我们" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        [button addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        button.tag = 3004;
        [_remindView addSubview:button];
        
        if (size.width<_remindView.frame.size.width) {
            remindLabel.frame = CGRectMake(0, 0, _remindView.frame.size.width, 15);
            if (size.width+btnSize.width>_remindView.frame.size.width) {
                button.frame = CGRectMake(0, 15, btnSize.width, 15);
            }else{
                button.frame = CGRectMake(size.width, 0, btnSize.width, 15);
            }
        }else{
            remindLabel.frame = CGRectMake(0, 0, _remindView.frame.size.width, 30);
            button.frame = CGRectMake(size.width-remindLabel.frame.size.width, 15, btnSize.width,15);
        }
    
        UIView *btnLine = [[UIView alloc] initWithFrame:CGRectMake(button.frame.origin.x,button.frame.origin.y+button.frame.size.height-1,btnSize.width,0.5)];
        btnLine.backgroundColor = [UIColor blueColor];
        [_remindView addSubview:btnLine];
        
        [_remindView addSubview:remindLabel];
        [self addSubview:_remindView];
        _remindView.hidden = YES;
        
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(20, 470, kWidth-40,1)];
        _lineView.backgroundColor = HexRGB(0xd5d5d5);
        [self addSubview:_lineView];
        
        _headImage = [[ProImageView alloc] initWithFrame:CGRectMake(kWidth/2-80/2,_lineView.frame.origin.y+10, 80, 80)];
        _headImage.hidden = YES;
        [self addSubview:_headImage];
        
        _publishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _publishBtn.frame = CGRectMake(24,_lineView.frame.origin.y+37,width, 35);
        [_publishBtn setTitle:@"发 布" forState:UIControlStateNormal];
        _publishBtn.titleLabel.font = [UIFont systemFontOfSize:PxFont(25)];
        [_publishBtn setBackgroundImage:[UIImage imageNamed:@"finish.png"] forState:UIControlStateNormal];
        [_publishBtn setBackgroundImage:[UIImage imageNamed:@"finish_pre.png"] forState:UIControlStateHighlighted];
        [_publishBtn setTitleColor:HexRGB(0xffffff) forState:UIControlStateNormal];
        _publishBtn.tag = 3002;
        [_publishBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_publishBtn];
        
        _isHide = YES;
      }
    return self;
}


//3d图片是否显示时的相关操作
- (void)setIsHide:(BOOL)isHide{
    _isHide = isHide;
    if (_isHide) {
        _remindView.hidden = YES;
        [UIView animateWithDuration:0.05 animations:^{
            _lineView.frame = CGRectMake(20,470, kWidth-40,1);
        }];
    }else{
        _remindView.hidden = NO;
        [UIView animateWithDuration:0.05 animations:^{
            _lineView.frame = CGRectMake(20, _remindView.frame.origin.y+_remindView.frame.size.height+10, kWidth-40,1);
       }];
    }
    [UIView animateWithDuration:0.05 animations:^{
        CGRect frame = _publishBtn.frame;
        if (_isExistImg) {
            _headImage.frame = CGRectMake(kWidth/2-80/2,_lineView.frame.origin.y+10, 80, 80);
            _publishBtn.frame = CGRectMake(frame.origin.x,_headImage.frame.origin.y+_headImage.frame.size.height+20,frame.size.width, frame.size.height);
        }else{
            CGRect frame = _publishBtn.frame;
            frame.origin.y = _lineView.frame.origin.y+37;
            _publishBtn.frame = CGRectMake(frame.origin.x,frame.origin.y,frame.size.width,frame.size.height);
        }
    }];
    CGRect frame = self.frame;
    frame.size.height = _publishBtn.frame.origin.y+_publishBtn.frame.size.height+20;
    self.frame = frame;
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


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSCharacterSet *cs;
    BOOL basic;
    switch (textField.tag) {
        case PRICE_TYPE:
        {
            cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789.\n"] invertedSet];
            NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
            basic = [string isEqualToString:filtered];
            if ([textField.text isEqualToString:@""]&&[string isEqualToString:@"."]) {
                return NO;
            }
            if ([textField.text rangeOfString:@"."].location != NSNotFound) {
                if ([string isEqualToString:@"."]) {
                    return NO;
                }
            }
            if (!basic) {
                return NO;
            }
        }
            break;
        case TITLE_TYPE:
        {
            NSUInteger length = textField.text.length;
            if (length>=30&&string.length > 0){
                return NO;
            }
        }
            break;
        case STANDARD_TYPE:
        {
            cs = [[NSCharacterSet characterSetWithCharactersInString:kAlphaNum] invertedSet];
            NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
            basic = [string isEqualToString:filtered];
            if (!basic) {
                return NO;
            }
        }
            break;
        case LINKMAN_TYPE:
        {
            
        }
            break;
        case PHONENUM_TYPE:
        {
            cs = [[NSCharacterSet characterSetWithCharactersInString:kAlphaNum] invertedSet];
            NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
            basic = [string isEqualToString:filtered];
            if (!basic) {
                return NO;
            }
        }
            break;
        default:
            break;
    }
    return YES;
}


- (void)textFieldDidEndEditing:(UITextField *)textField{
    if ([self.delegate respondsToSelector:@selector(textFieldEndEditting:)]){
        [self.delegate textFieldEndEditting:textField];
    }
}

- (void)btnClicked:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(buttonDown:)]){
        [self.delegate buttonDown:btn];
    }
}

- (void)reloadView{
//    self.categoryLabel.text = _supplyItem.categoryItem.name;
    
//    self.areaLabel.text = _supplyItem.area;
//    self.descriptionLabel.text = _supplyItem.description;
    CGRect frame = _publishBtn.frame;
    self.headImage.hidden = NO;
    _headImage.frame = CGRectMake(kWidth/2-80/2,_lineView.frame.origin.y+10, 80, 80);
    _publishBtn.frame = CGRectMake(frame.origin.x,_headImage.frame.origin.y+_headImage.frame.size.height+20,frame.size.width, frame.size.height);
    CGRect mFrame = self.frame;
    mFrame.size.height =_publishBtn.frame.origin.y+_publishBtn.frame.size.height+20;
    self.frame = mFrame;
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
