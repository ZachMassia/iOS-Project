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
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:0.2];
        
        self.myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        self.myLabel.name = @"Resume";
        self.myLabel.text = @"Resume Game";
        self.myLabel.fontSize = 30;
        self.myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                            CGRectGetMidY(self.frame));
        
        //self.button = [self createButtonWithImageNamed:@"Spaceship" atPosition:CGPointMake(CGRectGetMidX(self.frame),
        //                                                                                   CGRectGetMidY(self.frame))];
        
        [self addChild:self.myLabel];
        //[self addChild:self.button];
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    //if fire button touched, bring the rain
    if ([node.name isEqualToString:@"Resume"]) {
        //SKTransition *reveal = [SKTransition fadeWithDuration:0.1];
        //SKTransition *reveal = [SKTransition revealWithDirection:SKTransitionDirectionUp duration:1.0];
        //SLCGameScene *scene1 = [[SLCGameScene alloc] initWithSize:self.scene.size];
        //scene1.scaleMode = SKSceneScaleModeAspectFill;
        //[self.scene.view presentScene: self.otherScene transition: reveal];
        [self.scene.view presentScene: self.otherScene];
        
    }
}

@end
