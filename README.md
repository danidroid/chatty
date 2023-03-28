# chatty

A ChatGPT demo using API

## Context

This demo was created to be used in the Flutter Faro event #3 and #4

- [Event #3](https://www.meetup.com/flutter-faro/events/291516827/)
- [Event #4](https://www.meetup.com/flutter-faro/events/292386880/)

### Features

- [x] Base app structure
- [x] Connect Api to use [Completions](https://platform.openai.com/docs/api-reference/completions)
- [x] Connect Api to use [Images](https://platform.openai.com/docs/api-reference/images)
- [x] Connect Api to use [Audio](https://platform.openai.com/docs/api-reference/audio)
- [x] Simple Chat UI
- [ ] Proper error handling
- [ ] Improve and clean Models structure
- [ ] Improve chat UI for text and image prompts
- [ ] Add support to save conversation
- [x] Add Settings to configure the SecretKey
- [ ] Add tests

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## ChatGPT API

- [Docs](https://platform.openai.com/docs/introduction)

## How to use

 1. Create an account and generate a new Secret Key
    1. - [Create a Key](https://platform.openai.com/account/api-keys)
 2. Paste the Key into the '.env' file and set OPEN_AI_API_KEY=<API_KEY>
 3. run: flutter pub run build_runner build
 4. Compile and run it 
