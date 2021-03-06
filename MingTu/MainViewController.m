//
//  MainViewController.m
//  MingTu
//
//  Created by zhangzhihua on 16/3/3.
//  Copyright © 2016年 zhangzhihua. All rights reserved.
//
//self.view.frame.size.width
//self.view.frame.size.height

#define HEIDER_HEIGHT  VIEW_WIDTH*0.8
#define HEADERCOLOR RGBA(173, 79, 80, 1)
#define BUTTON_FRAME CGRectMake(0, _headerImageView.frame.origin.y + _headerImageView.frame.size.height , VIEW_WIDTH, VIEW_WIDTH * 0.8)


#define SPACE (VIEW_WIDTH - BUTTON_SIZE*3)/4.0
#define BUTTON_SIZE 70
#define BUTTON_BACK_COLOR1 RGBA(247, 164, 47, 1)
#define BUTTON_BACK_COLOR2 RGBA(196, 76, 122, 1)
#define BUTTON_BACK_COLOR3 RGBA(21, 120, 211, 1)



//frame
#define HEADERVIEW_FRAME CGRectMake(0, 0, VIEW_WIDTH, HEIDER_HEIGHT)

#import "MainViewController.h"
#import "Header.h"
#import <UserNotifications/UserNotifications.h>



@interface MainViewController () <UIScrollViewDelegate>{
    
    UIView *_headView;
    
    UIImageView *_headerImageView;
    
    UIImageView *_smallImageView;
    
    UIScrollView *_backGroundView;
    
    UIView *_ButtonView;
    
    UILabel *_LogoLabel;
    
    UILabel *_footLabel;
    
    CGFloat smallImagewidth,smallImageheight;
    
    NSMutableArray *_buttonArray;
    NSArray *_titleArray;
    
}

@property (nonatomic ,assign)NSInteger badge;

@property (nonatomic, weak) IBOutlet UIView *containerView;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"小姐姐";
    
    // Do any additional setup after loading the view.
    [self create_header_Controller];
    [self create_buttonView];
    [self push];
    [self createPage];
    [self registerNotifaction];
}

-(void)registerNotifaction{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshHeader) name:@"refreshHeader" object:nil];
}

-(void)refreshHeader{
    UIImage *headerImage = [[ZZH_LoadingProject shareMBProgress]readImage:TRUEPATH_IMAGE(HEADER_IMAGENAME)];
    if(headerImage==nil){
        
    }
    _smallImageView.image =headerImage;
}


-(void)createPage{
    // =================== 背景图片 ===========================
    UIImageView * backgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    //backgroundView.image = [UIImage imageNamed:@"樱花树1"];
    backgroundView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:backgroundView];
    
    
    // =================== 樱花飘落 ====================
    CAEmitterLayer * snowEmitterLayer = [CAEmitterLayer layer];
    snowEmitterLayer.emitterPosition = CGPointMake(100, -30);
    snowEmitterLayer.emitterSize = CGSizeMake(self.view.bounds.size.width * 2, 0);
    snowEmitterLayer.emitterMode = kCAEmitterLayerOutline;
    snowEmitterLayer.emitterShape = kCAEmitterLayerLine;
    //    snowEmitterLayer.renderMode = kCAEmitterLayerAdditive;
    
    CAEmitterCell * snowCell = [CAEmitterCell emitterCell];
    snowCell.contents = (__bridge id)[UIImage imageNamed:@"樱花瓣2.png"].CGImage;
    
    // 花瓣缩放比例
    snowCell.scale = 0.02;
    snowCell.scaleRange = 0.5;
    
    // 每秒产生的花瓣数量
    snowCell.birthRate = 7;
    snowCell.lifetime = 80;
    
    // 每秒花瓣变透明的速度
    snowCell.alphaSpeed = -0.01;
    
    // 秒速“五”厘米～～
    snowCell.velocity = 40;
    snowCell.velocityRange = 60;
    
    // 花瓣掉落的角度范围
    snowCell.emissionRange = M_PI;
    
    // 花瓣旋转的速度
    snowCell.spin = M_PI_4;
    
    // 每个cell的颜色
    //    snowCell.color = [[UIColor redColor] CGColor];
    
    // 阴影的 不透明 度
    snowEmitterLayer.shadowOpacity = 1;
    // 阴影化开的程度（就像墨水滴在宣纸上化开那样）
    snowEmitterLayer.shadowRadius = 8;
    // 阴影的偏移量
    snowEmitterLayer.shadowOffset = CGSizeMake(3, 3);
    // 阴影的颜色
    snowEmitterLayer.shadowColor = [[UIColor whiteColor] CGColor];
    
    
    snowEmitterLayer.emitterCells = [NSArray arrayWithObject:snowCell];
    [backgroundView.layer addSublayer:snowEmitterLayer];
}


