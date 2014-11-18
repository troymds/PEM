//
//  MeController.m
//  PEM
//
//  Created by jch on 14-8-13.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "MeController.h"
#import "DescriptionController.h"
#import "CategoryController.h"
#import "AreaController.h"
#import "TDImageController.h"
#import "SystemConfig.h"
#import "HttpTool.h"
#import "RegisterContrller.h"
#import "PrivilegeController.h"
#import "RemindView.h"
#import "GTMBase64.h"
#import "FindSecretController.h"
#import "MySupplyController.h"
#import "MyPurchaseController.h"
#import "SelectImageController.h"


@interface MeController ()
{
    CGPoint _purchaseOffset;
    CGPoint _supplyOffset;
}
@end

@implementation MeController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (![SystemConfig sharedInstance].isUserLogin){
        LoginView *loginView = [[LoginView alloc] init];
        loginView.delegate = self;
        [loginView loginWithSuccess:^{
            NSLog(@"登陆成功");
        } fail:^{
            NSLog(@"登陆失败");
        }];
        [loginView showView];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = HexRGB(0xffffff);
    self.title = @"发 布";
    _isPurchase = YES;
    canPublish = YES;
    [self addBtn];
    [self addView];
    
    tagsArray = [NSMutableArray array];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark add view
- (void)addView
{
    bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,40, kWidth, kHeight-64-40-44)];
    [bgScrollView setContentSize:CGSizeMake(kWidth*2, bgScrollView.frame.size.height)];
    bgScrollView.backgroundColor= HexRGB(0xffffff);
    bgScrollView.delegate = self;
    bgScrollView.showsHorizontalScrollIndicator = NO;
    bgScrollView.showsVerticalScrollIndicator = NO;
    bgScrollView.pagingEnabled = YES;
    [self.view addSubview:bgScrollView];
    //求购
    _purchaseScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,kWidth,bgScrollView.frame.size.height)];
    _purchaseScrollView.showsHorizontalScrollIndicator = NO;
    _purchaseScrollView.showsVerticalScrollIndicator = NO;
    _purchaseScrollView.backgroundColor= HexRGB(0xffffff);
    _purchaseView = [[PurchaseView alloc] initWithFrame:CGRectMake(0, 0,kWidth,416)];
    _purchaseView.delegate =self;
    [_purchaseScrollView addSubview:_purchaseView];
    [_purchaseScrollView setContentSize:CGSizeMake(kWidth,416)];
    [bgScrollView addSubview:_purchaseScrollView];
    
    //供应
    _supplyScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(kWidth,0,kWidth,bgScrollView.frame.size.height)];
    _supplyScrollView.showsHorizontalScrollIndicator = NO;
    _supplyScrollView.showsVerticalScrollIndicator = NO;
    _supplyScrollView.backgroundColor = HexRGB(0xffffff);
    [bgScrollView addSubview:_supplyScrollView];
    
    _supplyView = [[SupplyView alloc] initWithFrame:CGRectMake(0,0,kWidth, 565)];
    _supplyView.delegate =self;
    _supplyView.headImage.delegate = self;
    [_supplyScrollView setContentSize:CGSizeMake(kWidth, 565)];
    [_supplyScrollView addSubview:_supplyView];
}

//添加发布求购、发布供应按钮
- (void)addBtn{
    CGFloat width = self.view.frame.size.width/2;
    NSArray *arr = [NSArray arrayWithObjects:@"发布求购",@"发布供应",nil];
    for (int i = 0; i<2; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:[arr objectAtIndex:i] forState:UIControlStateNormal];
        if (i == 0) {
            btn.selected = YES;
        }
        btn.tag = 2000+i;
        [btn setTitleColor:HexRGB(0x808080) forState:UIControlStateNormal];
        [btn setTitleColor:HexRGB(0x18b0e7) forState:UIControlStateSelected];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        btn.backgroundColor = [UIColor clearColor];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake(width*i, 0, width, 40);
        [self.view addSubview:btn];
    }
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 39, kWidth, 1)];
    lineView.backgroundColor = HexRGB(0x808080);
    [self.view addSubview:lineView];
    
    sliderLine = [[UIView alloc] initWithFrame:CGRectMake(0,38, kWidth/2, 2)];
    sliderLine.backgroundColor = HexRGB(0x18b0e7);
    [self.view addSubview:sliderLine];
}



