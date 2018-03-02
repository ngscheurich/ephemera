# 🍃 Ephemera

After launching my [personal website](https://nick.scheurich.me/), I started to feel the desire,
as one does, to display my recent web activity in different places on the site. You know the stuff
I’m talking about: Spotify tracks, Tweets, Instagram posts. As my website is simply the output of a
[static site generator](http://gohugo.io/), I would clearly need some external resource to handle
this for me. Enter: Ephemera.

---

## Table of contents

* [Ephemera](#-ephemera)
* [Table of Contents](#table-of-contents)
* [Configuration](#configuration)
   * [Spotify](#spotify)
* [Retrieving data](#retrieving-data)
* [Roadmap](#roadmap)
* [Development](#development)
   * [Service adapters](#service-adapters)
      * [Specification](#specification)
      * [Example](#example)
* [License](#license)

## Configuration

### Spotify

Configure `Ephemera.Spotify` for the `:ephemera` app with your Spotify client ID, client secret,
and refresh token. For production, these should probably be kept somewhere safe, e.g., the system
environment:

```elixir
config :ephemera, Ephemera.Spotify,
  client_id: Map.fetch!(System.get_env(), "SPOTIFY_CLIENT_ID"),
  client_secret: Map.fetch!(System.get_env(), "SPOTIFY_CLIENT_SECRET"),
  refresh_token: Map.fetch!(System.get_env(), "SPOTIFY_REFRESH_TOKEN")
```

## Retrieving data

An endpoint at the root path of the application exposes data as per the [GraphQL spec](http://facebook.github.io/graphql/October2016/).
A simple JavaScript example to get some data about recent Spotify tracks could look something like:

```JavaScript
const query = `
  {
    spotifyTracks {
      name
      artist
    }
  }
`;

const xhr = new XMLHttpRequest();
xhr.responseType = "json";
xhr.open("POST", "https://your-ephemera-app.com/");
xhr.setRequestHeader("Content-Type", "application/json");
xhr.setRequestHeader("Accept", "application/json");
xhr.onload= () => console.log(xhr.response.data.spotifyTracks);
xhr.send(JSON.stringify({ query }));
```

## Roadmap

The following are the services I plan to implement initially:

- [x] Spotify
- [ ] Twitter
- [ ] Instagram

## Development

### Service adapters

Ephemera has a *service adapter* for each service it supports, which is just a fancy way to say a
collection of modules that implement an admittedly loosely-defined spec. One day, these service adapters
might be extracted into their own Hex packages, but that day is not today.

#### Specification

A service adapter must consist of the following parts:

* A `Client` spec that defines how clients for this adapter should behave
* An `HTTPClient` that implements the client behaviour to interface with the service’s web API
* One or more `Worker`s that implement the GenServer behaviour and interact with clients to generate and maintain an internal state

The idea that is that all state in the application is ephemeral—hence the name—so `Worker` process state is
not persisted in any external data store. If a `Worker` dies, its supervisor should just spin up a new one, at
which point the state will be regenerated.

#### Example

The Spotify adapter, for instance, has the following modules:

- `Client`: Defines Spotify client behaviour
- `HTTPClient`: A client that interfaces with Spotify’s web API
- `GrantWorker`: A worker that maintains and refreshes Spotify web API authorization grants
- `TracksWorker`: A worker that keeps a list of recently-played Spotify tracks

In addition, the Spotify adapter also includes an `InMemoryClient` that mocks the Spotify web API
for testing, and defines `Grant` and `Track` structs.

## License

Ephemera is released under the [MIT license](https://github.com/ngscheurich/ephemera/blob/master/LICENSE).