-(void)create_header_Controller{
    self.automaticallyAdjustsScrollViewInsets = NO;
    //创建底部的scrollview
    _backGroundView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, VIEW_WIDTH, VIEW_HEIGHT  - 44)];
    _backGroundView.backgroundColor = RGBA(235, 235, 235, 1);
    _backGroundView.contentSize = CGSizeMake(0, VIEW_HEIGHT);
    _backGroundView.delegate = self;
    [self.view addSubview:_backGroundView];
    
    //创建头部的headerView
    _headerImageView = [[UIImageView alloc]initWithFrame:HEADERVIEW_FRAME];
    _headerImageView.userInteractionEnabled = YES;
    _headerImageView.image = [UIImage imageNamed:@"水冰月.jpeg"];
    _headerImageView.backgroundColor = [UIColor blackColor];
    [_headerImageView setContentMode:UIViewContentModeScaleAspectFill];
    _smallImageView = [[UIImageView alloc]init];
    
    UIImage *headerImage = [[ZZH_LoadingProject shareMBProgress]readImage:TRUEPATH_IMAGE(HEADER_IMAGENAME)];
    if(headerImage==nil){
        headerImage = [UIImage imageNamed:HEAD_INDEXIMAGE];
    }
    _smallImageView.image =headerImage;
    [_smallImageView setContentMode:UIViewContentModeScaleAspectFill];
    _smallImageView.frame = HEADERVIEW_FRAME;
    //添加手势
    UITapGestureRecognizer* changeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    changeTap.numberOfTapsRequired = 1;
    [_headerImageView addGestureRecognizer:changeTap];
    
    
    smallImagewidth =_smallImageView.image.size.width/_smallImageView.image.size.height * HEIDER_HEIGHT;
    
    smallImageheight =(VIEW_WIDTH - _smallImageView.image.size.width/_smallImageView.image.size.height * HEIDER_HEIGHT)/2;
    [_backGroundView addSubview:_smallImageView];
    
    [_backGroundView addSubview:_headerImageView];
    ADDVIEW(_backGroundView)
    _LogoLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, -30, VIEW_WIDTH, 20)];
    _LogoLabel.text = @"命徒安静是帅比";
    _LogoLabel.textAlignment = NSTextAlignmentCenter;
    _LogoLabel.font = [UIFont systemFontOfSize:14 weight:0.005];
    _LogoLabel.textColor = RGBA(166, 166, 166, 1);
    //[_backGroundView addSubview:_LogoLabel];
    
    _footLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _backGroundView.contentSize.height-40, VIEW_WIDTH, 20)];
    _footLabel.text = @"create by : 张智华";
    _footLabel.textAlignment = NSTextAlignmentCenter;
    _footLabel.font = [UIFont systemFontOfSize:13 weight:0.1];
    _footLabel.textColor = RGBA(166, 166, 166, 1);
    _footLabel.alpha = 0.4;
    [_backGroundView addSubview:_footLabel];
    
    
    self.navigationController.navigationBarHidden = YES;
    _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, VIEW_WIDTH, 50)];
    _headView.backgroundColor = MainColor;
    _headView.alpha = 0.95;
    [self.view addSubview:_headView];
    
}

