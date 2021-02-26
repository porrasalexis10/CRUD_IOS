//
//  FormViewController.m
//  crud_axosnet
//
//  Created by Alexis Porras on 25/02/21.
//

#import "FormViewController.h"

@interface FormViewController ()

@end

@implementation FormViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.messageTextView.delegate = self;
    
     UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"close"]
                                                              style:UIBarButtonItemStylePlain
                                                             target:self
                                                             action:@selector(dismissController)];
    [self.navigationItem setLeftBarButtonItem:item animated:YES];
    
    if(self.parentRow){
        [self loadParentData];
        [self.saveButton setTitle:@"Guardar" forState:UIControlStateNormal];
    }else{
        [self loadData];
        [self.saveButton setTitle:@"Crear" forState:UIControlStateNormal];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

-(void)loadParentData{
    self.dateLabel.text = @"Sin fecha de creación";
    
    if(![self.parentRow[@"emission_date"] isEqual:@"<null>"])
        self.dateLabel.text = [NSString stringWithFormat:@"%@",self.parentRow[@"emission_date"]];
        
    if(self.parentRow[@"provider"])
        self.providerTextField.text = [NSString stringWithFormat:@"%@",self.parentRow[@"provider"]];
    
    if(self.parentRow[@"amount"])
        self.amountTextField.text = [NSString stringWithFormat:@"%@",self.parentRow[@"amount"]];
    
    if(self.parentRow[@"currency_code"])
        self.codeTextField.text = [NSString stringWithFormat:@"%@",self.parentRow[@"currency_code"]];
    
    if(self.parentRow[@"comment"])
        self.messageTextView.text = [NSString stringWithFormat:@"%@",self.parentRow[@"comment"]];
}

-(void)loadData{
    NSDate *date = [NSDate date];
    self.dateLabel.text = [[APKernel dateFormatter] stringFromDate:date];
}

-(void)dismissController{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSString *)validateFields{
    if ([self.providerTextField.text length] < 1)
        return @"Favor de escribir un 'Provider'";
    
    if ([self.amountTextField.text length] < 1)
        return @"Favor de escribir un 'Provider'";
    
    if ([self.codeTextField.text length] < 1)
        return @"Favor de escribir un 'Provider'";
    
    return nil;
}

- (IBAction)saveRow:(id)sender {
    [self.activityIndicator startAnimating];
    [self.saveButton setEnabled:NO];
    
    NSString *validationResult = [self validateFields];
    if (validationResult){
        [self.activityIndicator stopAnimating];
        [self.saveButton setEnabled:YES];
        [APKernel presentMessageAlert:validationResult withTitle:@"¡Atención!" toController:self];
        return;
    }
    
    NSString *url;
    if (self.parentRow[@"id"]) {
        url = [NSString stringWithFormat:@"receipt/update?id=%@&provider=%@&amount=%@&comment=%@&emission_date=%@&currency_code=%@",self.parentRow[@"id"],self.providerTextField.text, self.amountTextField.text, self.messageTextView.text, self.dateLabel.text, self.codeTextField.text];
    }else{
        url = [NSString stringWithFormat:@"receipt/insert?provider=%@&amount=%@&comment=%@&emission_date=2019-05-17&currency_code=%@",self.providerTextField.text, self.amountTextField.text, self.messageTextView.text, self.codeTextField.text];
        
    }
    
    [[APWSRequest sharedInstance] POST:url parameters:nil completion:^(NSString* responseObject, NSError * error) {
        if ([responseObject boolValue]){

            UIAlertAction *acceptButton = [UIAlertAction actionWithTitle:@"Aceptar" style:UIAlertActionStyleDefault
            handler:^(UIAlertAction * action) {

                if ([self.parentController respondsToSelector:@selector(loadData)]){
                    [self.parentController performSelector:@selector(loadData) withObject:nil];
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
            }];
            
            NSString *message;
            if(self.parentRow)
                message = @"Registro actualizado correctamente";
            else
                message = @"Registro creado correctamente";
            
            [APKernel presentDecisionAlert:message withTitle:@"¡Éxito!" withButton:acceptButton toController:self];
        }else{
            [APKernel presentMessageAlert:@"Algo fallo en el servidor, intenta de nuevo más tarde" withTitle:@"¡Atención!" toController:self];
        }
        
        [self.activityIndicator stopAnimating];
        [self.saveButton setEnabled:YES];
    }];
}

#pragma mark - Keyboard
- (IBAction)hideKeyboard:(id)sender {
    [self.providerTextField resignFirstResponder];
    [self.amountTextField resignFirstResponder];
    [self.codeTextField resignFirstResponder];
    [self.messageTextView resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self nextTextField:textField];
    
    return NO;
}

- (void) nextTextField:(UITextField *)textField{
    UIView *foundView = [self.view viewWithTag:textField.tag + 1];
    
    if(!foundView){
        [textField resignFirstResponder];
        [self.scrollView scrollRectToVisible:self.saveButton.frame animated:YES];
    }else{
        [foundView becomeFirstResponder];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self.view addGestureRecognizer:self.tapGesture];
    
    [self.scrollView scrollRectToVisible:textField.frame animated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self.view removeGestureRecognizer:self.tapGesture];
}

- (BOOL)textViewShouldReturn:(UITextView *)textField {
    [self.messageTextView resignFirstResponder];
    
    return NO;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    [self.view addGestureRecognizer:self.tapGesture];
    
    [self.scrollView scrollRectToVisible:textView.frame animated:YES];
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    [self.messageTextView resignFirstResponder];
    
    [self.view removeGestureRecognizer:self.tapGesture];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{

    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
   
    return YES;
}


#pragma mark - keyboard movements
- (void)keyboardWillShow:(NSNotification *)notification
{
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets keyboardInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0);
    
    self.scrollView.contentInset = keyboardInsets;
    self.scrollView.scrollIndicatorInsets = keyboardInsets;
}

-(void)keyboardWillHide:(NSNotification *)notification
{
    UIEdgeInsets keyboardInsets = UIEdgeInsetsZero;
    
    self.scrollView.contentInset = keyboardInsets;
    self.scrollView.scrollIndicatorInsets = keyboardInsets;
}
@end
