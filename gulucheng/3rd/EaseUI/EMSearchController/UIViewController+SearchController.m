/************************************************************
 *  * Hyphenate CONFIDENTIAL
 * __________________
 * Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of Hyphenate Inc.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Hyphenate Inc.
 */

#import "UIViewController+SearchController.h"
#import <objc/runtime.h>
#import "UIImage+ColorImage.h"

static const void *SearchControllerKey = &SearchControllerKey;
static const void *ResultControllerKey = &ResultControllerKey;

@implementation UIViewController (SearchController)

@dynamic searchController;
@dynamic resultController;

#pragma mark - getter & setter

- (UISearchController *)searchController
{
    return objc_getAssociatedObject(self, SearchControllerKey);
}

- (void)setSearchController:(UISearchController *)searchController
{
    objc_setAssociatedObject(self, SearchControllerKey, searchController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (EMSearchResultController *)resultController
{
    return objc_getAssociatedObject(self, ResultControllerKey);
}

- (void)setResultController:(EMSearchResultController *)resultController
{
    objc_setAssociatedObject(self, ResultControllerKey, resultController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - enable

- (void)enableSearchController
{
    self.resultController = [[EMSearchResultController alloc] init];
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:self.resultController];
    
    self.searchController.hidesNavigationBarDuringPresentation = YES;
    self.searchController.dimsBackgroundDuringPresentation = YES;
    if ([self.searchController respondsToSelector:@selector(setObscuresBackgroundDuringPresentation:)]) {
        [self.searchController setObscuresBackgroundDuringPresentation:YES];
    }
    
//    self.searchController.searchBar.frame = CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, 44);
    [self.searchController.searchBar setImage:[UIImage imageNamed:@"im-search"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];// 设置搜索框内放大镜图片
    
    self.searchController.searchBar.tintColor = kCOLOR(255, 129, 105, 1);//kCOLOR(186, 196, 212, 1.0);// 设置搜索框内按钮文字颜色，以及搜索光标颜色。
    
//    self.searchController.searchBar.barTintColor = [UIColor whiteColor];// 设置搜索框背景颜色
    self.searchController.searchBar.backgroundImage = [UIImage imageWithColor:[UIColor clearColor] size:self.searchController.searchBar.bounds.size];
    self.searchController.searchBar.backgroundColor = [UIColor whiteColor];
    [self.searchController.searchBar setSearchFieldBackgroundImage:[UIImage imageWithColor:kCOLOR(239, 242, 247, 1.0) size:CGSizeMake(1, 28)] forState:UIControlStateNormal];
    self.searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    self.searchController.searchResultsUpdater = self;
    self.searchController.delegate = self;
    
    self.definesPresentationContext = YES;
}

#pragma mark - disable

- (void)disableSearchController
{
    self.searchController.searchBar.delegate = nil;
    self.searchController = nil;
}

#pragma mark - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    if ([self conformsToProtocol:@protocol(EMSearchControllerDelegate)] &&
        [self respondsToSelector:@selector(willSearchBegin)]) {
        [self performSelector:@selector(willSearchBegin)];
    }
    
    return YES;
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        if ([self conformsToProtocol:@protocol(EMSearchControllerDelegate)] &&
            [self respondsToSelector:@selector(didSearchFinish)]) {
            [self performSelector:@selector(didSearchFinish)];
        }
    }
    
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    if ([self conformsToProtocol:@protocol(EMSearchControllerDelegate)] &&
        [self respondsToSelector:@selector(cancelButtonClicked)]) {
        [self performSelector:@selector(cancelButtonClicked)];
    }
}

- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar
{
    return UIBarPositionTopAttached;
}

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    if ([self conformsToProtocol:@protocol(EMSearchControllerDelegate)]
        && [self respondsToSelector:@selector(searchTextChangeWithString:)]) {
        [self performSelector:@selector(searchTextChangeWithString:)
                   withObject:searchController.searchBar.text];
    }
}

#pragma mark - public

- (void)cancelSearch
{
    [self.searchController setActive:NO];
}

@end

