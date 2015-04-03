//
//  TYPEID_View.m
//  DoExt_UI
//
//  Created by @userName on @time.
//  Copyright (c) 2015年 DoExt. All rights reserved.
//

#import "do_TextField_UIView.h"

#import "doIPage.h"
#import "doUIModuleHelper.h"
#import "doScriptEngineHelper.h"
#import "doTextHelper.h"
#import "doDefines.h"

@implementation do_TextField_UIView
{
    float keyBoardHeight;
    NSString *_myFontStyle;
    NSString *_oldFontStyle;
}

#pragma mark - doIUIModuleView协议方法（必须）
//引用Model对象
- (void) LoadView: (doUIModule *) _doUIModule
{
    _model = (typeof(_model)) _doUIModule;
    self.delegate =self;
    self.textColor = [UIColor blackColor];
    [self change_fontSize:[_model GetProperty:@"fontSize"].DefaultValue];
}
//销毁所有的全局对象
- (void) OnDispose
{
    _myFontStyle = nil;
    //自定义的全局属性
}
//实现布局
- (void) OnRedraw
{
    //实现布局相关的修改
    
    //重新调整视图的x,y,w,h
    [doUIModuleHelper OnRedraw:_model];
}

#pragma mark - TYPEID_IView协议方法（必须）
#pragma mark - Changed_属性
/*
 如果在Model及父类中注册过 "属性"，可用这种方法获取
 NSString *属性名 = [(doUIModule *)_model GetPropertyValue:@"属性名"];
 
 获取属性最初的默认值
 NSString *属性名 = [(doUIModule *)_model GetProperty:@"属性名"].DefaultValue;
 */
- (void)change_text:(NSString *)newValue{
    [self setText:newValue];
    if(_myFontStyle)
        [self change_fontStyle:_myFontStyle];
}
- (void)change_fontColor:(NSString *)newValue{
    [self setTextColor:[doUIModuleHelper GetColorFromString:newValue :[UIColor blackColor]]];
}
- (void)change_fontSize:(NSString *)newValue{
    UIFont * font = self.font;
    if (font == nil) {
        font = [UIFont systemFontOfSize:[[_model GetProperty:@"fontSize"].DefaultValue intValue]];
    }
    int _intFontSize = [doUIModuleHelper GetDeviceFontSize:[[doTextHelper Instance] StrToInt:newValue :[[_model GetProperty:@"fontSize"].DefaultValue intValue]] :_model.XZoom :_model.YZoom];
    
    self.font = [font fontWithSize:_intFontSize];
}
- (void)change_fontStyle:(NSString *)newValue{
    _myFontStyle = [NSString stringWithFormat:@"%@",newValue];
    if (self.text==nil || [self.text isEqualToString:@""]) return;
    NSRange range = {0,[self.text length]};
    NSMutableAttributedString *str = [self.attributedText mutableCopy];
    [str removeAttribute:NSUnderlineStyleAttributeName range:range];
    self.attributedText = str;
    
    float fontSize = self.font.pointSize;
    if([newValue isEqualToString:@"normal"])
        [self setFont:[UIFont systemFontOfSize:fontSize]];
    else if([newValue isEqualToString:@"bold"])
    {
        if([_oldFontStyle isEqualToString:@"italic"])
            [self setFont:[UIFont fontWithName:@"Helvetica-BoldOblique" size:fontSize]];
        else
            [self setFont:[UIFont boldSystemFontOfSize:fontSize]];
    }
    else if([newValue isEqualToString:@"italic"])
    {
        if([_oldFontStyle isEqualToString:@"bold"])
            [self setFont:[UIFont fontWithName:@"Helvetica-BoldOblique" size:fontSize]];
        else
            [self setFont:[UIFont italicSystemFontOfSize:fontSize]];
    }
    else if([newValue isEqualToString:@"underline"])
    {
        NSMutableAttributedString *content = [self.attributedText mutableCopy];
        NSRange contentRange = {0,[content length]};
        [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
        self.attributedText = content;
        [content endEditing];
    }
    else
    {
        NSString *mesg = [NSString stringWithFormat:@"不支持字体:%@",newValue];
        [NSException raise:@"do_TextField" format:mesg,@""];
    }
    _oldFontStyle = newValue;
}
- (void)change_hint:(NSString *)newValue
{
    [self setPlaceholder:newValue];
}
- (void)change_inputType:(NSString *)newValue{
    if ([newValue isEqualToString:@"ASC"]) {
        self.keyboardType = UIKeyboardTypeASCIICapable;
    }else if([newValue isEqualToString:@"PHONENUMBER"]){
        self.keyboardType = UIKeyboardTypePhonePad;
    }else if([newValue isEqualToString:@"URL"]){
        self.keyboardType = UIKeyboardTypeURL;
    }else if ([newValue isEqualToString:@"ENG"]) {
        self.keyboardType = UIKeyboardTypeDefault;
    }else if([newValue isEqualToString:@"CHS"]){
        self.keyboardType = UIKeyboardTypeDefault;
    }else if([newValue isEqualToString:@"NUM"]){
        self.keyboardType = UIKeyboardTypeDecimalPad;
    }else{
        self.keyboardType = UIKeyboardTypeDefault;
    }
}
- (void)change_password:(NSString *)newValue{
    if([newValue isEqualToString:@"true"] || [newValue isEqualToString:@"1"])
    {
        self.secureTextEntry = YES;
    }
    else
    {
        self.secureTextEntry = NO;
    }
}
- (void)change_clearAll:(NSString *)newValue{
    if([newValue isEqualToString:@"true"] || [newValue isEqualToString:@"1"])
    {
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    else
    {
        self.clearButtonMode = UITextFieldViewModeNever;
    }
}

#pragma mark -
#pragma mark keyBoardchangeView
- (void) registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:self];
}

