//
//  NewCompanySeController.m
//  PEM
//
//  Created by tianj on 14-10-28.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "NewCompanySeController.h"
#import "SetCellView.h"
#import "HttpTool.h"
#import "SystemConfig.h"
#import "CompanyInfoItem.h"
#import "UIImageView+WebCache.h"
#import "GTMBase64.h"
#import "RemindView.h"
#import "CityController.h"
#import "AdaptationSize.h"
#import "NewLoginController.h"
#import "CompanyInfoController.h"
#import "UIBarButtonItem+MJ.h"

#define SETICON_TYPE 6000
#define ICON_TYPE 6001
#define NAME_TYPE 6002
#define AREA_TYPE 6003
#define PHONE_TYPE 6004
#define WEBSITE_TYPE 6005
#define EMAIL_TYPE 6006
#define PROVINCE_TYPE 6007
#define CITY_TYPE 6008

@interface NewCompanySeController ()

@end

@implementation NewCompanySeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (IsIos7) {
        self.edgesForExtendedLayout =  UIRectEdgeNone;
    }
    
    self.title = @"企业设置";
    self.view.backgroundColor = HexRGB(0xffffff);
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"nav_return.png" highlightedIcon:@"nav_return_pre.png" target:self action:@selector(backItem)];

    // Do any additional setup after loading the view.
    [self addView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHiden) name:UIKeyboardWillHideNotification object:nil];

}

- (void)backItem
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)keyboardWillHiden{
    isEditing = NO;
    [UIView animateWithDuration:0.2 animations:^{
        [_scrollView setContentSize:CGSizeMake(kWidth, finishBtn.frame.origin.y+finishBtn.frame.size.height+20)];
    }];
}

