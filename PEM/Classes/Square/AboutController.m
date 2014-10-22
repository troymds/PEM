//
//  AboutController.m
//  PEM
//
//  Created by tianj on 14-8-29.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "AboutController.h"

@interface AboutController ()

@end

@implementation AboutController

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
    self.title = @"关于我们";
    self.view.backgroundColor = HexRGB(0xffffff);

    // Do any additional setup after loading the view.
    [self addView];
}

- (void)addView{
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake((kWidth-263)/2, 20, 263, 84)];
    imgView.image = [UIImage imageNamed:@"aboutus.png"];
    [self.view addSubview:imgView];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(25, 150, kWidth-25*2, 160)];
    bgView.backgroundColor = HexRGB(0xffffff);
    bgView.layer.borderColor = HexRGB(0xd5d5d5).CGColor;
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 6.0;
    bgView.layer.borderWidth = 1.0;
    [self.view addSubview:bgView];
    
    for (int i = 1; i < 4; i++) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 40*i, bgView.frame.size.width, 1)];
        lineView.backgroundColor = HexRGB(0xd5d5d5);
        [bgView addSubview:lineView];
    }
    NSArray *arr = [NSArray arrayWithObjects:@"公司名称",@"联 系 人",@"企业邮箱",@"联系电话", nil];
    NSArray *array = [NSArray arrayWithObjects:@"南京普而摩网络技术有限公司",@"董小姐",@"kefu@chinapromo.cn",@"025-68713202", nil];
    for (int i = 0; i < 4; i++) {
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 10+i*(20+20),70, 20)];
        nameLabel.text = [arr objectAtIndex:i];
        nameLabel.font = [UIFont systemFontOfSize:PxFont(22)];
        nameLabel.backgroundColor  = [UIColor clearColor];
        nameLabel.textColor = HexRGB(0x666666);
        [bgView addSubview:nameLabel];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(75, 10+i*(20+20), 5, 20)];
        label.text = @":";
        label.backgroundColor  = [UIColor clearColor];
        label.textColor = HexRGB(0x666666);
        [bgView addSubview:label];

        UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(86, 10+i*(20+20),bgView.frame.size.width-85, 20)];
        detailLabel.text = [array objectAtIndex:i];
        detailLabel.font = [UIFont systemFontOfSize:PxFont(18)];
        detailLabel.textColor = HexRGB(0x808080);
        detailLabel.backgroundColor = [UIColor clearColor];
        [bgView addSubview:detailLabel];
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
