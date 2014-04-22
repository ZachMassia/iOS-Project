//
//  Player.m
//  GravityRunner
//
//  Created by Student on 2014-04-01.
//  Copyright (c) 2014 edu.stlawrencetech. All rights reserved.
//

#import "SLCPlayer.h"
#import "SKTUtils.h"

@interface SLCPlayer()
@property (nonatomic, strong) SKAction *forwardWalk;
@property (nonatomic, strong) SKAction *flipAnimation;
@end

@implementation SLCPlayer
- (instancetype)init {
    // Load the sprite sheet first so that we can init the SKSpriteNode with the first animation frame.
    SLCSpriteSheet *spriteSheet = [[SLCSpriteSheet alloc] initWithAtlasNamed:@"walk_anim"];

    if (spriteSheet && self == [super initWithTexture:spriteSheet.animationTextures[0]]) {
        self.gravDir = 1;
        self.velocity = CGPointMake(0.0, 0.0);
        self.spriteSheet = spriteSheet;
        self.upsideDown = NO;

        self.forwardWalk = [self.spriteSheet generateAnimationWithTime:0.1f];
        self.flipAnimation = [SKAction rotateByAngle:180.0f * (M_PI / 180.0f) duration:0.5];

        self.xScale = 0.5;
        self.yScale = 0.5;

        [self runAction:self.forwardWalk withKey:@"walk_animation"];
    }

    return self;
}

- (void)update:(NSTimeInterval)delta {
    CGPoint gravity = CGPointMake(0.0, -450.0);
    CGPoint gravityStep = CGPointMultiplyScalar(gravity, delta * self.gravDir);
    self.velocity = CGPointAdd(self.velocity, gravityStep);
    
    static const CGPoint minMovement = { 0.0, -450.0 };
    static const CGPoint maxMovement = { 120.0, 450.0 };
    
    self.velocity = CGPointMake(Clamp(self.velocity.x, minMovement.x, maxMovement.x),
                                Clamp(self.velocity.y, minMovement.y, maxMovement.y));
    
    CGPoint velocityStep = CGPointMultiplyScalar(self.velocity, delta);
    
    self.desiredPosition = CGPointAdd(self.position, velocityStep);
}

- (CGRect)collisionBoundingBox {
    CGPoint diff = CGPointSubtract(self.desiredPosition, self.position);
    return CGRectOffset(self.frame, diff.x, diff.y);
}

- (void)flip {
    [self runAction:self.flipAnimation withKey:@"flip_animation"];

    // To keep things responsive, instantly flip the velocity's y-component.
    self.velocity = CGPointMake(self.velocity.x, self.velocity.y * -1);

    // By flipping the sign on the scale, the texture is inversed.
    self.xScale *= -1;

    [self emitDustParticle];

    self.upsideDown = !self.upsideDown;
}

/**
 *  Emits a cloud of smoke from the player's position.
 * 
 *  TODO: Reverse particle y-velocity when player is upside down.
 */
- (void)emitDustParticle {
    NSString *particlePath = [[NSBundle mainBundle] pathForResource:@"JumpDustParticle" ofType:@"sks"];
    SKEmitterNode *particleNode = [NSKeyedUnarchiver unarchiveObjectWithFile:particlePath];
    particleNode.numParticlesToEmit = 5;

    int heightModifier = self.upsideDown ? 1 : -1;
    particleNode.position = CGPointAdd(self.position, CGPointMake(0, (self.size.height / 2) * heightModifier));
    particleNode.yAcceleration = heightModifier;
    // Remove the sprite from the scene after 30 seconds.
    [particleNode runAction:[SKAction sequence:
                             @[[SKAction waitForDuration:30],
                               [SKAction removeFromParent]]]];

    [self.parent addChild:particleNode];
}
@end
