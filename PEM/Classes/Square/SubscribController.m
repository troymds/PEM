//
//  SubscribController.m
//  PEM
//
//  Created by tianj on 14-8-29.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "SubscribController.h"
#import "HttpTool.h"
#import "SystemConfig.h"
#import "TagItem.h"
#import "TagListController.h"
#import "RemindView.h"
#import "BuyTagController.h"
#import "PrivilegeController.h"



@interface SubscribController ()

@end

@implementation SubscribController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我的订阅";
    self.view.backgroundColor = HexRGB(0xffffff);
    // Do any additional setup after loading the view.
    
    
    space = 10;
    bottomSpace = kHeight-64-105;
    currentRow = 0;
    x =20;
    _currentCount = 0;
    _isDelete = NO;
    _dataArray =[NSMutableArray array];
    _allTagArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight-64)];
    [self.view addSubview:_scrollView];
    _scrollView.backgroundColor = HexRGB(0xffffff);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [_scrollView setContentSize:CGSizeMake(kWidth, kHeight-64)];
    
    remindLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, kWidth-40, 20)];
    remindLabel.backgroundColor = [UIColor clearColor];
    remindLabel.text = @"暂无收藏的标签";
    remindLabel.textColor = HexRGB(0x3a3a3a);
    remindLabel.hidden = YES;
    [_scrollView addSubview:remindLabel];
    if ([[SystemConfig sharedInstance].viptype isEqualToString:@"4"]) {
        _maxNum = LONG_MAX;
    }else{
        if ([SystemConfig sharedInstance].maxTagNum) {
            _maxNum = [SystemConfig sharedInstance].maxTagNum;
        }
    }
    [self addNavBarButton];
    [self loadData];
    [self addView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHiden) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillHiden
{
    isKeyboardShow = NO;
    [UIView animateWithDuration:0.2 animations:^{
        if (bottomView.frame.origin.y+bottomView.frame.size.height+40<= kHeight-64) {
            [_scrollView setContentSize:CGSizeMake(kWidth,kHeight-64)];
        }else{
            [_scrollView setContentSize:CGSizeMake(kWidth,bottomView.frame.origin.y+bottomView.frame.size.height+40)];
        }
    }];
}


- (void)tapDown{
    [addField resignFirstResponder];
}

- (void)addNavBarButton{
    // 创建按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    // 设置普通背景图片
    [btn setBackgroundImage:[UIImage imageNamed:@"right_save.png"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"right_save_pre.png"] forState:UIControlStateHighlighted];
    // 设置尺寸
    btn.frame = CGRectMake(10, 10,52, 23);
    [btn addTarget:self action:@selector(finish) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)finish{
    NSMutableArray *arr = [NSMutableArray array];
    for (UIView *subView in _scrollView.subviews){
        if ([subView isKindOfClass:[SubTagButton class]]){
            SubTagButton *btn = (SubTagButton *)subView;
            [arr addObject:btn.title];
        }
    }
    NSMutableString *tagStr = [NSMutableString stringWithString:@""];
    for (int i = 0; i < [arr count]; i++) {
        NSString *str = [arr objectAtIndex:i];
        if (i < [arr count]-1) {
            [tagStr appendString:[NSString stringWithFormat:@"%@,",str]];
        }else{
            [tagStr appendString:str];
        }
    }
    if (tagStr.length!=0){
        NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:tagStr,@"tags",[SystemConfig sharedInstance].company_id,@"company_id", nil];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.dimBackground = NO;
        [HttpTool postWithPath:@"saveTagList" params:param success:^(id JSON) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *dic = [result objectForKey:@"response"];
            if (dic) {
                NSInteger code = [[dic objectForKey:@"code"] integerValue];
                if (code == 100) {
                    [RemindView showViewWithTitle:@"保存成功" location:TOP];
                }else if(code ==101){
                    [RemindView showViewWithTitle:@"保存失败" location:TOP];
                }else if(code ==102){
                    [RemindView showViewWithTitle:[dic objectForKey:@"msg"] location:TOP];
                }
            }
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        }];
    }else{
        [RemindView showViewWithTitle:@"没有可保存的标签" location:MIDDLE];
    }
}

