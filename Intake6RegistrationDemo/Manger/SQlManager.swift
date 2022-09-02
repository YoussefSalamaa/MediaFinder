//
//  SQlManager.swift
//  Intake6RegistrationDemo
//
//  Created by AHMED on 8/24/22.
//  Copyright © 2022 IDEAEG. All rights reserved.
//

import SQLite

class SQlManager {
    
    //MARK:- Singletone
    private static let shared = SQlManager()
    
    static func sharedObject() -> SQlManager {
        return SQlManager.shared
    }
    
    //MARK:- Variables
    var database: Connection!
    let userTable = Table("Users")
    var id = Expression<Int>("id")
    var media = Expression<Data?>("media")
    var user = Expression<Data?>("user")
    
    //MARK:- Setup connection
    func setupConnection() {
        do {
            let doc = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileURL = doc.appendingPathComponent("Users").appendingPathExtension("sqlite3")
            let database = try Connection(fileURL.path)
            self.database = database
            createTable()
        } catch {
            print(error.localizedDescription)
        }
    }
    //MARK:- Create Table
    func createTable() {
        let createTable = self.userTable.create { table in
            table.column(self.id, primaryKey: true)
            table.column(self.media)
            table.column(self.user)
        }
        do {
            try self.database.run(createTable)
        } catch {
            print("There's a table created already.")
        }
    }
    //MARK:- Insert user.
    func insertUser(user: Data){
        let user = self.userTable.insert(self.user <- user)
        do {
            try self.database.run(user)
        } catch {
            print(error.localizedDescription)
        }
    }
    //MARK:- Decoding user Data.
    func decodeDataToUser(userData: Data) -> User? {
        do {
            let decoder = JSONDecoder()
            let user = try decoder.decode(User.self, from: userData)
            
            return user
            
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    //MARK:- get user
    func getUserData(email: String) -> User? {
        do {
            let users = try self.database.prepare(self.userTable)
            for user in users{
                guard let userData = user[self.user] else {return nil}
                print("\(id)")

                if let user = decodeDataToUser(userData: userData) {
                    if user.email == email {
                        return user
                    }
                }
            }
        } catch {
            print(error)
        }
        return nil
    }
    //MARK:- Insert Media.
    func insertMedia(media: Data) {
        let insertMedia = self.userTable.insert(self.media <- media)
        
        do {
            try self.database.run(insertMedia)
            
        } catch {
            print(error.localizedDescription)
        }
    }
    //MARK:- Update Media.
    func updateMedia(email: String, userMedia: Data) {
        do {
            let mediaData = try self.database.prepare(self.userTable)
            for data in mediaData{
                guard let userData = data[self.user] else {return}
                guard let user = decodeDataToUser(userData: userData) else {return}
                if email == user.email {
                    let id = data[self.id]
                    let media = self.userTable.filter(self.id == id)
                    let updatedMedia = media.update(self.media <- userMedia)
                    try self.database.run(updatedMedia)
                }
            }
        } catch {
            print(error)
        }
    }
    //MARK:- Decode Media.
    func decodeDataToMedia(mediaData: Data) -> MediaData? {
        do {
            let decoder = JSONDecoder()
            let media = try decoder.decode(MediaData.self, from: mediaData)
            
            return media
            
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    //MARK:- get Media.
    func getMediaData(email: String) -> MediaData? {
        do {
            let tableData = try self.database.prepare(self.userTable)
            for data in tableData{
                guard let userData = data[self.user] else {return nil}
                if let user = decodeDataToUser(userData: userData) {
                    if user.email == email {
                        guard let mediaData = data[self.media] else {return nil}
                        if let media = decodeDataToMedia(mediaData: mediaData) {
                            return media
                        }
                    }
                }
            }
        } catch {
            print(error)
        }
        return nil
    }
}
