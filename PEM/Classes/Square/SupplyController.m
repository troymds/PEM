//
//  SupplyController.m
//  PEM
//
//  Created by tianj on 14-9-26.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "SupplyController.h"
#import "RemindView.h"
#import "GTMBase64.h"
#import "SystemConfig.h"
#import "HttpTool.h"
#import "CategoryController.h"
#import "AreaController.h"
#import "DescriptionController.h"
#import "SystemConfig.h"
#import "SupplyDetailItem.h"
#import "UIImageView+WebCache.h"
#import "MySupplyController.h"
#import "PrivilegeController.h"


@interface SupplyController ()

@end

@implementation SupplyController

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
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width,kHeight-64)];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    
    _supplyView = [[SupplyView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width, 565)];
    _supplyView.delegate = self;
    _supplyView.headImage.delegate = self;
    [_scrollView setContentSize:CGSizeMake(self.view.frame.size.width, 565)];
    [_scrollView addSubview:_supplyView];
    if (!_isAdd) {
        //编辑类型  请求要编辑的数据
        isOrigionImg = YES;
        [self loadData];
    }else{
        //添加 判断是否可以发布
        [self check];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
}

- (void)check
{
    //判断是否能发布供应信息
    int vipType = [[SystemConfig sharedInstance].viptype intValue];
    //当会员类型小于等于0时  检查是否能发布供应信息
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
                        MyActionSheetView *actionView = [[MyActionSheetView alloc] initWithTitle:@"温馨提示" withMessage:message delegate:self cancleButton:@"取消" otherButton:@"立即升级"];
                        [actionView showView];
                    }
                }
            }
        } failure:^(NSError *error) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            NSLog(@"%@",error);
        }];
    }

}


- (void)keyboardWillHide
{
    [UIView animateWithDuration:0.2 animations:^{
        [_scrollView setContentSize:CGSizeMake(kWidth, _supplyView.frame.size.height)];
    }];
}