#pragma mark  scrollview_delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //bgScrollView向左拖动偏移量少于0时不能在拖动
    if (scrollView.contentOffset.x <=0) {
        scrollView.contentOffset = CGPointMake(0, 0);
    }
    //bgScrollView向右拖动到第二页后不能在向右拖动
    if (scrollView.contentOffset.x >= kWidth) {
        scrollView.contentOffset = CGPointMake(kWidth, 0);
    }
    //发布、求购按钮下的滑动条跟着scrollView滑动
    [UIView animateWithDuration:0.01 animations:^{
        sliderLine.frame = CGRectMake(scrollView.contentOffset.x/2,38, kWidth/2, 2);
    }];
    if (scrollView.contentOffset.x == 0) {
        for (UIView *subView in self.view.subviews){
            if ([subView isKindOfClass:[UIButton class]]){
                UIButton *button = (UIButton *)subView;
                if (button.tag == 2000) {
                    button.selected = YES;
                }else{
                    button.selected = NO;
                }
            }
        }
        needCheck = NO;
        _isPurchase = YES;
        [activeField resignFirstResponder];
        [UIView animateWithDuration:0.2 animations:^{
            [_supplyScrollView setContentSize:CGSizeMake(kWidth, _supplyView.frame.size.height)];
        }];
    }
    if (scrollView.contentOffset.x == kWidth) {
        for (UIView *subView in self.view.subviews){
            if ([subView isKindOfClass:[UIButton class]]){
                UIButton *button = (UIButton *)subView;
                if (button.tag == 2001) {
                    button.selected = YES;
                }else{
                    button.selected = NO;
                }
            }
        }
        _isPurchase = NO;
        [activeField resignFirstResponder];
        [UIView animateWithDuration:0.2 animations:^{
            [_purchaseScrollView setContentSize:CGSizeMake(kWidth, _purchaseView.frame.size.height)];
        }];
        
        int vipType = [[SystemConfig sharedInstance].viptype intValue];
        //当会员类型小于等于0时  检查是否能发布供应信息
        if (vipType <= 0 ) {
            if ([SystemConfig sharedInstance].vipInfo) {
                int supply_num = [[SystemConfig sharedInstance].vipInfo.supply_num intValue];
                NSLog(@"supply_num:%d",supply_num);
                if (supply_num>=10) {
                    NSString *message = @"您好,您的发布供应次数已用完,要想发布更多,请选择立即升级";
                    ProAlertView *alertView = [[ProAlertView alloc] initWithTitle:@"温馨提示" withMessage:message delegate:self cancleButton:@"取消" otherButton:@"立即升级", nil];
                    alertView.tag = 1003;
                    [alertView show];
                }
            }
        }
    }
}

//bgScrollView开始拖拽时执行
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (_isPurchase) {
        needCheck = YES;
    }else{
        needCheck = NO;
    }
}



//点击登陆框周围跳转到首页
- (void)tapDown
{
    if ([self.delegate respondsToSelector:@selector(changeControllerFrom:to:)]) {
        [self.delegate changeControllerFrom:2 to:0];
    }
}


