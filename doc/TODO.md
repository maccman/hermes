Email conversation style, with an integrated workflow.


# Types

* Everything - archives after a day
* Starred - todo list
* Activity feed - broadcast emails

http://mailgun.net/


    curl --user api:password
         https://hermes.com/messages.json
         -F to='@maccman, maccman@gmail.com'
         -F body='Testing some Mailgun awesomness!'
         -F attachment=@files/attachment.doc
     
     curl --user api:password
          https://hermes.com/messages.json
          
          [{
            body: "Foo",
            subject: "Bar",
            conversation_id: 123,
            from: '@handle',
            to: ['blah@gmail.com', 'blah2@gmail.com'],
            
            from_user: {
              handle: '@handle',
              avatar_url: "http://gravatar...",
              name: "Blah Blah",
              ...
            },
            
            to_users: [
              {...},
              {...}
            ]
          }]