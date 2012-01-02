## Data

User:

    handle: String unique in the system
    name: String
    avatar_url: String
    description: String

Message:

    created_at: Unix epoch timestamp
    sent_at: Unix epoch timestamp
    to: Array of recipients
    subject: String
    body: String
    attachments: Array of attachments

Attachment:

    name: A name unique to this attachment
    type: An HTTP content type
    size: Number of bytes encoded
    encoding: An encoding (default is base64)
    data: Raw data

## API

GET /messages?since=:since&limit=:limit

    Since defaults to now. Limit defaults to ?.

    Data:
    messages: Array of messages, sorted by sent_at DESC
    users: Array of users in the messages

POST /messages

    Data:
    Any data that is part of a message.
