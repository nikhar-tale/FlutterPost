# FlutterPost App

FlutterPost is a Flutter-based social media-like application where users can post messages and see real-time updates. It uses Firebase for authentication and Firestore for data storage, following the BLoC architecture for state management.

## Features

- **User Authentication**: Login and signup with email and password using Firebase Authentication.
- **Real-Time Updates**: Displays a list of posts updated in real-time from Firestore.
- **Firestore Integration**: Posts (message and username) are stored in Firestore.
- **State Management**: Built with BLoC architecture for clean and scalable state management.
- **Error Handling**: Implements error handling for authentication and Firestore operations.
- **Clean UI**: Simple and user-friendly interface.

## Project Structure

```plaintext
lib/
├── blocs/               # BLoC files for authentication and posts
├── models/              # Data models (e.g., PostModel)
├── repositories/        # Firebase service interactions
├── screens/             # UI screens (Login, Signup, Posts)
├── widgets/             # Reusable UI components
└── main.dart            # Application entry point
```




**App Build** : https://drive.google.com/file/d/12ShK8sKA4QXmM5PRcsXUaTx9lspYYHTO/view?usp=sharing




## Setup

### Step 1: Clone the Repository
Clone the repository to your local machine:
```bash
git clone https://github.com/nikhar-tale/FlutterPost.git
cd FlutterPost
```
## Optimized App
To build the APK with optimized size, use the following command:

```sh
flutter build apk --split-per-abi
```
This command generates separate APKs for different ABIs (Application Binary Interfaces), resulting in smaller APK sizes. Users download only the APK that matches their device's ABI, reducing download time and saving storage space.
