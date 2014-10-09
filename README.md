# Hacklab API

Sexy API for things and stuff

## To Install

To install:

1. `git clone https://github.com/hacklabto/hacklab_api.git`
2. `cd hacklab_api`

3. Create `./figaro.json`:

    ```
    {
      "AMQP_LOGIN": "YOUR_LOGIN",
      "AMQP_PASSWORD": "YOUR_PASSWORD",

      "DB_HOST": "YOUR_DATABASE_HOST",
      "DB_USER": "YOUR_DATABASE_USER_NAME",
      "DB_DATABASE": "YOUR_DATABASE_NAME",
      "DB_URL": null
    }
    ```
4. `npm install`
5. Launch with `bin/server.js`
