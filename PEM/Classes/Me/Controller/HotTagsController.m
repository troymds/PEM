//
//  HotTagsController.m
//  PEM
//
//  Created by tianj on 14-9-4.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "HotTagsController.h"
#import "HttpTool.h"
#import "HotTagItem.h"
#import "TagButton.h"
#import "UIBarButtonItem+MJ.h"
#import "FileManager.h"
#import "AdaptationSize.h"
#import "RemindView.h"

@interface HotTagsController ()

@end

@implementation HotTagsController

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
    
    self.view.backgroundColor = HexRGB(0xffffff);

    // Do any additional setup after loading the view.
    self.title = @"添加标签";
    
    space = 10;
    currentRow = 0;
    x =20;
    current_count = 0;
    max_count = 10;
    
    _dataArray = [[NSMutableArray alloc] init];
    
    [self addView];

    [self addNavBarButton];
    [self loadData];
}

- (void)addNavBarButton{
    // 创建按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];

    // 设置普通背景图片
    [btn setTitle:@"保存" forState:UIControlStateNormal];
    [btn setTitleColor:HexRGB(0x3a3a3a) forState:UIControlStateNormal];
    btn.frame = CGRectMake(10, 10,52, 24);
    [btn addTarget:self action:@selector(finish) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = item;
}


- (void)addView{
    UIImageView *hotTagImg = [[UIImageView alloc] initWithFrame:CGRectMake(19, 20, 20, 16)];
    hotTagImg.image = [UIImage imageNamed:@"hotTags.png"];
    [self.view addSubview:hotTagImg];

    
    UILabel *hotLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 20, kWidth-45-20, 16)];
    hotLabel.text = @"热门标签";
    hotLabel.textColor = HexRGB(0x3a3a3a);
    hotLabel.font = [UIFont systemFontOfSize:PxFont(24)];
    [self.view addSubview:hotLabel];
    
    bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 130, kWidth,70)];
    bottomView.backgroundColor = HexRGB(0xffffff);
    [self.view addSubview:bottomView];
    
    UIImageView *addTagImg = [[UIImageView alloc] initWithFrame:CGRectMake(19, 0, 20, 16)];
    addTagImg.image = [UIImage imageNamed:@"addtags.png"];
    [bottomView addSubview:addTagImg];

    
    addTagLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 0, kWidth-45-20, 16)];
    addTagLabel.text = @"新增标签";
    addTagLabel.textColor = HexRGB(0x3a3a3a);
    addTagLabel.font = [UIFont systemFontOfSize:PxFont(24)];
    [bottomView addSubview:addTagLabel];
    
    addField = [[UITextField alloc] initWithFrame:CGRectMake(20,addTagLabel.frame.origin.y+addTagLabel.frame.size.height+5, 200, 35)];
    addField.layer.borderColor = HexRGB(0xd5d5d5).CGColor;
    addField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    addField.layer.borderWidth = 1.0;
    addField.delegate = self;
    [bottomView addSubview:addField];
    
    addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(addField.frame.origin.x+addField.frame.size.width+20, addField.frame.origin.y, 60, 35);
    [addBtn setTitle:@"添加" forState:UIControlStateNormal];
    [addBtn setBackgroundImage:[UIImage imageNamed:@"finish.png"] forState:UIControlStateNormal];
    [addBtn setBackgroundImage:[UIImage imageNamed:@"finish_pre.png"] forState:UIControlStateHighlighted];
    [addBtn setTitleColor:HexRGB(0xffffff) forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addTags:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:addBtn];
}

- (void)finish{
    NSMutableArray *tagArray = [NSMutableArray array];
    for (UIView *subView in self.view.subviews){
        if ([subView isKindOfClass:[TagButton class]]){
            TagButton *btn = (TagButton *)subView;
            if (btn.isSelected){
                [tagArray addObject:btn.titleLabel.text];
            }
        }
    }
    if ([self.delegate respondsToSelector:@selector(sendValueFromViewController:value:isDemand:)]) {
        [self.delegate sendValueFromViewController:self value:tagArray isDemand:YES];
    }
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)addTags:(UIButton *)btn{
    
    if (addField.text.length!=0) {
        if (current_count < max_count) {
            for (UIView *subView in self.view.subviews){
                if ([subView isKindOfClass:[TagButton class]]){
                    TagButton *btn = (TagButton *)subView;
                    NSString *title = btn.titleLabel.text;
                    if ([title isEqualToString:addField.text]) {
                        [RemindView showViewWithTitle:@"该标签已存在" location:MIDDLE];
                        return;
                    }
                }
            }
            [self addButtonWithTitle:addField.text selected:YES];
            addField.text = @"";
            current_count++;
        }else{
            [RemindView showViewWithTitle:@"您最多只能添加10个标签" location:MIDDLE];
        }
    }else{
        [RemindView showViewWithTitle:@"请输入标签" location:MIDDLE];
    }
}