//发布求购、发布供应按钮点击触发
- (void)btnClick:(UIButton *)btn{
    if (btn.tag == 2001) {
        //可以发布信息
        needCheck = YES;
        _isPurchase = NO;
        for (UIView *subView in self.view.subviews){
            if ([subView isKindOfClass:[UIButton class]]){
                UIButton *button = (UIButton *)subView;
                if (btn.tag == button.tag){
                    button.selected = YES;
                }else{
                    button.selected = NO;
                }
            }
        }
        [bgScrollView scrollRectToVisible:CGRectMake(kWidth,40, kWidth, bgScrollView.frame.size.height) animated:YES];
    }else{
        _isPurchase = YES;
        for (UIView *subView in self.view.subviews){
            if ([subView isKindOfClass:[UIButton class]]){
                UIButton *button = (UIButton *)subView;
                if (btn.tag == button.tag){
                    button.selected = YES;
                }else{
                    button.selected = NO;
                }
            }
        }
        [bgScrollView scrollRectToVisible:CGRectMake(0, 40, kWidth, bgScrollView.frame.size.height) animated:YES];
    }
}

#pragma  mark supplyView_delegate
- (void)buttonClicked:(UIButton *)btn{
    switch (btn.tag-4000) {
        case 0:
        {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            picker.allowsEditing = YES;
            picker.delegate = self;
            [self presentViewController:picker animated:YES completion:nil];
        }
            break;
        case 1:
        {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                picker.allowsEditing = YES;
                picker.delegate = self;
                [self presentViewController:picker animated:YES completion:nil];
            }
        }
            break;
        case 2:
            
            break;
        default:
            break;
    }
}




#pragma mark alertView_delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0){
        //联系客服
        UIWebView *callWebview =[[UIWebView alloc] init];
        NSURL *telURL =[NSURL URLWithString:@"tel:02568713202"];
        [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
        [self.view addSubview:callWebview];
    }
}

#pragma mark PublishView_Delegate
- (void)buttonDown:(UIButton *)btn{
    switch (btn.tag) {
        case 3001:
        {
            //发布求购信息
            if ([self checkPurchaseData]){
                [self updateDemandData];
            }
        }
            break;
        case 3002:
        {
            //检验所填信息是否完整
            if ([self checkSuppayData]){
                //检查是否能够发布供应信息
                [self canPublishSupply];
            }
        }
            break;
        case 9000:
        {
            CategoryController *category = [[CategoryController alloc] init];
            [activeField resignFirstResponder];
            category.delegate = self;
            category.isSupply = YES;
            [self.navigationController pushViewController:category animated:YES];
            
        }
            break;
        case 9001:
        {
            AreaController *area = [[AreaController alloc] init];
            [activeField resignFirstResponder];
            area.delegate = self;
            [self.navigationController pushViewController:area animated:YES];
        }
            break;
        case 9002:
        {
            [activeField resignFirstResponder];
            CGRect frame = [UIScreen mainScreen].bounds;
//            SelectImageController *vc = [[SelectImageController alloc] init];
//            [self.navigationController pushViewController:vc animated:YES];
            _actionSheet = [[ProActionSheet alloc] initWithFrame:frame];
            _actionSheet.delegate = self;
            [_actionSheet showView];
        }
            break;
        case 9003:
        {
            DescriptionController *vc = [[DescriptionController alloc] init];
            [activeField resignFirstResponder];
            vc.delegate = self;
            vc.isSupply = YES;
            if (supplyDes.length!=0){
                vc.text = supplyDes;
            }
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 10000:
        {
            CategoryController *category = [[CategoryController alloc] init];
            [activeField resignFirstResponder];
            category.delegate = self;
            category.isSupply = NO;
            [self.navigationController pushViewController:category animated:YES];
            
        }
            break;
        case 10001:
        {
            DescriptionController *vc = [[DescriptionController alloc] init];
            [activeField resignFirstResponder];
            vc.delegate = self;
            vc.isSupply = NO;
            if (demandDes&&demandDes.length!=0) {
                vc.text = demandDes;
            }
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 10002:
        {
            HotTagsController *hotVC = [[HotTagsController alloc] init];
            [activeField resignFirstResponder];
            hotVC.delegate = self;
            hotVC.tagArray = tagsArray;
            [self.navigationController pushViewController:hotVC animated:YES];
        }
            break;
        case 3003:
        {
            if ([[SystemConfig sharedInstance].viptype isEqualToString:@"0"]) {
                _upTDView = [[ProAlertView alloc] initWithTitle:@"尊敬的体验会员" withMessage:@"您上传全景图片次数不足\n1.普通及以上会员可购买上传次数\n2.金牌会员赠送1次\n3.铂金会员赠送5次" delegate:self cancleButton:@"取 消" otherButton:@"立即升级", nil];
                _upTDView.tag =1000;
                [_upTDView show];
            }else{
                int display_3d_num = [[SystemConfig sharedInstance].vipInfo.display_3d_num intValue];
                if (display_3d_num <= 0) {
                    UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您好!您还不能上传全景图片或上传全景图片数量已用完,要上传全景图片,可到网页端单独购买" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
                    [view show];
                 }else{
                    btn.selected = !btn.selected;
                    if (btn.selected) {
                        isShowTD = YES;
                    }else{
                        isShowTD = NO;
                    }
                    _supplyView.isHide = !_supplyView.isHide;
                     if (isEditing) {
                         [_supplyScrollView setContentSize:CGSizeMake(kWidth, _supplyView.frame.size.height+240)];
                     }else{
                         [_supplyScrollView setContentSize:CGSizeMake(kWidth, _supplyView.frame.size.height)];
                     }
                }
            }
        }
            break;
        case 3004:
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"上传全景图片" message:@"" delegate:self cancelButtonTitle:@"咨询我们" otherButtonTitles:@"取消", nil];
            alertView.tag = 1002;
            alertView.delegate = self;
            [alertView show];
        }
            break;
        default:
            break;
    }
}

