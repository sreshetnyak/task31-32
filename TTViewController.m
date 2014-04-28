//
//  TTViewController.m
//  UITableViewEditing
//
//  Created by sergey on 4/24/14.
//  Copyright (c) 2014 sergey. All rights reserved.
//

#import "TTViewController.h"
#import "TTGroup.h"
#import "TTStudent.h"

@interface TTViewController () <UITableViewDataSource,UITableViewDelegate>

@property (weak,nonatomic) UITableView *tableView;
@property (strong,nonatomic) NSMutableArray *groupArray;

@end

@implementation TTViewController

- (void)loadView {
    
    [super loadView];
    
    CGRect frame = self.view.bounds;
    frame.origin = CGPointZero;
    UITableView *tableView = [[UITableView alloc]initWithFrame:frame style:UITableViewStylePlain];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    tableView.separatorInset = UIEdgeInsetsZero;
    
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor colorWithRed:0.192 green:0.192 blue:0.192 alpha:1.000];
    tableView.separatorColor = [UIColor colorWithRed:0.192 green:0.192 blue:0.192 alpha:1.000];
    
    
    tableView.allowsSelectionDuringEditing = NO;
    
    [self.view addSubview:tableView];
    
    self.tableView = tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editTableMode:)];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addGroup:)];
    
    self.navigationItem.rightBarButtonItem = rightButton;
        self.navigationItem.leftBarButtonItem = leftButton;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.192 green:0.192 blue:0.192 alpha:1.000];
    
    NSMutableArray *groupArr = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < 6; i++) {
        TTGroup *group = [[TTGroup alloc]init];
        NSMutableArray *students = [[NSMutableArray alloc]init];
        group.name = [NSString stringWithFormat:@"Group %d",i];
        
        for (int j = 0; j < 20; j++) {
            TTStudent *std = [TTStudent getRandomStudent];
            [students addObject:std];
        }
        
        group.studentArray = students;
        [groupArr addObject:group];
    }
    
    self.groupArray = groupArr;
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)editTableMode:(UIBarButtonItem *)selector {
    
    UIBarButtonSystemItem item = UIBarButtonSystemItemDone;
    
    if (self.tableView.editing) {
        
        item = UIBarButtonSystemItemEdit;

        [self.tableView setEditing:NO animated:YES];
    } else {
        [self.tableView setEditing:YES animated:YES];
    }
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:item target:self action:@selector(editTableMode:)];
    
    [self.navigationItem setRightBarButtonItem:rightButton animated:YES];
    
}

- (void)addGroup:(UIBarButtonItem *)selector {
    
    TTGroup *group = [[TTGroup alloc]init];
    NSMutableArray *students = [[NSMutableArray alloc]init];
    group.name = [NSString stringWithFormat:@"Group %lu",[self.groupArray count] + 1];
    
    for (int j = 0; j < 2; j++) {
        TTStudent *std = [TTStudent getRandomStudent];
        [students addObject:std];
    }
    
    group.studentArray = students;
    
    NSUInteger insertIndex = 0;
    
    [self.groupArray insertObject:group atIndex:insertIndex];
    
    [self.tableView beginUpdates];
    
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:insertIndex];
    
    [self.tableView insertSections:indexSet withRowAnimation:UITableViewRowAnimationTop];
    
    [self.tableView endUpdates];

}

- (TTGroup *)getGroupForIndexPath:(NSIndexPath *)indexPath {
    TTGroup *group = [self.groupArray objectAtIndex:indexPath.section];
    return group;
}

- (TTStudent *)getStudentForIndexPath:(NSIndexPath *)indexPath {
    TTStudent *student = [[self getGroupForIndexPath:indexPath].studentArray objectAtIndex:indexPath.row - 1] ;
    return student;
}

