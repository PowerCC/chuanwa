//
//  UserModel.m
//  JiaCheng
//
//  Created by 许坤志 on 16/6/16.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"userID" : @"id"
             };
}

- (void)encodeWithCoder:(NSCoder*)coder {
    [coder encodeObject:self.userID forKey:@"userID"];
    [coder encodeObject:self.nickName forKey:@"nickName"];
    [coder encodeObject:self.avatar forKey:@"avatar"];
    [coder encodeObject:self.cityCode forKey:@"cityCode"];
    [coder encodeObject:self.gender forKey:@"gender"];
    [coder encodeObject:self.loginToken forKey:@"loginToken"];
}

- (id)initWithCoder:(NSCoder*)decoder {
    if (self = [super init]) {
        if (decoder == nil) {
            return self;
        }
        self.userID = [decoder decodeObjectForKey:@"userID"];
        self.nickName = [decoder decodeObjectForKey:@"nickName"];
        self.avatar = [decoder decodeObjectForKey:@"avatar"];
        self.cityCode = [decoder decodeObjectForKey:@"cityCode"];
        self.gender = [decoder decodeObjectForKey:@"gender"];
        self.loginToken = [decoder decodeObjectForKey:@"loginToken"];
    }
    return self;
}


//@property (nonatomic, copy) NSString *userID;
//@property (nonatomic, copy) NSString *nickName;
//@property (nonatomic, copy) NSString *avatar;
//@property (nonatomic, copy) NSString *cityCode;
//@property (nonatomic, copy) NSString *gender;

@end
