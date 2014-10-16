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
    if (![SystemConfig sharedInstance].isUserLogin){
        CGRect frame = [UIScreen mainScreen].bounds;
        _loginView = [[LoginView alloc] initWithFrame:frame];
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userName"]) {
            NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
            _loginView.userField.text = userName;
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"secret"]) {
                _loginView.passwordField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"secret"];
            }
        }
        _loginView.delegate = self;
        [_loginView showView];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = HexRGB(0xffffff);
    self.title = @"发 布";
    _isPurchase = YES;
    [self addBtn];
    [self addView];
    
    tagsArray = [NSMutableArray array];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
}


- (void)addView
{
    //求购
    _purchaseScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,40,kWidth,kHeight-64-40-44)];
    _purchaseScrollView.showsHorizontalScrollIndicator = NO;
    _purchaseScrollView.showsVerticalScrollIndicator = NO;
    _purchaseScrollView.backgroundColor= HexRGB(0xffffff);
    _purchaseView = [[PurchaseView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,416)];
    _purchaseView.delegate =self;
    [_purchaseScrollView addSubview:_purchaseView];
    [_purchaseScrollView setContentSize:CGSizeMake(self.view.frame.size.width,416)];
    [self.view addSubview:_purchaseScrollView];
    
    //供应
    _supplyScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(kWidth, 40, self.view.frame.size.width,kHeight-64-40-44)];
    _supplyScrollView.showsHorizontalScrollIndicator = NO;
    _supplyScrollView.showsVerticalScrollIndicator = NO;
    _supplyScrollView.backgroundColor = HexRGB(0xffffff);
    [self.view addSubview:_supplyScrollView];
    _supplyView = [[SupplyView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width, 565)];
    _supplyView.delegate =self;
    _supplyView.headImage.delegate = self;
    [_supplyScrollView setContentSize:CGSizeMake(self.view.frame.size.width, 565)];
    [_supplyScrollView addSubview:_supplyView];

}

#pragma mark loginView_delegate
- (void)btnDown:(UIButton *)btn{
    switch (btn.tag){
        case LOGIN_TYPE:
        {
            NSDictionary *parms = [NSDictionary dictionaryWithObjectsAndKeys:_loginView.userField.text,@"phonenum",_loginView.passwordField.text,@"password", nil];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.labelText = @"登录中...";
            [HttpTool postWithPath:@"login" params:parms success:^(id JSON){
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                NSDictionary *result = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
                NSDictionary *dic = [result objectForKey:@"response"];
                NSString *code = [NSString stringWithFormat:@"%d",[[dic objectForKey:@"code"] intValue]];
                if ([code isEqualToString:@"100"]){
                    
                    [[NSUserDefaults standardUserDefaults] setObject:_loginView.userField.text forKey:@"userName"];
                    [[NSUserDefaults standardUserDefaults] setObject:_loginView.passwordField.text forKey:@"secret"];

                    NSDictionary *data = [dic objectForKey:@"data"];
                    [SystemConfig sharedInstance].isUserLogin = YES;
                    int company_id = [[data objectForKey:@"company_id"] intValue];
                    [SystemConfig sharedInstance].company_id = [NSString stringWithFormat:@"%d",company_id];
                    int vipType = [[data objectForKey:@"viptype"] intValue];
                    [SystemConfig sharedInstance].viptype = [NSString stringWithFormat:@"%d",vipType];
                    CompanyInfoItem *item = [[CompanyInfoItem alloc] initWithDictionary:data];
                    [SystemConfig sharedInstance].companyInfo = item;
                    
                    [self getVipInfo:[NSString stringWithFormat:@"%d",company_id]];
                    
                }else{
                    [RemindView showViewWithTitle:@"用户名或密码错误" location:MIDDLE];
                }
            }failure:^(NSError *error){
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                NSLog(@"%@",error);
            }];
        }
            break;
        case FIND_TYPE:
        {
            FindSecretController *fsc = [[FindSecretController alloc] init];
            [self.navigationController pushViewController:fsc animated:YES];
        }
            break;
        case REGIST_TYPE:
        {
            RegisterContrller *rsc = [[RegisterContrller alloc] init];
            rsc.pushType = PUBLISH_TYPE;
            [self.navigationController pushViewController:rsc animated:YES];
        }
            break;
        default:
            break;
    }
}


