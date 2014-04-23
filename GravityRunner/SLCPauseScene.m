//
//  SLCPauseScene.m
//  GravityRunner
//
//  Created by Student on 2014-04-22.
//  Copyright (c) 2014 edu.stlawrencetech. All rights reserved.
//

#import "SLCPauseScene.h"
#import "SLCGameScene.h"

@interface SLCPauseScene()
@property (nonatomic, strong) SKLabelNode *myLabel;
@end

@implementation SLCPauseScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:0.2];
        
        self.myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        self.myLabel.name = @"Resume";
        self.myLabel.text = @"Resume Game";
        self.myLabel.fontSize = 30;
        self.myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                            CGRectGetMidY(self.frame));

        [self addChild:self.myLabel];

    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint location = [[touches anyObject] locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];

    if ([node.name isEqualToString:@"Resume"]) {
        [self.scene.view presentScene: self.otherScene];
    }
}

@end
