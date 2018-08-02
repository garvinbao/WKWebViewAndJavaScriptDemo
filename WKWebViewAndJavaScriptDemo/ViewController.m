//
//  ViewController.m
//  WKWebViewAndJavaScriptDemo
//
//  Created by Garvin on 2018/7/26.
//  Copyright © 2018年 Garvin. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>

@interface ViewController () <WKScriptMessageHandler> {
    WKWebView *_wkWeb;
    UIButton *_button1;
    UIButton *_button2;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self loadUI];
}

- (void)loadUI {
    WKUserContentController *_userContentController = [[WKUserContentController alloc] init];
    // 注册JS消息，name必须JS发送消息时的名字对应
    [_userContentController addScriptMessageHandler:self name:@"noParamsFunction"];
    [_userContentController addScriptMessageHandler:self name:@"haveParamsFunction"];
    
    WKWebViewConfiguration *_configuration = [[WKWebViewConfiguration alloc] init];
    _configuration.userContentController = _userContentController;
    
    _wkWeb = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width,self.view.bounds.size.height/2 - 20) configuration:_configuration];
    _wkWeb.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_wkWeb];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"oc&js.html" ofType:nil];
    [_wkWeb loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]]];
    
    
    // OC的按钮
    _button1 = [[UIButton alloc] initWithFrame:CGRectMake(100, self.view.bounds.size.height/2 + 100, 200,40)];
    [_button1 setTitle:@"oc2js无参" forState:UIControlStateNormal];
    _button1.backgroundColor = [UIColor grayColor];
    [_button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_button1 addTarget:self action:@selector(button1Click:)forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_button1];
    
    _button2 = [[UIButton alloc]initWithFrame:CGRectMake(100,self.view.bounds.size.height/2 + 150, 200,40)];
    [_button2 setTitle:@"oc2js有参"forState:UIControlStateNormal];
    _button2.backgroundColor = [UIColor grayColor];
    [_button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_button2 addTarget:self action:@selector(button2Click:)forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_button2];
}

- (void)button1Click:(UIButton *)button {
    // OC给JS发送消息
    [_wkWeb evaluateJavaScript:@"oc2js1()" completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        NSLog(@"error %@", error);
    }];
}

- (void)button2Click:(UIButton *)button {
    // OC给JS发送消息
    [_wkWeb evaluateJavaScript:@"oc2js2('你','好')" completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        NSLog(@"error %@", error);
    }];
}


#pragma mark --- WKScriptMessageHandler ---
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    NSLog(@"message.name:%@", message.name);
    NSLog(@"message.body:%@", message.body);
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
