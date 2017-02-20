//
//  AddAreaVC.m
//  YiPinCang_Buyer
//
//  Created by YPC on 16/11/23.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "AddAreaVC.h"
#import "AreaModel.h"
#import "CityModel.h"
#import "ProvinceModel.h"
@interface AddAreaVC ()<UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UITextViewDelegate>
{

    NSDictionary *_areaDic;
    NSMutableArray *_provinceArr;
    
    
}
@property (strong, nonatomic) IBOutlet UIButton *chooseBtn;
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextField *phoneTextField;
@property (strong, nonatomic) IBOutlet UITextView *areaTextField;
@property (strong, nonatomic) IBOutlet UITextField *areatext;

@property (nonatomic,strong) UIPickerView *pickerView;
@property (strong, nonatomic) IBOutlet UILabel *areaLab;
@property (nonatomic,strong)UIView *bgView;
@property (nonatomic,assign)NSInteger didOne;
@property (nonatomic,assign)NSInteger didTwo;
@property (nonatomic,assign)NSInteger didThree;
@end

@implementation AddAreaVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.didOne = 0;
    self.didTwo = 0;
    self.didThree = 0;
    if ([self.type isEqualToString:@"1"]) {
        self.navigationItem.title = @"新建收货地址";
         self.is_default = @"0";
    }else{
        self.navigationItem.title = @"更改收货地址";
        self.nameTextField.text = self.name;
        self.areaTextField.text = self.address;
        self.phoneTextField.text = self.phone;
        self.areatext.text = self.area;
        
        if ([self.is_default isEqualToString:@"1"]) {
            self.chooseBtn.selected = YES;
             self.is_default = @"1";
        }else{
            self.chooseBtn.selected = NO;
             self.is_default = @"0";
        }
    }

    [self loading];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"完成" forState:UIControlStateNormal];
    btn.titleLabel.font = YPCPFFont(16);
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.acceptEventInterval = 1.f;
    [btn sizeToFit];
    [btn addTarget:self
                        action:@selector(saveBtnClick:)
              forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *shopCarItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = shopCarItem;

    
}
- (void)loading
{
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(globalQueue, ^{
        [self prepareData];
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        dispatch_async(mainQueue, ^{
            
        });
        
    });
}
- (void)prepareData
{
    //area.plist是字典
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"arealist" ofType:@"plist"];
    _areaDic = [[NSDictionary alloc]initWithContentsOfFile:plistPath];
    
    //city.plist是数组
    NSString *plist = [[NSBundle mainBundle] pathForResource:@"citylist" ofType:@"plist"];
    NSMutableArray *dataCity = [[NSMutableArray alloc] initWithContentsOfFile:plist];
    
    _provinceArr = [[NSMutableArray alloc]init];
    for (NSDictionary *dic in dataCity) {
        ProvinceModel *model  = [[ProvinceModel alloc]init];
        [model setValuesForKeysWithDictionary:dic];
        model.citiesArr = [[NSMutableArray alloc]init];
        for (NSDictionary *dic in model.cities) {
            CityModel *cityModel = [[CityModel alloc]init];
            [cityModel setValuesForKeysWithDictionary:dic];
            [model.citiesArr addObject:cityModel];
        }
        [_provinceArr addObject:model];
    }
    
}

