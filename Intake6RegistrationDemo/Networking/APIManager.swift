//
//  APIManager.swift
//  Intake6RegistrationDemo
//
//  Created by AHMED on 8/13/22.
//  Copyright © 2022 IDEAEG. All rights reserved.
//

import Alamofire

class APIManager {
    
    static func loadMediaData(term: String = "", media: String = "", completion: @escaping(_ error: Error?, _ mediaResponse: [Media]?) -> Void) {

        let url = "https://itunes.apple.com/search?"
        let param = ["term": term, "media": media]

        AF.request(url, method: .get, parameters: param, encoding: URLEncoding.default, headers: nil).response {
            response in
            guard response.error == nil else{
                completion(response.error, nil)
                return
            }
            guard let data = response.data else{
                return
            }
            do {
                let decoder = JSONDecoder()
                let mediaData = try decoder.decode(MediaResponse.self, from: data)
                completion(nil, mediaData.results)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
