//
//  TYPEID_View.h
//  DoExt_UI
//
//  Created by @userName on @time.
//  Copyright (c) 2015年 DoExt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DoExt_TextField_IView.h"
#import "DoExt_TextField_UIModel.h"
#import "doIUIModuleView.h"

@interface DoExt_TextField_UIView : UITextField<DoExt_TextField_IView,doIUIModuleView,UITextFieldDelegate>
//可根据具体实现替换UIView
{
    @private
    __weak DoExt_TextField_UIModel *_model;
}

@end
