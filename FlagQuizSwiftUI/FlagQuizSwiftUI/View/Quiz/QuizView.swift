//
//  QuizView.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/20/23.
//

import SwiftUI
import IsoCountryCodes

struct QuizView: View {
    @StateObject private var viewModel: QuizViewModel
    
    init(viewModel: QuizViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    private var currentQuizRound: FQQuizRound {
        viewModel.quiz.currentQuizRound
    }
    
    private var answerCountryFlagEmoji: String {
        let code = currentQuizRound.answerCountryCode.numericCode
        return IsoCountryCodes.find(key: code)?.flag ?? "정보없음"
    }
    
    private var flagImageUrl: URL? {
        if let country = viewModel.countries.first(where: {
            $0.id == currentQuizRound.answerCountryCode
        }) {
            return country.flagLinks.svgURL
        }
        return nil
    }
    
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
              
                AsyncImage(url: flagImageUrl) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 100)
                        .padding()
                } placeholder: {
                    Text(answerCountryFlagEmoji)
                        .font(.system(size: 96))
                }

                Spacer()
                quizQuestion
                
                QuizOptionsGrid(viewModel: viewModel)
                
                QuizSubmitButton(viewModel: viewModel)
                    .animation(.smooth, value: viewModel.isSubmitted)
                    .padding()
            }
            .onAppear {
                viewModel.send(.load)
            }
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        
                    } label: {
                        Text("Quit")
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    scoreView
                }
            }
        }
    }
    
    private var quizQuestion: some View {
        HStack {
            Text("Q\(viewModel.quiz.currentQuizIndex + 1)")
                .padding()
                .background(.ultraThinMaterial,
                            in: RoundedRectangle(cornerRadius: 8))
                .padding(.trailing)
            
            Text("quizview.question")
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.leading)
        }
        .font(.subheadline)
        .padding()
        .background(.thickMaterial,
                    in: Rectangle())
        .padding(.vertical)
    }
    
    private var scoreView: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("current.quiz.description")
                Spacer()
                Text("current.quiz \(viewModel.quiz.currentQuizIndex + 1) / \(viewModel.quiz.quizCount)")
                    .fontWeight(.bold)
            }
            HStack {
                Text("correct.quiz.description")
                Spacer()
                Text("correct.quiz.count \(viewModel.quiz.correctQuizRoundsCount)")
                    .fontWeight(.bold)
            }
            
            HStack {
                Text("wrong.quiz.description")
                Spacer()
                Text("wrong.quiz.count \(viewModel.quiz.wrongQuizRoundsCount)")
                    .fontWeight(.bold)
            }
            
        }
        .monospacedDigit()
        .font(.footnote)
        .frame(minWidth: 80, idealWidth: 100, maxWidth: 240)
        .padding(8)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 8))
        .offset(y: 20)
    }
}


#Preview {
    QuizView(
        viewModel: QuizViewModel(
            container: .init(services: StubService()),
            quizCount: 2,
            quizOptionsCount: 5)
    )
}