"use strict";

const uuid = require('node-uuid');
const EventTarget = require('event-target-shim');
const MacNotification = require('bindings')('Notification').MacNotification
const notifications = [];

module.exports = class Notification extends EventTarget {
  constructor(title, options) {
    super();
    
    if (!title) throw new Error('Title is required');
    
    Object.assign(this, {title}, options);
    
    options = options || {};
    options.id = options.id || uuid.v4();
    options.body = options.body || '';
    options.canReply = !!options.canReply;

    let activated = (isReply, response, id) => {
      const notification = this.getNotificationById(id);
      if (!notification) return;

      console.log(notifications);
      
      if (isReply) {
        notification.dispatchEvent({type: 'reply', response});
      } else {
        notification.dispatchEvent({type: 'click'});
      }
    };

    let args = Object.assign({title, activated}, options);
    this.notification = new MacNotification(args);
    notifications.push(this);
  }

  close() {
    let i = getNotificationIndexById(this.notification.id);
    if (i) notifications.splice(i, 1);

    this.notification.close();
    this.notification = null;
    
    this.dispatchEvent({type: 'close'});
  }

  getNotificationById(id) {
    return notifications.find((item) => (item.notification.id === id));
  }

  getNotificationIndexById(id) {
    return notifications.findIndex((item) => (item.notification.id === id));
  }
};