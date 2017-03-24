//
//  UtilMacros.h
//  gulucheng
//
//  Created by 许坤志 on 16/7/24.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#ifndef UtilMacros_h
#define UtilMacros_h

#define host                @"http://api.chuanwa.ltd:8080"
//#define imageuploadurl      @"http://mnc999.f3322.net:10100"

#define userRegister        @"/feeling/user/reg"                        // 用户注册
#define userLogin           @"/feeling/user/login"                      // 用户登录
#define userLogout          @"/feeling/user/logout"                     // 用户正常退出
#define updatePassword      @"/feeling/user/uptPwd"                     // 修改密码
#define updateUserStatus    @"/feeling/user/uptUserStatus"              // 修改用户状态
#define updateUserInfo      @"/feeling/user/uptUserInfo"                // 更新用户信息
#define verifyUserCode      @"/feeling/user/verifyCode"                 // 获取验证码
#define checkVerifyCode     @"/feeling/user/chkVerifyCode"              // 校验验证码是否正确
#define resetPassword       @"/feeling/user/resetPwd"                   // 找回密码【重置密码】
#define checkMobile         @"/feeling/user/chkMobile"                  // 校验手机号是否已经存在
#define sendFeedBack        @"/feeling/user/sendFeedBack"               // 意见反馈

/*! 用户事件接口 */
#define eventList           @"/feeling/userEvent/eventList"             // 获得用户事件列表【包括历史和当前的】
#define profile             @"/feeling/userEvent/profile"               // 用户的个人主页-基本数据部分
#define eventCommentedList  @"/feeling/userEvent/eventCommentedList"    // 用户的通知页面【新留言通知】
#define chkNewComment       @"/feeling/userEvent/chkNewComment"         // 判断是否有新留言通知
#define chkNewNotice        @"/feeling/userEvent/chkNewNotice"          // 检查是否有新动态【包括新留言和新他人卡片留言】
#define eventNoticeList     @"/feeling/userEvent/eventNoticeList"       // 查询用户某类通知列表
#define turnOnPush          @"/feeling/userEvent/turnOnPush"            // 开启用户对某个卡片的push
#define turnOffPush         @"/feeling/userEvent/turnOffPush"           // 关闭用户对某个卡片的push

/*! 事件评论接口 */
#define countComment        @"/feeling/ec/countComment"                 // 查询评论总数
#define commentList         @"/feeling/ec/commentListV2"                  // 获得评论列表
#define commentEvent        @"/feeling/ec/commentEvent"                 // 对某个事件进行评论
#define delCommentEvent     @"/feeling/ec/delComment"                   // 对某个事件评论进行删除

/*! 事件相关接口 */
#define voteEvent           @"/feeling/event/voteEvent"                 // 对投票事件进行投票
#define getEventCycle       @"/feeling/event/getEventCycle"             // 获得事件流转列表
#define getEventByEid       @"/feeling/event/getEventByEid"             // 根据事件id获得事件信息
#define skipEvent           @"/feeling/event/skipEvent"                 // 推荐事件后，用户点击跳过且忽略
#define spreadEvent         @"/feeling/event/spreadEvent"               // 推荐事件后，用户点击传播
#define publishVote         @"/feeling/event/publishVote"               // 发布投票事件
#define publishText         @"/feeling/event/publishText"               // 发布文字事件
#define publishMedia        @"/feeling/event/publishMedia"              // 发布图片/视频事件
#define recommendEvent      @"/feeling/event/recommendEvent"            // 推荐事件
#define spreadList          @"/feeling/event/spreadList"                // 获得某个事件的传播列表
#define statistics          @"/feeling/event/statistics"                // 获得某个事件的统计数据
#define commentedList       @"/feeling/event/getCommentedList"          // 获得当前用户评论过的事件列表
#define eventTipOffs        @"/feeling/event/eventTipOffs"              // 用户针对某个事件进行举报
#define delEvent            @"/feeling/event/delEvent"                  // 用户删除某个事件

/*! 用户收藏接口 */
#define favoriteAdd         @"/feeling/favorite/add"                    // 用户收藏某个卡片
#define favoriteCancel      @"/feeling/favorite/cancel"                 // 用户取消收藏某个卡片
#define favoriteList        @"/feeling/favorite/list"                   // 用户收藏列表
#define favoriteCheck       @"/feeling/favorite/check"                  // 检查收藏和push状态
#define favoriteUsers       @"/feeling/favorite/favoriteUsers"          // 某个事件的收藏用户列表


#endif /* UtilMacros_h */
