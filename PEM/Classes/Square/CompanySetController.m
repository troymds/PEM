//
//  CompanySetController.m
//  PEM
//
//  Created by tianj on 14-8-28.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "CompanySetController.h"
#import "SetCellView.h"
#import "HttpTool.h"
#import "SystemConfig.h"
#import "CompanyInfoItem.h"
#import "UIImageView+WebCache.h"
#import "GTMBase64.h"
#import "RemindView.h"
#import "CityController.h"

#define SETICON_TYPE 6000
#define ICON_TYPE 6001
#define NAME_TYPE 6002
#define AREA_TYPE 6003
#define PHONE_TYPE 6004
#define WEBSITE_TYPE 6005
#define EMAIL_TYPE 6006
#define PROVINCE_TYPE 6007
#define CITY_TYPE 6008

@interface CompanySetController ()

@end

@implementation CompanySetController

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
    self.title = @"企业设置";
    self.view.backgroundColor = HexRGB(0xffffff);

    // Do any additional setup after loading the view.
    [self addView];
    
    if ([SystemConfig sharedInstance].isUserLogin){
        //若处于登录状态 将企业信息显示在页面上进行修改
        [self loadInfoData:[SystemConfig sharedInstance].companyInfo];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHiden) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillHiden{
    [UIView animateWithDuration:0.2 animations:^{
        if (_offset.y > _scrollView.contentSize.height-_scrollView.frame.size.height) {
            _offset.y =_scrollView.contentSize.height-_scrollView.frame.size.height;
        }
        _scrollView.contentOffset = _offset;
    }];
}

- (void)addView
{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight-64)];
    _scrollView.backgroundColor = HexRGB(0xffffff);
    [_scrollView setContentSize:CGSizeMake(kWidth, 500)];
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
    _iconImage.delegate = self;
    [_iconSetView addSubview:_iconImage];
    [_scrollView addSubview:_iconSetView];
    
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(21, 133, kWidth-42, 280)];
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
    _areaView.textField.keyboardType = UIKeyboardTypePhonePad;
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
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(21, 443, kWidth-42,35);
    [button setTitle:@"完 成" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:[UIImage imageNamed:@"finish.png"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"finish_pre.png"] forState:UIControlStateHighlighted];
    [_scrollView addSubview:button];
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

- (void)loadInfoData:(CompanyInfoItem *)item{
    //如果以前上传过图片  则显示图片
    if (item.image&&item.image.length!=0){
        [_iconImage setImageWithURL:[NSURL URLWithString:item.image]];
        isExistImg = YES;
        _imgStr = item.image;
    }
    _nameView.textField.text = item.company_name;
    _areaView.textField.text = item.address;
    _websiteView.textField.text = item.website;
    _emailView.textField.text = item.email;
    _phoneView.textField.text = item.company_tel;
    _provinceView.contentLabel.text = item.province_name;
    _cityView.contentLabel.text = item.city_name;
    
    
    provinceName = item.province_name;
    cityName = item.city_name;
    _provinceId = item.province_id;
    _cityId = item.city_id;
}

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

