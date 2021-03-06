//
//  yue_ViewController.m
//  MingTu
//
//  Created by M-SJ077 on 2017/2/9.
//  Copyright © 2017年 zhangzhihua. All rights reserved.
//

#import "BianBianViewController.h"
#import "Header.h"
#import <MessageUI/MessageUI.h>
#import "yue_scrollView.h"
#import "lookBianViewController.h"
#define SLIDECOLOR RGBA(222, 200, 200, 0.6)


@interface BianBianViewController ()<SetPersonDelegate,UIPickerViewDelegate>{
    
    UITextView *_contentView;
    UITextField *_localLabel;
    UITextField *_timeLabel;
    UIButton     *_personButton;
    UIButton     *_sendButton;
    UIButton *_zhuaButton;
    
    yue_scrollView *_backScrollview;
    
    personModel *person;
    
    NSMutableArray *_modelArray;
    
    UIDatePicker *datePicker;
    
}
@end

@implementation BianBianViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self create_Views];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    if([[ZZH_LoadingProject shareMBProgress]read:TRUEPATH(BIANNAME)]){
        _modelArray =[(NSMutableArray*)[[ZZH_LoadingProject shareMBProgress]read:TRUEPATH(BIANNAME)] mutableCopy];
        for(BianModel *model in _modelArray){
            NSLog(@"bianname --- %@",model.time);
        }
    }else{
        _modelArray = [[NSMutableArray alloc]init];
    }
    
    [self create_rightButton];
}

-(void)create_rightButton{
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc]initWithTitle:@"查看历史" style:UIBarButtonItemStylePlain target:self action:@selector(lookSave)];
    
    rightBtnItem.tintColor=[UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem = rightBtnItem;
}

-(void)lookSave{
    lookBianViewController *lookBian = [[lookBianViewController alloc]init];
    [self.navigationController pushViewController:lookBian animated:YES];
}

-(void)create_Views{
    
    _backScrollview = [[yue_scrollView alloc]initWithFrame:CGRectMake(0, 64, VIEW_WIDTH, VIEW_HEIGHT - 64 - 44)];
    [self.view addSubview:_backScrollview];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 100, 20)];
    titleLabel.text = @" 记录:";
    titleLabel.font = [UIFont systemFontOfSize:13 weight:0.001];
    titleLabel.textColor = RGBA(122, 122, 122, 1);
    [_backScrollview addSubview:titleLabel];
    
    
    _contentView = [[UITextView alloc]initWithFrame:CGRectMake(20,30 , VIEW_WIDTH  - 40, 140)];
    _contentView.text = @"";
    _contentView.layer.cornerRadius = 5;
    _contentView.clipsToBounds = YES;
    _contentView.textColor = RGBA(44, 44, 44, 1);
    _contentView.font = [UIFont systemFontOfSize:13 weight:0.001];
    [self setSlide:_contentView];
    [_backScrollview addSubview:_contentView];
    
    
    
    
//    _localLabel = [[UITextField alloc]initWithFrame:CGRectMake(30, 210, VIEW_WIDTH - 60, 25)];
//    _localLabel.placeholder = @"地点";
//    _localLabel.textColor = RGBA(122, 122, 122, 1);
//    _localLabel.font = [UIFont systemFontOfSize:14 weight:0.001];
//    _localLabel.textAlignment = NSTextAlignmentCenter;
//    [_backScrollview addSubview:_localLabel];
//    UIView *Line1 = [[UIView alloc]initWithFrame:CGRectMake(30, 240, VIEW_WIDTH - 60, 1)];
//    Line1.backgroundColor =SLIDECOLOR;
//    [_backScrollview addSubview:Line1];
//    
//    _personButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    _personButton.frame =CGRectMake(30, 270, VIEW_WIDTH - 60, 25);
//    _personButton.tag = 1;
//    _personButton.titleLabel.font = [UIFont systemFontOfSize:14 weight:0.001];
//    [_personButton setTitle:@"选择联系人" forState:UIControlStateNormal];
//    [_personButton addTarget:self action:@selector(selectPersonal) forControlEvents:UIControlEventTouchUpInside];
//    [_personButton setTitleColor:RGBA(193, 193, 193,1) forState:UIControlStateNormal];
//    [_backScrollview addSubview:_personButton];
    
