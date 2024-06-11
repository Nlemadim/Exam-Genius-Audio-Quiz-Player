//
//  ConnectionMonitor.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 6/11/24.
//

import Foundation
import Network

class ConnectionMonitor: ObservableObject {
    private var monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    
    @Published var isConnected: Bool = true
    
    init() {
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                self.isConnected = path.status == .satisfied
            }
        }
        monitor.start(queue: queue)
    }
    
    init(forTesting isConnected: Bool) {
        self.isConnected = isConnected
        self.monitor = NWPathMonitor()
        // Do not start the real monitor in testing initializer
    }
    
    func simulateDisconnection() {
        self.isConnected = false
    }
    
    func simulateReconnection() {
        self.isConnected = true
    }
}
