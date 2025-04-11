//
//  SoundTranslationViewModel.swift
//  TrySwiftUI_Translator
//
//  Created by Артём on 11.04.2025.
//

import Foundation
import AVFoundation

class SoundTranslationViewModel: ObservableObject {
    private var syntesizer = AVSpeechSynthesizer()
    
    init() {
        configureAudioSession()
    }
    
    private func configureAudioSession() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playback, mode: .default)
            try audioSession.setActive(true)
        } catch {
            print("Error setting audio session category: \(error.localizedDescription)")
        }
    }
    
    func playSound(text: String) {
        let voices = AVSpeechSynthesisVoice.speechVoices()
        let filteredVoices = voices.filter { $0.language == "en-US"}
        DispatchQueue.global(qos: .userInitiated).async {
            for voice in filteredVoices {
                let utterance = AVSpeechUtterance(string: text)
                utterance.voice = voice
                self.syntesizer.speak(utterance)
                
                Thread.sleep(forTimeInterval: 3.0)
            }
        }
    }
}
