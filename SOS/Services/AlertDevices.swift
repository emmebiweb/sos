import AVFoundation
import Observation
import UIKit

/// Sirena in loop, continua anche con lo schermo bloccato (UIBackgroundModes: audio).
@Observable
final class SirenPlayer {
    private(set) var isPlaying = false
    @ObservationIgnored private var player: AVAudioPlayer?

    func toggle() { isPlaying ? stop() : play() }

    func play() {
        guard !isPlaying else { return }
        if player == nil, let url = Bundle.main.url(forResource: "siren", withExtension: "mp3") {
            player = try? AVAudioPlayer(contentsOf: url)
            player?.numberOfLoops = -1
            player?.volume = 1
        }
        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
        try? AVAudioSession.sharedInstance().setActive(true)
        player?.play()
        isPlaying = player?.isPlaying ?? false
    }

    func stop() {
        player?.stop()
        player?.currentTime = 0
        isPlaying = false
        try? AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
    }
}

/// Torcia che lampeggia "SOS" in codice Morse (··· ––– ···).
@Observable
final class TorchController {
    private(set) var isActive = false
    @ObservationIgnored private var task: Task<Void, Never>?

    var isAvailable: Bool {
        #if DEBUG
        if ProcessInfo.processInfo.arguments.contains("-demoData") { return true }
        #endif
        return AVCaptureDevice.default(for: .video)?.hasTorch ?? false
    }

    func toggle() { isActive ? stop() : start() }

    func start() {
        guard isAvailable, !isActive else { return }
        isActive = true
        UIApplication.shared.isIdleTimerDisabled = true
        task = Task { @MainActor [weak self] in
            await self?.runPattern()
        }
    }

    func stop() {
        task?.cancel()
        task = nil
        setTorch(false)
        isActive = false
        UIApplication.shared.isIdleTimerDisabled = false
    }

    private func runPattern() async {
        let unit: UInt64 = 180_000_000
        while !Task.isCancelled {
            for symbol in "...---..." {
                setTorch(true)
                try? await Task.sleep(nanoseconds: unit * (symbol == "." ? 1 : 3))
                setTorch(false)
                try? await Task.sleep(nanoseconds: unit)
                if Task.isCancelled { return }
            }
            try? await Task.sleep(nanoseconds: unit * 6)
        }
    }

    private func setTorch(_ on: Bool) {
        guard let device = AVCaptureDevice.default(for: .video), device.hasTorch else { return }
        do {
            try device.lockForConfiguration()
            if on {
                try device.setTorchModeOn(level: AVCaptureDevice.maxAvailableTorchLevel)
            } else {
                device.torchMode = .off
            }
            device.unlockForConfiguration()
        } catch {}
    }
}
