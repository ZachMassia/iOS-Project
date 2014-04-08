//
//  Player.m
//  GravityRunner
//
//  Created by Student on 2014-04-01.
//  Copyright (c) 2014 edu.stlawrencetech. All rights reserved.
//

#import "Player.h"
#import "SKTUtils.h"

@implementation Player
- (instancetype)initWithImageNamed:(NSString *)name {
    if (self == [super init]) {
        self.velocity = CGPointMake(0.0, 0.0);
    }
    
    NSString *fullPath = [[NSBundle mainBundle] pathForResource:name ofType:@"json"];
    [self parseAnimationJSONFromData:[NSData dataWithContentsOfFile:fullPath]];
    
    self.gravDir = 1;
    
    return self;
}

- (void)parseAnimationJSONFromData:(NSData *)data
{
    NSArray* json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}

- (void)update:(NSTimeInterval)delta {
    CGPoint gravity = CGPointMake(0.0, -450.0);
    
    CGPoint gravityStep = CGPointMultiplyScalar(gravity, delta * self.gravDir);
    
    self.velocity = CGPointAdd(self.velocity, gravityStep);
    /*
    CGPoint forwardMove = CGPointMake(800.0, 0.0);
    CGPoint forwardMoveStep = CGPointMultiplyScalar(forwardMove, delta);
    


    static const CGPoint jumpForce = { 0.0, 310.0 };
    static const float jumpCutoff = 150.0;
    
    if (self.jumpIntent && self.onGround) {
        self.velocity = CGPointAdd(self.velocity, jumpForce);
    } else if (!self.jumpIntent && self.velocity.y > jumpCutoff) {
        self.velocity = CGPointMake(self.velocity.x, jumpCutoff);
    }
    
    if (self.moveForwardIntent) {
        self.velocity = CGPointAdd(self.velocity, forwardMoveStep);
    }
    */
    static const CGPoint minMovement = { 0.0, -450.0 };
    static const CGPoint maxMovement = { 120.0, 450.0 };
    
    self.velocity = CGPointMake(Clamp(self.velocity.x, minMovement.x, maxMovement.x),
                                Clamp(self.velocity.y, minMovement.y, maxMovement.y));
    
    CGPoint velocityStep = CGPointMultiplyScalar(self.velocity, delta);
    
    self.desiredPosition = CGPointAdd(self.position, velocityStep);
}

- (CGRect)collisionBoundingBox {
    CGRect boundingbox = CGRectInset(self.frame, 2, 0);
    CGPoint diff = CGPointSubtract(self.desiredPosition, self.position);
    return CGRectOffset(boundingbox, diff.x, diff.y);
}

@end
