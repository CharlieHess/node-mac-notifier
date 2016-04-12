var Notification = require('../');
var assert = require('assert');

describe('Mac Notification', function() {
  it('should require an options argument', function() {
    assert.throws(function() {
      var notification = new Notification();
    });
  });
  
  it('should have a title accessor', function() {
    var title = 'Hello OS X!';
    var notification = new Notification({title: title});
    assert.equal(notification.title, title);
  });
  
  it('should have a body accessor', function() {
    var body = "This is a body"
    var notification = new Notification({body: body});
    assert.equal(notification.body, body);
  });
  
  it('should have a canReply accessor', function() {
    var canReply = true;
    var notification = new Notification({canReply: canReply});
    assert.equal(notification.canReply, canReply);
  });
});