-(void)create_buttonView{
    _ButtonView = [[UIView alloc]initWithFrame:BUTTON_FRAME];
    _ButtonView.backgroundColor = RGBA(255, 250, 250, 1);
    UIView *colorLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, VIEW_WIDTH, 1)];
    colorLine.backgroundColor = MainColor;
    colorLine.alpha = 0.1;
    [_ButtonView addSubview:colorLine];
    
    [_backGroundView addSubview:_ButtonView];
    
    
    _buttonArray = [[NSMutableArray alloc]init];
    _titleArray = [[NSArray alloc]initWithObjects:@"外卖",@"美丽说",@"无聊",@"bilibili",@"扑哧",@"约会", nil];
    for(int i = 0  ; i < _titleArray.count ; i++){
        UIButton *videoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [videoButton setSlide:videoButton andSlideColor:nil];
        videoButton.layer.cornerRadius = BUTTON_SIZE/2;
        videoButton.titleLabel.numberOfLines = 0;
        [videoButton.imageView setContentMode:UIViewContentModeScaleAspectFill];
        [videoButton addTarget:self action:@selector(videoClick:) forControlEvents:UIControlEventTouchUpInside];
        [videoButton setTitle:[_titleArray objectAtIndex:i] forState:UIControlStateNormal];
        videoButton.tag = i;
        
        switch (i) {
            case 0:
                [videoButton setImage:[UIImage imageNamed:@"hungry.jpg"] forState:UIControlStateNormal];
                break;
            case 1:
                [videoButton setImage:[UIImage imageNamed:@"美丽说.jpeg"] forState:UIControlStateNormal];
                break;
            case 2:
                [videoButton setImage:[UIImage imageNamed:@"kun.jpeg"] forState:UIControlStateNormal];
                break;
            case 3:
                [videoButton setImage:[UIImage imageNamed:@"招财猫.jpg"] forState:UIControlStateNormal];
                break;
            case 4:
                [videoButton setImage:[UIImage imageNamed:@"噗.jpeg"] forState:UIControlStateNormal];
                break;
            case 5:
                [videoButton setImage:[UIImage imageNamed:@"约会.jpeg"] forState:UIControlStateNormal];
                break;
            case 6:
                
                break;
            case 7:
                
                break;
            case 8:
                
                break;
                
            default:
                break;
        }
        videoButton.frame = CGRectMake(SPACE + (i%3)*(SPACE + BUTTON_SIZE), SPACE + (i/3)*(SPACE + BUTTON_SIZE) - 3, BUTTON_SIZE, BUTTON_SIZE);
        //[videoButton setLayoutSonView:_ButtonView andup:20 + _headerImageView.frame.size.height left:20 down:0 right:0];
        [videoButton addTarget:self action:@selector(videoClick:) forControlEvents:UIControlEventTouchUpInside];
        [_ButtonView addSubview:videoButton];
        [_buttonArray addObject:videoButton];
        
        //创建label
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(SPACE + (i%3)*(SPACE + BUTTON_SIZE), SPACE + (i/3)*(SPACE + BUTTON_SIZE) + BUTTON_SIZE, BUTTON_SIZE, 10)];
        titleLabel.textColor = RGBA(252, 102, 137, 1);
        titleLabel.text = [_titleArray objectAtIndex:i];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:10 weight:0.001];
        [_ButtonView addSubview:titleLabel];
        
        [self drawLine];
    }
}

