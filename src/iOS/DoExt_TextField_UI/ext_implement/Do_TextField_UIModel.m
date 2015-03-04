//
//  TYPEID_Model.m
//  DoExt_UI
//
//  Created by @userName on @time.
//  Copyright (c) 2015年 DoExt. All rights reserved.
//

#import "Do_TextField_UIModel.h"
#import "doProperty.h"

@implementation Do_TextField_UIModel

#pragma mark - 注册属性（--属性定义--）
/*
[self RegistProperty:[[doProperty alloc]init:@"属性名" :属性类型 :@"默认值" : BOOL:是否支持代码修改属性]];
 */
-(void)OnInit
{
    [super OnInit];
    //属性声明
    [self RegistProperty:[[doProperty alloc] init:@"text" : String :@"" :NO]];
    [self RegistProperty:[[doProperty alloc] init:@"fontColor" : String :@"000000FF" :NO]];
    [self RegistProperty:[[doProperty alloc] init:@"fontSize" : Number :@"9" :NO]];
    [self RegistProperty:[[doProperty alloc] init:@"fontStyle" : String :@"normal" :NO]];
    [self RegistProperty:[[doProperty alloc] init:@"hint" : String :@"" :NO]];
    [self RegistProperty:[[doProperty alloc] init:@"inputType" : String :@"" :NO]];
    [self RegistProperty:[[doProperty alloc] init:@"password" : Bool :@"false" :NO]];
    [self RegistProperty:[[doProperty alloc] init:@"clearAll" : Bool :@"false" :NO]];
}

@end
