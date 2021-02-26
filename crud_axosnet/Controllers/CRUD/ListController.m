//
//  ViewController.m
//  crud_axosnet
//
//  Created by Alexis Porras on 25/02/21.
//

#import "ListController.h"
#import "FormViewController.h"
//Cell
#import "TableViewCell.h"



@interface ListController (){
    UIRefreshControl *refreshControl;
    
    NSArray *dataArray;
    NSMutableArray *selectedRows;
}


@end

@implementation ListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    refreshControl = [[UIRefreshControl alloc]init];
    [refreshControl addTarget:self action:@selector(loadData) forControlEvents:UIControlEventValueChanged];
    
    if (@available(iOS 10.0, *)) {
        self.tableView.refreshControl = refreshControl;
    } else {
        [self.tableView addSubview:refreshControl];
    }
    
    [self loadData];
}

-(void)loadData{
    [self->refreshControl beginRefreshing];
    self->dataArray = nil;
    self->dataArray = [[NSMutableArray alloc] init];
    
    
    [[APWSRequest sharedInstance] GET:@"receipt/getall" parameters:nil completion:^(NSString* responseObject, NSError * error) {
        if (responseObject){
            NSData* data = [responseObject dataUsingEncoding:NSUTF8StringEncoding];
            NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            
            self->dataArray = array;
            
            if([self->dataArray count] > 0){
                [self.tableView reloadData];
                [self.tableView setHidden:NO];
                [self.emptyLabel setHidden:YES];
            }else{
                [self.tableView setHidden:YES];
                [self.emptyLabel setHidden:NO];
            }
            
            [self->refreshControl endRefreshing];
        }
    }];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self->dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *row = self->dataArray[indexPath.row];
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.parentController = self;
    cell.indexPath = indexPath;
    
    if(![row[@"provider"] isEqual:@"<null>"])
        cell.titleLabel.text = [NSString stringWithFormat:@"%@",row[@"provider"]];
    else
        cell.titleLabel.text = @"Vacio";
    
    if(![row[@"comment"] isEqual:@"<null>"])
        cell.messageLabel.text = [NSString stringWithFormat:@"%@",row[@"comment"]];
    else
        cell.messageLabel.text = @"Vacio";
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(![self.tableView isEditing]){
        [self performSegueWithIdentifier:@"editRowSegue" sender:self->dataArray[indexPath.row]];
        
    }else{
        if([self->selectedRows containsObject:self->dataArray[indexPath.row]])
           [self->selectedRows removeObject:self->dataArray[indexPath.row]];
        else
           [self->selectedRows addObject:self->dataArray[indexPath.row]];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIAlertAction *acceptButton = [UIAlertAction actionWithTitle:@"Aceptar" style:UIAlertActionStyleDefault
    handler:^(UIAlertAction * action) {

        [self deleteRow:self->dataArray[indexPath.row]];
    }];
    
    [APKernel presentDecisionAlert:@"¿Estás seguro de que quieres eliminar este registro?" withTitle:@"¡Atención!" withButton:acceptButton toController:self];
}

#pragma mark - Delete methods

- (IBAction)deleteAllRows:(id)sender {
    if(![self.tableView isEditing]){
        UIAlertAction *acceptButton = [UIAlertAction actionWithTitle:@"Aceptar" style:UIAlertActionStyleDefault
        handler:^(UIAlertAction * action) {

            [self deleteRegisters:YES];
        }];
        
        [APKernel presentDecisionAlert:@"¿Estás seguro de que quieres eliminar todas las notificaciones?" withTitle:@"¡Atención!" withButton:acceptButton toController:self];
    }else{
        
        if([self->selectedRows count] < 1){
            [APKernel presentMessageAlert:@"No se ha seleccionado ninguna notificación" withTitle:@"¡Atención!" toController:self];
            [self setEditingMode];
            return;
        }
        
        UIAlertAction *acceptButton = [UIAlertAction actionWithTitle:@"Aceptar" style:UIAlertActionStyleDefault
        handler:^(UIAlertAction * action) {

            [self deleteRegisters:NO];
        }];
        
        [APKernel presentDecisionAlert:@"¿Estás seguro de que quieres eliminar todas las notificaciones seleccionadas?" withTitle:@"¡Atención!" withButton:acceptButton toController:self];
    }
}

- (IBAction)editAllRows:(id)sender{
    if(![self.tableView isEditing])
        [self setEditingMode];
    else
        [self setNormalMode];
}

- (void)setEditingMode{
    self->selectedRows =[[NSMutableArray alloc]init];
    [self.tableView setEditing:YES animated:YES];
    [self.editButton setTitle:@"Cancelar" forState:UIControlStateNormal];
    [self.deleteButton setTitle:@"Borrar seleccionadas" forState:UIControlStateNormal];
}

- (void)setNormalMode{
    [self.tableView setEditing:NO animated:YES];
    [self.editButton setTitle:@"Editar" forState:UIControlStateNormal];
    [self.deleteButton setTitle:@"Borrar todas" forState:UIControlStateNormal];
}

- (void)deleteRegisters:(bool)deleteAll{
    if(deleteAll){
        for(NSDictionary *row in self->dataArray){
            [self deleteRow:row];
        }
        
    }else{
        for(NSDictionary *row in self->selectedRows){
            [self deleteRow:row];
        }
        
        [self setNormalMode];
    }
}

-(void)deleteRow:(NSDictionary *)currentdRow{
    [self->refreshControl beginRefreshing];
    
    NSString *url = [NSString stringWithFormat:@"receipt/delete?id=%@",currentdRow[@"id"]];
    
    [[APWSRequest sharedInstance] POST:url parameters:nil completion:^(NSString* responseObject, NSError * error) {
        if ([responseObject boolValue]){

            [self loadData];
        }
    }];
}

#pragma mark - Create methods

- (IBAction)newRows:(id)sender{
    [self performSegueWithIdentifier:@"newRowSegue" sender:nil];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"newRowSegue"]) {
        FormViewController *navigationController = [[(UINavigationController *)[segue destinationViewController] viewControllers] lastObject];
        navigationController.parentController = self;
    }else if ([segue.identifier isEqualToString:@"editRowSegue"]) {
        FormViewController *navigationController = [segue destinationViewController];
        navigationController.parentController = self;
        navigationController.parentRow = sender;
    }
}
@end