- (void)textFieldBeganEditting:(UITextField *)textField{
    activeField = textField;
    CGFloat y = 0;
    switch (textField.tag) {
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
                y = 75;
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
                y = 110;
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
                y = 150;
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
                y = 240;
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
                y = 275;
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
    [_scrollView setContentOffset:CGPointMake(0, y) animated:YES];
    [_scrollView setContentSize:CGSizeMake(kWidth, _supplyView.frame.size.height+240)];

}

- (void)loadData
{
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:[SystemConfig sharedInstance].company_id,@"company_id",_info_id,@"info_id", nil];
    [HttpTool postWithPath:@"getInfoDetail" params:param success:^(id JSON) {
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *dic = [result objectForKey:@"response"];
        if (dic) {
            if ([[dic objectForKey:@"code"] intValue] == 100) {
                NSDictionary *data = [dic objectForKey:@"data"];
                SupplyDetailItem *item = [[SupplyDetailItem alloc] init];
                [item setValuesForKeysWithDictionary:data];
                if ([[data objectForKey:@"from"] isEqualToString:@"pc"]) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您当前供应信息是从PC端发布的,请到PC端修改" delegate:self cancelButtonTitle:nil otherButtonTitles:@"我知道了", nil];
                    alertView.tag = 3000;
                    [alertView show];
                }else{
                    [self addDataWithItem:item];
                }
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 3000) {
        [self.navigationController popViewControllerAnimated:YES];
    }else if(alertView.tag ==1002){
        if (buttonIndex == 0){
            //联系客服
            UIWebView *callWebview =[[UIWebView alloc] init];
            NSURL *telURL =[NSURL URLWithString:@"tel:02568713202"];
            [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
            [self.view addSubview:callWebview];
        }
    }
}

- (void)addDataWithItem:(SupplyDetailItem *)item
{
    _supplyView.categoryLabel.text = item.category_name;
    _supplyView.areaLabel.text = item.region;
    _supplyView.titleTextField.text = item.title;
    _supplyView.priceTextField.text = item.price;
    _supplyView.unitField.text = item.unit;
    _supplyView.standardTextField.text = item.sell_limit;
    _supplyView.descriptionLabel.text = item.description;
    _supplyView.linkManTextField.text = item.contacts;
    _supplyView.phoneNumTextField.text = item.phone_num;
    
    //图片
    [_supplyView.headImage setImageWithURL:[NSURL URLWithString:item.image]];
    headImage = _supplyView.headImage.image;
    
    _supplyView.isExistImg = YES;
    [_supplyView reloadView];
    _scrollView.contentSize = CGSizeMake(kWidth,_supplyView.frame.size.height);

    
    CategoryItem *cateItem = [[CategoryItem alloc] init];
    cateItem.name = item.category_name;
    cateItem.uid = item.category_id;
    supplyCateItem = cateItem;
    region = item.region;
    supplyDes = item.description;
    imageUrl = item.image;
}

- (void)buttonDown:(UIButton *)btn
{
    switch (btn.tag) {
        case 3002:
        {
            //发布供应信息
            if ([self checkSuppayData]){
                
                int vipType = [[SystemConfig sharedInstance].viptype intValue];
                //当会员类型小于等于0时  检查是否能发布供应信息
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
                                    MyActionSheetView *actionView = [[MyActionSheetView alloc] initWithTitle:@"温馨提示" withMessage:message delegate:self cancleButton:@"取消" otherButton:@"立即升级"];
                                    [actionView showView];
                                }else{
                                    [self publishSupplyInfo];
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
                    [self publishSupplyInfo];
                }
            }
        }
            break;
        case 3003:
        {
            if ([[SystemConfig sharedInstance].viptype isEqualToString:@"0"]) {
                MyActionSheetView *actionView = [[MyActionSheetView alloc] initWithTitle:@"温馨提示" withMessage:@"您好！您目前所处等级没有权限上传全景图片,请先升级。" delegate:self cancleButton:@"取 消" otherButton:@"升 级"];
                actionView.tag =1000;
                [actionView showView];
            }else{
                int display_3d_num = [[SystemConfig sharedInstance].vipInfo.display_3d_num intValue];
                if (display_3d_num <= 0) {
                    MyActionSheetView *actionSheet = [[MyActionSheetView alloc] initWithTitle:@"温馨提示" withMessage:@"您好!您还不能上传全景图片或上传全景图片数量已用完,要上传全景图片,可单独购买" delegate:self cancleButton:@"取消" otherButton:@"单独购买"];
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
                    [_scrollView setContentSize:CGSizeMake(kWidth, _supplyView.frame.size.height)];
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
        case 9000:
        {
            CategoryController *category = [[CategoryController alloc] init];
            [activeField resignFirstResponder];
            category.delegate = self;
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
            ProActionSheet *actionSheet = [[ProActionSheet alloc] initWithFrame:frame];
            actionSheet.delegate = self;
            [actionSheet showView];
        }
            break;
        case 9003:
        {
            DescriptionController *vc = [[DescriptionController alloc] init];
            [activeField resignFirstResponder];
            vc.delegate = self;
            vc.isSupply = YES;
            if (supplyDes!=0){
                vc.text = supplyDes;
            }
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}

- (void)publishSupplyInfo
{
    NSString *apply3D;
    if (isShowTD){
        apply3D = @"1";
    }else{
        apply3D = @"0";
    }
    if (isOrigionImg) {
        //如果没有修改图片  直接上传数据
        NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:@"2",@"type",[SystemConfig sharedInstance].company_id,@"company_id",supplyCateItem.uid,@"category_id",region,@"region_name",apply3D,@"apply3D",_supplyView.priceTextField.text,@"price",_supplyView.standardTextField.text,@"min_sell_num",_supplyView.titleTextField.text,@"title",supplyDes,@"description",_supplyView.linkManTextField.text,@"contacts",_supplyView.phoneNumTextField.text,@"contacts_phone",imageUrl,@"image_url",_supplyView.unitField.text,@"unit",_info_id,@"info_id", nil];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"发布中...";
        [HttpTool postWithPath:@"saveInfo" params:param success:^(id JSON) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *dic = [result objectForKey:@"response"];
            if (dic) {
                if ([[dic objectForKey:@"code"] intValue] == 100){
                    //编辑成功，刷新原来列表界面
                    MySupplyController *vc = [self.navigationController.viewControllers objectAtIndex:1];
                    self.delegate = vc;
                    if ([self.delegate respondsToSelector:@selector(reloadData)]) {
                        [self.delegate reloadData];
                    }
                    [self.navigationController popToViewController:vc animated:YES];
                }else{
                    [RemindView showViewWithTitle:@"发布失败" location:MIDDLE];
                }
            }
        } failure:^(NSError *error){
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [RemindView showViewWithTitle:@"网络错误" location:MIDDLE];
        }];
        
    }else{
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
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"发布中...";
        [HttpTool postWithPath:@"uploadImage" params:param success:^(id JSON){
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *dic = [result objectForKey:@"response"];
            if (dic) {
                if ([[dic objectForKey:@"code"] intValue] ==100){
                    imageUrl = [[result objectForKey:@"response"] objectForKey:@"data"];
                    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:@"2",@"type",[SystemConfig sharedInstance].company_id,@"company_id",supplyCateItem.uid,@"category_id",region,@"region_name",apply3D,@"apply3D",_supplyView.priceTextField.text,@"price",_supplyView.standardTextField.text,@"min_sell_num",_supplyView.titleTextField.text,@"title",supplyDes,@"description",_supplyView.linkManTextField.text,@"contacts",_supplyView.phoneNumTextField.text,@"contacts_phone",imageUrl,@"image_url",_supplyView.unitField.text,@"unit", nil];
                    
                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    hud.labelText =@"发布中...";
                    [HttpTool postWithPath:@"saveInfo" params:param success:^(id JSON) {
                        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
                        NSDictionary *dic = [result objectForKey:@"response"];
                        if ([[dic objectForKey:@"code"] intValue] == 100){
                            //编辑成功，刷新原来列表界面
                            MySupplyController *vc = [self.navigationController.viewControllers objectAtIndex:1];
                            self.delegate = vc;
                            if ([self.delegate respondsToSelector:@selector(reloadData)]) {
                                [self.delegate reloadData];
                            }
                            [self.navigationController popToViewController:vc animated:YES];
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

-(BOOL)isValidateMobile:(NSString *)mobile
{
    NSString *phoneRegex  =  @"((0\\d{2,3}-\\d{7,8})|(^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}))$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
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


- (void)actionSheetButtonClicked:(MyActionSheetView *)actionSheetView
{
    PrivilegeController *pri = [[PrivilegeController alloc] init];
    [self.navigationController pushViewController:pri animated:YES];
}

#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    headImage = portraitImg;
    _supplyView.headImage.image = portraitImg;
    _supplyView.isExistImg = YES;

    //
    isOrigionImg = NO;
    [_supplyView reloadView];
    _scrollView.contentSize = CGSizeMake(kWidth,_supplyView.frame.size.height);
    [picker dismissViewControllerAnimated:YES completion:nil];
}


//图片点击事件
-(void)imageClicked:(ProImageView *)image{
    CGRect frame = [UIScreen mainScreen].bounds;
    ProActionSheet *actionSheet = [[ProActionSheet alloc] initWithFrame:frame];
    actionSheet.delegate = self;
    [actionSheet showView];
}

- (void)sendValueFromViewController:(UIViewController *)controller value:(id)value isDemand:(BOOL)isDemand
{
    if ([controller isKindOfClass:[CategoryController class]]) {
        supplyCateItem = value;
        _supplyView.categoryLabel.text = supplyCateItem.name;
    }else if ([controller isKindOfClass:[AreaController class]]){
        region = value;
        _supplyView.areaLabel.text = region;
    }else if ([controller isKindOfClass:[DescriptionController class]]){
        supplyDes = value;
        _supplyView.descriptionLabel.text = supplyDes;
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