- (void)buttonClick{
    if ([self checkOut]){
        if (isExistImg){
            if (isModifyImg) {
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
                    NSDictionary *dic = [result objectForKey:@"response"];
                    if ([[dic objectForKey:@"code"] intValue] == 100){
                        _imgStr = [dic objectForKey:@"data"];
                        [self updateData];
                    }else{
                        [RemindView showViewWithTitle:@"设置失败" location:MIDDLE];
                    }
                }failure:^(NSError *error){
                    NSLog(@"%@",error);
                }];
            }else{
                [self updateData];
            }
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
        if ([[dic objectForKey:@"code"] intValue] == 100){
            if ([SystemConfig sharedInstance].companyInfo){
                //设置成功后更新单例中的企业数据
                [SystemConfig sharedInstance].companyInfo.image = _imgStr;
                [SystemConfig sharedInstance].companyInfo.company_name = _nameView.textField.text;
                [SystemConfig sharedInstance].companyInfo.province_id = _provinceId;
                [SystemConfig sharedInstance].companyInfo.province_name = provinceName;
                [SystemConfig sharedInstance].companyInfo.city_id = _cityId;
                [SystemConfig sharedInstance].companyInfo.city_name = cityName;
                [SystemConfig sharedInstance].companyInfo.address = _areaView.textField.text;
                [SystemConfig sharedInstance].companyInfo.company_tel = _phoneView.textField.text;
                [SystemConfig sharedInstance].companyInfo.website = _websiteView.textField.text;
                [SystemConfig sharedInstance].companyInfo.email = _emailView.textField.text;
            }
            if ([self.pushType isEqualToString:DERECT_SET_TYPE]){
                [RemindView showViewWithTitle:@"设置成功" location:BELLOW];
            }else  if([self.pushType isEqualToString:PUBLISH_TYPE]){
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else{
                //注册成功  跳转到登陆页面
                UIViewController *vc = [self.navigationController.viewControllers objectAtIndex:1];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"registerSuccess" object:nil];
                [self.navigationController popToViewController:vc animated:YES];
            }
        }else if([[dic objectForKey:@"code"] intValue] == 101){
            [RemindView showViewWithTitle:@"注册失败" location:MIDDLE];
        }else if([[dic objectForKey:@"code"] intValue] == 102){
            [RemindView showViewWithTitle:@"邮箱已被占用" location:MIDDLE];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];

}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    activeField = textField;
    switch (textField.tag) {
        case NAME_TYPE:
        {
            if (_iPhone4){
                if (_scrollView.contentOffset.y < 40) {
                    [UIView animateWithDuration:0.2 animations:^{
                        CGPoint offset = _scrollView.contentOffset;
                        _offset = offset;
                        offset.y = 40;
                        _scrollView.contentOffset = offset;
                    }];
                }
            }
        }
            break;
        case AREA_TYPE:
        {
            if (_iPhone4){
                if (_scrollView.contentOffset.y < 120) {
                    [UIView animateWithDuration:0.2 animations:^{
                        CGPoint offset = _scrollView.contentOffset;
                        _offset = offset;
                        offset.y = 120;
                        _scrollView.contentOffset = offset;
                    }];
                }
            }else if(iPhone5){
                if (_scrollView.contentOffset.y < 60) {
                    [UIView animateWithDuration:0.2 animations:^{
                        CGPoint offset = _scrollView.contentOffset;
                        _offset = offset;
                        offset.y = 60;
                        _scrollView.contentOffset = offset;
                    }];
                }
            }
        }
            break;
        case PHONE_TYPE:
        {
            if (_iPhone4){
                if (_scrollView.contentOffset.y < 180) {
                    [UIView animateWithDuration:0.2 animations:^{
                        CGPoint offset = _scrollView.contentOffset;
                        _offset = offset;
                        offset.y = 180;
                        _scrollView.contentOffset = offset;
                    }];
                }
            }else if(iPhone5){
                if (_scrollView.contentOffset.y < 120) {
                    [UIView animateWithDuration:0.2 animations:^{
                        CGPoint offset = _scrollView.contentOffset;
                        _offset = offset;
                        offset.y = 120;
                        _scrollView.contentOffset = offset;
                    }];
                }
            }
        }
            break;
        case WEBSITE_TYPE:
        {
            if (_iPhone4){
                if (_scrollView.contentOffset.y < 220) {
                    [UIView animateWithDuration:0.2 animations:^{
                        CGPoint offset = _scrollView.contentOffset;
                        _offset = offset;
                        offset.y = 220;
                        _scrollView.contentOffset = offset;
                    }];
                }
            }else if(iPhone5){
                if (_scrollView.contentOffset.y < 160) {
                    [UIView animateWithDuration:0.2 animations:^{
                        CGPoint offset = _scrollView.contentOffset;
                        _offset = offset;
                        offset.y = 160;
                        _scrollView.contentOffset = offset;
                    }];
                }
            }
        }
            break;
        case EMAIL_TYPE:
        {
            if (_iPhone4){
                if (_scrollView.contentOffset.y < 280) {
                    [UIView animateWithDuration:0.2 animations:^{
                        CGPoint offset = _scrollView.contentOffset;
                        _offset = offset;
                        offset.y = 280;
                        _scrollView.contentOffset = offset;
                    }];
                }
            }else if(iPhone5){
                if (_scrollView.contentOffset.y < 220) {
                    [UIView animateWithDuration:0.2 animations:^{
                        CGPoint offset = _scrollView.contentOffset;
                        _offset = offset;
                        offset.y = 220;
                        _scrollView.contentOffset = offset;
                    }];
                }
            }
        }
            break;

        default:
            break;
    }
}

- (BOOL)checkOut{
    //企业邮箱必添  其他可选
    if (_emailView.textField.text.length == 0) {
        [RemindView showViewWithTitle:@"请填写企业邮箱" location:MIDDLE];
        return NO;
    }
    if (_phoneView.textField.text.length!=0) {
        if (![self isValidPhoneNum:_phoneView.textField.text]) {
            [RemindView showViewWithTitle:@"请填写正确的号码格式" location:MIDDLE];
            return NO;
        }
    }
    if (![self isValidateEmail:_emailView.textField.text]) {
        [RemindView showViewWithTitle:@"邮箱格式不正确" location:MIDDLE];
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
    isModifyImg = YES;
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
