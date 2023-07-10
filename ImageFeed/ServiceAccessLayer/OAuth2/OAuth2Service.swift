//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Андрей Асланов on 02.07.23.
//

//import Foundation

//final class OAuth2Service {
//    static let shared = OAuth2Service()
//    private let urlSession = URLSession.shared
//
//    func fetchOAuthToken(_ code: String, completion: @escaping(Result<String, Error>) -> Void) {
//        let request = authTokenRequest(code: code)
//        let task = object(for: request) { result in
//            switch result {
//            case .success(let body):
//                let authToken = body.accessToken
//                OAuth2TokenStorage().token = authToken
//                completion(.success(authToken))
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
//        task.resume()
//    }
//}
//
//extension OAuth2Service {
//
//    enum NetworkError: Error {
//        case httpStatusCode(Int)
//        case urlRequestError(Error)
//        case urlSessionError
//    }
//
//    private func object(
//        for request: URLRequest,
//        completion: @escaping (Result<OAuthTokenResponseBody, Error>) -> Void
//    ) -> URLSessionTask {
//        let decoder = JSONDecoder()
//        return urlSession.dataTask(with: request) { (data, response, error) in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//            guard let httpResponse = response as? HTTPURLResponse else {
//                completion(.failure(OAuth2Error.urlRequestError))
//                return
//            }
//
//            guard (200..<300).contains(httpResponse.statusCode) else {
//                completion(.failure(OAuth2Error.httpStatusCode(httpResponse.statusCode)))
//                return
//            }
//
//            guard let data = data else {
//                completion(.failure(OAuth2Error.invalidData))
//                return
//            }
//
//            do {
//                let responseObject = try decoder.decode(OAuthTokenResponseBody.self, from: data)
//                completion(.success(responseObject))
//            } catch {
//                completion(.failure(error))
//            }
//        }
//    }
//
//    private func authTokenRequest(code: String) -> URLRequest {
//        var urlComponents = URLComponents(string: "https://unsplash.com/oauth/token")!
//        urlComponents.queryItems = [
//            URLQueryItem(name: "client_id", value: AccessKey),
//            URLQueryItem(name: "client_secret", value: SecretKey),
//            URLQueryItem(name: "redirect_uri", value: RedirectURI),
//            URLQueryItem(name: "code", value: code),
//            URLQueryItem(name: "grant_type", value: "authorization_code")
//        ]
//        let url = urlComponents.url!
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        return request
//    }
//
//    private struct OAuthTokenResponseBody: Decodable {
//        let accessToken: String
//        let tokenType: String
//        let scope: String
//        let createdAt: Int
//
//        enum CodingKeys: String, CodingKey {
//            case accessToken = "access_token"
//            case tokenType = "token_type"
//            case scope
//            case createdAt = "created_at"
//        }
//    }
//
//    private enum OAuth2Error: Error {
//        case invalidData
//    }
//}

import Foundation

final class OAuth2Service {
    static let shared = OAuth2Service()
    private let urlSession = URLSession.shared

    func fetchOAuthToken(_ code: String, completion: @escaping(Result<String, Error>) -> Void) {
        let request = authTokenRequest(code: code)
        let task = urlSession.data(for: request) { result in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let responseObject = try decoder.decode(OAuthTokenResponseBody.self, from: data)
                    let authToken = responseObject.accessToken
                    OAuth2TokenStorage.shared.token = authToken
                    completion(.success(authToken))
                    print ("fetchOAuthToken")                                                       //
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
        task.resume()
    }
}

extension URLSession {
    func data(
        for request: URLRequest,
        completion: @escaping (Result<Data, Error>) -> Void
    ) -> URLSessionTask {
        let fulfillCompletion: (Result<Data, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        let task = dataTask(with: request, completionHandler: { data, response, error in
            if let data = data,
                let response = response,
                let statusCode = (response as? HTTPURLResponse)?.statusCode
            {
                if 200 ..< 300 ~= statusCode {
                    fulfillCompletion(.success(data))
                } else {
                    fulfillCompletion(.failure(OAuth2Error.httpStatusCode(statusCode)))
                }
            } else if let error = error {
                fulfillCompletion(.failure(OAuth2Error.urlRequestError(error)))
            } else {
                fulfillCompletion(.failure(OAuth2Error.urlSessionError))
            }
        })
        return task
    }
}

extension OAuth2Service {
    private func authTokenRequest(code: String) -> URLRequest {
        var urlComponents = URLComponents(string: "https://unsplash.com/oauth/token")!
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: AccessKey),
            URLQueryItem(name: "client_secret", value: SecretKey),
            URLQueryItem(name: "redirect_uri", value: RedirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        let url = urlComponents.url!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }
    
    private struct OAuthTokenResponseBody: Decodable {
        let accessToken: String
        let tokenType: String
        let scope: String
        let createdAt: Int
        
        enum CodingKeys: String, CodingKey {
            case accessToken = "access_token"
            case tokenType = "token_type"
            case scope
            case createdAt = "created_at"
        }
    }
}

enum OAuth2Error: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
}


