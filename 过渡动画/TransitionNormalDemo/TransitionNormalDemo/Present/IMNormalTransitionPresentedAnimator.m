//
//  IMNormalTransitionPresentedAnimator.m
//  TransitionNormalDemo
//
//  Created by Wu on 17/5/7.
//  Copyright © 2017年 Wu. All rights reserved.
//

#import "IMNormalTransitionPresentedAnimator.h"

@implementation IMNormalTransitionPresentedAnimator

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.7;
}

// 设置了过渡代理，在 presented 过渡时就会调用这个动画，来给 presented 添加过渡动画
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    // 这里需要注意: 这里 fromVc 是 UINavigationController，并不是 IMHomeVc，因为过渡实际是由 UINavigationController 开始的，由它找到 IMHomeVc 来执行
    UIViewController *toVc = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVc = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    CGRect finalFrame = [transitionContext finalFrameForViewController:toVc];
    
    // 很重要: 将需要动画的 view 放入 containerView
    // 默认: fromVc.view 已经被添加到里面了
    // 注意: containerView 最多放两个 view ，后放入的 view 会把最先放入的 view 挤掉
    // 区别: iOS7 中 transitionContext 对 toVc.view 和 fromVc.view(navi.view 也就是导航控制器中的所有 view) 强引用
    /*
     放入 containerView 的 view 最终会被 nil 一次（ARC 中 nil 也就是引用计数减 1），所以放入 containerView 的 view 必须是 transitionContext 强引用        的 view。
     问题: 如果这时候我需要对 IMHomeVc.view 也做动画（默认 navi.view 已经放入 containerView 了， IMHomeVc.view 是最上层 view 所以可以正常动画），正常对 fromVc.View 设置动画就可以了（顶层就是 IMHomeVc.view 所以效果一样）
     那么，为什么不直接把 IMHomeVc.view 放入 containerView 做动画呢？其实这个问题在 iOS8 得到了解决。在 iOS7 中如果直接把 IMHomeVc.view 放入 containerView 中，会产生问题，这会打破引用计数平衡。本来 transitionContext 的引用计数是平衡的，但是你把 IMHomeVc.view 放入其中，却不对其有引用，最后 transitionContext 自清理时，却要对其做 nil 操作。这就打破了引用计数平衡。会出错，所以在 containerView 中的只能是 fromVc.view 和 toVc.view。
     
     iOS8 中出现了 UIPresentationController 来调度所有 UIViewController 的过渡。当使用 UIPresentationController 时， 这时候默认加入到 containerView 的 view 不在是 fromVc.view 而是 IMHomeVc.view
     
     UIPresentationController 感觉就是一个 transitionContext 的体现，然后提供的很多接口和 transitionContext 进行交互和监听过渡过程
     
     
     如果要实现 push 的自定义 看 UINavigationController 的协议 UINavigationControllerDelegate 
     
     关于怎么自定义交互式动画 看 王巍 的 demo 。其实也不难。
     
     可以看官方文档配合王巍的 blog https://onevcat.com/2014/07/ios-ui-unique/ 一起看，这是功能性 API 会用就可以了
     
     */
    
    [[transitionContext containerView] addSubview:toVc.view];
    
    // 一般，Presented 动画之需要对 toVc 进行动画
    [toVc.view setFrame:CGRectOffset(finalFrame, 0, [[UIScreen mainScreen] bounds].size.height)];
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [toVc.view setFrame:finalFrame];
                     }
                     completion:^(BOOL finished) {
                         // 动画结束后，一定要告诉上下文过渡完成。完成 YES 取消 NO
                         [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                     }];
    
}

@end
