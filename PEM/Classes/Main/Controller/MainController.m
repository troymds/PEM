//
//  MainController.m
//  新浪微博
//
//  Created by apple on 13-10-26.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MainController.h"
#import "Dock.h"
#import "HomeController.h"
#import "MoreController.h"
#import "MeController.h"
#import "MessageController.h"
#import "SpuareController.h"
#import "UIBarButtonItem+MJ.h"
#import "WBNavigationController.h"
#define kDockHeight 44

@interface MainController () <DockDelegate,UINavigationControllerDelegate>
@end
@implementation MainController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor whiteColor];
    // 1.初始化所有的子控制器
    [self addAllChildControllers];
    
    // 2.初始化DockItems
    [self addDockItems];
}

#pragma mark 初始化所有的子控制器
- (void)addAllChildControllers
{
    // 1.首页
    HomeController *home = [[HomeController alloc] init];
        WBNavigationController *nav1 = [[WBNavigationController alloc] initWithRootViewController:home];
        nav1.delegate = self;
    // self在，添加的子控制器就存在
    [self addChildViewController:nav1];
    
    //    // 2.消息
    MessageController *msg = [[MessageController alloc] init];
    msg.delegate = self;
        WBNavigationController *nav2 = [[WBNavigationController alloc] initWithRootViewController:msg];
        nav2.delegate = self;
    [self addChildViewController:nav2];
    //
    // 3.我
    MeController *me = [[MeController alloc] init];
    me.delegate = self;
        WBNavigationController *nav3 = [[WBNavigationController alloc] initWithRootViewController:me];
        nav3.delegate = self;
    [self addChildViewController:nav3];
    
    // 4.广场
    SpuareController *square = [[SpuareController alloc] init];
        WBNavigationController *nav4 = [[WBNavigationController alloc] initWithRootViewController:square];
        nav4.delegate = self;
    [self addChildViewController:nav4];
    
}

#pragma mark 实现导航控制器代理方法
// 导航控制器即将显示新的控制器
- (void)navigationController:(WBNavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //    if (![viewController isKindOfClass:[HomeController class]])
    // 如果显示的不是根控制器，就需要拉长导航控制器view的高度
    
    // 1.获得当期导航控制器的根控制器
    UIViewController *root = navigationController.viewControllers[0];
    if (root != viewController) { // 不是根控制器
        // {0, 20}, {320, 460}
        // 2.拉长导航控制器的view
        CGRect frame = navigationController.view.frame;
        if (IsIos7) {
            frame.size.height = [UIScreen mainScreen].applicationFrame.size.height+20;
        }else{
            frame.size.height = [UIScreen mainScreen].applicationFrame.size.height;
        }

        navigationController.view.frame = frame;
        
        // 3.添加Dock到根控制器的view上面
        [_dock removeFromSuperview];
        CGRect dockFrame = _dock.frame;
        dockFrame.origin.y = root.view.frame.size.height - _dock.frame.size.height;
        if ([root.view isKindOfClass:[UIScrollView class]]) { // 根控制器的view是能滚动
            UIScrollView *scroll = (UIScrollView *)root.view;
            dockFrame.origin.y += scroll.contentOffset.y;
        }
        _dock.frame = dockFrame;
        [root.view addSubview:_dock];
        
        // 4.添加左上角的返回按钮
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"nav_return.png" highlightedIcon:@"nav_return_pre.png" target:self action:@selector(backItem)];
        
    }
}

- (void)backItem
{
    [self.childViewControllers[_dock.selectedIndex] popViewControllerAnimated:YES];
}

- (void)navigationController:(WBNavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    UIViewController *root = navigationController.viewControllers[0];
    if (viewController == root) {
        // 1.让导航控制器view的高度还原
        CGRect frame = navigationController.view.frame;
        if (IsIos7) {
            frame.size.height = [UIScreen mainScreen].applicationFrame.size.height+20 - _dock.frame.size.height;
        }else{
            frame.size.height = [UIScreen mainScreen].applicationFrame.size.height - _dock.frame.size.height;
        }
        
        navigationController.view.frame = frame;
        
        // 2.添加Dock到mainView上面
        [_dock removeFromSuperview];
        CGRect dockFrame = _dock.frame;
        // 调整dock的y值
        dockFrame.origin.y = self.view.frame.size.height - _dock.frame.size.height;
        _dock.frame = dockFrame;
        [self.view addSubview:_dock];
        
    }
}

#pragma mark 添加Dock
- (void)addDockItems
{
        // .往Dock里面填充内容
    [_dock addItemWithIcon:@"tab_index.png" selectedIcon:@"tab_index_pre.png" title:@"首页"];
    
    [_dock addItemWithIcon:@"tab_product.png" selectedIcon:@"tab_product_pre.png" title:@"发现"];
    
    [_dock addItemWithIcon:@"tab_release.png" selectedIcon:@"tab_release_pre.png" title:@"发布"];
    
    [_dock addItemWithIcon:@"tab_user.png" selectedIcon:@"tab_user_pre.png" title:@"个人中心"];
    
}

@end
