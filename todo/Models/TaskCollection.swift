//
//  TaskCollection.swift
//  todo
//
//  Created by Jun Takahashi on 2019/05/22.
//  Copyright © 2019年 Jun Takahashi. All rights reserved.
//

import UIKit
import FirebaseAuth

protocol TaskCollectionDelegate: class {
    func reload()
}

class TaskCollection {
    
    static var shared = TaskCollection()
    public private(set) var tasks: [Task] = []
    weak var delegate: TaskCollectionDelegate?
    
//    let userDefaults = UserDefaults.standard
    
    //4-1
    let taskUseCase: TaskUseCase

    private init() {
        self.taskUseCase = TaskUseCase()
        self.load()
    }
    //4-2 初期化したIDを返す
    func createTask() -> Task {
        let id = self.taskUseCase.createTaskId()
        //return Task(id: id, value: [:])は間違い
        return Task(id: id, value: [:])
    }
    
    // タスクの追加
    func addTask (_ task: Task) {
        self.tasks.append(task)
        self.taskUseCase.addTask(task)
        self.save()
    }
    
    // タスクの削除
    func removeTask (at: Int) {
        let id = self.tasks[at].id
        self.taskUseCase.removeTask(taskId: id)
        
        self.tasks.remove(at: at)
        self.save()
    }
    
    func editTask (_ task: Task) {
        self.taskUseCase.editTask(task)
        self.save()
    }
//    func editTask(_ task: Task){
//        let documentRef =
//            self.getCollectionRef().document(task.id)
//        documentRef.updateData(task.toValueDict()) { (err) in
//            if let _err = err {
//                print("データ修正失敗",_err)
//            } else {
//                print("データ修正成功")
//            }
//        }
//            self.taskUseCase.editTask(task)
//                self.save()
//    }
    

    
    private func save () {
        self.tasks = self.tasks.sorted(by: {$0.updateAt.dateValue() >
            $1.updateAt.dateValue()})
//        do {
//            let data = try PropertyListEncoder().encode(tasks)
//            userDefaults.set(data, forKey: "tasks")
//        } catch {
//            fatalError ("Save Faild.")
//        }
//
        delegate?.reload()
    }
    
    private func load() {
//        guard let data = userDefaults.data(forKey: "tasks") else { return }
//        do {
//            let tasks = try PropertyListDecoder().decode([Task].self, from: data)
//            self.tasks = tasks
//        } catch {
//            fatalError ("Cannot Load.")
//        }
        self.taskUseCase.fetchTaskDocuments { (tasks) in
            guard let _tasks = tasks else {
                self.save() //Console側とかで空にされたら
                return
            }
            self.tasks = _tasks
            self.save()
    }
}
}
