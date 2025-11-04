The code violated the SRP because the event manager was doing too many things at once
My partner said how she found that the SRP was storing raw event data, parsing event strings, and representing event objects ALL AT ONCE
