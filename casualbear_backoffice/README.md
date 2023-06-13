## ✨ Features

✅ State management using [Bloc Pattern]
✅ Authentication using Bedrock API  
✅ Unit testing, API Mocks using [Mockito](https://pub.dev/packages/mockito)  
✅ Widget tests  
✅ Support for 🌓 Dark/Light mode  
✅ CI via Github Actions
✅ Tool to generate data transfer objects serialization/deserialization boiler plate code using [json_serializable](https://pub.dev/packages/json_serializable)

## 🏁 Getting Started

### 📚 Prerequisites

1. Install Flutter SDK [here](https://flutter.dev/docs/get-started/install).
2. Run `flutter doctor` in terminal and install all missing dependencies required by Flutter to run.

### 🛠 Setup

```bash
git clone git@github.com:bedrockio/bedrock-flutter.git <name_of_project>
```

_Note_: Project names should use underscores between words because flutter tool doesn't allow
dashes/hyphens to be used in project name.

This project is a starting point for a Flutter application that follows the
[simple app state management
tutorial](https://flutter.dev/docs/development/data-and-backend/state-mgmt/simple).

For help getting started with Flutter, view our
[online documentation](), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

When adding new data transfer objects (check [shop_model.dart](https://github.com/bedrockio/bedrock-flutter/blob/authentication/lib/shops/shop_model.dart)) generate the boiler plate code by running

- `flutter pub run build_runner build`
- (In case there's conflicts run) `flutter packages pub run build_runner build --delete-conflicting-outputs`


- Install dependencies `flutter pub get`

## ℹ️ Useful Links

- [Flutter Official Docs](https://flutter.dev/docs)
