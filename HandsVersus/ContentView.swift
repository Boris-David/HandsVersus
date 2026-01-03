//
//  ContentView.swift
//  HandsVersus
//
//  Created by Instant System iOS Team on 02/01/2026.
//

import SwiftUI

enum GameStatus {
  case draw, win, loss, unknown
}

enum Player {
  case ai, user
}

struct ContentView: View {
  
  let figures = ["Rock", "Paper", "Scissors"]
  
  let figuresMode = ["Fluent", "Minimalist", "Cartoon", "Classic", "Retro", "Sketch"]
  
  let gameNumberOfQuestions: Int = 3
  
  @State var gameIsFinished: Bool = false
  @State var gameMode: Bool?
  @State var gameFigureStyle: String?
  @State var gamePickedFigure: String = ""
  
  @State var currentQuestion: Int = 1
  @State var userCurrentPickedFigure: String = ""
  
  @State var userScore: Int = 0
  @State var aiScore: Int = 0
  @State var drawScore: Int = 0
  
  var userShouldPick: Bool {
    !gamePickedFigure.isEmpty && userCurrentPickedFigure.isEmpty
  }
  var userGotTheWin: Bool {
    userScore > aiScore
  }
  
  var generateQuestionView: some View {
    ZStack(alignment: .center) {
      Rectangle()
        .frame(height: 10)
        
      if !gameIsFinished {
        Button("Generate a new question") {
          generateNewQuestion()
        }
        .disabled(userCurrentPickedFigure.isEmpty)
        .padding()
        .foregroundStyle(.black)
        .background(.white)
      }
    }
  }
  
  var AIPlayerView: some View {
    VStack {
      Text("Player - AI")
        .font(.largeTitle.bold())
        .frame(alignment: .top)
      
      Spacer()
      
      Image(getImageName(for: .ai))
        .padding()
      
      if userShouldPick {
        Text(gameMode == true ? "DEFEAT ME" : "YOU HAVE TO LOSE")
          .font(.largeTitle.bold())
          .foregroundStyle(gameMode == true ? .green : .red)
      }

      Spacer()

    }
    .alert(userGotTheWin ? "✅ Congrats, you are a rock !": "History only remembers the winners 🚬" , isPresented: $gameIsFinished) {
      Button("OK") {
        resetGame()
      }
    } message: {
      let drawText = drawScore > 0 ? "\n Draw: \(drawScore)" : ""
      Text("AI \(aiScore) - Me \(userScore) \(drawText)")
    }
    
  }
  
  @ViewBuilder var userPlayerView: some View {
    VStack {
      Spacer()
      Image(getImageName(for: .user))
        .padding()
      Spacer()
      Spacer()
      
      if userShouldPick {
        
        Spacer()
        
        Picker("Pick the right figure", selection: $userCurrentPickedFigure) {
          ForEach(figures, id: \.self) {
            Text($0)
          }
        }
        .pickerStyle(.segmented)
      }
      
      Spacer()
      
      Text("Player - ME")
        .font(.largeTitle.bold())
    }
    .onChange(of: userCurrentPickedFigure) { _, newValue in
      handleUserAnswer(newValue)
    }
    
    Spacer()
  }
  
  
  func generateNewQuestion() {
    userCurrentPickedFigure = ""
    gameMode = Bool.random()
    gamePickedFigure = figures.randomElement() ?? ""
  }
  
  func handleUserAnswer(_ userFigure: String) {
    if !userFigure.isEmpty {
      updateScoreTable()
    } else {
      prepareForNextQuestion()
    }
  }
  
  func updateScoreTable() {
    let gameStatus = checkUserAnswer()
    switch gameStatus {
    case .draw:
      drawScore += 1
    case .win:
      userScore += 1
    case .loss:
      aiScore += 1
    case .unknown:
      break
    }
  }
  
  func checkUserAnswer() -> GameStatus {
    
    if gamePickedFigure == userCurrentPickedFigure {
      return .draw
    }
    
    switch gameMode {
    case true:
      if gamePickedFigure == "Rock" {
        return userCurrentPickedFigure == "Paper" ? .win : .loss
      }
      if gamePickedFigure == "Paper" {
        return userCurrentPickedFigure == "Scissors" ? .win : .loss
      }
      if gamePickedFigure == "Scissors" {
        return userCurrentPickedFigure == "Rock" ? .win : .loss
      }
      
    case false:
      if gamePickedFigure == "Rock" {
        return userCurrentPickedFigure == "Scissors" ? .win : .loss
      }
      if gamePickedFigure == "Paper" {
        return userCurrentPickedFigure == "Rock" ? .win : .loss
      }
      if gamePickedFigure == "Scissors" {
        return userCurrentPickedFigure == "Paper" ? .win : .loss
      }
          
    default:
      return .unknown
    }
  
    return .unknown
    
  }
  
  func prepareForNextQuestion() {
    if currentQuestion == gameNumberOfQuestions {
      gameIsFinished = true
    } else {
      currentQuestion += 1
    }
  }
  
  func resetGamePickedFigure() {
    gamePickedFigure = ""
  }
  
  func resetGame() {
    userCurrentPickedFigure = ""
    gamePickedFigure = figures.randomElement() ?? ""
    gameMode = Bool.random()
    gameFigureStyle = figuresMode.randomElement()
    gameIsFinished = false
    currentQuestion = 1
    resetAllScores()
  }
  
  func resetAllScores() {
    userScore = 0
    aiScore = 0
    drawScore = 0
  }
  
  func getImageName(for player: Player) -> String {
    guard let gameFigureStyle else { return "" }
    let suffix = player == .ai ? "\(gamePickedFigure)" : "\(userCurrentPickedFigure)"
    return "\(gameFigureStyle)-\(suffix)"
  }
  
  
  var body: some View {
    ZStack {
      Color.gray.opacity(0.3)
      VStack {
  
        AIPlayerView
        
        Spacer()
        
        generateQuestionView
        
        Spacer()
        
        userPlayerView
        
      }
    }
    .onAppear {
      gameFigureStyle = figuresMode.randomElement() ?? ""
      gameMode = Bool.random()
      gamePickedFigure = figures.randomElement() ?? ""
    }
    .padding()
  }
}

#Preview {
  ContentView()
}
