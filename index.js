"use strict";

const uuid = require('node-uuid');
const EventTarget = require('event-target-shim');
const MacNotification = require('bindings')('Notification').MacNotification

module.exports = class Notification extends EventTarget {

  constructor(title, options) {
    super();
    
    if (!title) throw new Error('Title is required');
    
    Object.assign(this, {title}, options);
    
    options = options || {};
    options.id = options.id || uuid.v4();
    options.body = options.body || '';
    options.canReply = !!options.canReply;

    let activated = (isReply, response) => {
      if (isReply) {
        this.dispatchEvent({type: 'reply', response});
      } else {
        this.dispatchEvent({type: 'click'});
      }
    };

    let args = Object.assign({title, activated}, options);
    this.notification = new MacNotification(args);
  }

  close() {
    this.notification.close();
    this.notification = null;
    
    this.dispatchEvent({type: 'close'});
  }
};