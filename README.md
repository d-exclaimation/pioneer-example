# Pioneer Server Example

## Usage

Feel free to try out the server.

### Sign up a user

Sign up a user on the server using your user token by running:

Query

```graphql
mutation Signup($name: String!) {
  signup(name: $name) {
    __typename
    ... on InvalidName {
      name
    }
    ... on LoggedUser {
      token
    }
  }
}
```

Variables

```json
{
  "name": "Foo"
}
```

#### Expected Result

```json
{
  "data": {
    "signup": {
      "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJjaGF0LXVzZXIiLCJleHAiOjE2NjA4ODM1MjEuMTcxNTE1LCJ1aWQiOiIxQjI5NTY0My1GMjlELTQ1MTItQjE0My03RUU3RkU0Q0QwMjYifQ.6PwYyYtwr6iiEHJuHY9RrmWLNb_aoAJomNdL1S797VU",
      "__typename": "LoggedUser"
    }
  }
}
```

### Open a room

Next, open a room to send the message to by running:

Query

```graphql
mutation Open {
  open {
    __typename
    ... on Unauthorized {
      operation
    }
    ... on NewRoom {
      room {
        id
      }
    }
  }
}
```

Headers _(or Connection Parameters in WebSocket)_*

```json
{
  "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJjaGF0LXVzZXIiLCJleHAiOjE2NjA4ODM1MjEuMTcxNTE1LCJ1aWQiOiIxQjI5NTY0My1GMjlELTQ1MTItQjE0My03RUU3RkU0Q0QwMjYifQ.6PwYyYtwr6iiEHJuHY9RrmWLNb_aoAJomNdL1S797VU"
}
```
*<small>Change the token to your user token</small>

#### Expected Result

```json
{
  "data": {
    "open": {
      "room": {
        "id": "2EFCE9A7-9358-4AA6-A0EF-8A56981E2658"
      },
      "__typename": "NewRoom"
    }
  }
}
```

### Write a message

Using both your user token and the room id, send a message by running:

Query 

```graphql
mutation Write($content: String!, $to: ID!) {
  write(content: $content, to: $to) {
    __typename
    ... on Unauthorized {
      operation
    }
    ... on InvalidRoom {
      roomId
    }
    ... on NewMessage {
      message {
        id
        createdAt
        content
      }
    }
  }
}
```

Variables*

```json
{
  "content": "Hello!!",
  "to": "2EFCE9A7-9358-4AA6-A0EF-8A56981E2658"
}
```

*<small>Change the `to` variable to use the room id you made</small>

Headers _(or Connection Parameters in WebSocket)_*

```json
{
  "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJjaGF0LXVzZXIiLCJleHAiOjE2NjA4ODM1MjEuMTcxNTE1LCJ1aWQiOiIxQjI5NTY0My1GMjlELTQ1MTItQjE0My03RUU3RkU0Q0QwMjYifQ.6PwYyYtwr6iiEHJuHY9RrmWLNb_aoAJomNdL1S797VU"
}
```
*<small>Change the token to your user token</small>

#### Expected result

```json
{
  "data": {
    "write": {
      "message": {
        "id": "004FAAE9-4706-489C-9B26-235210288D49",
        "createdAt": "2022-08-05T16:39:58+1200",
        "content": "Hello!!"
      },
      "__typename": "NewMessage"
    }
  }
}
```