- (void)addView
{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight-64)];
    _scrollView.backgroundColor = HexRGB(0xffffff);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    
    _iconSetView = [[ProImageView alloc] initWithFrame:CGRectMake(21, 22, kWidth-42, 96)];
    _iconSetView.layer.borderColor = HexRGB(0xd5d5d5).CGColor;
    _iconSetView.layer.borderWidth = 1.0f;
    _iconSetView.layer.masksToBounds = YES;
    _iconSetView.layer.cornerRadius = 6.0;
    
    
    _iconSetView.tag = SETICON_TYPE;
    UILabel *iconLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 38, 90, 20)];
    iconLabel.backgroundColor = [UIColor clearColor];
    iconLabel.textColor = HexRGB(0x666666);
    iconLabel.font = [UIFont systemFontOfSize:PxFont(22)];
    iconLabel.text = @"企业形象";
    [_iconSetView addSubview:iconLabel];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(80, 38, 1, 20)];
    line.backgroundColor = HexRGB(0x666666);
    [_iconSetView addSubview:line];
    
    _iconImage = [[ProImageView alloc] initWithFrame:CGRectMake(_iconSetView.frame.size.width-38-78, 10, 78, 78)];
    _iconImage.image = [UIImage imageNamed:@"company_default.png"];
    _iconImage.tag = ICON_TYPE;
    _iconImage.layer.cornerRadius = _iconImage.frame.size.width/2;
    _iconImage.layer.masksToBounds = YES;
    _iconImage.delegate = self;
    [_iconSetView addSubview:_iconImage];
    [_scrollView addSubview:_iconSetView];
    
    
    bgView = [[UIView alloc] initWithFrame:CGRectMake(21, 133, kWidth-42, 280)];
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 6.0f;
    bgView.layer.borderColor = HexRGB(0xd5d5d5).CGColor;
    bgView.layer.borderWidth = 1.0f;
    [_scrollView addSubview:bgView];
    for (int i = 1 ; i < 7; i++) {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 40*i, kWidth-42, 1)];
        line.backgroundColor = HexRGB(0xd5d5d5);
        [bgView addSubview:line];
    }
    
    _nameView = [[SetCellView alloc] initWithFrame:CGRectMake(0, 0, kWidth-42, 40)];
    _nameView.titleLabel.text = @"企业名称";
    _nameView.textField.delegate = self;
    _nameView.textField.tag = NAME_TYPE;
    [bgView addSubview:_nameView];
    
    
    _areaView = [[SetCellView alloc] initWithFrame:CGRectMake(0,120, kWidth-42, 40)];
    _areaView.titleLabel.text = @"具体街道";
    _areaView.textField.delegate = self;
    _areaView.textField.tag = AREA_TYPE;
    [bgView addSubview:_areaView];
    
    _provinceView = [[SetAreaView alloc] initWithFrame:CGRectMake(0,40, kWidth-42, 40)];
    _provinceView.titleLabel.text = @"选择省份";
    _provinceView.areaBtn.tag = 2000;
    [_provinceView.areaBtn addTarget:self action:@selector(areaBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:_provinceView];
    
    _cityView = [[SetAreaView alloc] initWithFrame:CGRectMake(0,80, kWidth-42, 40)];
    _cityView.titleLabel.text = @"选择城市";
    _cityView.areaBtn.tag = 2001;
    [_cityView.areaBtn addTarget:self action:@selector(areaBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:_cityView];
    
    
    _phoneView = [[SetCellView alloc] initWithFrame:CGRectMake(0, 160, kWidth-42, 40)];
    _phoneView.titleLabel.text = @"企业电话";
    _phoneView.textField.delegate = self;
    _phoneView.textField.tag = PHONE_TYPE;
    [bgView addSubview:_phoneView];
    
    
    _websiteView = [[SetCellView alloc] initWithFrame:CGRectMake(0, 200, kWidth-42, 40)];
    _websiteView.titleLabel.text = @"企业网址";
    _websiteView.textField.delegate = self;
    _websiteView.textField.tag = WEBSITE_TYPE;
    [bgView addSubview:_websiteView];
    
    
    _emailView = [[SetCellView alloc] initWithFrame:CGRectMake(0, 240, kWidth-42, 40)];
    _emailView.titleLabel.text = @"企业邮箱";
    _emailView.textField.delegate = self;
    _emailView.textField.tag = EMAIL_TYPE;
    [bgView addSubview:_emailView];
    
    remindLabel = [[UILabel alloc] initWithFrame:CGRectMake(21, bgView.frame.origin.y+bgView.frame.size.height+5,kWidth-21*2,0)];
    remindLabel.backgroundColor = [UIColor clearColor];
    remindLabel.textColor = [UIColor redColor];
    remindLabel.font = [UIFont systemFontOfSize:11];
    remindLabel.numberOfLines = 0;
    [_scrollView addSubview:remindLabel];
    
    
    finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    finishBtn.frame = CGRectMake(21,bgView.frame.origin.y+bgView.frame.size.height+10, kWidth-42,35);
    [finishBtn setTitle:@"完 成" forState:UIControlStateNormal];
    [finishBtn addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [finishBtn setBackgroundImage:[UIImage imageNamed:@"finish.png"] forState:UIControlStateNormal];
    [finishBtn setBackgroundImage:[UIImage imageNamed:@"finish_pre.png"] forState:UIControlStateHighlighted];
    [_scrollView addSubview:finishBtn];
    
    [_scrollView setContentSize:CGSizeMake(kWidth, finishBtn.frame.origin.y+finishBtn.frame.size.height+20)];
}

//选择省份城市
- (void)areaBtnClick:(UIButton *)btn
{
    [activeField resignFirstResponder];
    if (btn.tag == 2000) {
        ProvinceController *vc = [[ProvinceController alloc] init];
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        if (provinceName&&provinceName.length!=0) {
            CityController *vc= [[CityController alloc] init];
            vc.uid = _provinceId;
            vc.delegate = self;
            [self.navigationController pushViewController:vc animated:YES];
        }else {
            [RemindView showViewWithTitle:@"请选择省份" location:MIDDLE];
        }
    }
}

- (void)selectedWith:(NSString *)province uid:(NSString *)uid
{
    if (!(provinceName&&[provinceName isEqualToString:province])) {
        if (cityName&&cityName.length!=0) {
            cityName = @"";
            _cityView.contentLabel.text = cityName;
        }
    }
    _provinceView.contentLabel.text = province;
    provinceName = province;
    _provinceId = uid;
    
}

- (void)selectCity:(NSString *)province withId:(NSString *)uid
{
    _cityView.contentLabel.text = province;
    cityName = province;
    _cityId = uid;
}

#pragma mark textField_delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag == PHONE_TYPE) {
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789-\n"] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basic = [string isEqualToString:filtered];
        if (!basic) {
            return NO;
        }
    }
    return YES;
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [activeField resignFirstResponder];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    activeField = textField;
    isEditing = YES;
    CGFloat y;
    if (_iPhone4) {
        y = bgView.frame.origin.y-60;
    }else if (_iPhone5){
        y = 0;
    }else if(_iPhone6){
        y = bgView.frame.origin.y-200;
    }else{
        y = bgView.frame.origin.y- 250;
    }
    switch (textField.tag) {
        case NAME_TYPE:
            
            break;
        case AREA_TYPE:
            y = y+40*3;
            
            break;
        case PHONE_TYPE:
            y = y+40*4;
            
            break;
        case WEBSITE_TYPE:
            y = y+40*5;
            break;
        case EMAIL_TYPE:
            y = y+40*6;
            break;
            
        default:
            break;
    }
    [_scrollView setContentSize:CGSizeMake(kWidth, finishBtn.frame.origin.y+finishBtn.frame.size.height+20+240)];
    [UIView animateWithDuration:0.3 animations:^{
        [_scrollView setContentOffset:CGPointMake(0, y)];
    }];
}



