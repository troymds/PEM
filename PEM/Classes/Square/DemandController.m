//
//  DemandController.m
//  PEM
//
//  Created by tianj on 14-9-26.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "DemandController.h"
#import "RemindView.h"
#import "SystemConfig.h"
#import "HttpTool.h"
#import "MyPurchaseController.h"
#import "CategoryController.h"
#import "DescriptionController.h"
#import "HotTagsController.h"
#import "SystemConfig.h"
#import "DemandDetailItem.h"
#import "MyPurchaseController.h"

@interface DemandController ()

@end

@implementation DemandController

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
    _demandView = [[PurchaseView alloc] initWithFrame:CGRectMake(0, 0, kWidth,416)];
    _demandView.delegate =self;
    tagsArray = [NSMutableArray array];
    [self.view addSubview:_demandView];
    if(!_isAdd){
        [self loadData];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillHide
{
    [UIView animateWithDuration:0.3 animations:^{
        _demandView.frame = CGRectMake(0, 0, kWidth, 416);
    }];
}

- (void)loadData
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.dimBackground = NO;
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:[SystemConfig sharedInstance].company_id,@"company_id",_info_id,@"info_id", nil];
    [HttpTool postWithPath:@"getInfoDetail" params:param success:^(id JSON){
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",result);
        NSDictionary *dic = [result objectForKey:@"response"];
        if ([[dic objectForKey:@"code"] intValue] ==100) {
            NSDictionary *data = [dic objectForKey:@"data"];
            DemandDetailItem *item = [[DemandDetailItem alloc] init];
            [item setValuesForKeysWithDictionary:data];
            if ([[data objectForKey:@"from"] isEqualToString:@"pc"]) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您当前求购信息是从PC端发布的,请到PC端修改" delegate:self cancelButtonTitle:nil otherButtonTitles:@"我知道了", nil];
                [alertView show];
            }else{
                [self addDataToViewWithItem:item];
            }
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSLog(@"%@",error);
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)addDataToViewWithItem:(DemandDetailItem *)item
{
    _demandView.categoryLabel.text = item.category_name;
    _demandView.titleTextField.text = item.title;
    _demandView.descriptionLabel.text = item.description;
    _demandView.purchaseNumField.text = item.need_num;
    _demandView.unitField.text = item.unit;
    _demandView.linkManTextField.text = item.contacts;
    _demandView.phoneNumTextField.text = item.phone_num;
    NSMutableString *tagStr = [NSMutableString stringWithString:@""];
    for (int i = 0; i< item.tags.count; i++) {
        NSDictionary *dic = [item.tags objectAtIndex:i];
        [tagStr appendString:[dic objectForKey:@"name"]];
        if (i < [item.tags count]-1) {
            [tagStr appendString:@","];
        }
        [tagsArray addObject:[dic objectForKey:@"name"]];
    }
    _demandView.markLabel.text = tagStr;
    
    
    demandDes = item.description;
    CategoryItem *cateItem = [[CategoryItem alloc] init];
    cateItem.uid = item.category_id;
    cateItem.name = item.category_name;
    demandCateItem = cateItem;
}



#pragma mark - delegate
- (void)buttonDown:(UIButton *)btn
{
    switch (btn.tag) {
        case 3001:
        {
            //发布求购信息
            //判断上传数据是否完整
            if ([self checkPurchaseData]){
                NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:[SystemConfig sharedInstance].company_id,@"company_id",demandCateItem.uid,@"category_id",_demandView.titleTextField.text,@"title",demandDes,@"description",_demandView.phoneNumTextField.text,@"contacts_phone",_demandView.linkManTextField.text,@"contacts",_demandView.markLabel.text,@"tags",@"1",@"type",_demandView.unitField.text,@"unit",_info_id,@"info_id",_demandView.purchaseNumField.text,@"buy_num",nil];
                [HttpTool postWithPath:@"saveInfo" params:param  success:^(id JSON){
                    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
                    NSDictionary *dic = [result objectForKey:@"response"];
                    if ([[dic objectForKey:@"code"] intValue] == 100){
                        
                        //编辑成功，刷新原来列表界面
                        MyPurchaseController *vc = [self.navigationController.viewControllers objectAtIndex:1];
                        self.delegate = vc;
                        if ([self.delegate respondsToSelector:@selector(reloadData)]) {
                            [self.delegate reloadData];
                        }
                        [self.navigationController popToViewController:vc animated:YES];
                    }else{
                        [RemindView showViewWithTitle:@"编辑失败" location:MIDDLE];
                    }
                } failure:^(NSError *error) {
                    NSLog(@"%@",error);
                }];
            }
        }
            break;
        case 10000:
        {
            CategoryController *category = [[CategoryController alloc] init];
            category.delegate = self;
            category.isSupply = NO;
            [self.navigationController pushViewController:category animated:YES];
            
        }
            break;
        case 10001:
        {
            DescriptionController *vc = [[DescriptionController alloc] init];
            vc.delegate = self;
            vc.isSupply = NO;
            if (demandDes.length!=0) {
                vc.text = demandDes;
            }
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 10002:
        {
            HotTagsController *hotVC = [[HotTagsController alloc] init];
            hotVC.delegate = self;
            if (tagsArray.count!=0) {
                hotVC.tagArray = tagsArray;
            }
            [self.navigationController pushViewController:hotVC animated:YES];
        }
            break;

        default:
            break;
    }

}


- (void)sendValueFromViewController:(UIViewController *)controller value:(id)value isDemand:(BOOL)isDemand
{
    if ([controller isKindOfClass:[CategoryController class]]) {
        demandCateItem = value;
        _demandView.categoryLabel.text = demandCateItem.name;
    }else if([controller isKindOfClass:[DescriptionController class]]){
        demandDes = value;
        _demandView.descriptionLabel.text = demandDes;
    }else if([controller isKindOfClass:[HotTagsController class]]){
        tagsArray = value;
        NSMutableString *tagStr = [NSMutableString stringWithString:@""];
        for (int i = 0; i< tagsArray.count; i++) {
            [tagStr appendString:[tagsArray objectAtIndex:i]];
            if (i < [tagsArray count]-1) {
                [tagStr appendString:@","];
            }
        }
        _demandView.markLabel.text = tagStr;
    }
}


//检查发布的求购数据信息
- (BOOL)checkPurchaseData{
    if (!demandCateItem) {
        [RemindView showViewWithTitle:@"请选择分类" location:MIDDLE];
        return NO;
    }
    if (!(_demandView.titleTextField.text.length!=0)) {
        [RemindView showViewWithTitle:@"请填写标题" location:MIDDLE];
        return NO;
    }
    if (!(demandDes&&demandDes.length !=0)) {
        [RemindView showViewWithTitle:@"请填写求购产品的描述信息" location:MIDDLE];
        return NO;
    }
    if (!(_demandView.purchaseNumField.text.length!=0)){
        [RemindView showViewWithTitle:@"请输入需要求购的数量" location:MIDDLE];
        return NO;
    }
    if (!(_demandView.unitField.text.length!=0)) {
        [RemindView showViewWithTitle:@"请输入求购物品的计量单位" location:MIDDLE];
        return NO;
    }
    if (!(_demandView.linkManTextField.text.length!=0)) {
        [RemindView showViewWithTitle:@"请输入联系人" location:MIDDLE];
        return NO;
    }
    if (!(_demandView.phoneNumTextField.text.length!=0)){
        [RemindView showViewWithTitle:@"请输入手机号码" location:MIDDLE];
        return NO;
    }
    if (![self isValidateMobile:_demandView.phoneNumTextField.text]){
        [RemindView showViewWithTitle:@"请输入正确的手机号码" location:MIDDLE];
        return NO;
    }
    return YES;
}


- (void)textFieldBeganEditting:(UITextField *)textField
{
    if (_iPhone4) {
        if (textField.tag == PC_PURCHASE_TYPE) {
            [UIView animateWithDuration:0.3 animations:^{
                _demandView.frame = CGRectMake(0,-60, kWidth, 416);
            }];
        }else if(textField.tag == PC_UNIT_TYPE){
            [UIView animateWithDuration:0.3 animations:^{
                _demandView.frame = CGRectMake(0,-100, kWidth, 416);
            }];
        }else if(textField.tag == PC_LINKMAN_TYPE){
            [UIView animateWithDuration:0.3 animations:^{
                _demandView.frame = CGRectMake(0,-160, kWidth, 416);
            }];
        }else if (textField.tag == PC_PHONENUM_TYPE){
            [UIView animateWithDuration:0.3 animations:^{
                _demandView.frame = CGRectMake(0,-190, kWidth, 416);
            }];
        }
    }else if (_iPhone5){
        if(textField.tag == PC_UNIT_TYPE){
            [UIView animateWithDuration:0.3 animations:^{
                _demandView.frame = CGRectMake(0, -30, kWidth, 416);
            }];
        }else if(textField.tag == PC_LINKMAN_TYPE){
            [UIView animateWithDuration:0.3 animations:^{
                _demandView.frame = CGRectMake(0, -80, kWidth, 416);
            }];
        }else if (textField.tag == PC_PHONENUM_TYPE){
            [UIView animateWithDuration:0.3 animations:^{
                _demandView.frame = CGRectMake(0,-120, kWidth, 416);
            }];
        }
    }
}


-(BOOL)isValidateMobile:(NSString *)mobile
{
    NSString *phoneRegex  =  @"((0\\d{2,3}-\\d{7,8})|(^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}))$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
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
