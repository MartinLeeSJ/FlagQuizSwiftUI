//
//  FQQuiz.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/20/23.
//

import Foundation

struct FQQuiz {
    let quizCount: Int
    let quizOptionsCount: Int
    
    var quizRounds: [FQQuizRound]
    private(set) var currentQuizIndex: Int = 0
    
    var currentQuizRound: FQQuizRound {
        quizRounds[currentQuizIndex]
    }
    
    var correctQuizRoundsCount: Int {
        quizRounds.filter { round in
            guard let submittedCountryCode = round.submittedCountryCode else {
                return false
            }
            
            return round.answerCountryCode == submittedCountryCode
        }.count
    }
    
    var wrongQuizRoundsCount: Int {
        quizCount - correctQuizRoundsCount
    }
    
    mutating func toNextIndex() {
        guard currentQuizIndex < (quizCount - 1) else { return }
        currentQuizIndex += 1
    }
    
    init(quizCount: Int, quizOptionsCount: Int) {
        self.quizCount = quizCount
        self.quizOptionsCount = quizOptionsCount
        self.quizRounds = Self.createQuizRounds(quizCount: quizCount, quizOptionsCount: quizOptionsCount)
    }

    static private func createQuizRounds(quizCount: Int, quizOptionsCount: Int) -> [FQQuizRound] {
        FQCountryISOCode.chooseRandomly(quizCount, except: nil).map {
            FQQuizRound(answerCountryCode: $0, quizOptionsCount: quizOptionsCount)
        }
    }
}