//上传求购信息
- (void)updateDemandData{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.dimBackground = NO;
    hud.labelText = @"发布中...";
    NSString *tags;
    if (_purchaseView.markLabel.text) {
        tags = _purchaseView.markLabel.text;
    }else{
        tags = @"";
    }
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:[SystemConfig sharedInstance].company_id,@"company_id",demandCateItem.uid,@"category_id",_purchaseView.titleTextField.text,@"title",demandDes,@"description",_purchaseView.phoneNumTextField.text,@"contacts_phone",_purchaseView.linkManTextField.text,@"contacts",tags,@"tags",@"1",@"type",_purchaseView.unitField.text,@"unit",_purchaseView.purchaseNumField.text,@"buy_num",nil];
    [HttpTool postWithPath:@"saveInfo" params:param  success:^(id JSON){
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *dic = [result objectForKey:@"response"];
        if (dic) {
            if ([[dic objectForKey:@"code"] intValue] == 100){
                [activeField resignFirstResponder];
                MyPurchaseController *pc = [[MyPurchaseController alloc] init];
                [self.navigationController pushViewController:pc animated:YES];
                [self clearPurchaseData];
            }else{
                [RemindView showViewWithTitle:@"发布失败" location:MIDDLE];
            }
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [RemindView showViewWithTitle:@"网络错误" location:MIDDLE];
    }];
}

