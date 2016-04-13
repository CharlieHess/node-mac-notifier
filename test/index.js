"use strict";

const MacNotification = require('bindings')('Notification').MacNotification
const assert = require('assert');

describe('Mac Notification', () => {
  it('should require an options argument', () => {
    assert.throws(() => {
      let notification = new MacNotification();
    });
  });
  
  it('should have an ID', () => {
    let id = 'really-long-string-identifying-this-uniquely';
    let notification = new MacNotification({id});
    assert.equal(notification.id, id);
  });
  
  it('should have a title', () => {
    let title = 'Hello OS X!';
    let notification = new MacNotification({title});
    assert.equal(notification.title, title);
  });
  
  it('should have a body', () => {
    let body = "This is a body"
    let notification = new MacNotification({body});
    assert.equal(notification.body, body);
  });
  
  it('should have an icon', () => {
    let icon = "https://s3-us-west-2.amazonaws.com/slack-files2/avatars/2014-10-29/2900953622_045c677bdf5cc6394c35_102.jpg"
    let notification = new MacNotification({icon});
    assert.equal(notification.icon, icon);
  });
  
  it('should have a canReply field', () => {
    let canReply = true;
    let notification = new MacNotification({canReply});
    assert.equal(notification.canReply, canReply);
  });
  
  it('should have a close method', () => {
    let notification = new MacNotification({id: 'toClose'});
    notification.close();
    assert.ok(notification);
  });
});
