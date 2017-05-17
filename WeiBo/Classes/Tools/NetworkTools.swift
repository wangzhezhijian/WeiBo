//
//  NetworkTools.swift
//  WeiBo
//
//  Created by AISION on 17/3/2.
//  Copyright © 2017年 xiaokai.wang. All rights reserved.
//

import AFNetworking
// 定义枚举类型
enum RequestType : String {
    case GET = "GET"
    case POST = "POST"
}
class NetworkTools: AFHTTPSessionManager {
    // let是线程安全的
    static let shareInstance : NetworkTools = {
        let tools = NetworkTools()
        tools.responseSerializer.acceptableContentTypes?.insert("text/html")
        tools.responseSerializer.acceptableContentTypes?.insert("text/plain")
        return tools
    }()
}
//MARK:-封装请求方法
extension NetworkTools{
    func request(methodType : RequestType ,urlString : String,parameters : [String : AnyObject], finished : @escaping (_ result : AnyObject?,_ error : Error?) -> ()){
        
        // 1.定义成功的回调
        let successCallBack = { (task : URLSessionDataTask, result : Any) -> Void in
            finished(result as AnyObject, nil)
        }
        // 2. 定义失败的回调
        let failureCallBack = { (task : URLSessionDataTask?, error : Error) -> Void in
            finished(nil, error)
        }
        if methodType == .GET {
            get(urlString, parameters: parameters, progress: nil, success: successCallBack, failure: failureCallBack)
        }else{
            post(urlString, parameters: parameters, progress: nil, success: successCallBack, failure: failureCallBack)
        }
    }
}

// MARK: 请求AccessToken 
extension NetworkTools{
    func loadAccessToken(code : String,finished : @escaping (_ reslut : [String : AnyObject]?, _ error : Error?)->()){
        // 1. 获取请求的URLString
        let urlString = "https://api.weibo.com/oauth2/access_token"
        // 2. 获取请求的参数
        let parameters = ["client_id":app_key,"client_secret":app_secret,"grant_type":"authorization_code","code":code,"redirect_uri":redirect_uri]
        // 3. 发送网络请求
        request(methodType: .POST, urlString: urlString, parameters: parameters as [String : AnyObject]) { (result, error) in
            finished(result as! [String : AnyObject]?, error)
        }
        
    }
}

// MARK: 请求用户信息
extension NetworkTools{
    func loadUserInfo(access_token : String,uid: String , finished : @escaping (_ result : [String : AnyObject]? , _ error : Error?) -> ()){
        // 1.获取请求的URLString
        let urlString = "https://api.weibo.com/2/users/show.json"

        // 2.获取请求的参数
        let parameters = ["access_token" : access_token,"uid":uid]
        // 3.发送网络请求
        request(methodType: .GET, urlString: urlString, parameters: parameters as [String : AnyObject]) { (result, error) in
            finished(result as! [String : AnyObject]?, error)
        }
        
    }
}
// MARK: 请求首页数据
extension NetworkTools{
    func loadStatuses(max_id : Int,since_id : Int,finished:@escaping (_ result : [[String : AnyObject]]?,_ error : Error?)->()) {
        // 1.获取请求的URLString
        let urlString = "https://api.weibo.com/2/statuses/home_timeline.json"
        // 2.获取请求的参数
        let parameters = ["access_token" : (UserAccountViewModel.shareIntance.account?.access_token)!,"since_id":"\(since_id)","max_id":"\(max_id)"]
        
        // 3. 发送网络请求
        request(methodType: .GET, urlString: urlString, parameters: parameters as [String : AnyObject]) { (result, error) in
            guard let resultDict = result as? [String : AnyObject] else{
                 finished(nil, error)
                return
            }
            // 将数组数据回调给外界控制器
            finished(resultDict["statuses"] as? [[String : AnyObject]], error)
        }
    }
    
}