//判断能否发布供应信息
- (void)canPublishSupply
{
    int vipType = [[SystemConfig sharedInstance].viptype intValue];
    //当会员类型 >0时 表示一定可以发布供应信息 否则检查是否能够发布
    if (vipType <= 0 ) {
        //判断是否可以发布供应信息
        NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:[SystemConfig sharedInstance].company_id,@"company_id", nil];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.dimBackground = NO;
        [HttpTool postWithPath:@"canPublishSupplyInfo" params:param success:^(id JSON) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
            if ([result objectForKey:@"response"]) {
                NSString *code = [[result objectForKey:@"response"] objectForKey:@"code"];
                if ([code intValue] ==100) {
                    int data = [[[result objectForKey:@"response"] objectForKey:@"data"] intValue];
                    if (data == 0) {
                        //不能发布信息
                        NSString *message = [[result objectForKey:@"response"] objectForKey:@"msg"];
                        ProAlertView *actionView = [[ProAlertView alloc] initWithTitle:@"温馨提示" withMessage:message delegate:self cancleButton:@"取消" otherButton:@"立即升级", nil];
                        actionView.tag = 1001;
                        [actionView show];
                    }else{
                        //发布供应信息
                        [self updateSupplyData];
                    }
                }else{
                    [RemindView showViewWithTitle:@"操作失败" location:MIDDLE];
                }
            }
        } failure:^(NSError *error) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [RemindView showViewWithTitle:@"网络错误" location:MIDDLE];
        }];
    }else{
        [self updateSupplyData];
    }
}


//发布供应信息
- (void)updateSupplyData
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.dimBackground = NO;
    hud.labelText = @"发布中...";
    NSData *data;
    NSString *str;
    if (UIImagePNGRepresentation(headImage)) {
        data = UIImagePNGRepresentation(headImage);
        str= @"png";
    }else{
        data = UIImageJPEGRepresentation(headImage, 1.0);
        str = @"jpg";
    }
    NSString *s = [GTMBase64 stringByEncodingData:data];
    NSString *string = [NSString stringWithFormat:@"data:image/%@;base64,%@",str,s];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:string,@"image", nil];
    [HttpTool postWithPath:@"uploadImage" params:param success:^(id JSON){
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
        if ([result objectForKey:@"response"]) {
            if ([[[result objectForKey:@"response"] objectForKey:@"code"] intValue] ==100 ){
                imageUrl = [[result objectForKey:@"response"] objectForKey:@"data"];
                NSString *apply3D;
                if (isShowTD){
                    apply3D = @"1";
                }else{
                    apply3D = @"0";
                }
                NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"2",@"type",[SystemConfig sharedInstance].company_id,@"company_id",supplyCateItem.uid,@"category_id",region,@"region_name",apply3D,@"apply3D",_supplyView.priceTextField.text,@"price",_supplyView.standardTextField.text,@"min_sell_num",_supplyView.titleTextField.text,@"title",supplyDes,@"description",_supplyView.linkManTextField.text,@"contacts",_supplyView.phoneNumTextField.text,@"contacts_phone",imageUrl,@"image_url",_supplyView.unitField.text,@"unit", nil];
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.dimBackground = NO;
                hud.labelText = @"发布中...";
                [HttpTool postWithPath:@"saveInfo" params:params success:^(id JSON) {
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
                    NSDictionary *dic = [result objectForKey:@"response"];
                    if ([[dic objectForKey:@"code"] intValue] == 100){
                        [self clearSupplyData];
                        [activeField resignFirstResponder];
                        MySupplyController *sc = [[MySupplyController alloc] init];
                        [self.navigationController pushViewController:sc animated:YES];
                    }else{
                        [RemindView showViewWithTitle:@"发布失败" location:MIDDLE];
                    }
                } failure:^(NSError *error){
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    [RemindView showViewWithTitle:@"网络错误" location:MIDDLE];
                }];
                
            }else{
                [RemindView showViewWithTitle:@"上传图片失败" location:MIDDLE];
            }
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [RemindView showViewWithTitle:@"网络错误" location:MIDDLE];
    }];
}

