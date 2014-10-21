//
//  BuyTagController.m
//  PEM
//
//  Created by tianj on 14-10-14.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "BuyTagController.h"
#import "RemindView.h"

@interface BuyTagController ()

@end

@implementation BuyTagController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HexRGB(0xffffff);
    self.title = @"购买标签";
    _currentCount = 0;
    space = 20;
    bottomSpace = kHeight-64-149;
    currentRow = 0;
    x =20;
    _currentCount = 0;
    _isDelete = NO;
    _allTagArray = [[NSMutableArray alloc] initWithCapacity:0];

    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight-64)];
    [self.view addSubview:_scrollView];
    _scrollView.backgroundColor = HexRGB(0xffffff);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [_scrollView setContentSize:CGSizeMake(kWidth, kHeight-64)];
    [self addNavBarButton];
    [self addView];
    
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDown)];
    
    // Do any additional setup after loading the view.
}

//点击事件
- (void)tapDown
{
    [addField resignFirstResponder];
}


#pragma mark textField_delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    isKeyboardShow = YES;
    
    CGFloat distanse = _scrollView.contentSize.height-(bottomView.frame.origin.y+bottomView.frame.size.height);
    if (distanse < 250) {
        [UIView animateWithDuration:0.2 animations:^{
            [_scrollView setContentSize:CGSizeMake(kWidth,_scrollView.contentSize.height+150)];
            //            _scrollView.contentOffset = contentOffset;
        }];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    isKeyboardShow = NO;
    [UIView animateWithDuration:0.2 animations:^{
        if (bottomView.frame.origin.y+bottomSpace <= kHeight-64) {
            [_scrollView setContentSize:CGSizeMake(kWidth,kHeight-64)];
        }
        if (bottomView.frame.origin.y > 149) {
            [_scrollView setContentSize:CGSizeMake(kWidth,bottomView.frame.origin.y+bottomSpace)];
        }
    }];
//    if (_iPhone4) {
//        [UIView animateWithDuration:0.2 animations:^{
//            _scrollView.contentOffset = contentOffset;
//        }];
//    }
//    if (_iPhone5) {
//        [UIView animateWithDuration:0.2 animations:^{
//            _scrollView.contentOffset = contentOffset;
//        }];
//    }
//    [_scrollView removeGestureRecognizer:tap];
//    
}




