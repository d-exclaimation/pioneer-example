# Pioneer Server Example

An example of a GraphQL server built with Pioneer.

This server provide a chat service which includes:
- Ability to sign up / log in user
- Ability to create / open rooms, if authenticated
- Ability to write messages into a room, if authenticated
- Ability to listen to messages given sent to a room, if authenticated
- Authentication through JWT
- Usage of GraphQL Union for better error or result handling on mutations

## Technologies

- Swift for Programming Language
- GraphQL for API Language
- Vapor for Web framework
- Graphiti for GraphQL schema library
- Pioneer for GraphQL server library
- PostgreSQL for RDMS
- Fluent for ORM

### Operations

#### Queries

<details>
<summary><code>me.graphql</code></summary>
Check if the request is logged in as a user or not

```graphql
query Me {
  me {
    id
    name
    messages {
      ...
    }
  }
}
```

Return a full `User` if logged in or `null` if not.

</details>


<details>
<summary><code>users.graphql</code></summary>
List all users in the database

```graphql
query Users {
  users {
    id
    name
    messages {
      ...
    }
  }
}
```

</details>

<details>
<summary><code>rooms.graphql</code></summary>
List all rooms in the database

```graphql
query Rooms {
  rooms {
    id
    history {
      ...
    }
    users {
      ...
    }
  }
}
```

</details>

#### Mutations

<details>
<summary><code>signup.graphql</code></summary>

Sign up / create a user, and log in as that user

```graphql
mutation Signup($name: String!) {
  signup(name: $name) {
    __typename
    ... on InvalidName {
      name
    }
    ... on LoggedUser {
      token
      user {
        ...
      }
    }
  }
}
```

Results:

- `InvalidName`
  - Returned when the `name` is not valid name for the database
- `LoggedUser`
  - Returned when a successful sign up happen and both user and its token have been created

</details>

<details>
<summary><code>login.graphql</code></summary>

Log into a user

```graphql
mutation Login($name: String!) {
  login(name: $name) {
    __typename
    ... on InvalidName {
      name
    }
    ... on LoggedUser {
      token
      user {
        ...
      }
    }
  }
}
```

Results:

- `InvalidName`
  - Returned when the `name` is not valid / not in database
- `LoggedUser`
  - Returned when a successful login happen and a token has been created


</details>


<details>
<summary><code>open.graphql</code></summary>

Open a room

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
        history {
          ...
        }
        users {
          ...
        }
      }
    }
  }
}
```

**Must be logged in / Have valid token in Authorization header**

Results:

- `Unauthorized`
  - Returned when not logged in as a user
- `NewRoom`
  - Returned when a room has been created

</details>

<details>
<summary><code>write.graphql</code></summary>

Write a new message to a user

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
        author {
          ...
        }
        room {
          ...
        }
      }
    }
  }
}
```

**Must be logged in / Have valid token in Authorization header**

Results:

- `Unauthorized`
  - Returned when not logged in as a user
- `InvalidRoom`
  - Returned when the `to` parameter is not a valid Room id
- `NewMessage`
  - Returned when message successfully created and shared to all listener for the room

</details>

#### Subscriptions

<details>
<summary><code>listen.graphql</code></summary>

Listen to all message sent to a room

```graphql
subscription Listen($to: ID!) {
  listen(to: $to) {
    content
    createdAt
    id
    author {
      ...
    }
    room {
      ...
    }
  }
}
```

**Subscription must go through WebSocket which also require authentication**

Results will be sent back when a message were created and sent to the room specified in the `to` parameter

</details>

### Schema

<details>
<summary><code>schema.graphql</code></summary>

```graphql
"""Results from sign up and log in"""
union AuthResult = InvalidName | LoggedUser

"""A result given an incorrect name"""
type InvalidName {
  """The name in question"""
  name: String!
}

"""A result given when Room id is invalid"""
type InvalidRoom {
  """The ID in question"""
  roomId: ID!
}

"""A result with all the information of a Logged in User"""
type LoggedUser {
  """JWT token for this User"""
  token: String!

  """The User for this logged in result"""
  user: User!
}

"""A Message sent to a room by a user"""
type Message {
  """User who wrote this Message"""
  author: User!

  """Message textual content"""
  content: String!

  """Message creation date and time"""
  createdAt: String!

  """Message unique identifier"""
  id: ID!

  """Room where this Message is sent to"""
  room: Room!
}

type Mutation {
  """Log into an exisiting User"""
  login(
    """Name of the User"""
    name: String!
  ): AuthResult!

  """Open a Room (must be logged in)"""
  open: OpenResult!

  """Sign up a new User"""
  signup(
    """Name of the User"""
    name: String!
  ): AuthResult!

  """Write a Message to a Room (must be logged in)"""
  write(
    """The content of the Message"""
    content: String!

    """The Room id sent the Message to"""
    to: ID!
  ): WriteResult!
}

"""A result given a successful write operation"""
type NewMessage {
  """The Message written"""
  message: Message!
}

"""A result given a successful open operation"""
type NewRoom {
  """The Room opened"""
  room: Room!
}

"""Results from opening a room"""
union OpenResult = Unauthorized | NewRoom

type Query {
  """Check for the sign in status"""
  me: User

  """List all available Rooms"""
  rooms: [Room!]!

  """List all signed up Users"""
  users: [User!]!
}

"""A certain Room / channel of messages"""
type Room {
  """Message history for this Room sent by any User"""
  history: Message!

  """Room unique identifier"""
  id: ID!

  """Users who have written into this Room"""
  users: User!
}

type Subscription {
  """Listen to all Messages sent to a Room (must be logged in)"""
  listen(
    """The Room id to listen to"""
    to: ID!
  ): Message!
}

"""A result given when not logged in"""
type Unauthorized {
  """Name of operation being performed"""
  operation: String!
}

"""A User who can write down messages"""
type User {
  """User unique identifier"""
  id: ID!

  """Message written by this User sent to any Room"""
  messages: Message!

  """User public name"""
  name: String!
}

"""Results from writing a message"""
union WriteResult = Unauthorized | InvalidRoom | NewMessage
```

</details>