- (void)buttonClick{
    [activeField resignFirstResponder];
    if ([self checkOut]){
        if (isExistImg){
            //第一次设置 或再次修改了图片时要上传图片
            MBProgressHUD *hud= [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.dimBackground = NO;
            NSData *data = UIImagePNGRepresentation(_iconImage.image);
            NSString *s = [GTMBase64 stringByEncodingData:data];
            NSString *string = [NSString stringWithFormat:@"data:image/png;base64,%@",s];
            NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:string,@"image", nil];
            [HttpTool postWithPath:@"uploadImage" params:param success:^(id JSON) {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                NSDictionary *result = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
                if ([result objectForKey:@"response"]) {
                    NSDictionary *dic = [result objectForKey:@"response"];
                    if ([[dic objectForKey:@"code"] intValue] == 100){
                        _imgStr = [dic objectForKey:@"data"];
                        [self updateData];
                    }else{
                        [RemindView showViewWithTitle:@"设置失败" location:MIDDLE];
                    }
                }
                }failure:^(NSError *error){
                [RemindView showViewWithTitle:@"网络错误" location:MIDDLE];
            }];
            
        }else{
            //没有图片 直接上传数据
            [self updateData];
        }
    }
}
//上传数据
- (void)updateData
{
    MBProgressHUD *hud= [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.dimBackground  = NO;
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:[SystemConfig sharedInstance].company_id,@"company_id",_nameView.textField.text,@"name",_phoneView.textField.text,@"company_tel",_areaView.textField.text,@"address",_websiteView.textField.text,@"website",_emailView.textField.text,@"email",_provinceId,@"province",_cityId,@"city", nil];
    if (isExistImg) {
        //如果有图片  则上传图片url
        [param setObject:_imgStr forKey:@"image"];
    }
    [HttpTool postWithPath:@"updateCompanyInfo" params:param success:^(id JSON){
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *dic = [result objectForKey:@"response"];
        if (dic) {
            if ([[dic objectForKey:@"code"] intValue] == 100){
                [RemindView showViewWithTitle:@"设置成功" location:MIDDLE];
                //隐藏掉可能存在的错误提示
                remindLabel.text = @"";
                [UIView animateWithDuration:0.3 animations:^{
                    finishBtn.frame = CGRectMake(21, bgView.frame.origin.y+bgView.frame.size.height+10, kWidth-21*2, 35);
                    if (isEditing) {
                        [_scrollView setContentSize:CGSizeMake(kWidth, finishBtn.frame.origin.y+finishBtn.frame.size.height+20+240)];
                        
                    }else{
                        [_scrollView setContentSize:CGSizeMake(kWidth, finishBtn.frame.origin.y+finishBtn.frame.size.height+20)];
                    }
                }];
                //注册成功后  判断是否有要跳转回的界面
                [self setSucess];
            }else if([[dic objectForKey:@"code"] intValue] == 101){
                [RemindView showViewWithTitle:@"注册失败" location:MIDDLE];
            }else if([[dic objectForKey:@"code"] intValue] == 102){
                [RemindView showViewWithTitle:@"邮箱已被占用" location:MIDDLE];
            }
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [RemindView showViewWithTitle:@"网络错误" location:MIDDLE];
    }];
    
}


- (void)setSucess
{
    NSArray *array = self.navigationController.viewControllers;
    int count=0;
    for (UIViewController *viewController in array) {
        if ([viewController isKindOfClass:[NewLoginController class]]) {
            [self.navigationController popToViewController:viewController animated:YES];
        }
        count++;
    }
    if (count== array.count) {
        NewLoginController *new = [[NewLoginController alloc] init];
        NSMutableArray *arr = [NSMutableArray arrayWithArray:array];
        [arr insertObject:new atIndex:0];
        self.navigationController.viewControllers = arr;
        [self.navigationController popToViewController:new animated:YES];
    }
}

- (BOOL)checkOut{
    if (_nameView.textField.text.length==0) {
        NSString *textStr = @"请输入企业名称";
        CGSize size = [AdaptationSize getSizeFromString:textStr Font:[UIFont systemFontOfSize:11] withHight:CGFLOAT_MAX withWidth:kWidth-21*2];
        remindLabel.frame = CGRectMake(21, remindLabel.frame.origin.y,kWidth-21*2,size.height);
        finishBtn.frame = CGRectMake(finishBtn.frame.origin.x, remindLabel.frame.origin.y+remindLabel.frame.size.height+10, finishBtn.frame.size.width, finishBtn.frame.size.height);
        remindLabel.text = textStr;
        finishBtn.frame = CGRectMake(finishBtn.frame.origin.x, remindLabel.frame.origin.y+remindLabel.frame.size.height+10, finishBtn.frame.size.width, finishBtn.frame.size.height);
        
        [UIView animateWithDuration:0.3 animations:^{
            if (isEditing) {
                [_scrollView setContentSize:CGSizeMake(kWidth, finishBtn.frame.origin.y+finishBtn.frame.size.height+20+240)];
                
            }else{
                [_scrollView setContentSize:CGSizeMake(kWidth, finishBtn.frame.origin.y+finishBtn.frame.size.height+20)];
            }
        }];
        
        return NO;
    }
    if (_phoneView.textField.text.length==0) {
        NSString *textStr = @"请输入企业电话,如固话:010-88888888或手机号:138********";
        CGSize size = [AdaptationSize getSizeFromString:textStr Font:[UIFont systemFontOfSize:11] withHight:CGFLOAT_MAX withWidth:kWidth-21*2];
        remindLabel.frame = CGRectMake(21, remindLabel.frame.origin.y,kWidth-21*2,size.height);
        finishBtn.frame = CGRectMake(finishBtn.frame.origin.x, remindLabel.frame.origin.y+remindLabel.frame.size.height+10, finishBtn.frame.size.width, finishBtn.frame.size.height);
        remindLabel.text = textStr;
        finishBtn.frame = CGRectMake(finishBtn.frame.origin.x, remindLabel.frame.origin.y+remindLabel.frame.size.height+10, finishBtn.frame.size.width, finishBtn.frame.size.height);
        
        [UIView animateWithDuration:0.3 animations:^{
            if (isEditing) {
                [_scrollView setContentSize:CGSizeMake(kWidth, finishBtn.frame.origin.y+finishBtn.frame.size.height+20+240)];
                
            }else{
                [_scrollView setContentSize:CGSizeMake(kWidth, finishBtn.frame.origin.y+finishBtn.frame.size.height+20)];
            }
        }];
        
        return NO;
    }else{
        if (![self isValidPhoneNum:_phoneView.textField.text]) {
            NSString *textStr = @"请输入正确的号码格式,如固话:010-88888888或手机号:138********";
            CGSize size = [AdaptationSize getSizeFromString:textStr Font:[UIFont systemFontOfSize:11] withHight:CGFLOAT_MAX withWidth:kWidth-21*2];
            remindLabel.frame = CGRectMake(21, remindLabel.frame.origin.y,kWidth-21*2,size.height);
            finishBtn.frame = CGRectMake(finishBtn.frame.origin.x, remindLabel.frame.origin.y+remindLabel.frame.size.height+10, finishBtn.frame.size.width, finishBtn.frame.size.height);
            remindLabel.text = textStr;
            finishBtn.frame = CGRectMake(finishBtn.frame.origin.x, remindLabel.frame.origin.y+remindLabel.frame.size.height+10, finishBtn.frame.size.width, finishBtn.frame.size.height);
            
            [UIView animateWithDuration:0.3 animations:^{
                if (isEditing) {
                    [_scrollView setContentSize:CGSizeMake(kWidth, finishBtn.frame.origin.y+finishBtn.frame.size.height+20+240)];
                    
                }else{
                    [_scrollView setContentSize:CGSizeMake(kWidth, finishBtn.frame.origin.y+finishBtn.frame.size.height+20)];
                }
            }];
            return NO;
        }
    }
    //企业邮箱必添  其他可选
    if (_emailView.textField.text.length == 0) {
        NSString *textStr = @"企业邮箱不能为空";
        CGSize size = [AdaptationSize getSizeFromString:textStr Font:[UIFont systemFontOfSize:11] withHight:CGFLOAT_MAX withWidth:kWidth-21*2];
        remindLabel.frame = CGRectMake(21, remindLabel.frame.origin.y,kWidth-21*2,size.height);
        finishBtn.frame = CGRectMake(finishBtn.frame.origin.x, remindLabel.frame.origin.y+remindLabel.frame.size.height+10, finishBtn.frame.size.width, finishBtn.frame.size.height);
        remindLabel.text = textStr;
        finishBtn.frame = CGRectMake(finishBtn.frame.origin.x, remindLabel.frame.origin.y+remindLabel.frame.size.height+10, finishBtn.frame.size.width, finishBtn.frame.size.height);
        
        [UIView animateWithDuration:0.3 animations:^{
            if (isEditing) {
                [_scrollView setContentSize:CGSizeMake(kWidth, finishBtn.frame.origin.y+finishBtn.frame.size.height+20+240)];
                
            }else{
                [_scrollView setContentSize:CGSizeMake(kWidth, finishBtn.frame.origin.y+finishBtn.frame.size.height+20)];
            }
        }];
        
        return NO;
    }
    if (![self isValidateEmail:_emailView.textField.text]) {
        
        NSString *textStr = @"请输入正确的邮箱格式";
        CGSize size = [AdaptationSize getSizeFromString:textStr Font:[UIFont systemFontOfSize:11] withHight:CGFLOAT_MAX withWidth:kWidth-21*2];
        remindLabel.frame = CGRectMake(21, remindLabel.frame.origin.y,kWidth-21*2,size.height);
        finishBtn.frame = CGRectMake(finishBtn.frame.origin.x, remindLabel.frame.origin.y+remindLabel.frame.size.height+10, finishBtn.frame.size.width, finishBtn.frame.size.height);
        remindLabel.text = textStr;
        finishBtn.frame = CGRectMake(finishBtn.frame.origin.x, remindLabel.frame.origin.y+remindLabel.frame.size.height+10, finishBtn.frame.size.width, finishBtn.frame.size.height);
        [UIView animateWithDuration:0.3 animations:^{
            if (isEditing) {
                [_scrollView setContentSize:CGSizeMake(kWidth, finishBtn.frame.origin.y+finishBtn.frame.size.height+20+240)];
                
            }else{
                [_scrollView setContentSize:CGSizeMake(kWidth, finishBtn.frame.origin.y+finishBtn.frame.size.height+20)];
            }
        }];
        return NO;
    }
    return YES;
}



//判断邮箱格式是否正确
-(BOOL)isValidateEmail:(NSString *)email {
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:email];
    
}

- (BOOL)isValidPhoneNum:(NSString *)phoneNum{
    NSString *phoneRegex  =  @"((0\\d{2,3}-\\d{7,8})|(^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}))$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:phoneNum];
}

#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    _iconImage.image = portraitImg;
    isExistImg = YES;
    [picker dismissViewControllerAnimated:YES completion:nil];
}



- (void)imageClicked:(ProImageView *)image{
    if (image.tag == ICON_TYPE) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"选取普通照片" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从相册选取", nil];
        alertView.delegate = self;
        [alertView show];
    }
}

#pragma mark alertView_delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1){
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.allowsEditing = YES;
            picker.delegate = self;
            [self presentViewController:picker animated:YES completion:nil];
        }
    }else if(buttonIndex ==2){
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.allowsEditing = YES;
        picker.delegate = self;
        [self presentViewController:picker animated:YES completion:nil];
    }
    
}


- (void)didReceiveMemoryWarning {
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
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