#pragma mark - UITableViewDataSource

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[self.groupArray objectAtIndex:section] name];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return [NSString stringWithFormat:@"Student in Group %lu",(unsigned long)[[[self.groupArray objectAtIndex:section] studentArray] count]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 22.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 22.f;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"Не сдал";
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    if ([view isKindOfClass: [UITableViewHeaderFooterView class]]) {
        UITableViewHeaderFooterView* castView = (UITableViewHeaderFooterView *)view;
        UIView *content = castView.contentView;
        content.backgroundColor = [UIColor colorWithRed:0.933 green:0.808 blue:0.200 alpha:1.000];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    if ([view isKindOfClass: [UITableViewHeaderFooterView class]]) {
        UITableViewHeaderFooterView* castView = (UITableViewHeaderFooterView *)view;
        UIView *content = castView.contentView;
        content.backgroundColor = [UIColor colorWithRed:0.698 green:0.843 blue:0.173 alpha:1.000];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    TTGroup *group = [self.groupArray objectAtIndex:section];
    
    return [group.studentArray count] + 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.groupArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.row == 0) {
        static NSString *tapIdentifier = @"TapCell";
        
        UITableViewCell *tapCell = [tableView dequeueReusableCellWithIdentifier:tapIdentifier];
        
        if (!tapCell) {
            tapCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tapIdentifier];
        }
        
        tapCell.textLabel.text = [NSString stringWithFormat:@"Add student"];
        tapCell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:0.192 green:0.192 blue:0.192 alpha:1.000];
        tapCell.backgroundColor = [UIColor colorWithRed:0.933 green:0.467 blue:0.078 alpha:1.000];
        return tapCell;
        
    } else {
    
        static NSString *identifier = @"cell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        }
        
        TTStudent *student = [self getStudentForIndexPath:indexPath];
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",student.firstName, student.lastName];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%1.2f",student.averageScore];
        
        cell.textLabel.textColor = [UIColor colorWithRed:0.231 green:0.616 blue:0.925 alpha:1.000];
        
        if (student.averageScore >= 4 ) {
            cell.detailTextLabel.textColor = [UIColor colorWithRed:0.329 green:0.820 blue:0.071 alpha:1.000];
        } else if (student.averageScore >= 3) {
            cell.detailTextLabel.textColor = [UIColor colorWithRed:0.933 green:0.467 blue:0.078 alpha:1.000];
        } else {
            cell.detailTextLabel.textColor = [UIColor colorWithRed:0.788 green:0.075 blue:0.098 alpha:1.000];
        }
        
        cell.backgroundColor = [UIColor colorWithRed:0.043 green:0.125 blue:0.176 alpha:1.000];
        cell.tintColor = [UIColor colorWithRed:0.933 green:0.467 blue:0.078 alpha:1.000];
        return cell;
    }
    
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.row > 0;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    TTGroup *sourceGrp = [self.groupArray objectAtIndex:sourceIndexPath.section];
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:sourceGrp.studentArray];
    TTStudent *sourceStd = [sourceGrp.studentArray objectAtIndex:sourceIndexPath.row - 1];
    
    if (sourceIndexPath.section == destinationIndexPath.section) {
        [tempArray exchangeObjectAtIndex:sourceIndexPath.row - 1 withObjectAtIndex:destinationIndexPath.row - 1];
        sourceGrp.studentArray = tempArray;
    } else {
        
        [tempArray removeObject:sourceStd];
        sourceGrp.studentArray = tempArray;
        
        TTGroup *destinationGrp = [self.groupArray objectAtIndex:destinationIndexPath.section];
        tempArray = [NSMutableArray arrayWithArray:destinationGrp.studentArray];
        
        [tempArray insertObject:sourceStd atIndex:destinationIndexPath.row - 1];
        
        destinationGrp.studentArray = tempArray;
        
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

    if (editingStyle == UITableViewCellEditingStyleDelete) {
        TTGroup *group = [self.groupArray objectAtIndex:indexPath.section];
        
        NSMutableArray *tempArray = [NSMutableArray arrayWithArray:group.studentArray];
        
        TTStudent *deleteStd = [group.studentArray objectAtIndex:indexPath.row - 1];
        
        [tempArray removeObject:deleteStd];
        
        group.studentArray = tempArray;
        
        [tableView beginUpdates];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        [tableView endUpdates];
        
    } if (editingStyle == UITableViewCellEditingStyleInsert) {
        
        TTGroup *group = [self.groupArray objectAtIndex:indexPath.section];
        NSMutableArray *students = [NSMutableArray arrayWithArray:group.studentArray];
        TTStudent *std = [TTStudent getRandomStudent];
        NSUInteger insertIndex = 0;
        [students insertObject:std atIndex:insertIndex];
        
        group.studentArray = students;
        
        [self.tableView beginUpdates];
        
        NSIndexPath *index = [NSIndexPath indexPathForRow:insertIndex + 1 inSection:indexPath.section];
        
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:index] withRowAnimation:UITableViewRowAnimationMiddle];
        
        [self.tableView endUpdates];

    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return UITableViewCellEditingStyleInsert;
    } else {
        return UITableViewCellEditingStyleDelete;
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        
        TTGroup *group = [self.groupArray objectAtIndex:indexPath.section];
        NSMutableArray *students = [NSMutableArray arrayWithArray:group.studentArray];
        TTStudent *std = [TTStudent getRandomStudent];
        NSUInteger insertIndex = 0;
        [students insertObject:std atIndex:insertIndex];
        
        group.studentArray = students;
        
        [self.tableView beginUpdates];
        
        NSIndexPath *index = [NSIndexPath indexPathForRow:insertIndex + 1 inSection:indexPath.section];
        
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:index] withRowAnimation:UITableViewRowAnimationMiddle];
        
        [self.tableView endUpdates];
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    
    if (proposedDestinationIndexPath.row == 0) {
        return sourceIndexPath;
    } else {
        return proposedDestinationIndexPath;
    }

}

@end
