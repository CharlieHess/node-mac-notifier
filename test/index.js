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
});
