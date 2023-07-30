//
//  URLSessionExtension.swift
//  ImageFeed
//
//  Created by Андрей Асланов on 20.07.23.
//

import Foundation

extension URLSession {
    func objectTask <T: Decodable>(
        for request: URLRequest, completion: @escaping(Result<T, Error>)->Void)->URLSessionTask {
            let fulfillCompletion: (Result<T, Error>) -> Void = { result in
                DispatchQueue.main.async {
                    completion(result)
                }
            }
            let session = URLSession.shared
            let task = session.dataTask(with: request,completionHandler: { data, response, error in
                if let data = data,
                   let response = response,
                   let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    if 200..<300 ~= statusCode {
                        do {
                            let decoder = JSONDecoder()
                            let result = try decoder.decode(T.self, from: data)
                            fulfillCompletion(.success(result))
                            
                            if let responseDataString = String(data: data, encoding: .utf8) {
                                print("Response Data:")
                                print(responseDataString)
                            } else {
                                print("Unable to convert data to a UTF-8 string.")
                            }
                            
                        } catch {
                            fulfillCompletion(.failure(NetworkError.decodingError(error)))
                        }
                    } else {
                            fulfillCompletion(.failure(NetworkError.httpStatusCode(statusCode)))
                        }
                        
                    } else if let error = error {
                        fulfillCompletion(.failure(NetworkError.urlRequestError(error)))
                    
                } else {
                    fulfillCompletion(.failure(NetworkError.urlSessionError))
                }
                })
            task.resume()
            return task
        }
}
