# Be sure to restart your server when you modify this file.

#Fly::Application.config.session_store :cookie_store, key: '_fly_session', expire_after: 30.minutes
Fly::Application.config.session_store :redis_store, servers: "redis://localhost:6379/1", expire_in: 30.minutes
