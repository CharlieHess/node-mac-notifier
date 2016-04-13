# node-mac-notifier
A native node module that lets you create OS X notifications from Node.js, without spawning a separate process.
This is useful for desktop applications built with [Electron](http://electron.atom.io/) (or something similar), as it adheres to the HTML5 [`Notification` API](https://developer.mozilla.org/en-US/docs/Web/API/Notification/Notification). Unlike the Electron [notification](https://github.com/electron/electron/blob/master/docs/tutorial/desktop-environment-integration.md#notifications-windows-linux-os-x) it also supports replies!

## Installation
`npm install`

## Usage
Ensure that this module is called from a renderer process; it will have no effect from the main process.
 
```js
Notification = require('node-mac-notifier');
noti = new Notification('Hello from OS X', {body: 'It Works!'});
noti.addEventListener('click', () => console.log('Got a click.'));
```

In addition to the standard `click` event, these notifications also support a (non-standard) `reply` event. To enable the reply button, set `canReply` in the options argument. The user's response is included as a parameter on the event:
```js
noti = new Notification('Wow, replies!', {canReply: true});
noti.addEventListener('reply', (response) => console.log(`User entered: ${response}`));
```

## Run Tests
`npm test`