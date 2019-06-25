//
//  TaskUseCase.swift
//  todo
//
//  Created by Akiko Sato on 2019/06/15.
//  Copyright © 2019 Jun Takahashi. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

//1-2のデータベース用意
class TaskUseCase {
    let db = Firestore.firestore()
    
    private func getCollectionRef () -> CollectionReference {
        guard let uid = Auth.auth().currentUser?.uid else {
            fatalError ("Uidを取得出来ませんでした。")
        }
        return self.db.collection("users").document(uid).collection("tasks")
    }
    func createTaskId() -> String {
        let id = self.getCollectionRef().document().documentID
        print("taskIdは",id)
        return id
    }
    //5-1
    func addTask(_ task: Task){
        let documentRef = self.getCollectionRef().document(task.id)
//        let taskData: [String: Any] = [:] //仮に⼊れてみているだけ(あとで消す)
        documentRef.setData(task.toValueDict()) { (err) in
            if let _err = err {
                print("データ追加失敗",_err)
            } else {
                print("データ追加成功")
            }
        }
    }
    //タスク消す
    func removeTask(taskId: String){
        let documentRef = self.getCollectionRef().document(taskId)
        documentRef.delete { (err) in
            if let _err = err {
                print("データ取得",_err)
            } else {
                print("データ削除成功")
            }
        }
    }
    //p55
    func editTask(_ task: Task){
        let documentRef =
            self.getCollectionRef().document(task.id)
        documentRef.updateData(task.toValueDict()) { (err) in
            if let _err = err {
                print("データ修正失敗",_err)
            } else {
                print("データ修正成功")
            }
        }
    }
    
    func fetchTaskDocuments(callback: @escaping ([Task]?) -> Void){
        let collectionRef = getCollectionRef()
        collectionRef.getDocuments(source: .default) { (snapshot, err) in
            guard err == nil,
                let _snapshot = snapshot,
                !_snapshot.isEmpty else {
                    print("データ取得失敗",err.debugDescription)
                    callback(nil)
                    return
            }
            
            print("データ取得成功")
            
            let taskCollection: [Task] = _snapshot.documents.compactMap{ (snapshot) in
                let id = snapshot.documentID
                let value = snapshot.data()
                return Task(id : id ,value: value)
            }
            
            callback(taskCollection)
        }
    }
    
}