- (void)loadData{
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:[SystemConfig sharedInstance].company_id,@"company_id", nil];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"";
    [HttpTool postWithPath:@"getMyTagList" params:param success:^(id JSON) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",result);
        NSDictionary *dic = [result objectForKey:@"response"];
        if (dic) {
            if ([[dic objectForKey:@"code"] intValue] == 100) {
                //当data为空时  表示当前用户没订阅过标签 其剩余标签数即用户当前所能订阅的最大标签数
                if ([[dic objectForKey:@"data"] isKindOfClass:[NSNull class]]) {
                    remindLabel.hidden = NO;
                    if (![[SystemConfig sharedInstance].viptype isEqualToString:@"4"]) {
                        if (![SystemConfig sharedInstance].maxTagNum) {
                            if ([SystemConfig sharedInstance].vipInfo) {
                                _maxNum = [[SystemConfig sharedInstance].vipInfo.tag_num intValue];
                                [SystemConfig sharedInstance].maxTagNum = _maxNum;
                            }
                        }
                    }
                }else{
                    //当data不为空时,及用户订阅过标签 用户已经订阅的标签数加上剩余的标签数 就是当前用户所能订阅的最大标签数
                    NSArray *dataArr = [dic objectForKey:@"data"];
                    NSMutableArray *arr = [NSMutableArray array];
                    for (NSDictionary *dic in dataArr){
                        TagItem *item = [[TagItem alloc] initWithDictionary:dic];
                        [arr addObject:dic];
                        NSString *no_read = item.no_read;
                        if ([no_read intValue] > 100) {
                            no_read = @"99+";
                        }
                        [self addBtnWithTitle:item.name withId:item.uid withMessage:([item.no_read intValue] !=0) messgaeNum:no_read];
                        [_dataArray addObject:item];
                    }
                    if (![[SystemConfig sharedInstance].viptype isEqualToString:@"4"]) {
                        if (![SystemConfig sharedInstance].maxTagNum) {
                            if ([SystemConfig sharedInstance].vipInfo) {
                                _maxNum = [[SystemConfig sharedInstance].vipInfo.tag_num intValue]+[_dataArray count];
                                [SystemConfig sharedInstance].maxTagNum = _maxNum;
                            }
                        }
                    }
                }
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark proImageView_delegate
- (void)imageClicked:(ProImageView *)image{
    if (!_isDelete) {
        if ([image isMemberOfClass:[SubTagButton class]]) {
            SubTagButton *btn = (SubTagButton *)image;
            TagListController *listVC = [[TagListController alloc] init];
            listVC.title = btn.title;
            if (btn.uid) {
                listVC.tag_id = btn.uid;
            }
            [self.navigationController pushViewController:listVC animated:YES];

        }
    }else{
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


- (void)addView{
    UIImageView *myTagImg = [[UIImageView alloc] initWithFrame:CGRectMake(19, 20, 20, 16)];
    myTagImg.image = [UIImage imageNamed:@"mytags.png"];
    [_scrollView addSubview:myTagImg];
    
    UILabel *hotLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 20,160, 16)];
    hotLabel.text = @"我的订阅标签:";
    hotLabel.textColor = HexRGB(0x3a3a3a);
    hotLabel.font = [UIFont systemFontOfSize:PxFont(24)];
    [_scrollView addSubview:hotLabel];
    
    UIButton *managerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    managerBtn.frame =CGRectMake(kWidth-10-80,16, 80, 30);
    [managerBtn setTitle:@"【管理】" forState:UIControlStateNormal];
    [managerBtn setTitleColor:HexRGB(0x3a3a3a) forState:UIControlStateNormal];
    managerBtn.backgroundColor = [UIColor clearColor];
    managerBtn.tag = 1000;
    [managerBtn addTarget:self action:@selector(subButtonDown:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:managerBtn];
    
    
    bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 105, kWidth,160)];
    [_scrollView addSubview:bottomView];
    UIImageView *addHotImg = [[UIImageView alloc] initWithFrame:CGRectMake(20,29, 20, 16)];
    addHotImg.image = [UIImage imageNamed:@"addtags.png"];
    [bottomView addSubview:addHotImg];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(20,0, kWidth-40, 1)];
    lineView.backgroundColor = HexRGB(0xced2d8);
    [bottomView addSubview:lineView];
    
    
    UILabel *addTagLabel = [[UILabel alloc] initWithFrame:CGRectMake(45,29,160, 16)];
    addTagLabel.text = @"新增标签:";
    addTagLabel.textColor = HexRGB(0x3a3a3a);
    addTagLabel.font = [UIFont systemFontOfSize:PxFont(24)];
    [bottomView addSubview:addTagLabel];


    addField = [[UITextField alloc] initWithFrame:CGRectMake(20,63, kWidth-40, 35)];
    addField.delegate = self;
    addField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    addField.placeholder = @"请输入您要添加的新标签";
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

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [addField resignFirstResponder];
}


#pragma mark textField_delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    isKeyboardShow = YES;
    CGFloat distanse = _scrollView.contentSize.height-(bottomView.frame.origin.y+bottomView.frame.size.height);
    if (distanse < 250) {
        [UIView animateWithDuration:0.2 animations:^{
            [_scrollView setContentSize:CGSizeMake(kWidth,_scrollView.contentSize.height+(250-distanse))];
        }];
    }
    if (_iPhone4) {
        [_scrollView setContentOffset:CGPointMake(0, bottomView.frame.origin.y-10) animated:YES];
    }else if (_iPhone5) {
        [_scrollView setContentOffset:CGPointMake(0, bottomView.frame.origin.y-75) animated:YES];
    }else{
        [_scrollView setContentOffset:CGPointMake(0, bottomView.frame.origin.y-130) animated:YES];
    }

}

