//
//  IMHomeVc.m
//  TransitionNormalDemo
//
//  Created by Wu on 17/5/7.
//  Copyright © 2017年 Wu. All rights reserved.
//

#import "IMHomeVc.h"
#import "IMDetailVc.h"

#import "IMNormalTransitionPresentedAnimator.h"
#import "IMNormalTransitionDismissedAnimator.h"

// iOS8 新增
#import "IMNormalTransitionPresentedController.h"
#import "IMNormalTransitionDismissedController.h"

@interface IMHomeVc ()<UIViewControllerTransitioningDelegate>

@end

@implementation IMHomeVc
{
    IMDetailVc *_detailVc;
    BOOL _isPresenting;/**< 不是 dismiss */
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)presentedVc:(id)sender {
    if (!_detailVc) {
        _detailVc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DetailVc"];
        // 设置动画样式为 UIModalPresentationCustom 才会调用 iOS8 的接口 presentationControllerForPresentedViewController
        // 注释这句代码就会是 iOS7 的效果
        _detailVc.modalPresentationStyle = UIModalPresentationCustom;// 设置 动画样式
        _detailVc.transitioningDelegate = self;
    }
    _isPresenting = YES;
    [self presentViewController:_detailVc animated:YES completion:nil];
}

- (IBAction)pushVc:(id)sender {
}

#pragma mark
#pragma mark UIViewControllerTransitioningDelegate
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return [IMNormalTransitionPresentedAnimator new];
}

- (nullable UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source {
    if (_isPresenting) {
        _isPresenting = NO;
        return [[IMNormalTransitionPresentedController alloc]initWithPresentedViewController:_detailVc presentingViewController:self];
    }
    return [[IMNormalTransitionDismissedController alloc]initWithPresentedViewController:_detailVc presentingViewController:self];
}

//- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
//    return [IMNormalTransitionDismissedAnimator new];
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
