//
//  SPGGameKitManager.swift
//  Space Gravity
//
//  Created by John Champion on 4/3/20.
//  Copyright © 2020 John Champion. All rights reserved.
//

import GameKit

class SPGGameKitManager: NSObject, GKGameCenterControllerDelegate {
    
    /*
     We're going to try to authenticate with Game Center as soon as possible.
     In the mean time, we're going to check the local filesystem for save data.
     Once we authenticate, we're going to check with Game Center for save data.
     If we find it, we'll replace the current game data with that from Game Center.
     
     There are two main functions that load and save the game data.  These are handled automatically, and need not be called unless you know what you're doing.
     loadSavedGame() loads the game data from wherever it can find it.
     saveGame() saves the current game data to whevever it needs to go.
     
     There will be more functionality to come that further utilizes Game Center features, such as leaderboards, achievements, and challenges.
     */
    
    /// Singleton object used to access save data and Game Center features.
    static let shared = SPGGameKitManager()
    
    /// Dictionary variable containing all of the save data.
    var gameData: [String: Any] = ["ClassicHighScore": 0,
                                   "ClassicTimesPlayed": 0]
    
    /// The view controller that displays data from game center.  It's being initialized immediately so there is no wait time upon requesting the view.
    let gameCenterViewController = GKGameCenterViewController()
    
    // MARK: -
    
    /**
     Properly instanciates this manager.
     */
    override init() {
        super.init()
        
        self.loadSavedGame()
        
        // Setting up the Game Center View now so there is no loading time.
        self.gameCenterViewController.gameCenterDelegate = self
        self.gameCenterViewController.viewState = .leaderboards
        self.gameCenterViewController.leaderboardTimeScope = .allTime
        self.gameCenterViewController.leaderboardIdentifier = "classicModeTopScores"
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerAuthenticated), name: NSNotification.Name.GKPlayerAuthenticationDidChangeNotificationName, object: nil)
    }
    
    /**
     Only called when the player becomes authenticated.
     */
    @objc private func playerAuthenticated() {
        self.loadSavedGame()
    }
    
    /**
     Returns the path to the game data file.  For use if iCloud and Game Center are not being used.
     */
    private func getLocalFilePath() -> String? {
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        
        if var pathURL = URL(string: documentDirectory[0]) {
            pathURL.appendPathComponent("Game1")
            
            return pathURL.absoluteString
        }
        
        return nil
    }
    
    /**
     Authenticates the player with Game Center.  Presents a view controller if the player is not authenticated.
     - parameter scene: The scene in which the authentication interface should be presented.
     */
    func authenticateLocalPlayer(inViewController vc: UIViewController) {
        GKLocalPlayer.local.authenticateHandler = {(viewController, error) -> Void in
            if viewController != nil {
                vc.show(viewController!, sender: self)
            }
        }
    }
    
    /**
     Loads all of the save data into the gameData dictionary variable where it can be easily accessed.
     */
    func loadSavedGame() {
        if GKLocalPlayer.local.isAuthenticated {
            // Try to load game data from Game Center.
            
            GKLocalPlayer.local.fetchSavedGames { (gameSaves, err) in
                print("\(String(describing: gameSaves))")
                if gameSaves != nil && gameSaves!.count > 0 {
                    let savedGame = gameSaves?.first
                    
                    // Load data, then convert to JSON, then to Foundation dictionary
                    savedGame?.loadData(completionHandler: { (data, err) in
                        let savedGameJSON = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]
                        
                        self.gameData["ClassicHighScore"] = savedGameJSON?["ClassicHighScore"] ?? 0
                        self.gameData["ClassicTimesPlayed"] = savedGameJSON?["ClassicTimesPlayed"] ?? 0
                        
                        NotificationCenter.default.post(name: Notification.Name("saveDataLoaded"), object: nil)
                        
                        print("Loaded save data from iCloud")
                        
                    })
                } else {
                    // Save data should be blank
                    NotificationCenter.default.post(name: Notification.Name("saveDataLoaded"), object: nil)
                }
            }
        } else {
            // Try to load game data from the local filesystem.
            
            let gameData = NSData(contentsOfFile: self.getLocalFilePath()!)
            
            // Convert data to JSON, then to Foundation dictionary
            if gameData != nil {
                let jsonGameData = try? JSONSerialization.jsonObject(with: gameData! as Data, options: .allowFragments) as? [String: Any]
                self.gameData["ClassicHighScore"] = jsonGameData?["ClassicHighScore"] ?? 0
                self.gameData["ClassicTimesPlayed"] = jsonGameData?["ClassicTimesPlayed"] ?? 0
                
                NotificationCenter.default.post(name: Notification.Name("saveDataLoaded"), object: nil)
                
                print("Loaded save data from device")
            } else {
                print("No save data on device to read")
            }
        }
    }
    
    // MARK: -
    
    func showGameCenterViewController(inScene scene: SKScene) {
        scene.view?.window?.rootViewController?.show(self.gameCenterViewController, sender: self)
    }
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
    // MARK: -
    
    /**
     Saves the current game data to its appropriate place.
     - parameter saveLocal: If this is true, the save data will default to saving locally instead of trying an iCloud save first.
     */
    func saveGame(saveLocal: Bool) {
        if GKLocalPlayer.local.isAuthenticated && !saveLocal {
            // Save to iCloud with Game Center
            
            let data = try! JSONSerialization.data(withJSONObject: self.gameData, options: .prettyPrinted)
            
            GKLocalPlayer.local.saveGameData(data, withName: "Game1") { (savedGame, err) in
                if err != nil {
                    print("Error saving game with Game Center: \(String(describing: err))")
                    self.saveGame(saveLocal: true)
                } else {
                    print("Saved to iCloud")
                }
            }
        } else {
            // Save to local drive
            
            let nsdata: NSData = try! JSONSerialization.data(withJSONObject: self.gameData, options: .prettyPrinted) as NSData
            
            do {
                try nsdata.write(toFile: self.getLocalFilePath()!, options: .atomic)
                print("Saved to Drive")
            } catch  {
                print("Save to Drive Failed")
            }
            
        }
    }
    
    /**
     Sets the all time high score for Classic Mode.
     - parameter score: The high score to be saved.
     */
    func saveClassicModeHighScore(score: Int) {
        if self.gameData["ClassicHighScore"] as! Int > score { return }
        
        self.gameData["ClassicHighScore"] = score
        self.uploadClassicModeHighScore(score: score)
    }
    
    /**
     Sends a score to the Game Center leaderboard for Classic Mode Top Scores.
     - parameter score: The score to be submitted.
     */
    func uploadClassicModeHighScore(score: Int) {
        let scoreToReport = GKScore(leaderboardIdentifier: "classicModeTopScores")
        scoreToReport.value = Int64(score)
        
        GKScore.report([scoreToReport]) { (err) in
            if err != nil {
                print("Could not upload score")
            }
        }
    }
    
    /**
     Increments the times played count by one.
     */
    func incrementTimesPlayed() {
        self.gameData["ClassicTimesPlayed"] = self.gameData["ClassicTimesPlayed"] as! Int + 1
    }
}
