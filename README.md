# Pastebin.jl - A Wrapper around the Pastebin REST API

[![Build Status](https://travis-ci.org/molnarmark/Pastebin.jl.svg?branch=master)](https://travis-ci.org/molnarmark/Pastebin.jl)

### Installation

```Julia
Pkg.add("Pastebin")
```
### Usage

```Julia
using Pastebin
```

###### You have 3 ways of creating a Pastebin Client:

```Julia
PastebinClient(devKey::AbstractString)
PastebinClient(devKey::AbstractString, userKey::AbstractString)
PastebinClient(devKey::AbstractString, username::AbstractString, password::AbstractString)
```

###### Available Methods:
```Julia
# For creating pastes
# Note: If your client has a user key, the paste will be created by that user.
paste!(client::PastebinClient, title::AbstractString, text::AbstractString, expiration::Expiration, access::Access)

# For removing pastes
delpaste!(client::PastebinClient, key::PasteKey)

# For retrieving pastes by Paste Key.
# Example: getraw(PasteKey("fs52lKAHf"))
getraw(key::PasteKey)
```
###### You can use the following methods to access parts of the PastebinResponse:
```Julia
content(resp::PastebinResponse)
success(resp::PastebinResponse)
```

# License: MIT
###### Developed by Mark Molnar, 2016
