# Communityshare Elm App

## Introduction

This project is half a learning project and half a vision for a rebuild of 
the client-side app for [Communityshare](app.communityshare.us).
The [current project](github.com/communityshare/communityshare) is built
ontop of Angular in JavaScript and this rewrite eschews the conveniences
that Angular offers inside of its own framework for the simplicity and
explicitness offered by Elm's purely functional approach.

It is unknown how completely this project will develop as it relates
entirely to my interests and persistence. It is first a learning project
for me and less a clear path forward for the Communityshare project.

## Running Locally

Eventually I will try and create a `webpack` build to generate an actual
webpage. In the meantime, this app can run inside of the `elm-reactor`.

First, install Elm and the reactor

```bash
npm install -g elm
```

Then, clone this repository and start the reactor

```bash
git clone https://github.com/dmsnell/cs-elm.git
cd cs-elm
elm-reactor
```

Next, since the app is making calls to the actual Communityshare project 
but those API calls aren't originating from app.communityshare.us, we will
need to start a browser with certain same-origin checks disabled.

Here is how we can open Chrome on Mac OS X:
```bash
open /Applications/Google\ Chrome.app --args --disable-web-security --user-data-dir=~/Downloads/ChromeData
```

Finally, navigate to the app itself inside of the browser at 
[localhost:8000/src/App.elm](localhost:8000/src/App.elm) 