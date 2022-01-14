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
    @State private var isHumansTurn = true
    
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
                            moves[item] = Move(player: isHumansTurn ? .human : .computer, boardIndex: item)
                            isHumansTurn.toggle()
                        }
                    }
                }
                .padding()
                Spacer()
            }
        }
    }
    func isSquareOccupied(in moves: [Move?], forIndex index: Int) -> Bool {
        return moves.contains(where: { $0?.boardIndex == index})
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
