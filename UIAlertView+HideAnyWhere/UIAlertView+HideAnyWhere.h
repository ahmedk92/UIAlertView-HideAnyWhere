//
//  UIAlertView+HideAnyWhere.h
//  AlertHideDemo
//
//  Created by Ahmed Khalaf on 9/10/17.
//  Copyright © 2017 Ahmed Khalaf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (HideAnyWhere)

+ (void)avhaw_enumerateAlertViewsWithBlock:(void (^)(UIAlertView*))block;
+ (void)avhaw_hideAllAnimated:(BOOL)animated;
+ (void)avhaw_hideAll;

@end
