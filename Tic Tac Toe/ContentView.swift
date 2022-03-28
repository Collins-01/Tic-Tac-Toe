//
//  ContentView.swift
//  Tic Tac Toe
//
//  Created by Oriakhi Collins on 3/28/22.
//

import SwiftUI

struct ContentView: View {
    let columns:[GridItem]=[GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible())]
    @State private var move:[Move?]=Array(repeating: nil , count: 9)
    @State private var isGamBoardDisabled=false
    var body: some View {
        GeometryReader{
            geometry in  VStack {
                Spacer()
                LazyVGrid(columns: columns){
                    ForEach(0..<9){ i in
                        ZStack{
                            Circle().frame(
                                width: 80,
                                height: 80
                            ).foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                            
                            Image(systemName: move[i]?.indicator ?? "")
                                .resizable()
                                .foregroundColor(.white)
                                .frame(width:30, height: 30).foregroundColor(.white)
                            
                        }
                        .onTapGesture{
                            
                            if isCellOcuppied(in: move, forIndex: i){
                                return
                                //                                Do mnot execute any code
                            }
                            move[i]=Move(player:  .human ,   cellIndex: i)
                            isGamBoardDisabled = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                let computerPosition = determineComputerMovePosition(in: move)
                                move[computerPosition] = Move(player: .computer, cellIndex: computerPosition)
                                isGamBoardDisabled = false
                                
                            }
                            
                        }
                    }
                }
                Spacer()
            }
            .disabled(isGamBoardDisabled)
        }
    }
    
    func isCellOcuppied(in moves:[Move?], forIndex index:Int) ->  Bool {
        return moves.contains(where: {$0?.cellIndex == index})
    }
    func determineComputerMovePosition(in moves:[Move?]) -> Int {
        var newMovePositon = Int.random(in: 0..<9)
        while isCellOcuppied(in: moves, forIndex: newMovePositon) {
            newMovePositon = Int.random(in: 0..<9)
            
        }
        return newMovePositon
    }
    
    func checkWinCondition(in player:Player , in moves: [Move?]) -> Bool {
        return false
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
//sparkles



enum Player {
    case human, computer
}

struct Move {
    let player:Player
    let cellIndex:Int
    
    var indicator: String{
        return player == .human ? "moon" : "sparkles"
    }
}