-(void)videoClick:(UIButton*)sender{
    switch (sender.tag) {
        case 0:{
            showWebViewController *showViewcontroller = [[showWebViewController alloc]init];
            showViewcontroller.URL = E_L_M;
//            [self.navigationController pushViewController:showViewcontroller animated:YES];
            [self presentViewController:showViewcontroller animated:YES completion:^{
                [[ZZH_LoadingProject shareMBProgress]showAlkerInformation:@"打开定位哦" andDelayDismissTime:1.5];
            }];
//            NSURL* url = [[ NSURL alloc ] initWithString :E_L_M];
//            [[UIApplication sharedApplication ] openURL: url];
        }
            break;
        case 1:{
//            videoViewController *videoVC = [[videoViewController alloc]init];
//            [self.navigationController pushViewController:videoVC animated:YES];
//            [self push];
            showWebViewController *showViewcontroller = [[showWebViewController alloc]init];
            showViewcontroller.URL = MEILISHUO;
            //            [self.navigationController pushViewController:showViewcontroller animated:YES];
            [self presentViewController:showViewcontroller animated:YES completion:^{
                
            }];
        }
            break;
        case 2:{
            exchangeViewController *exchangeVC = [[exchangeViewController alloc]init];
            [self.navigationController pushViewController:exchangeVC animated:YES];
            
        }
            break;
        case 3:{
            showWebViewController *showViewcontroller = [[showWebViewController alloc]init];
            showViewcontroller.URL = BILI;
            //            [self.navigationController pushViewController:showViewcontroller animated:YES];
            [self presentViewController:showViewcontroller animated:YES completion:^{
                
            }];
//            NSString*domainStr=@"http://localhost:8080/webTest/doServlet";
//            
//            AFHTTPSessionManager*manager=[AFHTTPSessionManager manager];
//            manager.responseSerializer=[AFHTTPResponseSerializer serializer];
//            
//            //以GET的形式提交，只需要将上面的请求地址给GET做参数就可以
//            [manager GET:domainStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
//                
//            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//                NSLog(@"成功了");
//                responseObject = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
//                NSLog(@"success --- obj --- %@",responseObject);
//            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//                
//                
//            }];
        }
            
            break;
        case 4:{
            SmileViewController *smileVC = [[SmileViewController alloc]init];
            [self.navigationController pushViewController:smileVC animated:YES];
        }
            break;
        case 5:{
            yue_ViewController *yueVC = [[yue_ViewController alloc]init];
            [self.navigationController pushViewController:yueVC animated:YES];
        }
            break;
        case 6:
            
            break;
        case 7:{
            NSString*domainStr=@"http://www.renyeping.com";
            
            AFHTTPSessionManager*manager=[AFHTTPSessionManager manager];
            manager.responseSerializer=[AFHTTPResponseSerializer serializer];
            
            //以GET的形式提交，只需要将上面的请求地址给GET做参数就可以
          [manager GET:domainStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
              
          } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              NSLog(@"成功了");
               responseObject = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
              NSLog(@"success --- obj --- %@",responseObject);
          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          }];
        }
            break;
        case 8:{
           
        }
            break;
            
        default:
            break;
    }
}


#pragma mark -  单机手势
-(void)tap:(UITapGestureRecognizer*)gesture{
    showWebViewController *showViewcontroller = [[showWebViewController alloc]init];
    showViewcontroller.URL = @"http://www.wulin2.com.cn";
    [self presentViewController:showViewcontroller animated:YES completion:nil];
//    NSURL* url = [[ NSURL alloc ] initWithString :PERSONAL_MAIN];
//    [[UIApplication sharedApplication ] openURL: url];
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"%f",scrollView.contentOffset.y);
    if(scrollView.contentOffset.y<0){
        _headerImageView.frame = CGRectMake(scrollView.contentOffset.y/2.0, scrollView.contentOffset.y, VIEW_WIDTH - scrollView.contentOffset.y, HEIDER_HEIGHT  - scrollView.contentOffset.y);
        
        _smallImageView.frame =CGRectMake(scrollView.contentOffset.y/2.0, scrollView.contentOffset.y, VIEW_WIDTH - scrollView.contentOffset.y, HEIDER_HEIGHT  - scrollView.contentOffset.y);
        
        _headerImageView.alpha = (100+scrollView.contentOffset.y)/100;
    }
    _headView.alpha = (100 - ABS(scrollView.contentOffset.y))/100.0 - 0.05;
    
}

