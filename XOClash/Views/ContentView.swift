//
//  XOClashView.swift
//  XOClash
//
//  Created by olivier geiger on 30/05/2024.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    @AppStorage("isFirstTime") private var isFirstTime: Bool = true
    @State private var board = Array(repeating: Array(repeating: "", count: 3), count: 3)
    @State private var currentPlayer = "cross"
    @State private var winner = ""
    @State private var player1Name = "Joueur 1"
    @State private var player1Score = 0
    @State private var botScore = 0
    @State private var playerType: PlayerType = .player
    @State private var previousPlayerType: PlayerType?
    @State private var player: AVAudioPlayer?
    @State private var showAlert = false
    @State private var winnerName = ""
    @State private var animateTitle = false
    @State private var animateGrid = false
    @State private var numberOfGame = 0
    
    enum PlayerType {
        case player
        case bot
    }
    
    init() {
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor.black
        
        let attributes: [NSAttributedString.Key:Any] = [
            .foregroundColor : UIColor.white
        ]
        UISegmentedControl.appearance().setTitleTextAttributes(attributes, for: .selected)
        UISegmentedControl.appearance().backgroundColor = .white
    }
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.black, .green, .black, .black]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
                    )
            .ignoresSafeArea()
            
            VStack {
                Text("X O  C l a s h")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .scaleEffect(animateTitle ? 1.2 : 1)
                    .animation(.easeInOut(duration: 1), value: animateTitle)
                    .onAppear {
                        animateTitle.toggle()
                    }
                    .padding(.bottom, 10)
                
                HStack {
                    Spacer()
                    HStack(alignment: .lastTextBaseline) {
                        Text("\(player1Name): ")
                            .font(.headline)
                            .foregroundColor(.white)
                        Text("\(player1Score)")
                            .font(.largeTitle)
                            .foregroundStyle(.green)
                    }
                    .padding()
                    .frame(height: 40)
                    .background(.black.opacity(0.5))
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    Spacer()
                    HStack(alignment: .lastTextBaseline) {
                        Text(playerType == .player ? "Joueur 2" : "Bot")
                            .font(.headline)
                            .foregroundColor(.white)
                        Text("\(botScore)")
                            .font(.largeTitle)
                            .foregroundStyle(.purple)
                    }
                    .padding()
                    .frame(height: 40)
                    .background(.black.opacity(0.5))
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    Spacer()
                }
                .padding([.top, .bottom], 20)
                
                if numberOfGame > 0 {
                    Text("Nombre de parties : \(numberOfGame)")
                        .font(.title2)
                        .foregroundStyle(.white)
                    
                }
                
                ForEach(0..<3) { row in
                    HStack {
                        ForEach(0..<3) { column in
                            Button(action: {
                                self.makeMove(row: row, column: column)
                            }) {
                                ZStack {
                                    Color.black.opacity(0.3)
                                        .frame(width: 90, height: 90)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(Color.white, lineWidth: 2)
                                        )
                                    
                                    if !self.board[row][column].isEmpty {
                                        Image(self.board[row][column])
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 70, height: 70)
                                            .transition(.scale)
                                    }
                                }
                            }
                        }
                    }
                }
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("Joueur 1:")
                            .font(.caption)
                            .foregroundColor(.white)
                        TextField("Nom...", text: $player1Name)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 150)
                    }
                    Spacer()
                    VStack(alignment: .leading) {
                        Text("Joueur 2:")
                            .font(.caption)
                            .foregroundColor(.white)
                        Picker(selection: $playerType, label: Text("Choisir le joueur")) {
                            Text("Joueur2").tag(PlayerType.player)
                            Text("Bot").tag(PlayerType.bot)
                        }
                        .pickerStyle(.segmented)
                        .frame(width: 150)
                        .onChange(of: playerType) { newValue in
                            if newValue == .player {
                                player1Score = 0
                                botScore = 0
                                numberOfGame = 0
                                endGame()
                            } else {
                                player1Score = 0
                                botScore = 0
                                numberOfGame = 0
                                endGame()
                            }
                        }
                    }
                }
                .padding([.top, .bottom], 20)
                .padding(.horizontal)
                
                Button(action: {
                    self.endGame()
                }) {
                    HStack {
                        Image(systemName: "arrow.clockwise")
                            .foregroundColor(.white)
                        Text("Réinitialiser le jeu")
                            .foregroundColor(.white)
                    }
                }
                .padding()
                .frame(maxWidth: 300)
                .background(.black.opacity(0.5))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                
                NavigationLink {
                    RulesView()
                        .navigationBarBackButtonHidden()
                } label: {
                    Text("Voir les rêgles")
                        .foregroundColor(.black)
                        .padding()
                        .frame(maxWidth: 300)
                        .background(.white.opacity(0.8))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                
                Spacer()
            }
            .sheet(isPresented: $isFirstTime, content: {
                IntroScreenView()
                    .interactiveDismissDisabled()
            })
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        InfoView()
                            .navigationBarBackButtonHidden()
                    } label: {
                        Image(systemName: "info.circle.fill")
                            .foregroundStyle(.white)
                    }
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Fin du match"), message: Text(winner == "Match nul" ? "Match nul !" : "\(winnerName) a gagné !"), dismissButton: .default(Text("Continuer")) {
                    resetGame()
                })
            }
        }
    }
    
    // MARK: - FUCTIONS
    
    func makeMove(row: Int, column: Int) {
        if board[row][column].isEmpty && winner.isEmpty {
            board[row][column] = currentPlayer
            playSound(name: "spin")
            if checkWinner(player: currentPlayer) {
                winner = currentPlayer
                winnerName = currentPlayer == "cross" ? player1Name : (playerType == .player ? "Joueur 2" : "Bot")
                showAlert = true
                if currentPlayer == "cross" {
                    player1Score += 1
                } else {
                    botScore += 1
                }
                numberOfGame += 1
            } else if checkDraw() {
                winner = "Match nul"
                showAlert = true
                numberOfGame += 1
            } else {
                currentPlayer = currentPlayer == "cross" ? "circle" : "cross"
                if currentPlayer == "circle" && playerType == .bot {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        botMove()
                        if checkWinner(player: "circle") {
                            winner = "circle"
                            winnerName = "Bot"
                            showAlert = true
                            botScore += 1
                            numberOfGame += 1
                        } else if checkDraw() {
                            winner = "Match nul"
                            showAlert = true
                            numberOfGame += 1
                        }
                    }
                }
            }
        }
    }

    
    func checkDraw() -> Bool {
        for row in board {
            for cell in row {
                if cell.isEmpty {
                    return false
                }
            }
        }
        return true
    }
    
    func botMove() {
        let strategicMoveProbability = 0.8
        let randomValue = Double.random(in: 0..<1)
        
        if randomValue < strategicMoveProbability {
            if makeWinningMove(player: "circle") {
                return
            }
            
            if blockWinningMove(player: "cross") {
                return
            }
            
            if let (row, column) = evaluateBestMove() {
                makeMove(row: row, column: column)
                return
            }
        }
        
        var availableMoves = [(Int, Int)]()
        for row in 0..<3 {
            for column in 0..<3 {
                if board[row][column].isEmpty {
                    availableMoves.append((row, column))
                }
            }
        }
        guard !availableMoves.isEmpty else {
            return
        }
        let randomIndex = Int.random(in: 0..<availableMoves.count)
        let (row, column) = availableMoves[randomIndex]
        makeMove(row: row, column: column)
    }
    
    
    func evaluateBestMove() -> (Int, Int)? {
        var bestMove: (row: Int, column: Int)?
        var bestScore = Int.min
        
        for row in 0..<3 {
            for column in 0..<3 {
                if board[row][column].isEmpty {
                    board[row][column] = currentPlayer
                    
                    let score = minimax(depth: -3, isMaximizing: false)
                    
                    board[row][column] = ""
                    
                    if score > bestScore {
                        bestScore = score
                        bestMove = (row, column)
                    }
                }
            }
        }
        return bestMove
    }
    
    func minimax(depth: Int, isMaximizing: Bool) -> Int {
        if checkWinner(player: "circle") {
            return 10 - depth
        } else if checkWinner(player: "cross") {
            return depth - 10
        } else if checkDraw() {
            return 0
        }
        
        if isMaximizing {
            var bestScore = Int.min
            for row in 0..<3 {
                for column in 0..<3 {
                    if board[row][column].isEmpty {
                        board[row][column] = "circle"
                        let score = minimax(depth: depth + 1, isMaximizing: false)
                        board[row][column] = ""
                        bestScore = max(bestScore, score)
                    }
                }
            }
            return bestScore
        } else {
            var bestScore = Int.max
            for row in 0..<3 {
                for column in 0..<3 {
                    if board[row][column].isEmpty {
                        board[row][column] = "cross"
                        let score = minimax(depth: depth + 1, isMaximizing: true)
                        board[row][column] = ""
                        bestScore = min(bestScore, score)
                    }
                }
            }
            return bestScore
        }
    }
    
    func makeWinningMove(player: String) -> Bool {
        for row in 0..<3 {
            for column in 0..<3 {
                if board[row][column].isEmpty {
                    board[row][column] = player
                    if checkWinner(player: player) {
                        return true
                    }
                    board[row][column] = ""
                }
            }
        }
        return false
    }
    
    func blockWinningMove(player: String) -> Bool {
        return makeWinningMove(player: player == "cross" ? "circle" : "cross")
    }
    
    func makeStrategicMove() -> Bool {
        // Prendre le centre si disponible
        if board[1][1].isEmpty {
            makeMove(row: 1, column: 1)
            return true
        }
        
        // Prendre les coins si disponibles
        let corners = [(0, 0), (0, 2), (2, 0), (2, 2)]
        for (row, column) in corners {
            if board[row][column].isEmpty {
                makeMove(row: row, column: column)
                return true
            }
        }
        
        // Prendre les bords si disponibles
        let edges = [(0, 1), (1, 0), (1, 2), (2, 1)]
        for (row, column) in edges {
            if board[row][column].isEmpty {
                makeMove(row: row, column: column)
                return true
            }
        }
        
        return false
    }
    
    func checkWinner(player: String) -> Bool {
        for row in board {
            if row == [player, player, player] {
                return true
            }
        }
        
        for columnIndex in 0..<3 {
            var column = [String]()
            for rowIndex in 0..<3 {
                column.append(board[rowIndex][columnIndex])
            }
            if column == [player, player, player] {
                return true
            }
        }
        
        let diagonal1 = [board[0][0], board[1][1], board[2][2]]
        let diagonal2 = [board[0][2], board[1][1], board[2][0]]
        
        if diagonal1 == [player, player, player] || diagonal2 == [player, player, player] {
            return true
        }
        
        return false
    }
    
    func resetGame() {
        board = Array(repeating: Array(repeating: "", count: 3), count: 3)
           currentPlayer = "cross"
           winner = ""
           winnerName = ""
           playSound(name: "riseup")
    }
    
    func endGame() {
        board = Array(repeating: Array(repeating: "", count: 3), count: 3)
        player1Score = 0
        player1Score = 0
        botScore = 0
        numberOfGame = 0
        playSound(name: "riseup")
    }
    
    func loadSound(name: String) {
        guard let soundURL = Bundle.main.url(forResource: name, withExtension: "mp3") else {
            fatalError("Sound file not found")
        }
        
        do {
            self.player = try AVAudioPlayer(contentsOf: soundURL)
            player?.prepareToPlay()
        } catch {
            print("Error loading sound: \(error.localizedDescription)")
        }
    }
    
    func playSound(name: String) {
        loadSound(name: name)
        player?.play()
    }
}

#Preview {
        ContentView()
}
