//
//  Downloader.swift
//  SeriesViewer
//
//  Created by Victoria Denisyuk on 8/8/16.
//  Copyright © 2016 Victoria Denisyuk. All rights reserved.
//

import Foundation
import Alamofire
import SimpleKeychain

class Downloader {
    
    // MARK: - Strings
    private let baseURLPath = "https://api.thetvdb.com"
    private let baseImageURLPath = "https://thetvdb.com/banners/_cache/posters/"
    private let apiKey = "9D215E2C81B076DC"
    
    //MARK: - Properties
    private var tokenString: String = ""
    private var token: String {
        set {
            tokenString = newValue
            let keychain = A0SimpleKeychain()
            keychain.setString(tokenString, forKey: "token")
        }
        get {
            let keychain = A0SimpleKeychain()
            return keychain.stringForKey("token") ?? ""
        }
    }
    
    private var defaultHHTPHeaders: [String: String] {
        return ["Authorization": "Bearer \(token)", "Accept" : "application/json"]
    }
    
    // MARK: - Private Methods
    private func getRequest(path: String, parameters: [String: AnyObject]? = nil, encoding: ParameterEncoding = .JSON) -> Request {
        let request = Alamofire.request(.GET,
                                        "\(baseURLPath)/\(path)",
                                        headers: defaultHHTPHeaders,
                                        parameters: parameters,
                                        encoding: encoding)
        print(request.debugDescription)
        return request
    }
    
    private func postRequest(path: String, parameters: [String: AnyObject]? = nil, encoding: ParameterEncoding = .JSON) -> Request {
        let request = Alamofire.request(.POST,
                                        "\(baseURLPath)/\(path)",
                                        headers: defaultHHTPHeaders,
                                        parameters: parameters,
                                        encoding: encoding)
        print(request.debugDescription)
        return request
    }
    
    // MARK: Login
    private func login(onLoginError: () -> Void, onLoginSuccess: () -> Void) {
        let request = postRequest("login", parameters: ["apikey": apiKey])
        
        request.responseJSON { response in
            guard response.result.isSuccess
            else {
                print("Request failed while login : \(response.result.error)")
                onLoginError()
                return
            }

            guard let
                responseJSON = response.result.value as? [String: AnyObject],
                token = responseJSON["token"] as? String
            else {
                print("Error received on login \(response.debugDescription)")
                onLoginError()
                return
            }
            
            self.token = token
            onLoginSuccess()
        }
    }

    private func refreshToken(onRefreshError: ()-> Void, onRefreshSuccess: () -> Void) {
        let requestRefreshToken = getRequest("refresh_token")
        
        requestRefreshToken.responseJSON { response in
            guard response.result.isSuccess
            else {
                print("Error while token refresh : \(response.result.error)")
                onRefreshError()
                return
            }
            
            guard let
                responseJSON = response.result.value as? [String: AnyObject],
                token = responseJSON["token"] as? String
            else {
                print("Error received on token refresh \(response.debugDescription)")
                onRefreshError()
                return
            }
            
            self.token = token
            onRefreshSuccess()
        }
    }
    
    private func parseSeries(results: [AnyObject]) -> [Series]{
        let series = results.flatMap({ (newSeries) -> Series? in
            guard let
                id = newSeries["id"] as? Int,
                lastUpdated = newSeries["lastUpdated"] as? Int
                else {
                    return nil
            }
            return Series(id: id, lastUpdated: lastUpdated)
        })
        return series
    }
    
    private func parseSeriesInfo(info: [String: AnyObject]) -> SeriesInfo? {
        guard let
            id = info["id"] as? Int
            else {
                print(info)
                return nil
        }
        let name = info["seriesName"] as? String
        return SeriesInfo(id: id, seriesName: name ?? "...")
    }
    
    // MARK: - Public Methods
    func authenticate(onAuthError: ()-> Void, onAuthSuccess: () -> Void) {
      
        if token.isEmpty {
            //first launch, no saved tokens
            self.login({onAuthError()}){
                print("Logged in")
                onAuthSuccess()
            }
        } else {
            //token is not empty, refresh it
            let onRefreshError = {
                // refresh failed, log in again
                self.login({onAuthError()}){
                    print("Logged in")
                    onAuthSuccess()
                }
            }
            
            refreshToken(onRefreshError) {
                print("Token refreshed")
                onAuthSuccess()
            }
        }
    }
    
    func loadUpdates(onLoadError: () -> Void, onLoadSuccess: ([Series]) -> Void) {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Year, .Month, .Day], fromDate: NSDate())
        components.day -= 7
        
        guard let weekAgoDate = calendar.dateFromComponents(components) else { return }
        let requestSeries = getRequest("updated/query",
                                       parameters: ["fromTime": weekAgoDate.timeIntervalSince1970],
                                       encoding: .URLEncodedInURL)
        requestSeries.responseJSON { response in
            guard response.result.isSuccess
            else {
                print("Error while series fetching : \(response.result.error)")
                onLoadError()
                return
            }
            
            guard let
                responseJSON = response.result.value as? [String: AnyObject],
                results = responseJSON["data"] as? [AnyObject]
            else {
                print("Invalid series received : \(response.debugDescription)")
                onLoadError()
                return
            }
            
            let series = self.parseSeries(results)
            onLoadSuccess(series)
        }
    }
    
    func loadSeriesInfo(id: Int, onInfoError: () -> Void, onInfoSuccess: (SeriesInfo?) -> Void) {
        let requestInfo = getRequest("series/\(id)")
        requestInfo.responseJSON { response in
            guard response.result.isSuccess
            else {
                print("Error while info fetching : \(response.result.error)")
                onInfoError()
                return
            }
            
            guard let
                responseJSON = response.result.value as? [String: AnyObject],
                info = responseJSON["data"] as? [String: AnyObject]
            else {
                print("Invalid info received : \(response.debugDescription)")
                onInfoError()
                return
            }
            
            print(requestInfo)
            guard let
                seriesInfo = self.parseSeriesInfo(info)
            else {
                onInfoError()
                return
            }
            onInfoSuccess(seriesInfo)
        }
    }
    
    func imagePathForSeries(seriesId: Int) -> String {
        return "\(baseImageURLPath)\(seriesId)-1.jpg"
    }
    
}