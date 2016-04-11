# node-mac-notifier
Create native OS X notifications from Node.js.

## Installation
`npm install`

## Example Usage
This module tries to behave like an HTML5 [Notification](https://developer.mozilla.org/en-US/docs/Web/API/Notification/Notification).
```js
Notification = require('../../node_modules/node-mac-notifier');
noti = new Notification('Hello from OS X', {body: 'It Works!'});
```

## Run Tests
`npm test`