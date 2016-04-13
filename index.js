"use strict";

const uuid = require('node-uuid');
const EventTarget = require('event-target-shim');
const MacNotification = require('bindings')('Notification').MacNotification

let macNotification;

module.exports = class Notification extends EventTarget {

  constructor(title, options) {
    super();
    
    if (!title) throw new Error('Title is required');
    
    options = options || {};
    options.id = options.id || uuid.v4();
    options.body = options.body || '';
    
    Object.assign(this, {title}, options);
    
    options.canReply = !!options.canReply;

    let activated = (isReply, response) => {
      if (isReply) {
        this.dispatchEvent({type: 'reply', response});
      } else {
        this.dispatchEvent({type: 'click'});
      }
    };

    let args = Object.assign({title, activated}, options);
    macNotification = new MacNotification(args);
  }

  close() {
    macNotification.close();
    macNotification = null;
    
    this.dispatchEvent({type: 'close'});
  }
};