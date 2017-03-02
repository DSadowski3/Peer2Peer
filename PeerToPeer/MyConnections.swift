//
//  ViewController.swift
//  PeerToPeer
//
//  Created by Dominik Sadowski on 3/1/17.
//  Copyright © 2017 Dominik Sadowski. All rights reserved.
//

import UIKit
import MultipeerConnectivity


class MyConnections: UICollectionViewController, UICollectionViewDelegateFlowLayout, MCSessionDelegate, MCBrowserViewControllerDelegate, MCAdvertiserAssistantDelegate {
    
    var peerId: MCPeerID!
    var mcSession: MCSession!
    var mcAdAssistant: MCAdvertiserAssistant!
    //var mcAdNearByAssistant: MCNearbyServiceAdvertiser
    //var mcBrowser: MCNearbyServiceBrowser!
    var browserVC: MCBrowserViewController!
    
    var foundDevices = [MCPeerID]()
    //var invitaionHandler: ((Bool, MCSession?)->Void)
    
    let cellId = "cellId"
    let serviceType = "doms-testsession10"
    
    let conncetButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Connect", for: .normal)
        button.addTarget(self, action: #selector(showConnectionPrompt), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let disconnectButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Disconnect", for: .normal)
        button.addTarget(self, action: #selector(stopConnection), for: .touchUpInside )
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let connectedLabel: UILabel = {
        let label = UILabel()
        label.text = "Connected with:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let makeVisibleLabel: UILabel = {
        let label = UILabel()
        label.text = "Allow other to see you?"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let visibleSwitch: UISwitch = {
        let sw = UISwitch()
        sw.isOn = true
        sw.translatesAutoresizingMaskIntoConstraints = false
        return sw
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Peer2Peer"
        collectionView?.backgroundColor = .white
        collectionView?.alwaysBounceVertical = true

        
        collectionView?.register(ConnectionCell.self, forCellWithReuseIdentifier: cellId)
        
        peerId = MCPeerID(displayName: UIDevice.current.name)
        mcSession = MCSession(peer: peerId, securityIdentity: nil, encryptionPreference: .required)
        mcSession.delegate = self
        
        
//        mcBrowser = MCNearbyServiceBrowser(peer: peerId, serviceType: serviceType)
//        //mcBrowser.delegate = self
//        
//        mcAdNearByAssistant = MCNearbyServiceAdvertiser(peer: peerId, discoveryInfo: nil, serviceType: serviceType)
//        //mcAdNearByAssistant.delegate = self
//        mcAdNearByAssistant.startAdvertisingPeer()
//        
//        browserVC = MCBrowserViewController(browser: mcBrowser, session: mcSession)
//        browserVC.delegate = self
//        self.present(browserVC, animated: true) { 
//            self.mcBrowser.stopBrowsingForPeers()
//        }
        
        
        setupConncentionComponents()
        
    }
    
    func showConnectionPrompt() {
        let alert = UIAlertController(title: "Connect To Others", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Host a session", style: .default, handler: startHosting))
        alert.addAction(UIAlertAction(title: "Join a session", style: .default, handler: joinSession))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func stopConnection() {
        
    }
    
    func setupConncentionComponents() {
        
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(containerView)
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 60).isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 74).isActive = true
        
        containerView.addSubview(visibleSwitch)
        visibleSwitch.widthAnchor.constraint(equalToConstant: 50).isActive = true
        visibleSwitch.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8).isActive = true
        visibleSwitch.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -8).isActive = true
        visibleSwitch.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        containerView.addSubview(makeVisibleLabel)
        makeVisibleLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
        makeVisibleLabel.rightAnchor.constraint(equalTo: visibleSwitch.leftAnchor, constant: 8).isActive = true
        makeVisibleLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        makeVisibleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8).isActive = true
        
        containerView.addSubview(conncetButton)
        conncetButton.topAnchor.constraint(equalTo: makeVisibleLabel.bottomAnchor, constant: 8).isActive = true
        conncetButton.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
        conncetButton.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 1/2).isActive = true
        conncetButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        containerView.addSubview(disconnectButton)
        disconnectButton.topAnchor.constraint(equalTo: makeVisibleLabel.bottomAnchor, constant: 8).isActive = true
        disconnectButton.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -8).isActive = true
        disconnectButton.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 1/2).isActive = true
        disconnectButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        containerView.addSubview(connectedLabel)
        connectedLabel.topAnchor.constraint(equalTo: conncetButton.bottomAnchor, constant: 8).isActive = true
        connectedLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
        connectedLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -8).isActive = true
        connectedLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        
    }

    func startHosting(action: UIAlertAction) {
        mcAdAssistant = MCAdvertiserAssistant(serviceType: serviceType, discoveryInfo: nil, session: mcSession)
        mcAdAssistant.start()
        
    }
    
    func joinSession(action: UIAlertAction) {
        
        let mcBrowser = MCBrowserViewController(serviceType: serviceType, session: mcSession)
        mcBrowser.delegate = self
        present(mcBrowser, animated: true, completion: nil)
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didReceiveCertificate certificate: [Any]?, fromPeer peerID: MCPeerID, certificateHandler: @escaping (Bool) -> Void) {

    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL, withError error: Error?) {
        
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case MCSessionState.connected:
            print("Connected: \(peerId.displayName)")
        case MCSessionState.connecting:
            print("Connecting to: \(mcSession.description)")
        case MCSessionState.notConnected:
            print("Not Connected: \(mcSession.description)")
        
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        
    }
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        
//        mcBrowser.invitePeer(peerId, to: mcSession, withContext: nil, timeout: 10)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {

    }
    
    
    func advertiserAssistantWillPresentInvitation(_ advertiserAssistant: MCAdvertiserAssistant) {
        
    }
    
    func advertiserAssistantDidDismissInvitation(_ advertiserAssistant: MCAdvertiserAssistant) {
    
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
    
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        
        invitationHandler(false, nil)
        
        let session = MCSession(peer: peerId, securityIdentity: nil, encryptionPreference: .none)
        session.delegate = self
        
        let ac = UIAlertController(title: "Received Invitation from \(peerId.displayName)", message: nil, preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            invitationHandler(false, nil)
        }
        
        let accept = UIAlertAction(title: "Accept", style: .default) { _ in
            invitationHandler(true, session)
        }
        
        ac.addAction(cancel)
        ac.addAction(accept)
        
        self.present(ac, animated: true, completion: nil)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ConnectionCell
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 91)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 50)
    }


}

