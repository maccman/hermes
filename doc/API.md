## Data

This is a description of the fields and types of data in the system.

User:

  handle: String, unique in the system
  name: String
  avatar_url: URL string
  description: String

Message:

  created_at: Unix timestamp
  sent_at: Unix timestamp
  subject: String
  body: String
  attachments: [Attachment]
  starred: Boolean
  to_users: [User]
  from_user: User

Attachment:

  message: Message
  name: String, unique among attachments to the message
  type: String, an HTTP content type
  size: Number, bytes encoded
  encoding: String, specifies data encoding (default is base64)
  data: String

Conversation:

  read: Boolean
  from_user: User
  to_users: [User]
  messages: [Message]

## API

GET /messages?since=:since&limit=:limit

  Since defaults to current server time. Limit defaults to ?.
  Finds messages where from_user is current_user

  Returns:
  messages: [Message] sorted by sent_at DESC
  users: [User] who appear in the messages

POST /messages

  Creates a new message. If a conversation between the creator of the message
  and any of the recipients does not yet exist, a new conversation is created
  between them.
  
  Sets from_user to current_user

  Params:
  sent_at: Unix timestamp
  to: Array of handles/emails
  subject: String
  body: String
  attachments: [Attachment]

PUT /messages/:id

  Finds any message the current_user is associated with (i.e. via from_user or to_users)
  Update starred.

  Params:
  starred: Boolean

DELETE /messages/:id

  Marks a message as deleted.
