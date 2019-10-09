//
//  ReachabilityWrapper.swift
//  WOAH
//
//  Created by Jerilyn Goncalves on 26/06/2017.
//  Copyright © 2017 Gigigo SL. All rights reserved.
//

import Foundation

public enum NetworkStatus {
    case notReachable
    case reachableViaWiFi
    case reachableViaMobileData
}

public protocol ReachabilityWrapperDelegate: class {
     func reachabilityChanged(with status: NetworkStatus)
}

public protocol ReachabilityInput {
    func isReachable() -> Bool
    func isReachableViaWiFi() -> Bool
}

public class ReachabilityWrapper: ReachabilityInput {
    // MARK: Singleton
    public static let shared = ReachabilityWrapper()
    
    // MARK: Public properties
    public weak var delegate: ReachabilityWrapperDelegate?
    
    // MARK: Private properties
    private let reachability: Reachability?
    private var currentStatus = NetworkStatus.notReachable
    
    // MARK: - Life cycle
    private init() {
        self.reachability = Reachability()
        self.startNotifier()
    }
    
    deinit {
       self.stopNotifier()
    }
    
    // MARK: - Reachability methods
    public func startNotifier() {
        // Listen to reachability changes
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(reachabilityChanged(_:)),
            name: .reachabilityChanged,
            object: reachability
        )
        
        self.currentStatus = self.networkStatus()
        ((try? self.reachability?.startNotifier()) as ()??)
    }
    
    public func stopNotifier() {
        NotificationCenter.default.removeObserver(
            self,
            name: .reachabilityChanged,
            object: reachability
        )
        
        self.reachability?.stopNotifier()
    }
    
    public func isReachable() -> Bool {
        return self.reachability?.connection != Reachability.Connection.none
    }
    
    public func isReachableViaWiFi() -> Bool {
        return self.reachability?.connection == .wifi
    }
        
    // MARK: - Private methods
    private func networkStatus() -> NetworkStatus {
        if let connection = self.reachability?.connection {
            switch connection {
            case .none:
                return .notReachable
            case .cellular:
                return .reachableViaMobileData
            case .wifi:
                return .reachableViaWiFi
            }
        }
        return .notReachable
    }
    
    // MARK: - Reachability Change
    @objc func reachabilityChanged(_ notification: NSNotification) {
        guard let reachability = notification.object as? Reachability else { return }
        if self.networkStatus() != self.currentStatus {
            self.currentStatus = self.networkStatus()
            if reachability.connection != Reachability.Connection.none {
                if reachability.connection == .wifi {
                    self.delegate?.reachabilityChanged(with: .reachableViaWiFi)
                } else {
                    self.delegate?.reachabilityChanged(with: .reachableViaMobileData)
                }
            } else {
                self.delegate?.reachabilityChanged(with: .notReachable)
            }
        }
    }
}
