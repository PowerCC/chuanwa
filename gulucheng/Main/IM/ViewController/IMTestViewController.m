//
//  IMTestViewController.m
//  GuluCheng
//
//  Created by PWC on 2017/2/6.
//  Copyright © 2017年 许坤志. All rights reserved.
//

#import "IMTestViewController.h"
#import "UIViewController+SearchController.h"

@interface IMTestViewController ()

//@property (strong, nonatomic) UISearchController *searchController;

@end

@implementation IMTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self enableSearchController];
    
    [self.searchView addSubview:self.searchController.searchBar];
    
//    _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
//    _searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
//    _searchController.searchBar.placeholder = @"搜索用户";
//    _searchController.searchResultsUpdater = self;
//    _searchController.dimsBackgroundDuringPresentation = YES;
//    _searchController.hidesNavigationBarDuringPresentation = YES;
//    if ([_searchController respondsToSelector:@selector(setObscuresBackgroundDuringPresentation:)]) {
//        [_searchController setObscuresBackgroundDuringPresentation:YES];
//    }
//    [self.searchView addSubview:_searchController.searchBar];    //将searbar添加在self.view上，这一步很重要.
//    //重点：在合适的地方添加下面一行代码
//    self.definesPresentationContext = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