- (void)textFieldBeganEditting:(UITextField *)textField{
    activeField = textField;
    CGFloat y = 0;
    switch (textField.tag) {
        case PC_TITLE_TYPE:
        {
            y = 0;
        }
            break;
        case PC_PURCHASE_TYPE:
        {
            if (_iPhone4) {
                y = 90;
            }else if (_iPhone5){
                y = 35;
            }else{
                y = 0;
            }
        }
            break;
        case PC_UNIT_TYPE:
        {
            if (_iPhone4) {
                y = 125;
            }else if (_iPhone5){
                y = 70;
            }else{
                y =35;
            }
        }
            break;
        case PC_LINKMAN_TYPE:
        {
            if (_iPhone4) {
                y = 160;
            }else if (_iPhone5){
                y = 105;
            }else{
                y = 70;
            }
        }
            break;
        case PC_PHONENUM_TYPE:
        {
            if (_iPhone4) {
                y = 195;
            }else if (_iPhone5){
                y = 140;
            }else{
                y = 105;
            }
        }
            break;
        case TITLE_TYPE:
        {
            if (_iPhone4) {
                y = 35;
            }else if (_iPhone5){
                y = 0;
            }else{
                y = 0;
            }
        }
            break;
        case PRICE_TYPE:
        {
            if (_iPhone4) {
                y = 90;
            }else if (_iPhone5){
                y = 35;
            }else{
                y = 0;
            }
        }
            break;
        case UNIT_TYPE:
        {
            if (_iPhone4) {
                y = 125;
            }else if (_iPhone5){
                y = 70;
            }else{
                y = 35;
            }
        }
            break;
        case STANDARD_TYPE:
        {
            if (_iPhone4) {
                y = 160;
            }else if (_iPhone5){
                y = 105;
            }else{
                y = 70;
            }
        }
            break;
        case LINKMAN_TYPE:
        {
            if (_iPhone4) {
                y = 245;
            }else if (_iPhone5){
                y = 190;
            }else{
               y = 145;
            }
        }
            break;
        case PHONENUM_TYPE:
        {
            if (_iPhone4) {
                y = 280;
            }else if (_iPhone5){
                y = 225;
            }else{
                y = 180;
            }
        }
            break;
        default:
            break;
    }
    if (_isPurchase) {

        [_purchaseScrollView setContentOffset:CGPointMake(0, y) animated:YES];
        [_purchaseScrollView setContentSize:CGSizeMake(kWidth,416+240)];
        
    }else{
        [_supplyScrollView setContentOffset:CGPointMake(0, y) animated:YES];
        [_supplyScrollView setContentSize:CGSizeMake(kWidth, _supplyView.frame.size.height+240)];
    }
}

#pragma mark keyboard_NSNotification
- (void)keyboardWillShow
{
    isEditing = YES;
}


- (void)keyboardWillHide
{
    isEditing = NO;
    if (_isPurchase) {
        [UIView animateWithDuration:0.2 animations:^{
            [_purchaseScrollView setContentSize:CGSizeMake(kWidth,416)];
        }];
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            [_supplyScrollView setContentSize:CGSizeMake(kWidth, _supplyView.frame.size.height)];
        }];
    }
}

#pragma mark check data
//发布求购成功后，清空页面数据
- (void)clearPurchaseData
{
    demandCateItem = nil;
    _purchaseView.categoryLabel.text = @"";
    _purchaseView.titleTextField.text = @"";
    _purchaseView.descriptionLabel.text = @"10字以上";
    _purchaseView.descriptionLabel.textColor = HexRGB(0xd5d5d5);
    demandDes = @"";
    _purchaseView.purchaseNumField.text = @"";
    _purchaseView.unitField.text = @"";
    _purchaseView.markLabel.text = @"";
    _purchaseView.linkManTextField.text = @"";
    _purchaseView.phoneNumTextField.text = @"";
    if (tagsArray.count!=0) {
        [tagsArray removeAllObjects];
    }
}
//发布供应成功后，清空页面数据
- (void)clearSupplyData
{
    supplyCateItem = nil;
    _supplyView.areaLabel.text = @"";
    region = nil;
    _supplyView.categoryLabel.text = @"";
    _supplyView.titleTextField.text = @"";
    _supplyView.descriptionLabel.text = @"";
    _supplyView.priceTextField.text = @"";
    _supplyView.unitField.text = @"";
    _supplyView.standardTextField.text = @"";
    _supplyView.descriptionLabel.text = @"10字以上";
    _supplyView.descriptionLabel.textColor = HexRGB(0xd5d5d5);
    _supplyView.linkManTextField.text=@"";
    _supplyView.phoneNumTextField.text = @"";
    supplyDes = @"";
    _supplyView.headImage.image = nil;
    headImage = nil;
    for (UIView *subView in _supplyView.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)subView;
            if (button.tag == 3003) {
                button.selected = NO;
            }
        }
    }
    //下面两句代码不能颠倒
    _supplyView.isExistImg = NO;
    _supplyView.isHide = YES;
    [_supplyScrollView setContentSize:CGSizeMake(kWidth,_supplyView.frame.size.height)];
}