- (void)addView{
    UIImageView *myTagImg = [[UIImageView alloc] initWithFrame:CGRectMake(19, 20, 20, 16)];
    myTagImg.image = [UIImage imageNamed:@"mytags"];
    [_scrollView addSubview:myTagImg];
    
    UILabel *hotLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 20,160, 16)];
    hotLabel.text = @"我的订阅标签:";
    hotLabel.textColor = HexRGB(0x3a3a3a);
    hotLabel.font = [UIFont systemFontOfSize:PxFont(24)];
    [_scrollView addSubview:hotLabel];
    
    UIButton *managerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    managerBtn.frame =CGRectMake(kWidth-25-60, 19, 80, 16);
    [managerBtn setTitle:@"【管理】" forState:UIControlStateNormal];
    [managerBtn setTitleColor:HexRGB(0x3a3a3a) forState:UIControlStateNormal];
    managerBtn.backgroundColor = [UIColor clearColor];
    managerBtn.tag = 1000;
    [managerBtn addTarget:self action:@selector(subButtonDown:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:managerBtn];
    
    
    bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 149, kWidth,160)];
    [_scrollView addSubview:bottomView];
    UIImageView *addHotImg = [[UIImageView alloc] initWithFrame:CGRectMake(20,29, 20, 16)];
    addHotImg.image = [UIImage imageNamed:@"addtags.png"];
    [bottomView addSubview:addHotImg];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(20,0, kWidth-40, 1)];
    lineView.backgroundColor = HexRGB(0xced2d8);
    [bottomView addSubview:lineView];
    
    
    UILabel *addTagLabel = [[UILabel alloc] initWithFrame:CGRectMake(45,29,160, 16)];
    addTagLabel.text = @"购买标签:";
    addTagLabel.textColor = HexRGB(0x3a3a3a);
    addTagLabel.font = [UIFont systemFontOfSize:PxFont(24)];
    [bottomView addSubview:addTagLabel];
    
    
    addField = [[UITextField alloc] initWithFrame:CGRectMake(20,63, kWidth-40, 35)];
    addField.delegate = self;
    addField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    addField.placeholder = @"请输入您要购买的标签";
    addField.layer.borderColor = HexRGB(0xced2d8).CGColor;
    addField.layer.borderWidth = 1.0f;
    [bottomView addSubview:addField];
    
    addBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    addBtn.frame = CGRectMake(20,127, kWidth-40, 35);
    [addBtn setTitle:@"添 加" forState:UIControlStateNormal];
    addBtn.tag = 1001;
    [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addBtn setBackgroundImage:[UIImage imageNamed:@"finish.png"] forState:UIControlStateNormal];
    [addBtn setBackgroundImage:[UIImage imageNamed:@"finish_pre.png"] forState:UIControlStateHighlighted];
    [addBtn addTarget:self action:@selector(subButtonDown:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:addBtn];
    
}
- (void)addNavBarButton{
    // 创建按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    // 设置普通背景图片
    [btn setTitle:@"购买" forState:UIControlStateNormal];
    [btn setTitleColor:HexRGB(0x3a3a3a) forState:UIControlStateNormal];
    // 设置尺寸
    btn.frame = CGRectMake(10, 10,52, 24);
    [btn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)rightBtnClick
{
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [addField resignFirstResponder];
    return YES;
}




- (void)imageClicked:(ProImageView *)image
{
    if (_isDelete) {
        [_allTagArray removeObjectAtIndex:image.tag-2000];
        for (UIView *subView in _scrollView.subviews) {
            if ([subView isKindOfClass:[SubTagButton class]]) {
                [subView removeFromSuperview];
            }
        }
        currentRow =0;
        _currentCount = 0 ;
        x=20;
        NSMutableArray *array = [NSMutableArray arrayWithArray:_allTagArray];
        [_allTagArray removeAllObjects];
        for (int i = 0; i < [array count]; i++) {
            SubTagButton *btn = [array objectAtIndex:i];
            [self addBtnWithTitle:btn.title withId:btn.uid withMessage:btn.hasMesage messgaeNum:btn.messageNum];
        }
    }
}

//管理和添加按钮响应方法
- (void)subButtonDown:(UIButton *)btn{
    if (btn.tag == 1000) {
        if (_currentCount==0&&!_isDelete) {
            [RemindView showViewWithTitle:@"没有可管理的标签" location:MIDDLE];
        }else{
            _isDelete = !_isDelete;
            if (_isDelete) {
                [btn setTitle:@"【取消】" forState:UIControlStateNormal];
            }else{
                [btn setTitle:@"【管理】" forState:UIControlStateNormal];
                
            }
            for (UIView *subView in _scrollView.subviews) {
                if ([subView isKindOfClass:[SubTagButton class]]){
                    SubTagButton *btn = (SubTagButton *)subView;
                    btn.isDelete = !btn.isDelete;
                }
            }
        }

    }else if(btn.tag ==1001){
        if (_currentCount!=0){
            NSInteger count = 0;
            for (UIView *subView in _scrollView.subviews) {
                if ([subView isKindOfClass:[SubTagButton class]]) {
                    SubTagButton *btn = (SubTagButton *)subView;
                    if ([btn.title isEqualToString:addField.text]) {
                        break;
                    }
                    count++;
                }
            }
            if (count < _currentCount){
                [RemindView showViewWithTitle:@"该标签已存在" location:MIDDLE];
            }else{
                [self addBtnWithTitle:addField.text withId:nil withMessage:NO messgaeNum:nil];
                addField.text = @"";
            }
        }else{
            [self addBtnWithTitle:addField.text withId:nil withMessage:NO messgaeNum:nil];
            addField.text = @"";
        }

    }
}

//添加按钮
- (void)addBtnWithTitle:(NSString *)text withId:(NSString *)uid withMessage:(BOOL)hasMessage messgaeNum:(NSString *)num{
    if (text.length!=0) {
            NSInteger distace = 5;   //button文字离边框的距离
            if (text.length!=0){
                //20显示文字的高度
                CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(CGFLOAT_MAX,30) lineBreakMode:NSLineBreakByWordWrapping];
                if ((x+space+size.width+distace*2) > kWidth-25){
                    currentRow++;
                    x =20;
                }
                SubTagButton *btn = [[SubTagButton alloc] initWithFrame:CGRectMake(x, 60+currentRow*(30+14), size.width+distace*2,30)];
                btn.title = text;
                btn.uid = uid;
                btn.hasMesage = hasMessage;
                btn.isDelete = _isDelete;
                btn.messageNum = num;
                x+=space+size.width+distace*2;
                
                if (_isDelete){
                    btn.isDelete = YES;
                }
                NSInteger count = 0;
                if (_allTagArray.count!=0) {
                    count = _allTagArray.count;
                }
                if (btn.hasMesage) {
                    btn.delegate = self;
                }
                btn.delegate = self;
                btn.tag = 2000+count;
                [_scrollView addSubview:btn];
                [_allTagArray addObject:btn];
                [self moveBottomView];
                _currentCount++;
        }
    }
}

- (void)moveBottomView{
    CGRect bottomFrame = bottomView.frame;
    if (currentRow >=1) {
        bottomFrame.origin.y = 55 + (currentRow+1)*(30+14)-14+20;//40为热门标签的底坐标，20为button的高度，10为上下button的间距
        if (!_isDelete) {
            [UIView animateWithDuration:0.2 animations:^{
                bottomView.frame = bottomFrame;
            }];
        }else{
            bottomView.frame = bottomFrame;
        }
    }else{
        CGRect bottomFrame = bottomView.frame;
        bottomFrame.origin.y = 149;   //40为热门标签的底坐标，20为button的高度，10为上下button的间距
        if (!_isDelete) {
            [UIView animateWithDuration:0.2 animations:^{
                bottomView.frame = bottomFrame;
            }];
        }else{
            bottomView.frame = bottomFrame;
        }
    }
    if (isKeyboardShow) {
        CGFloat distanse = _scrollView.contentSize.height-(bottomView.frame.origin.y+bottomView.frame.size.height);
        if (distanse < 250) {
            [UIView animateWithDuration:0.2 animations:^{
                [_scrollView setContentSize:CGSizeMake(kWidth,_scrollView.contentSize.height+50)];
                //            _scrollView.contentOffset = contentOffset;
            }];
        }
    }else{
        if (bottomView.frame.origin.y+bottomSpace <= kHeight-64) {
            [_scrollView setContentSize:CGSizeMake(kWidth,kHeight-64)];
        }
        if (bottomView.frame.origin.y > 149) {
            [_scrollView setContentSize:CGSizeMake(kWidth,bottomView.frame.origin.y+bottomSpace)];
        }
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
