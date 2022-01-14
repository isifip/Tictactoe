//
//  ContentView.swift
//  Tictactoe
//
//  Created by Irakli Sokhaneishvili on 14.01.22.
//

import SwiftUI

struct ContentView: View {
    
    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    @State private var moves: [Move?] = Array(repeating: nil, count: 9)
    @State private var isGameBoardDisabled = false
    @State private var alertItem: AlertItem?
    @State private var showingAlert = false
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                Spacer()
                LazyVGrid(columns: columns, spacing: 2) {
                    ForEach(0..<9) { item in
                        ZStack {
                            Circle()
                                .foregroundColor(.purple).opacity(0.7)
                                .frame(width: geo.size.width / 3 - 10, height: geo.size.width / 3 - 10)
                            Image(systemName: moves[item]?.idicator ?? "")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.white)
                        }
                        .onTapGesture {
                            if isSquareOccupied(in: moves, forIndex: item) { return }
                            moves[item] = Move(player: .human, boardIndex: item)
                            isGameBoardDisabled = true
                            // check for win condition or draw
                            if checkWinCondition(for: .human, in: moves) {
                                alertItem = AlertContext.humanWin
                                showingAlert = true
                                return
                            }
                            if checkForDraw(in: moves) {
                                alertItem = AlertContext.draw
                                showingAlert = true
                                return
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                let computerPosition = determineComputerMovePosition(in: moves)
                                moves[computerPosition] = Move(player: .computer, boardIndex: computerPosition)
                                isGameBoardDisabled = false
                                
                                if checkWinCondition(for: .computer, in: moves) {
                                    alertItem = AlertContext.computerWin
                                    showingAlert = true
                                    return
                                }
                                if checkForDraw(in: moves) {
                                    alertItem = AlertContext.draw
                                    showingAlert = true
                                    return
                                }
                            }
                            
                        }
                    }
                }
                
                Spacer()
            }
            .disabled(isGameBoardDisabled)
            .padding()
            .alert(alertItem?.title ?? Text(""), isPresented: $showingAlert) {
                Button(role: .cancel) {
                    
                } label: {
                    alertItem?.buuttonTitle ?? Text("")
                }
                Button {
                    resetGame()
                } label: {
                    Text("Reset game")
                }
            } message: {
                alertItem?.message ?? Text("")
            }
            
        }
    }
    func isSquareOccupied(in moves: [Move?], forIndex index: Int) -> Bool {
        return moves.contains(where: { $0?.boardIndex == index})
    }
    func determineComputerMovePosition(in moves: [Move?]) -> Int {
        var movePosition = Int.random(in: 0..<9)
        while isSquareOccupied(in: moves, forIndex: movePosition) {
            movePosition = Int.random(in: 0..<9)
        }
        return movePosition
    }
    
    func checkWinCondition(for player: Player, in moves: [Move?]) -> Bool {
        let winPatterns: Set<Set<Int>> = [
            [0, 1, 2],
            [3, 4, 5],
            [6, 7, 8],
            [0, 3, 6],
            [1, 4, 7],
            [2, 5, 8],
            [0, 4, 8],
            [2, 4, 6]
        ]
        let playerMoves = moves.compactMap { $0 }.filter { $0.player == player }
        let playerPositions = Set(playerMoves.map { $0.boardIndex })
        
        for pattern in winPatterns where pattern.isSubset(of: playerPositions){
           return true
        }
        return false
    }
    
    func checkForDraw(in moves: [Move?]) -> Bool {
        return moves.compactMap { $0 }.count == 9
    }
    
    func resetGame() {
        moves = Array(repeating: nil, count: 9)
        isGameBoardDisabled = false
    }
}

enum Player {
    case human, computer
}

struct Move {
    let player: Player
    let boardIndex: Int
    
    var idicator: String {
        return player == .human ? "xmark" : "circle"
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
