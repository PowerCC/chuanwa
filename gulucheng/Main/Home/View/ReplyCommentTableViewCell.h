//
//  ReplyCommentTableViewCell.h
//  gulucheng
//
//  Created by PWC on 2017/1/3.
//  Copyright © 2017年 许坤志. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentModel.h"

@interface ReplyCommentTableViewCell : UITableViewCell

@property (strong, nonatomic) UILabel *commentLabel;

@property (strong, nonatomic) CommentModel *commentModel;

@property (copy, nonatomic) void (^commentContentButtonTapBlock)(CommentModel *commentModel);

@end