- (UIPickerView *)pickerView{
    if (_pickerView == nil) {
        _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 216)];
        _pickerView.delegate = self;
        _pickerView.backgroundColor = [UIColor whiteColor];
        _pickerView.dataSource = self;
        _pickerView.hidden = NO;
        [_pickerView selectRow:0 inComponent:0 animated:YES];
        
    }
    return _pickerView;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    return 3;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (0 == component)
    {
        return _provinceArr.count;
    }
    else if(1==component)
    {
        NSInteger rowProvince = [pickerView selectedRowInComponent:0];
        ProvinceModel *model =   _provinceArr[rowProvince];
        return model.citiesArr.count;
    }
    else
    {   NSInteger rowProvince = [pickerView selectedRowInComponent:0];
        NSInteger rowCity = [pickerView selectedRowInComponent:1];
        ProvinceModel *model = _provinceArr[rowProvince];
        CityModel *cityModel = model.citiesArr[rowCity];
        NSString *str = [cityModel.code description];
        NSArray *arr =  _areaDic[str];
        return arr.count;
    }
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (0 == component)
    {
        ProvinceModel *model = _provinceArr[row];
        return model.name;
    }
    else if(1==component)
    {
        NSInteger rowProvince = [pickerView selectedRowInComponent:0];
        ProvinceModel *model = _provinceArr[rowProvince];
        CityModel *cityModel = model.citiesArr[row];
        return cityModel.name;
    }else
    {
        NSInteger rowProvince = [pickerView selectedRowInComponent:0];
        NSInteger rowCity = [pickerView selectedRowInComponent:1];
        ProvinceModel *model = _provinceArr[rowProvince];
        CityModel *cityModel = model.citiesArr[rowCity];
        NSString *str = [cityModel.code description];
        NSArray *arr = _areaDic[str];
        AreaModel *areaModel = [[AreaModel alloc]init];
        if (row < arr.count) {
            [areaModel setValuesForKeysWithDictionary:arr[row]];
        }
        return areaModel.name;
    }
    
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(0 == component)
    {
        [pickerView reloadComponent:1];
        [pickerView reloadComponent:2];
        self.didOne = [pickerView selectedRowInComponent:0];
        
    }else if(1 == component)
    {
        [pickerView reloadComponent:2];
        self.didTwo = [pickerView selectedRowInComponent:1];
    }else{
      
        self.didThree = [pickerView selectedRowInComponent:2];
    }
}

