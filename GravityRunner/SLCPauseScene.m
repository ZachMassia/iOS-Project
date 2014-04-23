//
//  SLCPauseScene.m
//  GravityRunner
//
//  Created by Student on 2014-04-22.
//  Copyright (c) 2014 edu.stlawrencetech. All rights reserved.
//

#import "SLCPauseScene.h"
#import "SLCGameScene.h"

@implementation SLCPauseScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor colorWithRed:.823529412 green:.956862745 blue:.968627451 alpha:1.0];
        
        SKLabelNode *resumeLabel = [SKLabelNode labelNodeWithFontNamed:@"KenPixel Blocks"];
        resumeLabel.name = @"Resume";
        resumeLabel.text = @"Resume Game";
        resumeLabel.fontSize = 50;
        resumeLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));

        [self addChild:resumeLabel];
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint location = [[touches anyObject] locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];

    if ([node.name isEqualToString:@"Resume"]) {
        [self.otherScene runAction:self.otherScene.sounds[@"button-fwd"]];
        [self.scene.view presentScene: self.otherScene];
    }
}

@end
