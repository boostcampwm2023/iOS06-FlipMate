//
//  SignUpEndpoints.swift
//  FlipMate
//
//  Created by 권승용 on 11/28/23.
//

import Foundation

struct SignUpEndpoints {
    static func nickNameValidation(_ nickName: String) -> EndPoint<NickNameValidationResponseDTO> {
        let path = Paths.authInfo + "?nickName=\(nickName)"
        return EndPoint(
            baseURL: BaseURL.flipmateDomain,
            path: path,
            method: .get)
    }
    
    static func userSignUp(nickName: String, profileImageData: Data) -> EndPoint<SignUpResponseDTO> {
        let boundary = "\(UUID().uuidString)"
        let contentType = "multipart/form-data; boundary=\(boundary)"
        var body = Data()
        
        print(nickName)
        print(profileImageData)
        
        // nickname 추가
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"nickname\"\r\n\r\n".data(using: .utf8)!)
        body.append(nickName.data(using: .utf8)!)
        body.append("\r\n".data(using: .utf8)!)
        
        // 이미지 데이터 추가
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"image\"; filename=\"profileImage.jpeg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(profileImageData)
        body.append("\r\n".data(using: .utf8)!)
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        return EndPoint(
            baseURL: BaseURL.flipmateDomain,
            path: Paths.authInfo,
            method: .patch,
            data: body,
            headers: [HTTPHeader(value: contentType, field: "Content-Type")])
    }
}