- (void) keyboardWasShown:(NSNotification *) notif
{
    NSDictionary *info = [notif userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGSize keyboardSize = [value CGRectValue].size;
    
    UIInterfaceOrientation orientation =[UIApplication sharedApplication].statusBarOrientation;
    
    if(orientation == UIDeviceOrientationLandscapeLeft ||orientation == UIDeviceOrientationLandscapeRight)
    {
        if(IOS_8)
        {
            keyBoardHeight = keyboardSize.height;
        }
        else
        {
            keyBoardHeight = keyboardSize.width;
        }
        if(keyBoardHeight==352)
        {
            keyBoardHeight=416;
        }
    }
    else
    {
        keyBoardHeight = keyboardSize.height;
    }
    UIViewController *curController = (UIViewController *)_model.CurrentPage.PageView;
    CGRect curRect1 = [self.superview convertRect:self.frame toView:curController.view];
    //216
    if (curRect1.origin.y+curRect1.size.height + keyBoardHeight >curController.view.frame.size.height) {
        float moveHeight = (curRect1.origin.y+curRect1.size.height + keyBoardHeight - curController.view.frame.size.height+20);
        [UIView animateWithDuration:0.3 animations:^{
            curController.view.frame = CGRectMake(0, -moveHeight, curController.view.frame.size.width, curController.view.frame.size.height);
        }];
    }
}
- (void) keyboardWasHidden:(NSNotification *) notif
{
    UIViewController *curController = (UIViewController *)_model.CurrentPage.PageView;
    [UIView animateWithDuration:0.3 animations:^{
        curController.view.frame = CGRectMake(0, 0, curController.view.frame.size.width, curController.view.frame.size.height);
    }];
}

#pragma mark - UITextField delegate
-(BOOL)textField:(UITextField *)textFiled shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self resignFirstResponder];
    UIViewController *curController = (UIViewController *)_model.CurrentPage.PageView;
    [UIView animateWithDuration:0.3 animations:^{
        curController.view.frame = CGRectMake(0, 0, curController.view.frame.size.width, curController.view.frame.size.height);
    }];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self registerForKeyboardNotifications];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    UIViewController *curController  = (UIViewController *)_model.CurrentPage.PageView;
    CGRect curRect1 = [self.superview convertRect:self.frame toView:curController.view];
    if (curRect1.origin.y+curRect1.size.height+keyBoardHeight >curController.view.frame.size.height) {
        float moveHeight = (curRect1.origin.y+curRect1.size.height+keyBoardHeight - curController.view.frame.size.height+20);
        [UIView animateWithDuration:0.3 animations:^{
            curController.view.frame = CGRectMake(0, -moveHeight, curController.view.frame.size.width, curController.view.frame.size.height);
        }];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)textFieldChanged:(id)sender
{
    [_model SetPropertyValue:@"text" :self.text];
    //change事件
    doInvokeResult *_invokeResult = [[doInvokeResult alloc]init:_model.UniqueKey];
    [_invokeResult SetResultText:self.text];
    [_model.EventCenter FireEvent:@"changed":_invokeResult];
}

#pragma mark - doIUIModuleView协议方法（必须）<大部分情况不需修改>
- (BOOL) OnPropertiesChanging: (NSMutableDictionary *) _changedValues
{
    //属性改变时,返回NO，将不会执行Changed方法
    return YES;
}
- (void) OnPropertiesChanged: (NSMutableDictionary*) _changedValues
{
    //_model的属性进行修改，同时调用self的对应的属性方法，修改视图
    [doUIModuleHelper HandleViewProperChanged: self :_model : _changedValues ];
}
- (BOOL) InvokeSyncMethod: (NSString *) _methodName : (doJsonNode *)_dicParas :(id<doIScriptEngine>)_scriptEngine : (doInvokeResult *) _invokeResult
{
    //同步消息
    return [doScriptEngineHelper InvokeSyncSelector:self : _methodName :_dicParas :_scriptEngine :_invokeResult];
}
- (BOOL) InvokeAsyncMethod: (NSString *) _methodName : (doJsonNode *) _dicParas :(id<doIScriptEngine>) _scriptEngine : (NSString *) _callbackFuncName
{
    //异步消息
    return [doScriptEngineHelper InvokeASyncSelector:self : _methodName :_dicParas :_scriptEngine: _callbackFuncName];
}
- (doUIModule *) GetModel
{
    //获取model对象
    return _model;
}

@end
