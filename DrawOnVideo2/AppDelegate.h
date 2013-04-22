//
//  AppDelegate.h
//  DrawOnVideo2
//
//  Created by Harel Avikasis on 02/04/13.
//  Copyright (c) 2013 Harel Avikasis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    UINavigationController  *navigationController;
    ViewController    *viewController;
    NSURL * savedUrl;
    NSURL *videoUrl;
}
@property (weak, nonatomic) IBOutlet UIView *videoView;
@property (weak, nonatomic) IBOutlet UIImageView *drawView;
@property NSURL  *videoUrl;
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) UINavigationController  *navigationController;
@property (nonatomic, retain) ViewController   *viewController;
@property (nonatomic, retain) NSURL *savedUrl;

@end