//添加标签按钮
- (void)addButtonWithTitle:(NSString *)title selected:(BOOL)seleclted
{
    NSInteger distance = 5;
    CGSize size = [AdaptationSize getSizeFromString:title Font:[UIFont systemFontOfSize:15] withHight:20 withWidth:CGFLOAT_MAX];
    if (x+space+size.width+distance*2 > kWidth-20) {
        currentRow++;
        x = 20;
    }
    TagButton *btn = [[TagButton alloc] initWithFrame:CGRectMake(x, 50+currentRow*(30+10), size.width+distance*2, 30)];
    btn.isSelected = seleclted;
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    x += space +size.width+distance*2;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(tagBtnDown:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [self moveBottomView];
}


//下载标签数据
- (void)loadData{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.dimBackground = NO;
    [HttpTool postWithPath:@"getHotTags" params:nil success:^(id JSON){
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
        if ([result objectForKey:@"response"]) {
            NSDictionary *dic = [result objectForKey:@"response"];
            if ([[dic objectForKey:@"code"] intValue] == 100) {
                if (!isNull(dic, @"data")) {
                    NSArray *arr = [[result objectForKey:@"response"] objectForKey:@"data"];
                    for (NSDictionary *dic in arr){
                        HotTagItem *item = [[HotTagItem alloc] initWithDictionary:dic];
                        //添加热门标签
                        [_dataArray addObject:item];
                    }
                    [self addTags];
                }
            }
        }
    } failure:^(NSError *error){
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    //    NSLog(@"error");
    }];
}

- (void)addTags
{
    for (int i =0; i < [_dataArray count]; i++){
        BOOL basic = NO;
        HotTagItem *item = [_dataArray objectAtIndex:i];
        //如果是第二次进入该页面 则判断上次保存的标签中是否存在选中的热门标签
        NSInteger count = 0;   // 获取上次手动添加的标签数量dfdsf
        
        for (int i = 0; i < [_tagArray count]; i++){
            if ([item.name isEqualToString:[_tagArray objectAtIndex:i]]){
                basic = YES;
                break;
            }else{
                count++;
            }
        }
        current_count = count;
        [self addButtonWithTitle:item.name selected:basic];
    }
    if (_tagArray.count!=0) {
        for (int i = 0 ; i< [_tagArray count]; i++) {
            NSString *tag = [_tagArray objectAtIndex:i];
            NSInteger count = 0 ;
            //判断除热门标签外是否有自己添加的标签
            for (int j = 0; j < [_dataArray count]; j++) {
                HotTagItem *item = [_dataArray objectAtIndex:j];
                if ([tag isEqualToString:item.name]) {
                    break;
                }
                count++;
            }
            if (count==[_dataArray count]) {
                [self addButtonWithTitle:[_tagArray objectAtIndex:i] selected:YES];
            }
        }

    }
}


- (void)moveBottomView{
    CGRect bottomFrame = bottomView.frame;
    bottomFrame.origin.y = 40+(currentRow+1)*(30+10)+10;
    bottomView.frame = bottomFrame;
    
    if (isEditing) {
        if (_iPhone4) {
            if (bottomView.frame.origin.y - 120 > 0) {
                [UIView animateWithDuration:0.2 animations:^{
                    self.view.frame = CGRectMake(0,-(bottomView.frame.origin.y-120), self.view.frame.size.width, self.view.frame.size.height);
                }];
            }
        }
    }
    
}

- (void)tagBtnDown:(TagButton *)btn{
    btn.isSelected = !btn.isSelected;
}


#pragma  mark textField_delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    isEditing = YES;
    if (_iPhone4) {
        if (bottomView.frame.origin.y - 120 > 0) {
            [UIView animateWithDuration:0.2 animations:^{
                self.view.frame = CGRectMake(0,-(bottomView.frame.origin.y-120), self.view.frame.size.width, self.view.frame.size.height);
            }];
        }
    }
    if (_iPhone5) {
        if (bottomView.frame.origin.y - 180 > 0) {
            [UIView animateWithDuration:0.2 animations:^{
                self.view.frame = CGRectMake(0,-(bottomView.frame.origin.y-180), self.view.frame.size.width, self.view.frame.size.height);
            }];
        }
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    isEditing = NO;
    if (_iPhone4) {
        [UIView animateWithDuration:0.2 animations:^{
            self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        }];
    }
    if (_iPhone5) {
        if (bottomView.frame.origin.y - 180 > 0) {
            [UIView animateWithDuration:0.2 animations:^{
                self.view.frame = CGRectMake(0,-(bottomView.frame.origin.y-180), self.view.frame.size.width, self.view.frame.size.height);
            }];
        }
    }

}




- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [addField resignFirstResponder];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