- (IBAction)chooseBtnClick:(UIButton *)sender {
    [self.nameTextField resignFirstResponder];
    [self.phoneTextField resignFirstResponder];
    [self.areaTextField resignFirstResponder];
    if (sender.selected == YES) {
        sender.selected = NO;
        self.is_default = @"0";
    }else{
        sender.selected = YES;
        self.is_default = @"1";
    }
}
- (IBAction)saveBtnClick:(UIButton *)sender {
    if (self.nameTextField.text.length == 0) {
        [YPC_Tools showSvpWithNoneImgHud:@"请输入收货人姓名"];
    }else if (self.phoneTextField.text.length == 0){
        [YPC_Tools showSvpWithNoneImgHud:@"请输入手机号码"];
    }else if (![self.phoneTextField.text isValidPhone]){
        [YPC_Tools showSvpWithNoneImgHud:@"请输入正确手机号码"];
    }else if (self.areaTextField.text.length == 0){
        [YPC_Tools showSvpWithNoneImgHud:@"请输入详细地址"];
    }else if (self.areatext.text.length == 0){
        [YPC_Tools showSvpWithNoneImgHud:@"请选择收货地址"];
    }else{
        if ([self.type isEqualToString:@"1"]) {
            [YPCNetworking postWithUrl:@"shop/address/add"
                          refreshCache:YES
                                params:[YPCRequestCenter getUserInfoAppendDictionary:@{
                                                                                       @"true_name":self.nameTextField.text,
                                                                                       @"area_id":self.area_id,
                                                                                       @"city_id":self.city_id,
                                                                                       @"address":self.areaTextField.text,
                                                                                       @"tel_phone":self.phoneTextField.text,
                                                                                       @"is_default":self.is_default
                                                                                       
                                                                                       }]
                               success:^(id response) {
                                   if ([YPC_Tools judgeRequestAvailable:response]) {
                                       if (self.backreload) {
                                           self.backreload();
                                       }
                                       NSString *address_id = response[@"data"][@"address_id"];
                                       if (self.addBackreload) {
                                           self.addBackreload([NSString stringWithFormat:@"%@ %@",self.nameTextField.text,self.phoneTextField.text],[NSString stringWithFormat:@"%@ %@",self.areatext.text,self.areaTextField.text],self.is_default,address_id,self.area_id,self.city_id);
                                       }
                                       [self.navigationController popViewControllerAnimated:YES];
                                       
                                   }
                                   
                               }
                                  fail:^(NSError *error) {
                                      
                                  }];
        }else{
            [YPCNetworking postWithUrl:@"shop/address/update"
                          refreshCache:YES
                                params:[YPCRequestCenter getUserInfoAppendDictionary:@{
                                                                                       @"id":self.areaid,
                                                                                       @"true_name":self.nameTextField.text,
                                                                                       @"area_id":self.area_id,
                                                                                       @"city_id":self.city_id,
                                                                                       @"address":self.areaTextField.text,
                                                                                       @"tel_phone":self.phoneTextField.text,
                                                                                       @"is_default":self.is_default
                                                                                       
                                                                                       }]
                               success:^(id response) {
                                   if ([YPC_Tools judgeRequestAvailable:response]) {
                                       if (self.backreload) {
                                           self.backreload();
                                       }
                                       [self.navigationController popViewControllerAnimated:YES];
                                       
                                   }
                                   
                               }
                                  fail:^(NSError *error) {
                                      
                                  }];
        }
    }
}
- (void)cancel:(UITapGestureRecognizer *)tap{
    [self.nameTextField resignFirstResponder];
    [self.phoneTextField resignFirstResponder];
    [self.areaTextField resignFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{
        _pickerView.hidden = YES;
        _bgView.hidden = YES;
    }];
}
- (IBAction)setAreaBtnClick:(UIButton *)sender {
    [self.nameTextField resignFirstResponder];
    [self.phoneTextField resignFirstResponder];
    [self.areaTextField resignFirstResponder];

    WS(weakself);
    LGAlertView *alertV = [[LGAlertView alloc] initWithViewAndTitle:nil
                                                            message:nil
                                                              style:LGAlertViewStyleActionSheet
                                                               view:self.pickerView
                                                       buttonTitles:nil
                                                  cancelButtonTitle:@"取消"
                                             destructiveButtonTitle:@"完成"
                                                      actionHandler:nil
                                                      cancelHandler:nil
                                                 destructiveHandler:^(LGAlertView *alertView) {
                                                     if (weakself.didOne < _provinceArr.count) {
                                                         ProvinceModel *model = _provinceArr[weakself.didOne];
                                                         if (weakself.didTwo < model.citiesArr.count) {
                                                             CityModel *cityModel = model.citiesArr[weakself.didTwo];
                                                             NSString *str = [cityModel.code description];
                                                             NSArray *arr = _areaDic[str];
                                                             AreaModel *areaModel = [[AreaModel alloc]init];
                                                             if (weakself.didThree < arr.count) {
                                                                 [areaModel setValuesForKeysWithDictionary:arr[weakself.didThree]];
                                                                 weakself.areatext.text = [NSString stringWithFormat:@"%@ %@ %@",model.name,cityModel.name,areaModel.name];
                                                                 weakself.area_id = areaModel.code;
                                                                 weakself.city_id = cityModel.code;
                                                             }
                                                             
                                                         }
                                                     }
                                                    
                                                 }];
    alertV.cancelButtonFont = LightFont(16);
    alertV.cancelButtonTitleColor = [Color colorWithHex:@"#3B3B3B"];
    alertV.cancelButtonTitleColorHighlighted = [UIColor whiteColor];
    alertV.cancelButtonBackgroundColor = [UIColor whiteColor];
    alertV.cancelButtonBackgroundColorHighlighted = [Color colorWithHex:@"#3B3B3B"];
    alertV.cancelButtonTextAlignment = NSTextAlignmentCenter;
    
    alertV.destructiveButtonFont = LightFont(16);
    alertV.destructiveButtonTitleColor = [Color colorWithHex:@"#3B3B3B"];
    alertV.destructiveButtonTitleColorHighlighted = [UIColor whiteColor];
    alertV.destructiveButtonBackgroundColor = [UIColor whiteColor];
    alertV.destructiveButtonBackgroundColorHighlighted = [Color colorWithHex:@"#3B3B3B"];
    alertV.destructiveButtonTextAlignment = NSTextAlignmentCenter;
    
    [alertV showAnimated:YES completionHandler:nil];

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