- (void)textFieldDidEndEditing:(UITextField *)textField
{

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
        if (addField.text.length==0) {
            [RemindView showViewWithTitle:@"请输入要添加的标签" location:MIDDLE];
        }else{
            if (_currentCount < _maxNum) {
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
            }else{
                ProAlertView *alertView = [[ProAlertView alloc] initWithTitle:@"温馨提示" withMessage:[NSString stringWithFormat:@"您好,您目前最多只能订阅%ld个标签,升级后可订阅更多标签",_maxNum] delegate:self cancleButton:@"取消" otherButton:@"立即升级"];
                [alertView showView];
            }
        }
    }
}

//添加按钮
- (void)addBtnWithTitle:(NSString *)text withId:(NSString *)uid withMessage:(BOOL)hasMessage messgaeNum:(NSString *)num{
    remindLabel.hidden = YES;
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


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        BuyTagController *tagVc = [[BuyTagController alloc] init];
        [self.navigationController pushViewController:tagVc animated:YES];
    }
}


#pragma mark -- proAlertView_delegate

- (void)proAclertView:(ProAlertView *)alertView clickButtonAtIndex:(NSInteger)index
{
    if (index == 0) {
        PrivilegeController *pri = [[PrivilegeController alloc] init];
        [self.navigationController pushViewController:pri animated:YES];
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
        bottomFrame.origin.y = 105;
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
                [_scrollView setContentSize:CGSizeMake(kWidth,_scrollView.contentSize.height+(250-distanse))];
            }];
        }
        if (_iPhone4) {
            [_scrollView setContentOffset:CGPointMake(0, bottomView.frame.origin.y-10) animated:YES];
        }else if (_iPhone5) {
            [_scrollView setContentOffset:CGPointMake(0, bottomView.frame.origin.y-75) animated:YES];
        }else{
            [_scrollView setContentOffset:CGPointMake(0, bottomView.frame.origin.y-130) animated:YES];
        }
    }else{
        if (bottomView.frame.origin.y+bottomView.frame.size.height+40<= kHeight-64) {
            [_scrollView setContentSize:CGSizeMake(kWidth,kHeight-64)];
        }else{
            [_scrollView setContentSize:CGSizeMake(kWidth,bottomView.frame.origin.y+bottomView.frame.size.height+40)];
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
