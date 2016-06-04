//
//  ViewController.m
//  Hackathon2
//
//  Created by Mr.Vu on 6/3/16.
//  Copyright © 2016 Mr.Vu. All rights reserved.
//

#import "ViewController.h"
#import "Cell.h"
#import "Piece.h"
#import "Map.h"
#import "BoardConfig.h"



@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.game = [[GameObject alloc]initGameBoard:self.vBoard];
    self.arrBoard = [[NSMutableArray alloc]init];
    [self initBoard];
}

- (void)initBoard {
    for(UIView *subview in self.vBoard.subviews) {
        
        if([subview isKindOfClass:[Cell class] ]) {
            [self caculateOrigiForCell:(Cell *)subview];
            [self.arrBoard addObject:subview];
            [((UIButton *)subview) addTarget:self action:@selector(clickOnCell: :) forControlEvents:UIControlEventTouchUpInside];
        }
        
        if([subview isKindOfClass:[Piece class]]) {
            [self caculateOrigiForPiece:(Piece *)subview];
            [((UIButton *)subview) addTarget:self action:@selector(clickOnPiece:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    [Map print];
}

- (void)caculateOrigiForCell:(Cell *)cell {
    cell.row = cell.frame.origin.y/CELL_FRAME;
    cell.column = cell.frame.origin.x/CELL_FRAME;
}

- (void)caculateOrigiForPiece:(Piece *)piece {
    piece.row = piece.frame.origin.y/CELL_FRAME;
    piece.column = piece.frame.origin.x/CELL_FRAME;
}

- (void)clickOnCell:(Cell *)cell :(Piece *)piece{
    
    if(cell.canMove) {
        //piece.center = cell.center;
        NSLog(@"%ld - %ld",cell.row,cell.column);
        for(UIView *subview in self.vBoard.subviews){
            if([subview isKindOfClass:[Piece class]] && ((Piece *)subview).canMove) {
                [UIView animateWithDuration:1.0f animations:^{
                    subview.center = cell.center;
                    [((Piece *)subview) moveToRow:cell.row Column:cell.column];
                } completion:^(BOOL finished) {
                    ((Piece *)subview).canMove = NO;
                    [Map print];
                    for(Cell *cell in self.arrBoard) {
                       [cell setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
                    }
                }];
            }

        }
    }
}

- (void)clickOnPiece:(Piece *)piece {
    [piece called];
    NSLog(@"%ld - %ld",piece.row,piece.column);
    for(Cell *cell in self.arrBoard) {
        if([piece checkMoveWithRow:cell.row Column:cell.column]) {
            [self setupMoveForPiece:piece];
            if(piece.playerColor == BLACK) {
                [cell setBackgroundImage:[UIImage imageNamed:EFFECT_BLUE] forState:UIControlStateNormal];
            }else {
                [cell setBackgroundImage:[UIImage imageNamed:EFFECT_RED] forState:UIControlStateNormal];
            }
            
            cell.canMove = YES;
        } else {
            cell.canMove = NO;
        }
    }
}

- (void)setupMoveForPiece:(Piece *)piece {
    piece.canMove = YES;
    for(UIView *view in self.vBoard.subviews) {
        if((Piece *)view != piece) {
            ((Piece *)view).canMove = NO;
        }
    }
}


@end