//检查发布的求购数据信息
- (BOOL)checkPurchaseData{
    if (!demandCateItem) {
        [RemindView showViewWithTitle:@"请选择分类" location:MIDDLE];
        return NO;
    }
    if (!(_purchaseView.titleTextField.text.length!=0)) {
        [RemindView showViewWithTitle:@"请填写标题" location:MIDDLE];
        return NO;
    }
    if (!(demandDes&&demandDes.length !=0)) {
        [RemindView showViewWithTitle:@"请填写求购产品的描述信息" location:MIDDLE];
        return NO;
    }
    if (!(_purchaseView.purchaseNumField.text.length!=0)){
        [RemindView showViewWithTitle:@"请输入需要求购的数量" location:MIDDLE];
        return NO;
    }
    if (!(_purchaseView.unitField.text.length!=0)) {
        [RemindView showViewWithTitle:@"请输入求购物品的计量单位" location:MIDDLE];
        return NO;
    }
    if (!(_purchaseView.linkManTextField.text.length!=0)) {
        [RemindView showViewWithTitle:@"请输入联系人" location:MIDDLE];
        return NO;
    }
    if (_purchaseView.linkManTextField.text.length < 2||_purchaseView.linkManTextField.text.length>4) {
        [RemindView showViewWithTitle:@"联系人为2-4个字符" location:MIDDLE];
        return NO;
    }
    if (!(_purchaseView.phoneNumTextField.text.length!=0)){
        [RemindView showViewWithTitle:@"请输入手机号码" location:MIDDLE];
        return NO;
    }
    if (![self isValidateMobile:_purchaseView.phoneNumTextField.text]){
        [RemindView showViewWithTitle:@"请输入正确的手机号码" location:MIDDLE];
        return NO;
    }
    return YES;
}
//判断电话是否合法 固定号码 或手机号
-(BOOL)isValidateMobile:(NSString *)mobile
{
    NSString *phoneRegex  =  @"((0\\d{2,3}-\\d{7,8})|(^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}))$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}


//检查发布的供应数据信息
-(BOOL)checkSuppayData{
    if (!supplyCateItem) {
        [RemindView showViewWithTitle:@"请选择分类" location:MIDDLE];
        return NO;
    }
    if (!(region&&region.length!=0)){
        [RemindView showViewWithTitle:@"请选择供应的区域" location:MIDDLE];
        return NO;
    }
    if (!(_supplyView.titleTextField.text.length!=0)) {
        [RemindView showViewWithTitle:@"请填写标题" location:MIDDLE];
        return NO;
    }
    if (!(_supplyView.priceTextField.text.length!=0)){
        [RemindView showViewWithTitle:@"请输入供应产品价格" location:MIDDLE];
        return NO;
    }
    if (!(_supplyView.unitField.text.length!=0)) {
        [RemindView showViewWithTitle:@"请输入物品的计量单位" location:MIDDLE];
    }
    if (!(_supplyView.standardTextField.text.length!=0)) {
        [RemindView showViewWithTitle:@"请填写产品的起订标准" location:MIDDLE];
        return NO;
    }
    if (!(supplyDes&&supplyDes.length !=0)) {
        [RemindView showViewWithTitle:@"请填写供应产品的描述信息" location:MIDDLE];
        return NO;
    }
    if (!(_supplyView.linkManTextField.text.length!=0)) {
        [RemindView showViewWithTitle:@"请输入联系人" location:MIDDLE];
        return NO;
    }
    if (_supplyView.linkManTextField.text.length < 2||_supplyView.linkManTextField.text.length>4) {
        [RemindView showViewWithTitle:@"联系人为2-4个字符" location:MIDDLE];
        return NO;
    }
    if (!(_supplyView.phoneNumTextField.text.length!=0)) {
        [RemindView showViewWithTitle:@"请输入手机号码" location:MIDDLE];
        return NO;
    }
    if (![self isValidateMobile:_supplyView.phoneNumTextField.text]){
        [RemindView showViewWithTitle:@"请输入正确的手机号码" location:MIDDLE];
        return NO;
    }
    if (!headImage){
        [RemindView showViewWithTitle:@"请为产品选择一张图片" location:MIDDLE];
        return NO;
    }
    return YES;
}

#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    headImage = portraitImg;
    _supplyView.headImage.image = headImage;
    _supplyView.isExistImg = YES;
    [_supplyView reloadView];
    _supplyScrollView.contentSize = CGSizeMake(kWidth,_supplyView.frame.size.height);
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [activeField resignFirstResponder];
}

