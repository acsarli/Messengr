//
//  CBEULAViewController.m
//  Messengr
//
//  Created by Adrian Sarli on 6/28/13.
//  Copyright (c) 2013 Adrian Sarli. All rights reserved.
//

#import "CBEULAViewController.h"

@interface CBEULAViewController ()

@end

@implementation CBEULAViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.wv loadHTMLString:@"<!DOCTYPE html PUBLIC \"-\/\/W3C\/\/DTD HTML 4.01\/\/EN\" \"http:\/\/www.w3.org\/TR\/html4\/strict.dtd\">\r\n<html>\r\n<head>\r\n  <meta http-equiv=\"Content-Type\" content=\"text\/html; charset=utf-8\">\r\n  <meta http-equiv=\"Content-Style-Type\" content=\"text\/css\">\r\n  <title>Terms and Conditions.docx<\/title>\r\n  <meta name=\"Generator\" content=\"Cocoa HTML Writer\">\r\n  <meta name=\"CocoaVersion\" content=\"1138.51\">\r\n  <style type=\"text\/css\">\r\n    p.p1 {margin: 0.0px 0.0px 0.0px 0.0px; text-align: center; font: 12.0px Times}\r\n    p.p2 {margin: 0.0px 0.0px 0.0px 0.0px; font: 12.0px Times; min-height: 14.0px}\r\n    p.p3 {margin: 0.0px 0.0px 14.0px 0.0px; font: 9.0px Times; color: #424242}\r\n    p.p4 {margin: 0.0px 0.0px 14.0px 0.0px; font: 12.0px Times; min-height: 14.0px}\r\n    span.Apple-tab-span {white-space:pre}\r\n  <\/style>\r\n<\/head>\r\n<body>\r\n<p class=\"p1\">TERMS AND CONDITIONS<\/p>\r\n<p class=\"p2\"><br><\/p>\r\n<p class=\"p3\">This legal agreement governs your use of the Messengr messaging service. By tapping \u201CAgree\u201D at the bottom of this document, you agree to these terms of service.<\/p>\r\n<p class=\"p3\">Messengr is service provider of the messaging service provided within this app.<\/p>\r\n<p class=\"p3\">a. Code of conduct: You agree not to use this service to:<\/p>\r\n<p class=\"p3\"><span class=\"Apple-tab-span\">\t<\/span>a. engage in illegal activities, including the transmission of confidential information in violation of a nondisclosure agreement.<\/p>\r\n<p class=\"p3\"><span class=\"Apple-tab-span\">\t<\/span>b. spam or solicit other users with advertisements, links, and unsolicited requests for publicity, including requests for follows, likes, and\/or reblogs on Tumblr, or any other solicitation relating to a product, service, or company.<\/p>\r\n<p class=\"p3\"><span class=\"Apple-tab-span\">\t<\/span>c. harass, stalk, harm, or threaten another user<\/p>\r\n<p class=\"p3\"><span class=\"Apple-tab-span\">\t<\/span>d. transmit messages which are defamatory, libelous, violent, abusive, racially or ethnically offensive, or otherwise objectionable<\/p>\r\n<p class=\"p3\"><span class=\"Apple-tab-span\">\t<\/span>e. interfere or disrupt the messaging service<\/p>\r\n<p class=\"p3\">b. Consent to Use of Data: You agree that service provider may collect and use information about your account and related information. This data is gathered to facilitate usage statistics to better accommodate users. Usage statistics, including number of messages sent and\/or received, number of users, and amount of usage may be published.<span class=\"Apple-converted-space\">\u00A0<\/span><\/p>\r\n<p class=\"p3\">c. Termination. Your account may be terminated at any time if<\/p>\r\n<p class=\"p3\">1) you violate the code of conduct as listed in section a;<\/p>\r\n<p class=\"p3\">2) you violate the terms of service or community guidelines of Tumblr;<\/p>\r\n<p class=\"p3\">3) the primary blog of your Tumblr account is deleted or the username of that blog is reassigned or altered;<\/p>\r\n<p class=\"p3\">4) your Tumblr account is terminated.<\/p>\r\n<p class=\"p4\"><br><\/p>\r\n<\/body>\r\n<\/html>\r\n" baseURL:nil];
}
-(IBAction)done:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
