# You shouldn't use this directly. It's a local-only collection that doesn't get synced with the server.
# Instead of interfacing with this directly. Use the methods provided by the bopOfflineImageHelper service
# If a method doesn't exist, please create one to maintain encapsulation for offline images functionality.
#
# -Andrew
@LocalOnlyImages = new Ground.Collection(new Meteor.Collection(null))