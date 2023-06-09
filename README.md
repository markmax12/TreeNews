# TreeNews

Simple CLI app that fetches data from TreeNews websocket and sends news to Telegram channels/chats using Telegram bot's API.

## Overview

Made for educational purposes only, it is however can be used as helper for news traders.

Uses Swift's Regex, async/await model, websockets and custom codable logic.

## Requirements

Swift 5.7.1 or higher.

macOS 10.15 or higher.

## Getting Bot Token and Chat ID

The app uses Telegram Bot's API so to make everything work you'll need a bot and its token. [Follow this guide to create a bot and get a token.](https://core.telegram.org/bots/features#botfather)

The token looks like this: `110201543:AAHdqTcvCH1vGWJxfSeofSAs0K5PALDsaw`

You will also need a chat ID in the format of `@yourChanelOrChat`

## Manual Installation

Clone the repository:

```
$ git clone https://github.com/markmax12/TreeNews
$ cd TreeNews
```

### Usage

Before using the application, first set environment variables of bot key and chat ID:

```
$ export BOT_KEY=12345678
$ export CHAT_ID=12345678  
```

Build and run the app:

```
$ swift run treenews
```

If connection is successful, tokens and IDs are valid, you will see that you are subscribed to the websocket:
```
subscribed
```

## Running through Xcode

You can use the app with Xcode. It is a preferred method as you wouldn't need to specify tokens and ids every time you run the app.

To clone the app, go to `Source Control` -> `Clone`, enter repository url: 
```
https://github.com/markmax12/TreeNews
```

To include environment variables for build:

1. Select the scheme for application from the toolbar next to the current branch button. If you don't see the scheme, click on the scheme dropdown and choose `Edit Scheme...`.

2. In the scheme settings window, select the `Run` option from the left sidebar.

3. In the main window, select the `Arguments` tab.

4. Under `Environment Variables`, add variables.

5. Enter each argument in the fields. So you would need two fields for bot token and chat ID: `BOT_KEY` and `CHAT_ID`

After passing the arguments, you can run the application.

If connection is successful, tokens and IDs are valid, you will see that you are subscribed to the websocket:
```
subscribed
```