- (void)tapDown
{
    if ([self.delegate respondsToSelector:@selector(changeController)]) {
        [self.delegate changeController];
    }
}


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
//发布求购、发布供应按钮点击触发
- (void)btnClick:(UIButton *)btn{
    if (btn.tag == 2001&&(![SystemConfig sharedInstance].viptype||[[SystemConfig sharedInstance].viptype isEqualToString:@"0"])) {
        btn.selected = NO;
    }else
    for (UIView *subView in self.view.subviews){
        if ([subView isKindOfClass:[UIButton class]]){
            UIButton *button = (UIButton *)subView;
            if (btn.tag == button.tag){
                if (button.tag ==2000||button.tag ==2001){
                    button.selected = YES;
                }
            }else{
                if (btn.tag == 2000||btn.tag ==2001){
                    button.selected = NO;
                }
            }
        }
    }
    switch (btn.tag) {
        case 2000:
        {
            _isPurchase = YES;
                [UIView animateWithDuration:0.5 animations:^{
                    sliderLine.frame = CGRectMake(0, 38, kWidth/2, 2);
                    _purchaseScrollView.frame = CGRectMake(0,40,kWidth,kHeight-64-40-49);
                    _supplyScrollView.frame = CGRectMake(kWidth, 40, kWidth,kHeight-64-40-49);
                }];
        }
            break;
        case 2001:
        {
            NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:[SystemConfig sharedInstance].company_id,@"company_id", nil];
            [HttpTool postWithPath:@"canPublishSupplyInfo" params:param success:^(id JSON) {
                NSDictionary *result = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
                if ([result objectForKey:@"response"]) {
                    NSString *code = [[result objectForKey:@"response"] objectForKey:@"code"];
                    if ([code intValue] ==100) {
                        int data = [[[result objectForKey:@"response"] objectForKey:@"data"] intValue];
                        if (data == 0) {
                            //不能发布信息
                            NSString *message = [[result objectForKey:@"response"] objectForKey:@"msg"];
                            MyActionSheetView *actionView = [[MyActionSheetView alloc] initWithTitle:@"温馨提示" withMessage:message delegate:self cancleButton:@"取消" otherButton:@"立即升级"];
                            [actionView showView];
                        }else if(data == 1){
                            //可以发布信息
                            _isPurchase = NO;
                            [UIView animateWithDuration:0.5 animations:^{
                                _supplyScrollView.frame = CGRectMake(0, 40, kWidth, kHeight-64-40-49);
                                _purchaseScrollView.frame = CGRectMake(-kWidth, 40, kWidth,kHeight-64-40-49);
                                sliderLine.frame = CGRectMake(kWidth/2,38, kWidth/2, 2);
                            }];

                        }
                    }else{
                        
                    }
                }
            } failure:^(NSError *error) {
                NSLog(@"%@",error);
            }];
        }
                break;
            default:
                break;
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
            //判断上传数据是否完整
            if ([self checkPurchaseData]){
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.dimBackground = NO;
                hud.labelText = @"发布中...";
                NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:[SystemConfig sharedInstance].company_id,@"company_id",demandCateItem.uid,@"category_id",_purchaseView.titleTextField.text,@"title",demandDes,@"description",_purchaseView.phoneNumTextField.text,@"contacts_phone",_purchaseView.linkManTextField.text,@"contacts",_purchaseView.markLabel.text,@"tags",@"1",@"type",_purchaseView.unitField.text,@"unit",_purchaseView.purchaseNumField.text,@"buy_num",nil];
                [HttpTool postWithPath:@"saveInfo" params:param  success:^(id JSON){
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
                    NSDictionary *dic = [result objectForKey:@"response"];
                    if ([[dic objectForKey:@"code"] intValue] == 100){
                        MyPurchaseController *pc = [[MyPurchaseController alloc] init];
                        [self.navigationController pushViewController:pc animated:YES];
                    }else{
                        [RemindView showViewWithTitle:@"发布失败" location:MIDDLE];
                    }
                } failure:^(NSError *error) {
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    NSLog(@"%@",error);
                }];
            }
        }
            break;
        case 3002:
        {
            //发布供应信息
            if ([self checkSuppayData]){
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
                                MySupplyController *sc = [[MySupplyController alloc] init];
                                [self.navigationController pushViewController:sc animated:YES];
                            }else{
                                [RemindView showViewWithTitle:@"发布失败" location:MIDDLE];
                            }
                        } failure:^(NSError *error){
                            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                            NSLog(@"%@",error);
                        }];
                        
                    }else{
                        [RemindView showViewWithTitle:@"上传图片失败" location:MIDDLE];
                    }
                } failure:^(NSError *error) {
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    NSLog(@"%@",error);
                }];
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
                _upTDView = [[MyActionSheetView alloc] initWithTitle:@"温馨提示" withMessage:@"您好！您目前所处等级没有权限上传3D图片,请先升级。" delegate:self cancleButton:@"取 消" otherButton:@"升 级"];
                _upTDView.tag =1000;
                [_upTDView showView];
            }else{
                int display_3d_num = [[SystemConfig sharedInstance].vipInfo.display_3d_num intValue];
                if (display_3d_num <= 0) {
                    MyActionSheetView *actionSheet = [[MyActionSheetView alloc] initWithTitle:@"温馨提示" withMessage:@"您好!您还不能上传3D图片或上传3D图片数量已用完,要上传3D图片,可单独购买" delegate:self cancleButton:@"取消" otherButton:@"单独购买"];
                    actionSheet.tag = 1001;
                    [actionSheet showView];
                }else{
                    btn.selected = !btn.selected;
                    if (btn.selected) {
                        isShowTD = YES;
                    }else{
                        isShowTD = NO;
                    }
                    _supplyView.isHide = !_supplyView.isHide;
                    [_supplyScrollView setContentSize:CGSizeMake(kWidth, _supplyView.frame.size.height)];
                }
            }
        }
            break;
        case 3004:
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"上传3D图片" message:@"" delegate:self cancelButtonTitle:@"咨询我们" otherButtonTitles:@"取消", nil];
            alertView.tag = 1002;
            alertView.delegate = self;
            [alertView show];
        }
            break;
        default:
            break;
    }
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

