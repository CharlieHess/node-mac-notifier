"use strict";

const EventTarget = require('event-target-shim');
const MacNotification = require('bindings')('Notification').MacNotification

module.exports = class Notification extends EventTarget {

  constructor(title, options) {
    super();
    
    if (!title) throw new Error('Title is required');
    
    options = options || {};
    options.body = options.body || '';
    
    Object.assign(this, {title}, options);
    
    options.canReply = !!options.canReply;

    let activated = (isReply, response) => {
      if (isReply) {
        this.dispatchEvent('reply', {target: this, response});
      } else {
        this.dispatchEvent('click', {target: this});
      }
    };

    let args = Object.assign({title, activated}, options);
    new MacNotification(args);
  }

  close() {
  }
};