# Snapgram
![Snapgram](https://github.com/19193-IbrohimHusain/BootcampSwiftPhincon/blob/main/Akademik/Snapgram/Application%20Screen.png)

An Instagram-like Clone. Built with Swift & UIKit

## Table of Contents
- [Tech Stack](#tech-stack)
- [Features](#features)
- [Installation](#installation)
  - [CocoaPods](#cocoapods)
- [Folder Structure](#folder-structure)

## Tech Stack

![Tech Stack](https://github.com/19193-IbrohimHusain/BootcampSwiftPhincon/blob/main/Akademik/Snapgram/Tech%20Stack.png)

## Features

- Explore your interests and post what's going on, from your daily moments to life's highlights

- See what people around you are up to and into.

- Browse and discover various quality products in Shop.

## Installation

Follow these steps to install and set up the project.

### CocoaPods

This project relies on various third-party libraries for enhanced functionality. Ensure you have CocoaPods installed, then run the following command:

```bash
pod install
```

This will install the required dependencies specified in the `Podfile`.

## Folder Structure

This project's folder structure is designed for modularity and separation of concerns, enhancing maintainability and organization.

### App

- **AppDelegate**: Manages the application's lifecycle events.
  
- **SceneDelegate**: Handles the setup of the app's user interface upon launching.

### Resource

- **Assets**: Stores general assets used in the application.

- **CoreData**: Stores core data entities and configurations.

### Common

- **Extensions**: Contains Swift extensions for extending functionality of built-in classes.

- **Network**: Contains APIManager class, models and params related to network request.

- **Components**: Houses reusable UI components used across multiple modules.

- **Utils**: Includes files for storing constants, base class and helper used throughout the app.

### Module

- **TabBar**: Contains files specific to the tab bar module.

- **SplashScreen**: Contains files specific to the splash screen module.

- **Authentication**: Contains files specific to the authentication module.

- **Story**: Contains files specific to the story module.

- **Map**: Includes files related to the map module.

- **Store**: Holds files for the store module.

- **Profile**: Contains files specific to the profile module.

### Info.plist

- Stores configuration settings and metadata for the app.

---
