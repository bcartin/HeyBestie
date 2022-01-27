//
//  SettingsController.swift
//  HeyBestie
//
//  Created by Bernie Cartin on 9/27/21.
//

import UIKit

class SettingsController: UIViewController {
    
    //MARK: - Properties
    
    let backgroundView = UIImageView(image: UIImage(named: "background"), contentMode: .scaleAspectFill, size: nil, cornerRadius: nil)
    
    let backButton = UIButton(image: UIImage(systemName: "xmark.circle")!, tintColor: .white, size: .init(width: 32, height: 32), target: self, action: #selector(handleBackTapped))
    
    let titleLabel = UILabel(text: "SETTINGS", font: UIFont().Poppins(type: .SemiBold, size: 22), textColor: .black, textAlignment: .center, numberOfLines: 1)
    
    let waterRemindersLabel = UILabel(text: "Daily Drink Water Reminders", font: UIFont().Poppins(type: .Regular, size: 15), textColor: .white)
    let waterRemindersSwitch: UISwitch = {
        let sw = UISwitch(backgroundColor: .clear)
        sw.addTarget(self, action: #selector(handleSwitchChanged(_:)), for: .valueChanged)
        sw.tintColor = UIColor(named: "DarkPink")
        sw.onTintColor = UIColor(named: "DarkPink")
        return sw
    }()
    
    let meditationRemindersLabel = UILabel(text: "Daily Meditation Reminders", font: UIFont().Poppins(type: .Regular, size: 15), textColor: .white)
    let meditationRemindersSwitch: UISwitch = {
        let sw = UISwitch(backgroundColor: .clear)
        sw.addTarget(self, action: #selector(handleSwitchChanged(_:)), for: .valueChanged)
        sw.tintColor = UIColor(named: "DarkPink")
        sw.onTintColor = UIColor(named: "DarkPink")
        return sw
    }()
    
    let skincareRemindersLabel = UILabel(text: "Daily Skincare Routine Reminders", font: UIFont().Poppins(type: .Regular, size: 15), textColor: .white)
    let skincareReminderstSwitch: UISwitch = {
        let sw = UISwitch(backgroundColor: .clear)
        sw.addTarget(self, action: #selector(handleSwitchChanged(_:)), for: .valueChanged)
        sw.tintColor = UIColor(named: "DarkPink")
        sw.onTintColor = UIColor(named: "DarkPink")
        return sw
    }()
    
    let notificationsStack = UIStackView()
    
    
    //MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupDelegates()
        loadValues()
    }

    
    fileprivate func setupUI() {
        navigationController?.isNavigationBarHidden = true
        
        view.backgroundColor = .white
        view.addSubview(backgroundView)
        backgroundView.fillSuperview()
        let safeArea = view.safeAreaLayoutGuide
        
        view.addSubview(backButton)
        backButton.anchor(top: safeArea.topAnchor, leading: safeArea.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 12, left: 24, bottom: 0, right: 0))
        
        view.addSubview(titleLabel)
        titleLabel.centerHorizontaly(offset: 0)
        titleLabel.anchorTop(anchor: safeArea.topAnchor, paddingTop: 12)
        
        notificationsStack.axis = .vertical
        notificationsStack.spacing = 24
        
        let waterStack = UIStackView(arrangedSubviews: [waterRemindersLabel, waterRemindersSwitch])
        waterStack.alignment = .center
        notificationsStack.addArrangedSubview(waterStack)
        
        let meditationStack = UIStackView(arrangedSubviews: [meditationRemindersLabel, meditationRemindersSwitch])
        meditationStack.alignment = .center
        notificationsStack.addArrangedSubview(meditationStack)
        
        let skincareStack = UIStackView(arrangedSubviews: [skincareRemindersLabel, skincareReminderstSwitch])
        skincareStack.alignment = .center
        notificationsStack.addArrangedSubview(skincareStack)
        
        view.addSubview(notificationsStack)
        notificationsStack.anchor(top: titleLabel.bottomAnchor, leading: safeArea.leadingAnchor, bottom: nil, trailing: safeArea.trailingAnchor, padding: .init(top: 48, left: 24, bottom: 0, right: 24))
    }
    
    fileprivate func setupDelegates(){
        
    }
    
    //MARK: - Handlers
    
    @objc
    private func handleBackTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc
    private func handleSwitchChanged(_ sender: UISwitch) {
//        if doneButton.alpha == 0 {
//            doneButton.fadeTo(alphaValue: 1, withDuration: 0.3)
//        }
//        if sender == notificationsSwitch {
//            notificationsStack.isHidden = !sender.isOn
//            requestAcceptedSwitch.isOn = sender.isOn
//            followSwitch.isOn = sender.isOn
//            requestSwitch.isOn = sender.isOn
//            inviteSwitch.isOn = sender.isOn
//            alertsSwitch.isOn = sender.isOn
//            directMessageSwitch.isOn = sender.isOn
//            eventRsvpSwitch.isOn = sender.isOn
//            eventCommentSwitch.isOn = sender.isOn
//        }
        if sender == waterRemindersSwitch {
            Session.shared.user?.waterReminder = sender.isOn
            if sender.isOn {
                NotificationsManager.shared.createWaterNotificationRequest()
            }
            else {
                NotificationsManager.shared.deleteNotificationRequest(identifiers: [C_WATER])
            }
        }
        else if sender == skincareReminderstSwitch {
            Session.shared.user?.skincareReminder = sender.isOn
            if sender.isOn {
                NotificationsManager.shared.createSkincareNotificationRequest()
            }
            else {
                NotificationsManager.shared.deleteNotificationRequest(identifiers: [C_SKINCARE])
            }
        }
        else if sender == meditationRemindersSwitch {
            Session.shared.user?.meditationReminder = sender.isOn
            if sender.isOn {
                NotificationsManager.shared.createMeditationNotificationRequest()
            }
            else {
                NotificationsManager.shared.deleteNotificationRequest(identifiers: [C_MEDITATION])
            }
        }
        UserManager().saveUserData(user: Session.shared.user)
    }
    
    private func loadValues() {
        if let user = Session.shared.user {
            waterRemindersSwitch.setOn(user.waterReminder ?? false, animated: true)
            meditationRemindersSwitch.setOn(user.meditationReminder ?? false, animated: true)
            skincareReminderstSwitch.setOn(user.skincareReminder ?? false, animated: true)
        }
    }
}


