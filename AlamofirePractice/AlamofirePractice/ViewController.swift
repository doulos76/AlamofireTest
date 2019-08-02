//
//  ViewController.swift
//  AlamofirePractice
//
//  Created by iOS_Dev on 02/08/2019.
//  Copyright © 2019 iOS_Dev. All rights reserved.
//

import UIKit

// import Library
import Alamofire

class ViewController: UIViewController {
  
  // MARK:- Properties
  
  let urlString = "https://httpbin.org/get"
  
  lazy var imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.backgroundColor = .blue
    imageView.contentMode = UIImageView.ContentMode.scaleAspectFill
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()
  
  // MARK:- View Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    setupView()
    setupLayout()
    
//    makingARequestWithAlamofire()
//    responseHandling()
//    responseManualValidation()
//    responseAutomaticValidation()
//    httpMethodsTest()
//    getRequestWithUrlEncodedParameters()
//    postRequestWithJsonEncodedParameters()
//    httpBasicAuthentication()
    downloadDataToFile()
  }
  
  func setupView() {
    view.addSubview(imageView)
  }
  
  func setupLayout() {
    NSLayoutConstraint.activate([
      imageView.topAnchor.constraint(equalTo: view.topAnchor),
      imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
      ])
  }
  
  //: Making a Request
  func makingARequestWithAlamofire() {
    print("\n------------- [ making a request with Alamofire ] -------------\n")
    Alamofire.request(urlString)
  }
  
  //: Response Handling
  func responseHandling() {
    print("\n------------- [ response handling with Alamofire ] -------------\n")
    Alamofire.request(urlString).responseJSON { response in
      print("Request: \(String(describing: response.request))") // original url request
      print("Response: \(String(describing: response.response))") // http url response
      print("Result: \(response.request))") // response serialization result
      
      if let json = response.result.value {
        print("JSON: \(json)") // serialized json response
      }
      
      if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
        print("Data: \(utf8Text)")  // original server data as UTF8 string
      }
    }
  }
  
  //: Response Varidation
  // Manual Validation
  func responseManualValidation() {
    print("\n------------- [ response validation manually ] -------------\n")
    Alamofire.request("https://httpbin.org/get")
    .validate(statusCode: 200..<300)
    .validate(contentType: ["application/json"])
      .responseData { response in
        switch response.result {
        case .success:
          print("Manual Validation Successful")
        case .failure(let error):
          print("Manual Validation Error: \(error)")
        }
    }
  }
  
  //: Automatic Validation
  func responseAutomaticValidation() {
    print("\n------------- [ response validation automatically ] -------------\n")
    Alamofire.request("https://httpbin.org/get").validate().responseJSON { response in
      switch response.result {
      case .success:
        print("Automatic Validation Successful")
      case .failure(let error):
        print("Automatic Validation Error: \(error)")
      }
    }
  }
  
  //: HTTP Methods
  func httpMethodsTest() {
    Alamofire.request("https://httpbin.org/get", method: .get)
    Alamofire.request("https://httpbin.org/post", method: .post)
    Alamofire.request("https://httpbin.org/put", method: .put)
    Alamofire.request("https://httpbin.org/delete", method: .delete)
  }
  
  //: GET Request With URL_Encoded Parameters
  func getRequestWithUrlEncodedParameters() {
    print("\n------------- [ GET Request With URL_Encoded Parameters ] -------------\n")
    let parameters: Parameters = ["foo": "bar"]
    // All three of theser calls are equivalent
    Alamofire.request("https://httpbin.org/get", parameters: parameters)
    Alamofire.request("https://httpbin.org/get", parameters: parameters, encoding: URLEncoding.default)
    Alamofire.request("https://httpbin.org/get", parameters: parameters, encoding: URLEncoding.httpBody)
  }
  
  //: POST Request With URL-Encoded Parameters
  func postRequestWithUrlEncodedParameters() {
    print("\n------------- [ POST Request With URL_Encoded Parameters ] -------------\n")
    let parameters: Parameters = ["foo": "bar",
                                  "baz": ["a", 1],
                                  "qux": [
                                    "x": 1,
                                    "y": 2,
                                    "z": 3]
    ]
    
    // All three of theser calls are equivalent
    Alamofire.request("https://httpbin.org/post", method: .post, parameters: parameters)
    Alamofire.request("https://httpbin.org/post", method: .post, parameters: parameters, encoding: URLEncoding.default)
    Alamofire.request("https://httpbin.org/post", method: .post, parameters: parameters, encoding: URLEncoding.httpBody)
  }
  
  //: JSON Encoding
  func postRequestWithJsonEncodedParameters() {
    let parameters: Parameters = [
      "foo": [1, 2, 3],
      "bar": [
        "baz": "qux"
      ]
    ]
    
    // Both calls are equivalent
    Alamofire.request("https://httpbin.org/post", method: .post, parameters: parameters, encoding: JSONEncoding.default)
    Alamofire.request("https://httpbin.org/post", method: .post, parameters: parameters, encoding: JSONEncoding(options: []))
  }
  
  //: HTTP Basic Authentication
  func httpBasicAuthentication() {
    let user = "user"
    let password = "password"
    
    var headers: HTTPHeaders = [:]
    if let authorizationHeader = Request.authorizationHeader(user: user, password: password) {
      headers[authorizationHeader.key] = authorizationHeader.value
    }
    
    Alamofire.request("https://httpbin.org/basic-auth/user/password)", headers: headers)
      .responseJSON { response in
        debugPrint(response)
    }
  }
  
  //: Downloading Data to a File
  func downloadDataToFile() {
    Alamofire.download("https://httpbin.org/image/png").responseData { response in
      if let data = response.result.value {
        print(data)
        if let image = UIImage(data: data) {
          print(image)
          self.imageView.image = image
        }
      }
    }
  }
}

