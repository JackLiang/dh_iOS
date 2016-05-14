//
//  DHInterface.h
//  DriverHelper
//
//  Created by Gordon Su on 16/4/22.
//  Copyright © 2016年 S&L. All rights reserved.
//

#ifndef DHInterface_h
#define DHInterface_h

#define ServerUrl       @"http://112.74.96.226:8080/dh-web"

#define AddReportUrl    [NSString stringWithFormat:@"%@/message/addReport.do?", ServerUrl]
#define GetReportUrl    [NSString stringWithFormat:@"%@/message/getReport.do?", ServerUrl]

#define AuthenticateUrl [NSString stringWithFormat:@"%@/user/authenticate.do?", ServerUrl]

#define UploadPicUrl    [NSString stringWithFormat:@"%@/common/uploadPicUrl.do?", ServerUrl]

#endif /* DHInterface_h */
