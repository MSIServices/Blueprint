//
//  Constants.swift
//  Blueprint
//
//  Created by Stephen Muscarella on 7/29/17.
//  Copyright © 2017 Stephen Muscarella. All rights reserved.
//

import Foundation
import UIKit

//Colors
let CHAIN_BLUE_LOADING = UIColor(red: 185.0 / 255.0, green: 196.0 / 255.0, blue: 197.0 / 255.0, alpha: 1.0) //#B9C4C5
let CHAIN_BLUE_BG = UIColor(red: 115.0 / 255.0, green: 137.0 / 255.0, blue: 139.0 / 255.0, alpha: 1.0) //#73898B
let CHAIN_BLUE = UIColor(red: 0, green: 39.0 / 255.0, blue: 43.0 / 255.0, alpha: 1.0) //#00272B
let CHAIN_CREAM = UIColor(red: 255.0 / 255.0, green: 201.0 / 255.0, blue: 81.0 / 255.0, alpha: 1.0) //#FFC951
let CHAIN_GREY = UIColor(red: 91.0 / 255.0, green: 91.0 / 255.0, blue: 91.0 / 255.0, alpha: 1.0) //#5B5B5B
let CHAIN_LIGHT = UIColor(red: 214.0 / 255.0, green: 217.0 / 255.0, blue: 206.0 / 255.0, alpha: 1.0) //#D6D9CE
let CHAIN_RED = UIColor(red: 161.0 / 255.0, green: 94.0 / 255.0, blue: 73.0 / 255.0, alpha: 1.0) //#A15E49
let CHAIN_RED_HIGHLIGHT = UIColor(red: 169.0 / 255.0, green: 108.0 / 255.0, blue: 89.0 / 255.0, alpha: 1.0) //#A96C59
let SPACE_GREY = UIColor(red: 165.0 / 255.0, green: 173.0 / 255.0, blue: 176.0 / 255.0, alpha: 1.0) //#A5ADB0
let SPACE_GREY_HIGHLIGHT = UIColor(red: 191.0 / 255.0, green: 191.0 / 255.0, blue: 191.0 / 255.0, alpha: 1.0) //#BFBFBF
let GOLD = UIColor(red: 245.0 / 250.0, green: 203.0 / 255.0, blue: 50.0 / 255.0, alpha: 1.0) //#F5CB32
let WARNING = UIColor(red: 255.0 / 255.0, green: 197.0 / 255.0, blue: 47.0 / 255.0, alpha: 2.0) //#FFC52F
let ERROR = UIColor(red: 255.0 / 255.0, green: 63.0 / 255.0, blue: 0.0, alpha: 1.0) //#FF3F00
let ERROR_BUTTON = UIColor(red: 209.0 / 255.0, green: 52.0 / 255.0, blue: 0.0, alpha: 1.0)  //#D13400
let ERROR_BUTTON_HIGHLIGHT = UIColor(red: 232.0 / 255.0, green: 58.0 / 255.0, blue: 0.0, alpha: 0.0) //#E83A00

//Fonts
let OPEN_SANS = ["OpenSans-ExtraBoldItalic", "OpenSans-SemiBoldItalic", "OpenSans-ExtraBold", "OpenSans-BoldItalic", "OpenSans-Italic", "OpenSans-SemiBold", "OpenSans-Light", "OpenSans-Regular", "OpenSans-LightItalic", "OpenSans-Bold"]

//Server
let AES_KEY: Array<UInt8> = [159, 125, 16, 203, 153, 34, 59, 223, 109, 170, 224, 224, 159, 168, 57, 31, 79, 192, 182, 130, 0, 119, 56, 245, 47, 224, 171, 199, 59, 58, 16, 243]
let HOME_IP_ADDRESS: String = "192.168.0.7"
let WORK_IP_ADDRESS_ONE: String = "10.1.204.83"
let WORK_IP_ADDRESS_TWO: String = "10.1.228.145"
let WORK_IP_ADDRESS_THREE: String = "169.254.130.194"
let LOCAL_HOST_PORT: Int = 3000
let SERVER_DOMAIN: String = "https://arcane-retreat-99625.herokuapp.com"

//Database
let S3_BUCKET: String = "chain-hosting-mobilehub-1716918461"

//UserDefaults
let USER_ID = "user_id"
let EMAIL = "email"
let USERNAME = "username"
let CURRENT_VC = "current_vc"
let CURRENT_TAB = "current_tab"

//Segues
let LOGIN_VC = "LoginVC"
let SIGN_UP_ONE_VC = "SignUpOneVC"
let SIGN_UP_TWO_VC = "SignUpTwoVC"
let SIGN_UP_THREE_VC = "SignUpThreeVC"
let SIGN_UP_FOUR_VC = "SignUpFourVC"
let HOME_VC = "HomeVC"
let NEW_POST_VC = "NewPostVC"
let TEXT_VC = "TextVC"
let LINK_VC = "LinkVC"
let IMAGE_VC = "ImageVC"
let VIDEO_VC = "VideoVC"
let AUDIO_VC = "AudioVC"
let QUOTE_VC = "QuoteVC"
let RECIPIENT_VC = "RecipientVC"
let MEDIA_VC = "MediaVC"
let MEDIA_LIBRARY_VC = "MediaLibraryVC"

//Reverse Segues
let UNWIND_LOGIN_VC = "unwindToLoginVC"
let UNWIND_SIGN_UP_ONE_VC = "unwindToSignUpOneVC"
let UNWIND_SIGN_UP_TWO_VC = "unwindToSignUpTwoVC"
let UNWIND_SIGN_UP_THREE_VC = "unwindToSignUpThreeVC"
let UNWIND_HOME_VC = "unwindToHomeVC"
let UNWIND_MAIN_VC = "unwindToMainVC"
let UNWIND_NEW_POST_VC = "unwindToNewPostVC"
let UNWIND_TEXT_VC = "unwindToTextVC"
let UNWIND_LINK_VC = "unwindToLinkVC"
let UNWIND_MEDIA_VC = "unwindToMediaVC"
let UNWIND_AUDIO_VC = "unwindToAudioVC"
let UNWIND_QUOTE_VC = "unwindToQuoteVC"

//UI
let NAVIGATION_BAR_HEIGHT: CGFloat = 64.0
let TAB_BAR_HEIGHT: CGFloat = 49.0

//Mobile Devices
let IPHONE_5: CGFloat = 320 //iPhone 5S, iPhone 5C, iPhone SE
let IPHONE_7: CGFloat = 375 //iPhone 6S, iPhone 6
let IPHONE_7_PLUS: CGFloat = 414 //iPhone 6S Plus, iPhone 6 Plus

//Tablet Devices
let IPAD_AIR: CGFloat = 768 //9.7-inch iPad Pro, iPad Air 2, iPad 4, iPad 3
let IPAD_PRO_10_5: CGFloat = 834
let IPAD_PRO_12_9: CGFloat = 1024
