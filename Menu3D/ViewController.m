//
//  ViewController.m
//  Menu3D
//
//  Created by Rafael Fantini da Costa on 9/17/15.
//  Copyright © 2015 Rafael Fantini da Costa. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIView *coverView;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *spacing;
@property (weak, nonatomic) IBOutlet UILabel *surpriseLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURL *address = [NSURL URLWithString:@"http://lab.hakim.se/hypnos"];
    NSURLRequest *request = [NSURLRequest requestWithURL:address];
    [self.webView loadRequest:request];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showPressed:(id)sender {
    CALayer *layer = self.coverView.layer;
    CATransform3D perspective = CATransform3DIdentity;
    perspective.m34 = 1.0 / -500;
    layer.transform = perspective;
    
    CABasicAnimation *rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.x"];
    rotation.fromValue = @0;
    rotation.toValue = @(M_PI / 12);
    rotation.duration = 0.5f;
    rotation.fillMode = kCAFillModeForwards;
    rotation.removedOnCompletion = NO;
    rotation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
        self.spacing.constant = -30;
        [self.view setNeedsUpdateConstraints];
        
        [UIView animateWithDuration:0.5f animations:^{
            [self.view layoutIfNeeded];
        }];
    }];
    [self.coverView.layer addAnimation:rotation forKey:@"rotation"];
    [CATransaction commit];
}

- (IBAction)dismissPressed:(id)sender {
    CABasicAnimation *rotation = (CABasicAnimation *)[self.coverView.layer animationForKey:@"rotation"];
    if (rotation == nil) {
        return;
    }
    
    CALayer *layer = self.coverView.layer;
    CABasicAnimation *reverseRotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.x"];
    reverseRotation.fromValue = rotation.toValue;
    reverseRotation.toValue = rotation.fromValue;
    reverseRotation.duration = rotation.duration;
    reverseRotation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    self.spacing.constant = 0;
    [self.view setNeedsUpdateConstraints];
    [UIView animateWithDuration:0.25f animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [CATransaction begin];
        [layer removeAnimationForKey:@"rotation"];
        [layer addAnimation:reverseRotation forKey:@"rotation"];
        [CATransaction commit];
    }];
}

@end
