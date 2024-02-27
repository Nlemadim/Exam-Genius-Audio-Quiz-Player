//
//  Test.swift
//  AUdio Quiz Beta
//
//  Created by Tony Nlemadim on 1/24/24.
//

import SwiftUI


class TestClass: ObservableObject {
    @Published var color: Color = .green
    @Published var number: Int = 0
    
    func changeColor() {
        if self.number > 10 {
            self.color = .red
        }
    }
}

//struct Test: View {

//    @State private var isRecording = false
//    @State private var transcriptCopy: String = ""
//    
//    @State var index = 0
//    @State var interactionState: InteractionState = .idle
//     
//    
//    var body: some View {
//        VStack {
//            if let question = quizPlayer.currentQuestion {
//                Text(quizPlayer.speechRecognizer.transcript)
//                    .padding()
//
//                Spacer()
//                Text(question.questionContent)
//                    .padding()
//                Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
//                
//                HStack {
//                    VStack {
//                        Text(question.options[0])
//                            .foregroundStyle(question.options[0] == question.correctOption && !question.selectedOption.isEmpty ? .green : .gray)
//                            .padding()
//                        
//                        Text(question.options[1])
//                            .foregroundStyle(question.options[1] == question.correctOption && !question.selectedOption.isEmpty ? .green : .gray)
//                            .padding()
//                    }
//                    Spacer()
//                    
//                    VStack {
//                        Text(question.options[2])
//                            .foregroundStyle(question.options[2] == question.correctOption && !question.selectedOption.isEmpty ? .green : .gray)
//                            .padding()
//                        Text(question.options[3])
//                            .foregroundStyle(question.options[3] == question.correctOption && !question.selectedOption.isEmpty ? .green : .gray)
//                            .padding()
//                    }
//                }
//                .padding()
//                
//                Spacer()
//                
//                HStack {
//                    interactionVisualizer(comment: question.selectedOption)
//                    
//                }
//                
//                HStack(spacing: 40) {
//                    
//                    Button("Test") {
//                        
//                    }
//                    .buttonStyle(.borderedProminent)
//                    
//                    Button {
//                        //quizPlayer.recordAnswer()
//                       // isRecording = quizPlayer.isRecordingAnswer
//  
//                    } label: {
//                        Image(systemName: "mic.fill")
//                            .font(.largeTitle)
//                            .foregroundStyle(quizPlayer.isRecordingAnswer ? .red : .white)
//                            .symbolEffect(.scale, isActive: interactionState == .isListening)
//                    }
//                    .padding(20)
//                    .padding(.horizontal, 10)
//                    
//                    Button("Next") {
//                        quizPlayer.playNextQuestion()
////                        guard self.index <= currentQuestion.options.count - 1 else { return }
//                        
//                    }
//                    .buttonStyle(.borderedProminent)
//                    .cornerRadius(10)
//                    
//                }
//                .padding()
//                .padding(.top)
//                .padding(.horizontal)
//
//            }
//            
//     
//        }
//    }
//    
//    private func interactionVisualizer(comment: String) -> some View {
//        let didRecieveSpeech = !comment.isEmpty
//        let isPlaying = interactionState == .isNowPlaying || interactionState == .isListening
//        
//        
//        return HStack {
//            
//            HStack(spacing: 0) {
//                Button(action: {
//                    
//                }, label: {
//                    Image(systemName: "play.desktopcomputer")
//                        .resizable()
//                        .frame(width: 30, height: 30)
//                        .foregroundStyle(!isPlaying ? .gray : .teal)
//                })
//                
//                Image(systemName: "waveform")
//                    .resizable()
//                    .foregroundStyle(isPlaying ? .themeTeal : .gray)
//                    .symbolEffect(.variableColor.iterative.dimInactiveLayers.reversing, options: .repeating, isActive: interactionState == .isNowPlaying || interactionState == .isListening)
//                    .frame(width: 33, height: 33)
//                    .offset(y: -5)
//                    .padding(.leading, 3)
//                    .activeGlow(isPlaying ? .themeTeal : .clear, radius: 2)
//                
//            }
//            
//            
//            Spacer()
//            
//            HStack(spacing: 0) {
//                ZStack {
//                    Image(systemName: "bubble.right")
//                        .resizable()
//                        .foregroundStyle(!didRecieveSpeech ? .gray : .green)
//                        .symbolEffect(.scale.wholeSymbol, options: .nonRepeating, isActive: interactionState == .hasResponded)
//                        .frame(width: 33, height: 33)
//                        .offset(y: -5)
//                        .padding(.leading, 3)
//                    
//                    Text(comment.isSingleCharacterABCD ? comment : "")
//                        .fontWeight(.bold)
//                        .offset(y: -8)
//                        .foregroundStyle(comment == quizPlayer.currentQuestion?.correctOption ? .green : .red)
//                }
//                
//                Button(action: {
//                    
//                }, label: {
//                    Image(systemName: "person.fill")
//                        .resizable()
//                        .frame(width: 25, height: 25)
//                        .foregroundStyle(!didRecieveSpeech ? .gray : .green)
//                })
//                
//                
//            }
//        }
//        .padding(.horizontal)
//        .padding(.top)
//        .frame(maxWidth: .infinity)
//    }
//}
//
//#Preview {
//    Test()
//        .preferredColorScheme(.dark)
//}

/** message.badge.waveform
 message.badge.waveform.fill
 bubble.right.fill
 bubble.fill
 waveform
 play.desktopcomputer
 desktopcomputer.trianglebadge.exclamationmark
 desktopcomputer
 
 
 
 **/