#pragma mark imageSelectView_delegate
- (void)selectedBtnDown:(UIButton *)btn{
    if (btn.tag == 4000) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.allowsEditing = YES;
            picker.delegate = self;
            [self presentViewController:picker animated:YES completion:nil];
        }
    }else{
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.allowsEditing = YES;
        picker.delegate = self;
        [self presentViewController:picker animated:YES completion:nil];
    }
}

#pragma mark ---proAlertView_delegate
- (void)proAclertView:(ProAlertView *)alertView clickButtonAtIndex:(NSInteger)index
{
    if (alertView.tag!=1001) {
        if (index == 1) {
            PrivilegeController *priVC = [[PrivilegeController alloc] init];
            [self.navigationController pushViewController:priVC animated:YES];
        }
    }
}


//图片点击事件
-(void)imageClicked:(ProImageView *)image{
    CGRect frame = [UIScreen mainScreen].bounds;
    ProActionSheet *actionSheet = [[ProActionSheet alloc] initWithFrame:frame];
    actionSheet.delegate = self;
    [actionSheet showView];
}

#pragma mark - sendValueDelegate
- (void)sendValueFromViewController:(UIViewController *)controller value:(id)value isDemand:(BOOL)isDemand
{
    if ([controller isKindOfClass:[CategoryController class]]){
        if (isDemand) {
            demandCateItem = value;
            _purchaseView.categoryLabel.text = demandCateItem.name;
        }else{
            supplyCateItem = value;
            _supplyView.categoryLabel.text = supplyCateItem.name;
        }
    }else if ([controller isKindOfClass:[DescriptionController class]]){
        if (isDemand) {
            demandDes = value;
            _purchaseView.descriptionLabel.textColor = [UIColor blackColor];
            _purchaseView.descriptionLabel.text = value;
        }else{
            supplyDes = value;
            _supplyView.descriptionLabel.textColor = [UIColor blackColor];
            _supplyView.descriptionLabel.text = value;
        }
    }else if([controller isKindOfClass:[HotTagsController class]]){
        tagsArray = value;
        
        NSMutableString *tagStr = [NSMutableString stringWithString:@""];
        for (int i = 0; i< tagsArray.count; i++) {
            
            [tagStr appendString:[tagsArray objectAtIndex:i]];
            if (i < [tagsArray count]-1){
                [tagStr appendString:@","];
            }
        }
        _purchaseView.markLabel.text = tagStr;
    }else if ([controller isKindOfClass:[AreaController class]]){
        region = value;
        _supplyView.areaLabel.text = region;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
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
