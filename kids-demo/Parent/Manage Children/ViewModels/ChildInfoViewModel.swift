//
//  ChildInfoViewModel.swift
//  AlifBee Kids
//
//  Created by Yaman on 3.11.2021.
//  Copyright © 2021 ALEMI. All rights reserved.
//


import Foundation
import UIKit
import RxSwift
import RxCocoa

enum ChildInfoModelType{
    case Edit
    case Add
    case Signup
}

enum Gender: String {
    case Male = "m"
    case Female = "f"
    case NotSet = "x"
}

enum AgeGroups: String {
    case Age1 = "0-2"
    case Age2 = "3-5"
    case Age3 = "5"
    case NotSet = "x"
}

final class ChildInfoViewModel {
    
    var submitResult = BehaviorRelay<Int>.init(value: -1)
    var selectedGender: BehaviorRelay<Gender> = .init(value: Gender.NotSet)
    var selectedAge: BehaviorRelay<AgeGroups> = .init(value: AgeGroups.NotSet)
    var name: BehaviorRelay<String> = .init(value: "")
    
    func setGender(gender: String) {
        if gender == Gender.Male.rawValue {
            self.selectedGender.accept(Gender.Male)
        } else if gender == Gender.Female.rawValue {
            self.selectedGender.accept(Gender.Female)
        } else {
            self.selectedGender.accept(Gender.NotSet)
        }
    }
    
    func setName(name: String) {
        self.name.accept(name)
    }
    
    func setAge(age: String) {
        if age == AgeGroups.Age1.rawValue {
            self.selectedAge.accept(AgeGroups.Age1)
        } else if age == AgeGroups.Age2.rawValue {
            self.selectedAge.accept(AgeGroups.Age2)
        } else if age == AgeGroups.Age3.rawValue {
            self.selectedAge.accept(AgeGroups.Age3)
        } else {
            self.selectedAge.accept(AgeGroups.NotSet)
        }
    }
    
    func setAge(age: AgeGroups) {
        self.selectedAge.accept(age)
        if age != AgeGroups.NotSet {
            addNewChild()
        } else {
            self.submitResult.accept(-1)
        }
    }
    
    func addNewChild() {
        let child = Child(
            id: 1,
            name: name.value,
            gender: selectedGender.value.rawValue,
            birthYear: 2017,
            learningLanguage: "en",
            avatar: "avatar",
            classroomId: 1,
            ageGroup: selectedAge.value.rawValue,
            finishedLessons: 5,
            allLessons: 20,
            elapsedTime: "30",
            progress: 40
        )
        
        // Some api call after that
        
        SharedData.shared.children.append(child)
        self.submitResult.accept(1)
    }
    
    func ageDescription (key : String)-> String{
        let desc = "ageGroup_\(key)"
        return desc
    }
}
