ecs
===

Generic Entity Component System backend


General idea:
Entities are just uuids. Will need some kind of pooling system so entities from
one application aren't mixed with another application.

Connections

ECS -> WS (web clients needs entity updates)
Controllers -> ECS (only controllers on the server should be able to update the ECS)
WS -> Controllers (controllers can do things in response to WS events)

That authorisation could probably just be done with a shared key on the server.

The connection WS -> ECS would be useful for testing. 



Perhaps in the path:
ecs/#{appid}/#{event}

Events:
  Server to client
    ecs/create -> {appid}

  Client to server
    ecs/create {key?} -> {appid}

App Events:
  Server to client
    ecs/#{appid}/created -> {id}
    # ecs/#{appid}/sync -> {id, all fields} (or read?)
    ecs/#{appid}/updated -> {id, changed fields}
    ecs/#{appid}/destroyed -> {id}

  client to server
    ecs/#{appid}/read -> trigger a sync?
    ecs/#{appid}/update {id, changed fields} -> 
    ecs/#{appid}/create {fields} -> server generates id