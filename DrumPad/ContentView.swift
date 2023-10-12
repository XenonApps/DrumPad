//
//  ContentView.swift
//  DrumPad
//
//  Created by Iain Caldwell on 12/10/2023.
//

import SwiftUI
import AudioKit

class DrumClass: ObservableObject {
    let engine = AudioEngine()
    let instrument = AppleSampler()
    
    @Published var playing = false
    
    init() {
        engine.output = instrument
        try? engine.start()
    }
    
    func loadInstrument() {
        do {
            if let fileURL = Bundle.main.url(forResource: "Sounds/drumSimp", withExtension: "exs") {
                try instrument.loadInstrument(url: fileURL)
            } else {
                Log("Could not find file")
            }
        } catch {
            Log("Could not load instrument")
        }
    }
}

struct ContentView: View {
    
    @StateObject var conductor = DrumClass()
    
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(Color.black.opacity(0.5))
            .aspectRatio(contentMode: .fit)
            .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                .onChanged { _ in
                    if !conductor.playing {
                        conductor.instrument.play(noteNumber: MIDINoteNumber(36), velocity: 90, channel: 0)
                    }
                }
                .onEnded { _ in
                    conductor.playing = false
                })
    }
}

#Preview {
    ContentView()
}
