//
//  SLCPauseScene.m
//  GravityRunner
//
//  Created by Student on 2014-04-22.
//  Copyright (c) 2014 edu.stlawrencetech. All rights reserved.
//

#import "SLCPauseMenu.h"

@interface SLCPauseMenu()

@property (assign, nonatomic, readwrite) BOOL isVisible;

@end

@implementation SLCPauseMenu

-(id)initWithParentNode:(SKNode *)parent {
    if (self = [super init]) {
        self.userInteractionEnabled = YES;
        self.isVisible = NO;

        SKSpriteNode *bgFrame = [self frameWithSize:CGSizeMake(parent.scene.size.width * 0.45,
                                                               parent.scene.size.height * 0.65)];
        [self addChild:bgFrame];

        SKLabelNode *resumeLabel = [SKLabelNode labelNodeWithFontNamed:@"KenPixel Blocks"];
        resumeLabel.name = @"Resume";
        resumeLabel.text = @"Resume Game";
        resumeLabel.fontSize = 25;
        resumeLabel.fontColor = [SKColor blackColor];
        resumeLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));

        [self addChild:resumeLabel];
    }
    return self;
}

- (void)hideWithFadeDuration:(NSTimeInterval)sec {
    // To avoid restarting gameplay before the menu is fully hidden, set the
    // isVisible property in the completion block.
    [self runAction:[SKAction fadeOutWithDuration:sec] completion:^{ self.isVisible = NO; }];
}

- (void)showWithFadeDuration:(NSTimeInterval)sec {
    self.isVisible = YES;
    [self runAction:[SKAction fadeInWithDuration:sec]];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint location = [[touches anyObject] locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];

    if ([node.name isEqualToString:@"Resume"]) {
        [self runAction:[SKAction playSoundFileNamed:@"button-fwd.caf" waitForCompletion:NO]];
        [self hideWithFadeDuration:0.25];
    }
}

/**
 *  Creates a background frame of the given size.
 *
 *  @param size The frame size.
 *
 *  @return The initialized frame node.
 */
- (SKSpriteNode *)frameWithSize:(CGSize)size {
    SKSpriteNode *frame = [SKSpriteNode spriteNodeWithImageNamed:@"grey_panel"];

    frame.xScale = size.width  / frame.size.width;
    frame.yScale = size.height / frame.size.height;

    return frame;
}

@end