//    UIView *Line2 = [[UIView alloc]initWithFrame:CGRectMake(30, 210, VIEW_WIDTH - 60, 1)];
//    Line2.backgroundColor =SLIDECOLOR;
//    [_backScrollview addSubview:Line2];
    
    
    //创建一个UIPickView对象
    datePicker = [[UIDatePicker alloc]init];
    //自定义位置
    datePicker.frame = CGRectMake(0, _backScrollview.frame.size.height - 150, VIEW_WIDTH, 150);
    //设置背景颜色
    datePicker.backgroundColor = [UIColor whiteColor];
    //datePicker.center = self.center;
    //设置本地化支持的语言（在此是中文)
    datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
    //显示方式是只显示年月日
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker addTarget:self action:@selector(changeDate:) forControlEvents:UIControlEventValueChanged];
    
    
    UIView *Line3 = [[UIView alloc]initWithFrame:CGRectMake(30, 210, VIEW_WIDTH - 60, 1)];
    Line3.backgroundColor =SLIDECOLOR;
    [_backScrollview addSubview:Line3];
    _timeLabel = [[UITextField alloc]initWithFrame:CGRectMake(30, Line3.frame.origin.y - 30, VIEW_WIDTH - 60, 25)];
    _timeLabel.placeholder = @"时间";
    _timeLabel.textColor = RGBA(122, 122, 122, 1);
    _timeLabel.keyboardType  = UIKeyboardTypeNumbersAndPunctuation;
    _timeLabel.font = [UIFont systemFontOfSize:14 weight:0.001];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    [_backScrollview addSubview:_timeLabel];
    NSDate *date = [NSDate date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YY年MM月dd日"];
    NSString *DateTime = [formatter stringFromDate:date];
    _timeLabel.text = DateTime;
    
    _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _sendButton.bounds = CGRectMake(0, 0, VIEW_WIDTH - 80, 30);
    _sendButton.center = CGPointMake(VIEW_WIDTH/2, Line3.frame.origin.y + 40);
    _sendButton.backgroundColor = MainColor;
    _sendButton.alpha = 0.9;
    _sendButton.titleLabel.font = [UIFont systemFontOfSize:14 weight:0.001];
    [_sendButton setTitle:@"保存" forState:UIControlStateNormal];
    [_sendButton addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    _sendButton.layer.cornerRadius = 15;
    [_backScrollview addSubview:_sendButton];
    
    
    _zhuaButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _zhuaButton.frame = CGRectMake(30, Line3.frame.origin.y - 35, 40, 34);
    [_zhuaButton addTarget:self action:@selector(selectDate) forControlEvents:UIControlEventTouchUpInside];
    [_zhuaButton setImage:[UIImage imageNamed:@"zhua.png"] forState:UIControlStateNormal];
    [_backScrollview addSubview:_zhuaButton];
    
}

-(void)selectDate{
    
    //放在盖板上
    [_backScrollview addSubview:datePicker];

    
    
}

-(void)changeDate:(UIDatePicker*)picker{
    NSDate *date = datePicker.date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yy年MM月dd日"];
    NSString  *string = [[NSString alloc]init];
    string = [dateFormatter stringFromDate:date];
    _timeLabel.text = string;
    // [datePicker removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)save{
    //    NSString *yueString = [NSString stringWithFormat:@"%@:/n      我想%@"]
    //    [self showMessageView:[NSArray arrayWithObjects:[NSString stringWithFormat:@"%@",person.phone], nil] title:@"test" body:@""];
    
    /*
     _localLabel
     _timeLabel
     _personButton
     */
//    if(([_localLabel.text isEqualToString:@""])||([_timeLabel.text isEqualToString:@""])||(_personButton.tag==1)){
//        NSLog(@"信息没有填写完整 -- %@- ---- %@ ---- %ld",_localLabel.text,_timeLabel.text,(long)_personButton.tag);
//        [[ZZH_LoadingProject shareMBProgress]showAlkerInformation:@"信息没有填写完整 " andDelayDismissTime:1];
//        return;
//    }
//    
//    NSString *bodyString  = [NSString stringWithFormat:@"%@ :\n我要在%@去%@%@",person.name,_timeLabel.text,_localLabel.text,_contentView.text];
//    
//    NSLog(@"约会 -- %@",bodyString);
//    [self showMessageView:[NSArray arrayWithObjects:[NSString stringWithFormat:@"%@",person.phone], nil] title:@"" body:bodyString];
    
    
    BianModel *model = [[BianModel alloc]init];
    model.time = _timeLabel.text;
    model.content = _contentView.text;
    
    [_modelArray addObject:model];
    
    if([[ZZH_LoadingProject shareMBProgress]save:TRUEPATH(BIANNAME) andSaveObject:_modelArray]){
        [[ZZH_LoadingProject shareMBProgress]showAlkerInformation:@"保存成功" andDelayDismissTime:1];
    }
    
}

-(void)selectPersonal{
    selectPersonViewController *selectVC = [[selectPersonViewController alloc]init];
    selectVC.methodString = @"";
    selectVC.orLocation = YES;
    selectVC.delegate = self;
    [self.navigationController pushViewController:selectVC animated:YES];
}

-(void)setPerson:(NSObject *)returnObj{
    person = (personModel*)returnObj;
    NSLog(@"person name ---- %@",person.name);
    [_personButton setTitle:person.name forState:UIControlStateNormal];
    _personButton.tag =2;
}

-(void)setSlide:(UIView*)view{
    //button设置边框
    [view.layer setMasksToBounds:YES];
    [view.layer setBorderWidth:1];   //边框宽度
    [view.layer setBorderColor:SLIDECOLOR.CGColor];//边框颜色
    
    //[NSHomeDirectory() stringByAppendingString:@"/name.plist"
}



// 发送短信的代码
//smsDelegate
-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:YES completion:nil];
    switch (result) {
        case MessageComposeResultSent:{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:[NSString stringWithFormat:@"发送成功"]
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil, nil];
            [alert show];
        }
            //信息传送成功
            
            break;
        case MessageComposeResultFailed:
            //信息传送失败
            
            break;
        case MessageComposeResultCancelled:
            //信息被用户取消传送
            
            break;
        default:
            break;
    }
}


-(void)showMessageView:(NSArray *)phones title:(NSString *)title body:(NSString *)body
{
    if( [MFMessageComposeViewController canSendText] )
    {
        MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc] init];
        controller.title = @"短信";
        controller.recipients = phones;
        controller.navigationBar.tintColor = [UIColor redColor];
        controller.body = body;
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:nil];
        //[[[[controller viewControllers] lastObject] navigationItem] setTitle:@"短信"];//修改短信界面标题
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"该设备不支持短信功能"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [datePicker removeFromSuperview];
}

//


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
