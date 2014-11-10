//
//  SelectImageController.m
//  PEM
//
//  Created by tianj on 14-11-10.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "SelectImageController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "SelectImgCell.h"
#import "ProImageView.h"

@interface SelectImageController ()<UITableViewDataSource,UITableViewDelegate,ProImageViewDelegate>
{
    NSMutableArray *_assets;
    ALAssetsLibrary *_assetsLibrary;
    UITableView *_tableView;
}
@end

@implementation SelectImageController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _assets = [[NSMutableArray alloc] initWithCapacity:0];
    _assetsLibrary = [[ALAssetsLibrary alloc] init];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, kHeight-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.separatorColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    [self getImgFromLibray];
}

- (void)getImgFromLibray
{
    dispatch_async(dispatch_get_main_queue(), ^{
        ALAssetsLibraryAccessFailureBlock failureblock = ^(NSError *myerror){
            NSLog(@"相册访问失败 =%@", [myerror localizedDescription]);
            if ([myerror.localizedDescription rangeOfString:@"Global denied access"].location!=NSNotFound) {
                NSLog(@"无法访问相册.请在'设置->定位服务'设置为打开状态.");
            }else{
                NSLog(@"相册访问失败.");
            }
        };
        
        ALAssetsGroupEnumerationResultsBlock groupEnumerAtion = ^(ALAsset *result, NSUInteger index, BOOL *stop){
            if (result!=NULL) {
                
                if ([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]) {
                    
                    NSString *urlstr=[NSString stringWithFormat:@"%@",result.defaultRepresentation.url];//图片的url
                    [_assets addObject:urlstr];
                    NSLog(@"%d",_assets.count);
                    [_tableView performSelectorOnMainThread:@selector(reloadData) withObject:self waitUntilDone:NO];
                }
            }
            
        };
        ALAssetsLibraryGroupsEnumerationResultsBlock
        libraryGroupsEnumeration = ^(ALAssetsGroup* group, BOOL* stop){
              if (group!=nil) {
                  
                NSString *g=[NSString stringWithFormat:@"----%@",group];//获取相簿的组
                NSLog(@"%@",g);
                [group enumerateAssetsUsingBlock:groupEnumerAtion];
            }
            
        };
        ALAssetsLibrary* library = [[ALAssetsLibrary alloc] init];
        [library enumerateGroupsWithTypes:ALAssetsGroupAll
                               usingBlock:libraryGroupsEnumeration
                             failureBlock:failureblock];
        
    });
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (_assets.count+1)%3==0? (_assets.count+1)/3:(_assets.count+1)/3+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"identiry";
    SelectImgCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell==nil) {
        cell = [[SelectImgCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identify];
    }
    if (indexPath.row==0) {
        UIImageView *imgeView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"takePhoto.png"]];
        imgeView.frame = CGRectMake(0, 0, 37, 28);
        [cell.img1 addSubview:imgeView];
        imgeView.center = cell.img1.center;
        cell.img1.delegate = self;
        cell.img1.tag = 999;
        cell.img1.backgroundColor = HexRGB(0x353534);
        if (_assets.count!=0) {
            NSString *urlStr1 = [_assets objectAtIndex:0];
            NSURL *imgUrl1 = [NSURL URLWithString:urlStr1];
            [_assetsLibrary assetForURL:imgUrl1 resultBlock:^(ALAsset *asset) {
                cell.img2.image = [UIImage imageWithCGImage:asset.thumbnail];
                cell.img2.delegate = self;
                cell.img2.tag = 1000;
            } failureBlock:^(NSError *error) {
                NSLog(@"%@",error);
            }];
            if (_assets.count>1) {
                NSString *urlStr = [_assets objectAtIndex:1];
                NSURL *imgUrl = [NSURL URLWithString:urlStr];
                [_assetsLibrary assetForURL:imgUrl resultBlock:^(ALAsset *asset) {
                    cell.img3.image = [UIImage imageWithCGImage:asset.thumbnail];
                    cell.img3.delegate = self;
                    cell.img3.tag = 1001;
                } failureBlock:^(NSError *error) {
                    NSLog(@"%@",error);
                }];
            }
        }
    }else{
        NSString *urlStr1 = [_assets objectAtIndex:indexPath.row*3-1];
        NSURL *imgUrl1 = [NSURL URLWithString:urlStr1];
        [_assetsLibrary assetForURL:imgUrl1 resultBlock:^(ALAsset *asset) {
            cell.img1.image = [UIImage imageWithCGImage:asset.thumbnail];
            cell.img1.delegate = self;
            cell.img1.tag = 1000+indexPath.row*3-1;
        } failureBlock:^(NSError *error) {
            NSLog(@"%@",error);
        }];
        NSInteger count = _assets.count;
        if (indexPath.row*3<count) {
            NSString *urlStr2 = [_assets objectAtIndex:indexPath.row*3];
            NSURL *imgUrl2 = [NSURL URLWithString:urlStr2];
            [_assetsLibrary assetForURL:imgUrl2 resultBlock:^(ALAsset *asset) {
                cell.img2.image = [UIImage imageWithCGImage:asset.thumbnail];
                cell.img2.delegate =self;
                cell.img2.tag =1000+indexPath.row*3;
            } failureBlock:^(NSError *error) {
                NSLog(@"%@",error);
            }];
        }
        if (indexPath.row*3+1< count) {
            NSString *urlStr3 = [_assets objectAtIndex:indexPath.row*3+1];
            NSURL *imgUrl3 = [NSURL URLWithString:urlStr3];
            [_assetsLibrary assetForURL:imgUrl3 resultBlock:^(ALAsset *asset) {
                cell.img3.image = [UIImage imageWithCGImage:asset.thumbnail];
                cell.img3.delegate =self;
                cell.img3.tag = 1000+indexPath.row*3+1;
            } failureBlock:^(NSError *error) {
                NSLog(@"%@",error);
            }];

        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)imageClicked:(ProImageView *)image
{
    NSLog(@"%d",image.tag);
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (kWidth-4)/3+2;
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