- (void)textFieldBeganEditting:(UITextField *)textField{
    activeField = textField;
    if (_iPhone4) {
        if (textField.tag == PC_PURCHASE_TYPE) {
            if (_purchaseScrollView.contentOffset.y < 90) {
                [UIView animateWithDuration:0.3 animations:^{
                    CGPoint offset = _purchaseScrollView.contentOffset;
                    _purchaseOffset = offset;
                    offset.y = 90;
                    _purchaseScrollView.contentOffset= offset;
                }];
            }
        }else if(textField.tag == PC_UNIT_TYPE){
            if (_purchaseScrollView.contentOffset.y < 130) {
                [UIView animateWithDuration:0.3 animations:^{
                    CGPoint offset = _purchaseScrollView.contentOffset;
                    _purchaseOffset = offset;
                    offset.y = 130;
                    _purchaseScrollView.contentOffset= offset;
                }];
            }
        }else if(textField.tag == PC_LINKMAN_TYPE){
            if (_purchaseScrollView.contentOffset.y < 160) {
                [UIView animateWithDuration:0.3 animations:^{
                    CGPoint offset = _purchaseScrollView.contentOffset;
                    _purchaseOffset = offset;
                    offset.y = 160;
                    _purchaseScrollView.contentOffset= offset;
                }];
            }
        }else if (textField.tag == PC_PHONENUM_TYPE){
            if (_purchaseScrollView.contentOffset.y < 190) {
                [UIView animateWithDuration:0.3 animations:^{
                    CGPoint offset = _purchaseScrollView.contentOffset;
                    _purchaseOffset = offset;
                    offset.y = 190;
                    _purchaseScrollView.contentOffset= offset;
                }];
            }
        }else if(textField.tag == PRICE_TYPE){
            if (_supplyScrollView.contentOffset.y < 50) {
                [UIView animateWithDuration:0.3 animations:^{
                    CGPoint offset = _supplyScrollView.contentOffset;
                    _supplyOffset = offset;
                    offset.y = 50;
                    _supplyScrollView.contentOffset= offset;
                }];
            }
        }else if(textField.tag == UNIT_TYPE){
            if (_supplyScrollView.contentOffset.y < 80) {
                [UIView animateWithDuration:0.3 animations:^{
                    CGPoint offset = _supplyScrollView.contentOffset;
                    _supplyOffset = offset;
                    offset.y = 80;
                    _supplyScrollView.contentOffset= offset;
                }];
            }
        }else if(textField.tag == STANDARD_TYPE){
            if (_supplyScrollView.contentOffset.y < 140) {
                [UIView animateWithDuration:0.3 animations:^{
                    CGPoint offset = _supplyScrollView.contentOffset;
                    _supplyOffset = offset;
                    offset.y = 140;
                    _supplyScrollView.contentOffset= offset;
                }];
            }
        }else if(textField.tag == LINKMAN_TYPE){
            if (_supplyScrollView.contentOffset.y < 200) {
                [UIView animateWithDuration:0.3 animations:^{
                    CGPoint offset = _supplyScrollView.contentOffset;
                    _supplyOffset = offset;
                    offset.y = 200;
                    _supplyScrollView.contentOffset= offset;
                }];
            }
        }else if(textField.tag == PHONENUM_TYPE){
            if (_supplyScrollView.contentOffset.y < 240) {
                [UIView animateWithDuration:0.3 animations:^{
                    CGPoint offset = _supplyScrollView.contentOffset;
                    _supplyOffset = offset;
                    offset.y = 240;
                    _supplyScrollView.contentOffset= offset;
                }];
            }
        }
    }else if (_iPhone5){
        if(textField.tag == PC_UNIT_TYPE){
            if (_purchaseScrollView.contentOffset.y < 50) {
                [UIView animateWithDuration:0.3 animations:^{
                    CGPoint offset = _purchaseScrollView.contentOffset;
                    _purchaseOffset = offset;
                    offset.y = 50;
                    _purchaseScrollView.contentOffset= offset;
                }];
            }
        }else if(textField.tag == PC_LINKMAN_TYPE){
            if (_purchaseScrollView.contentOffset.y < 80) {
                [UIView animateWithDuration:0.3 animations:^{
                    CGPoint offset = _purchaseScrollView.contentOffset;
                    _purchaseOffset = offset;
                    offset.y = 80;
                    _purchaseScrollView.contentOffset= offset;
                }];
            }
        }else if (textField.tag == PC_PHONENUM_TYPE){
            if (_purchaseScrollView.contentOffset.y < 120) {
                [UIView animateWithDuration:0.3 animations:^{
                    CGPoint offset = _purchaseScrollView.contentOffset;
                    _purchaseOffset = offset;
                    offset.y = 120;
                    _purchaseScrollView.contentOffset= offset;
                }];
            }
        }else if(textField.tag == PRICE_TYPE){
            if (_supplyScrollView.contentOffset.y < 50) {
                [UIView animateWithDuration:0.3 animations:^{
                    CGPoint offset = _supplyScrollView.contentOffset;
                    _supplyOffset = offset;
                    offset.y = 50;
                    _supplyScrollView.contentOffset= offset;
                }];
            }
        }else if(textField.tag == UNIT_TYPE){
            if (_supplyScrollView.contentOffset.y < 80) {
                [UIView animateWithDuration:0.3 animations:^{
                    CGPoint offset = _supplyScrollView.contentOffset;
                    _supplyOffset = offset;
                    offset.y = 80;
                    _supplyScrollView.contentOffset= offset;
                }];
            }
        }else if(textField.tag == STANDARD_TYPE){
            if (_supplyScrollView.contentOffset.y < 140) {
                [UIView animateWithDuration:0.3 animations:^{
                    CGPoint offset = _supplyScrollView.contentOffset;
                    _supplyOffset = offset;
                    offset.y = 140;
                    _supplyScrollView.contentOffset= offset;
                }];
            }
        }else if(textField.tag == LINKMAN_TYPE){
            if (_supplyScrollView.contentOffset.y < 200) {
                [UIView animateWithDuration:0.3 animations:^{
                    CGPoint offset = _supplyScrollView.contentOffset;
                    _supplyOffset = offset;
                    offset.y = 200;
                    _supplyScrollView.contentOffset= offset;
                }];
            }
        }else if(textField.tag == PHONENUM_TYPE){
            if (_supplyScrollView.contentOffset.y < 240) {
                [UIView animateWithDuration:0.3 animations:^{
                    CGPoint offset = _supplyScrollView.contentOffset;
                    _supplyOffset = offset;
                    offset.y = 240;
                    _supplyScrollView.contentOffset= offset;
                }];
            }
        }
    }
}

