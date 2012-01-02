## Data

User:

    handle: String unique in the system
    name: String
    avatar_url: String
    description: String

Message:

    created_at: Unix epoch timestamp
    sent_at: Unix epoch timestamp
    subject: String
    body: String
    attachments: Array of attachments
    starred: Boolean
    to_users: [User]
    from_user: User

Attachment:

    name: A name unique to this attachment
    type: An HTTP content type
    size: Number of bytes encoded
    encoding: An encoding (default is base64)
    data: Raw data
    
Conversation:

    read: Boolean
    from_user: User
    to_users: [User]
    messages: [Message]

## API

GET /messages?since=:since&limit=:limit

    Since defaults to now. Limit defaults to ?.

    Returns:
    messages: Array of messages, sorted by sent_at DESC
    users: Array of users in the messages

POST /messages

    Create message.
    
    Params:
    sent_at: Unix epoch timestamp
    to: Array of handles/emails
    subject: String
    body: String
    attachments: Array of attachments

PUT /messages/:id

    Update starred.

    Params:
    starred: Boolean