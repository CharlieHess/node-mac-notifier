"use strict";

const MacNotification = require('bindings')('Notification').MacNotification
const assert = require('assert');

describe('Mac Notification', () => {
  it('should require one argument', () => {
    assert.throws(() => {
      let notification = new MacNotification();
    });
  });

  it('should have an ID field', () => {
    let id = 'really-long-string-identifying-this-uniquely';
    let notification = new MacNotification({id});
    assert.equal(notification.id, id);
  });

  it('should set unprovided fields to undefined', () => {
    let notification = new MacNotification({id: 'test'});
    assert.equal(notification.title, undefined);
    assert.equal(notification.body, undefined);
    assert.equal(notification.icon, undefined);
    assert.equal(notification.soundName, undefined);
  });

  it('should have a title field', () => {
    let title = 'Hello macOS!';
    let notification = new MacNotification({title});
    assert.equal(notification.title, title);
  });

  it('should have a subtitle field', () => {
    let subtitle = 'subtitular field';
    let notification = new MacNotification({subtitle});
    assert.equal(notification.subtitle, subtitle);
  });

  it('should have a body field', () => {
    let body = "This is a body"
    let notification = new MacNotification({body});
    assert.equal(notification.body, body);
  });

  it('should have an icon field', () => {
    let icon = "https://s3-us-west-2.amazonaws.com/slack-files2/avatars/2014-10-29/2900953622_045c677bdf5cc6394c35_102.jpg"
    let notification = new MacNotification({icon});
    assert.equal(notification.icon, icon);
  });

  it('should have a soundName field', () => {
    let soundName = 'default';
    let notification = new MacNotification({soundName});
    assert.equal(notification.soundName, soundName);
  });

  it('should have a canReply field', () => {
    let canReply = true;
    let notification = new MacNotification({canReply});
    assert.equal(notification.canReply, canReply);
  });

  it('should have a showCloseButton field', () => {
    let showCloseButton = true;
    let notification = new MacNotification({showCloseButton});
    assert.equal(notification.showCloseButton, showCloseButton);
  });

  it('should have a close method', () => {
    let notification = new MacNotification({id: 'toClose'});
    notification.close();
    assert.ok(notification);
  });

  it('should allow overriding the NSBundle ID', () => {
    let bundleId = 'com.lol.what.bundle';
    let notification = new MacNotification({bundleId});
    assert.equal(notification.bundleId, bundleId);
  });
});