- (void)keyboardWillHide
{
    if (_isPurchase){
        if (_purchaseOffset.y > _purchaseScrollView.contentSize.height - _purchaseScrollView.frame.size.height){
            _purchaseOffset.y = _purchaseScrollView.contentSize.height - _purchaseScrollView.frame.size.height;
        }
        [UIView animateWithDuration:0.3 animations:^{
            _purchaseScrollView.contentOffset = _purchaseOffset;
        }];
    }else{
        if (_supplyOffset.y > _supplyScrollView.contentSize.height - _supplyScrollView.frame.size.height){
            _supplyOffset.y = _supplyScrollView.contentSize.height - _supplyScrollView.frame.size.height;
        }
        [UIView animateWithDuration:0.3 animations:^{
            _supplyScrollView.contentOffset = _supplyOffset;
        }];
    }
}


- (void)getVipInfo:(NSString *)company_id
{
    //获取用户VIP信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.dimBackground = NO;
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:company_id,@"company_id",nil];
    [HttpTool postWithPath:@"getCompanyVipInfo" params:params success:^(id JSON) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *dic = [result objectForKey:@"response"];
        if ([[dic objectForKey:@"code"] intValue] ==100) {
            NSDictionary *data = [dic objectForKey:@"data"];
            VipInfoItem *vipInfo = [[VipInfoItem alloc] initWithDictionary:data];
            [SystemConfig sharedInstance].vipInfo = vipInfo;
            [_loginView dismissView];
        }else{
            [_loginView dismissView];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSLog(@"%@",error);
    }];
    
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
    if (!_isPurchase) {
        for (UIView *subView in _supplyView.subviews) {
            if ([subView isKindOfClass:[UITextField class]]) {
                [subView resignFirstResponder];
            }
        }
    }else{
        for (UIView *subView in _purchaseView.subviews) {
            if ([subView isKindOfClass:[UITextField class]]) {
                [subView resignFirstResponder];
            }
        }
    }
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


- (void)actionSheetButtonClicked:(MyActionSheetView *)actionSheetView
{
    if (actionSheetView.tag ==1001) {
        
    }else{
        PrivilegeController *priVC = [[PrivilegeController alloc] init];
        [self.navigationController pushViewController:priVC animated:YES];
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
            _purchaseView.descriptionLabel.text = value;
        }else{
            supplyDes = value;
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