-(void)drawLine{
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(SPACE - 5, SPACE*1.5 + BUTTON_SIZE, VIEW_WIDTH+10 - 2*SPACE, 1)];
    line1.backgroundColor = RGBA(222, 222, 222, 1);
    [_ButtonView addSubview:line1];
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(SPACE - 5, SPACE*2.5 + BUTTON_SIZE*2, VIEW_WIDTH+10 - 2*SPACE, 1)];
    line2.backgroundColor = RGBA(222, 222, 222, 1);
    //[_ButtonView addSubview:line2];
    
    UIView *line3 = [[UIView alloc]initWithFrame:CGRectMake(SPACE*2.5 + BUTTON_SIZE*2 , SPACE - 5, 1, VIEW_WIDTH*2/3+10 - 2*SPACE)];
    line3.backgroundColor = RGBA(222, 222, 222, 1);
    [_ButtonView addSubview:line3];
    
    UIView *line4 = [[UIView alloc]initWithFrame:CGRectMake(SPACE*1.5 + BUTTON_SIZE , SPACE - 5, 1, VIEW_WIDTH*2/3+10 - 2*SPACE)];
    line4.backgroundColor = RGBA(222, 222, 222, 1);
    [_ButtonView addSubview:line4];
    
}

#pragma mark - 推送
-(void)push{
    // 申请通知权限
    [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionSound | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error) {
        
        // A Boolean value indicating whether authorization was granted. The value of this parameter is YES when authorization for the requested options was granted. The value is NO when authorization for one or more of the options is denied.
        if (granted) {
            
            // 1、创建通知内容，注：这里得用可变类型的UNMutableNotificationContent，否则内容的属性是只读的
            UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
            // 标题
            content.title = @"凡凡提醒";
            // 次标题
//            content.subtitle = @"柯梵办公室通知";
            // 内容
            content.body = @"杜鹃小姐姐今天忘记记便签了吗？";
            
            self.badge++;
            // app显示通知数量的角标
            content.badge = @(self.badge);
            
            // 通知的提示声音，这里用的默认的声音
            content.sound = [UNNotificationSound defaultSound];
            
            NSURL *imageUrl = [[NSBundle mainBundle] URLForResource:@"kun" withExtension:@"jpeg"];
            //UNNotificationAttachment *attachment = [UNNotificationAttachment attachmentWithIdentifier:@"imageIndetifier" URL:imageUrl options:nil error:nil];
            
            // 附件 可以是音频、图片、视频 这里是一张图片
            //content.attachments = @[attachment];
            
            // 标识符
            content.categoryIdentifier = @"categoryIndentifier";
            
            // 2、创建通知触发
            /* 触发器分三种：
             UNTimeIntervalNotificationTrigger : 在一定时间后触发，如果设置重复的话，timeInterval不能小于60
             UNCalendarNotificationTrigger : 在某天某时触发，可重复
             UNLocationNotificationTrigger : 进入或离开某个地理区域时触发
             */
            NSDateComponents *date = [[NSDateComponents alloc]init];
            date.hour = 22;
            date.minute = 30;
            date.second = 20;
            
            UNCalendarNotificationTrigger *trigger1 = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:date repeats:YES];
            //UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:5 repeats:NO];
            
            // 3、创建通知请求
            UNNotificationRequest *notificationRequest = [UNNotificationRequest requestWithIdentifier:@"KFGroupNotification" content:content trigger:trigger1];
            
            // 4、将请求加入通知中心
            [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:notificationRequest withCompletionHandler:^(NSError * _Nullable error) {
                if (error == nil) {
                    NSLog(@"已成功加推送%@",notificationRequest.identifier);
                }
            }];
        }
        
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
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
