//
//  KillNetFiltersViewController.m
//  EVEUniverse
//
//  Created by Artem Shimanski on 13.11.12.
//
//

#import "KillNetFiltersViewController.h"
#import "UITableViewCell+Nib.h"
#import "EVEKillNetAPI.h"
#import "EVEDBAPI.h"
#import "GroupedCell.h"
#import "appearance.h"
#import "NCItemsViewController.h"
#import "UIViewController+Neocom.h"

@interface KillNetFiltersViewController ()
@property (nonatomic, strong) NSMutableArray* filters;
@property (nonatomic, strong) NSMutableDictionary* filter;
@end

@implementation KillNetFiltersViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor colorWithNumber:AppearanceBackgroundColor];

	self.title = NSLocalizedString(@"Search Criteria", nil);
	self.filters = [NSMutableArray arrayWithObjects:
					@{@"title" : NSLocalizedString(@"Start Date", nil), @"filterType" : @(KillNetFilterTypeStartDate), @"key" : EVEKillNetLogFilterStartDate},
					@{@"title" : NSLocalizedString(@"End Date", nil), @"filterType" : @(KillNetFilterTypeEndDate), @"key" : EVEKillNetLogFilterEndDate},
					@{@"title" : NSLocalizedString(@"Solar System", nil), @"filterType" : @(KillNetFilterTypeSolarSystem), @"key" : EVEKillNetLogFilterSystem},
					@{@"title" : NSLocalizedString(@"Region", nil), @"filterType" : @(KillNetFilterTypeRegion), @"key" : EVEKillNetLogFilterRegion},
					@{@"title" : NSLocalizedString(@"Victim Pilot", nil), @"filterType" : @(KillNetFilterTypeVictimPilot), @"key" : EVEKillNetLogFilterVictimPilot},
					@{@"title" : NSLocalizedString(@"Victim Corp", nil), @"filterType" : @(KillNetFilterTypeVictimCorp), @"key" : EVEKillNetLogFilterVictimCorp},
					@{@"title" : NSLocalizedString(@"Victim Alliance", nil), @"filterType" : @(KillNetFilterTypeVictimAlliance), @"key" : EVEKillNetLogFilterVictimAlliance},
					@{@"title" : NSLocalizedString(@"Victim Ship", nil), @"filterType" : @(KillNetFilterTypeVictimShip), @"key" : EVEKillNetLogFilterVictimShip},
					@{@"title" : NSLocalizedString(@"Victim Ship Class", nil), @"filterType" : @(KillNetFilterTypeVictimShipClass), @"key" : EVEKillNetLogFilterVictimShipClass},
					@{@"title" : NSLocalizedString(@"Attacker Pilot", nil), @"filterType" : @(KillNetFilterTypeAttackerPilot), @"key" : EVEKillNetLogFilterInvolvedPilot},
					@{@"title" : NSLocalizedString(@"Attacker Corp", nil), @"filterType" : @(KillNetFilterTypeAttackerCorp), @"key" : EVEKillNetLogFilterInvolvedCorp},
					@{@"title" : NSLocalizedString(@"Attacker Alliance", nil), @"filterType" : @(KillNetFilterTypeAttackerAlliance), @"key" : EVEKillNetLogFilterInvolvedAlliance},
					@{@"title" : NSLocalizedString(@"Attacker Ship", nil), @"filterType" : @(KillNetFilterTypeAttackerShip), @"key" : EVEKillNetLogFilterInvolvedShip},
					@{@"title" : NSLocalizedString(@"Attacker Ship Class", nil), @"filterType" : @(KillNetFilterTypeAttackerShipClass), @"key" : EVEKillNetLogFilterInvolvedShipClass},
					@{@"title" : NSLocalizedString(@"Combined Pilot", nil), @"filterType" : @(KillNetFilterTypeCombinedPilot), @"key" : EVEKillNetLogFilterCombinedPilot},
					@{@"title" : NSLocalizedString(@"Combined Corp", nil), @"filterType" : @(KillNetFilterTypeCombinedCorp), @"key" : EVEKillNetLogFilterCombinedCorp},
					@{@"title" : NSLocalizedString(@"Combined Alliance", nil), @"filterType" : @(KillNetFilterTypeCombinedAlliance), @"key" : EVEKillNetLogFilterCombinedAlliance},
					nil];

	for (NSDictionary* usedFilter in self.usedFilters) {
		NSInteger i = 0;
		KillNetFilterType filterType = [[usedFilter valueForKey:@"filterType"] integerValue];
		for (NSDictionary* filter in self.filters) {
			if ([[filter valueForKey:@"filterType"] integerValue] == filterType)
				break;
			i++;
		}
		if (self.filters.count > i)
			[self.filters removeObjectAtIndex:i];
	}
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
		return YES;
	else
		return UIInterfaceOrientationIsPortrait(toInterfaceOrientation);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.filters.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
	GroupedCell* cell = (GroupedCell*) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (cell == nil)
		cell = [[GroupedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
	
    cell.textLabel.text = [[self.filters objectAtIndex:indexPath.row] valueForKey:@"title"];
	
	GroupedCellGroupStyle groupStyle = 0;
	if (indexPath.row == 0)
		groupStyle |= GroupedCellGroupStyleTop;
	if (indexPath.row == [self tableView:tableView numberOfRowsInSection:indexPath.section] - 1)
		groupStyle |= GroupedCellGroupStyleBottom;
	cell.groupStyle = groupStyle;
	return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	self.filter = [NSMutableDictionary dictionaryWithDictionary:[self.filters objectAtIndex:indexPath.row]];
	KillNetFilterType filterType = [[self.filter valueForKey:@"filterType"] integerValue];
	
	switch (filterType) {
		case KillNetFilterTypeVictimShip:
		case KillNetFilterTypeAttackerShip:
		case KillNetFilterTypeCombinedShip: {
			NCItemsViewController* controller = [[NCItemsViewController alloc] init];
			controller.title = [self.filter valueForKey:@"title"];
			
			controller.conditions = @[@"invGroups.groupID = invTypes.groupID", @"invGroups.categoryID = 6"];
			
			
			controller.completionHandler = ^(EVEDBInvType* type) {
				if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
					[self dismiss];
				if (type) {
					[self.filter setValue:type.typeName forKey:@"value"];
					[self.delegate killNetFiltersViewController:self didSelectFilter:self.filter];
				}
			};
			
			if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
				[self presentViewControllerInPopover:controller
											fromRect:[tableView rectForRowAtIndexPath:indexPath]
											  inView:tableView
							permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
			else {
				[self presentViewController:controller animated:YES completion:nil];
			}
			
			break;
		}
		case KillNetFilterTypeSolarSystem: {
			KillNetFilterSolarSystemsViewController* controller = [[KillNetFilterSolarSystemsViewController alloc] initWithNibName:@"KillNetFilterDBViewController" bundle:nil];
			controller.delegate = self;
			controller.title = [self.filter valueForKey:@"title"];
			[self.navigationController pushViewController:controller animated:YES];
			break;
		}
		case KillNetFilterTypeRegion: {
			KillNetFilterRegionsViewController* controller = [[KillNetFilterRegionsViewController alloc] initWithNibName:@"KillNetFilterDBViewController" bundle:nil];
			controller.groupsRequest = nil;
			controller.delegate = self;
			controller.title = [self.filter valueForKey:@"title"];
			[self.navigationController pushViewController:controller animated:YES];
			break;
		}
		case KillNetFilterTypeVictimShipClass:
		case KillNetFilterTypeAttackerShipClass: {
			KillNetFilterShipClassesViewController* controller = [[KillNetFilterShipClassesViewController alloc] initWithNibName:@"KillNetFilterDBViewController" bundle:nil];
			controller.delegate = self;
			controller.title = [self.filter valueForKey:@"title"];
			[self.navigationController pushViewController:controller animated:YES];
			break;
		}
		case KillNetFilterTypeStartDate:
		case KillNetFilterTypeEndDate: {
			KillNetFilterDateViewController* controller = [[KillNetFilterDateViewController alloc] initWithNibName:@"KillNetFilterDateViewController" bundle:nil];
			controller.title = [self.filter valueForKey:@"title"];
			controller.maximumDate = [NSDate date];
			controller.date = [self.filter valueForKey:@"value"];
			controller.delegate = self;
			[self.navigationController pushViewController:controller animated:YES];
			break;
		}
		default:
			[self.delegate killNetFiltersViewController:self didSelectFilter:[self.filters objectAtIndex:indexPath.row]];
			break;
	}
	
}

- (void)viewDidUnload {
	[super viewDidUnload];
}

#pragma mark - KillNetFilterDBViewControllerDelegate

- (void) killNetFilterDBViewController:(KillNetFilterDBViewController*) controller didSelectItem:(NSDictionary*) item {
	[self.filter setValue:[item valueForKey:@"name"] forKey:@"value"];
	[self.delegate killNetFiltersViewController:self didSelectFilter:self.filter];
}

#pragma mark - KillNetFilterDateViewControllerDelegate

- (void) killNetFilterDateViewController:(KillNetFilterDateViewController*) controller didSelectDate:(NSDate*) date {
	[self.filter setValue:date forKey:@"value"];
	[self.delegate killNetFiltersViewController:self didSelectFilter:self.filter];
}

@end
