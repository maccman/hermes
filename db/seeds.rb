user1 = User.create(uid: "2006261", handle: "maccman", name: "Alex MacCaw", email: "maccman@gmail.com", twitter_token: "blank")
user2 = User.create(uid: "734903", handle: "mjackson", name: "Michael Jackson", email: "mjijackson@gmail.com", twitter_token: "blank")

message = Message.new
message.body = "Hello World"
message.from_user = user1
message.user = user1
message.to = "@mjackson"
message.save!

message = Message.new
message.body = "Hello right back at ya!"
message.user = user2
message.from_user = user2
message.to = "@maccman"
message.save!