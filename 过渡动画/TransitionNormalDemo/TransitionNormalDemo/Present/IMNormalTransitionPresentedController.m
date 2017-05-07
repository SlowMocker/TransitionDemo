//
//  IMNormalTransitionPresentedController.m
//  TransitionNormalDemo
//
//  Created by Wu on 17/5/7.
//  Copyright © 2017年 Wu. All rights reserved.
//

#import "IMNormalTransitionPresentedController.h"

@implementation IMNormalTransitionPresentedController
{
    UIView *_view;
    // 这里可以在 IMDetailVc 的 view 上加几个 btn ，然后把 IMDetailVc.view 的背景色设置为 clear 就可以得到 actionSheet 的效果。
}

- (id) initWithPresentedViewController:(UIViewController *)presentedViewController presentingViewController:(UIViewController *)presentingViewController {
    self = [super initWithPresentedViewController:presentedViewController presentingViewController:presentingViewController];
    if (self) {
        _view = [UIView new];
        UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapHandle:)];
        [_view addGestureRecognizer:tapG];
    }
    return self;
}

- (void) tapHandle:(UITapGestureRecognizer *)tap {
    [[self presentedViewController] dismissViewControllerAnimated:YES completion:nil];
}

//presentationTransitionWillBegin 是在呈现过渡即将开始的时候被调用的。我们在这个方法中把半透明黑色背景 View 加入到 containerView 中，并且做一个 alpha 从0到1的渐变过渡动画。
- (void) presentationTransitionWillBegin {
    
    _view.frame = self.containerView.bounds;
    _view.alpha = 0;
    _view.backgroundColor = [UIColor blackColor];
    
    [self.containerView addSubview:_view];
    [[[self presentedViewController] transitionCoordinator] animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        _view.alpha = 0.4;
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        
    }];
    
}


//presentationTransitionDidEnd: 是在呈现过渡结束时被调用的，并且该方法提供一个布尔变量来判断过渡效果是否完成。在我们的例子中，我们可以使用它在过渡效果已结束但没有完成时移除半透明的黑色背景 View。
-(void)presentationTransitionDidEnd:(BOOL)completed {
    
    // 如果呈现没有完成，那就移除背景 View
    if (!completed) {
        
        [_view removeFromSuperview];
        
    }
}


//以上就涵盖了我们的背景 View 的呈现部分，我们现在需要给它添加淡出动画并且在它消失后移除它。正如你预料的那样，dismissalTransitionWillBegin 正是我们把它的 alpha 重新设回0的地方。
-(void)dismissalTransitionWillBegin {
    
    [[[self presentedViewController] transitionCoordinator] animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        _view.alpha = 0;
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        
    }];
    
}


//我们还需要在消失完成后移除背景 View。做法与上面 presentationTransitionDidEnd: 类似，我们重载 dismissalTransitionDidEnd: 方法
-(void)dismissalTransitionDidEnd:(BOOL)completed{
    
    
    if (completed) {
        
        [_view removeFromSuperview];
    }
}


//还有最后一个方法需要重载。在我们的自定义呈现中，被呈现的 view 并没有完全完全填充整个屏幕，而是很小的一个矩形。被呈现的 view 的过渡动画之后的最终位置，是由 UIPresentationViewController 来负责定义的。我们重载 frameOfPresentedViewInContainerView 方法来定义这个最终位置
- (CGRect)frameOfPresentedViewInContainerView
{
    
    CGFloat windowH = [UIScreen mainScreen].bounds.size.height;
    
    CGFloat windowW = [UIScreen mainScreen].bounds.size.width;
    
    self.presentedView.frame = CGRectMake(0, windowH - 200, windowW, 200);
    
    
    return self.presentedView.frame;
}

@end
