//
//  ViewController.swift
//  iOS Example
//
//  Created by Watanabe Toshinori on 12/21/18.
//  Copyright © 2018 Watanabe Toshinori. All rights reserved.
//

import UIKit
import TagengoKit

class ViewController: UIViewController, LanguagesViewControllerDelegate {
    
    @IBOutlet weak var recordButton: UIButton!
    
    @IBOutlet weak var fromLanguageButton: UIButton!
    
    @IBOutlet weak var toLanguageButton: UIButton!
    
    @IBOutlet weak var originalTextView: UITextView!
    
    @IBOutlet weak var translatedTextView: UITextView!

    @IBOutlet weak var reTranslatedTextView: UITextView!

    let recorder = Recorder()
    
    let player = Player()

    let id = "ENTER_SANDBOX_ID_HERE"
    
    let secret = "ENTER_SANDBOX_SECRET_HERE"

    var accessToken = ""
    
    var from: Language = .ja {
        didSet {
            fromLanguageButton.setTitle(from.displayValue, for: .normal)
        }
    }
    
    var to: Language = .en {
        didSet {
            toLanguageButton.setTitle(to.displayValue, for: .normal)
        }
    }
    
    var target: UIButton!

    // MARK: - ViewController lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        getAccessToken()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.destination, segue.identifier) {
        case (let navigationController as UINavigationController, "PresentLanguagesViewController"?):
            guard let viewController = navigationController.topViewController as? LanguagesViewController else {
                return
            }
            viewController.delegate = self
            viewController.selectedLanguage = (target == fromLanguageButton) ? from : to

        default:
            break
        }
    }
    
    // MARK: - Actions
    
    @IBAction func recordTapped(_ sender: Any) {
        if recorder.isRecording == false {
            do {
                try recorder.startRecording()
                recordButton.setImage(UIImage(named: "Stop"), for: .normal)
            } catch {
                alert(error)
            }

        } else {
            recorder.stopRecording()
            recordButton.setImage(UIImage(named: "Record"), for: .normal)

            recognizeAudio()
        }
    }
    
    @IBAction func languageTapped(_ sender: UIButton) {
        target = sender
        performSegue(withIdentifier: "PresentLanguagesViewController", sender: nil)
    }
    
    // MARK: - Language view controller delegate
    
    func languagesViewController(_ viewController: LanguagesViewController, didSelectLanguage language: Language) {
        if target == fromLanguageButton {
            from = language
        } else {
            to = language
        }
    }
    
    // MARK: - Tagengo API
    
    func getAccessToken() {
        let api = AccessToken(id: id, secret: secret)
        api.getToken { (accessToken, error) in
            if let error = error {
                self.alert(error)
                return
            }
            
            self.accessToken = accessToken!
            
            self.getTicketCount()
        }
    }
    
    func getTicketCount() {
        let api = TicketCounter(accessToken: accessToken)
        api.getCount { (count, error) in
            if let error = error {
                self.alert(error)
                return
            }
            
            print(count)
        }
    }
    
    func recognizeAudio() {
        let language = Recognizer.RecognizeLanguage(rawValue: self.from.rawValue)!
        
        let api = Recognizer(accessToken: self.accessToken)
        api.recognize(audio: recorder.path, language: language, completionHandler: { (result, error) in
            if let error = error {
                self.alert(error)
                return
            }
            
            self.originalTextView.text = result
            
            self.translateText()
        })
    }
    
    func translateText() {
        let text = originalTextView.text ?? ""
        let from = Translator.TranslateLanguage(rawValue: self.from.rawValue)!
        let to = Translator.TranslateLanguage(rawValue: self.to.rawValue)!

        let api = Translator(accessToken: accessToken)
        api.translate(text: text, from: from, to: to) { (translatedText, error) in
            if let error = error {
                self.alert(error)
                return
            }
            
            self.translatedTextView.text = translatedText
            
            self.reTranslateText()
        }
    }
    
    func reTranslateText() {
        let text = translatedTextView.text ?? ""
        let from = Translator.TranslateLanguage(rawValue: self.to.rawValue)!
        let to = Translator.TranslateLanguage(rawValue: self.from.rawValue)!
        
        let api = Translator(accessToken: accessToken)
        api.translate(text: text, from: from, to: to) { (translatedText, error) in
            if let error = error {
                self.alert(error)
                return
            }
            
            self.reTranslatedTextView.text = translatedText
        }
    }
    
    func speechText(_ text: String, language: SpeechSynthesizer.SynthesizeLanguage) {
        let language = SpeechSynthesizer.SynthesizeLanguage(rawValue: language.rawValue)!

        let api = SpeechSynthesizer(accessToken: accessToken)
        api.synthesize(text: text, language: language) { (data, error) in
            if let error = error {
                self.alert(error)
                return
            }
            
            let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let url = documentDirectoryURL.appendingPathComponent("export.wav")
            
            try! data!.write(to: url)
            
            do {
                let wav = self.player.appendWavHeader(to: data!)
                try self.player.play(audio: wav)

            } catch {
                self.alert(error)
            }
        }
    }
    
    // MARK: - Alert
    
    func alert(_ error: Error) {
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }

}
