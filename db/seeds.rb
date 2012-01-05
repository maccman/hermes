user1 = User.create(uid: "2006261", handle: "maccman", name: "Alex MacCaw", avatar_url: "https://secure.gravatar.com/avatar/baf018e2cc4616e4776d323215c7136c", email: "maccman@gmail.com", twitter_token: "blank")
user2 = User.create(uid: "734903", handle: "mjackson", name: "Michael Jackson", avatar_url: "https://secure.gravatar.com/avatar/9210a60b1492363560375d9cd6c842de", email: "info@eribium.org", twitter_token: "blank")

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