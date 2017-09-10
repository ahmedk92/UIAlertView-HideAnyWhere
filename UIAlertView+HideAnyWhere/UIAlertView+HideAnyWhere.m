//
//  UIAlertView+HideAnyWhere.m
//  AlertHideDemo
//
//  Created by Arabia -IT on 9/10/17.
//  Copyright © 2017 Arabia-IT. All rights reserved.
//

#import "UIAlertView+HideAnyWhere.h"
#import <objc/runtime.h>

#define kAlertMapKey @"avhaw_alert_map"

@implementation UIAlertView (HideAnyWhere)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSelector = @selector(show);
        SEL swizzledSelector = @selector(xxx_show);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        BOOL didAddMethod =
        class_addMethod(class,
                        originalSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod));
        
        if (didAddMethod) {
            class_replaceMethod(class,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

#pragma mark - Method Swizzling

- (void)xxx_show {
    [self xxx_show];
    
    [[self.class alertMap] setObject:self forKey:self];
}

#pragma mark - HideAnyWhere

+ (NSMapTable*)alertMap {
    NSMapTable* alertMap = [NSThread mainThread].threadDictionary[kAlertMapKey];
    if (alertMap == nil) {
        alertMap = [NSMapTable weakToWeakObjectsMapTable];
        [NSThread mainThread].threadDictionary[kAlertMapKey] = alertMap;
    }
    
    return alertMap;
}

+ (void)avhaw_enumerateAlertViewsWithBlock:(void (^)(UIAlertView*))block {
    NSEnumerator *enumerator = [[self.class alertMap] objectEnumerator];
    id value;
    
    while ((value = [enumerator nextObject])) {
        UIAlertView* alertView = (UIAlertView*)value;
        block(alertView);
    }
}

+ (void)avhaw_hideAllAnimated:(BOOL)animated {
    [self.class avhaw_enumerateAlertViewsWithBlock:^(UIAlertView *alertView) {
        [alertView dismissWithClickedButtonIndex:alertView.cancelButtonIndex animated:animated];
    }];
}

+ (void)avhaw_hideAll {
    [self.class avhaw_hideAllAnimated:YES];
}

@end
