const { spawn, exec } = require('child_process');
const Event = require('./event')

class ServerController {

  constructor(options) {
    const prefix = '^[0-9]+-[0-9]+-[0-9]+ [0-9]+:[0-9]+:[0-9]+ '
    this.events = new Event()
    this._process = undefined
    this.options = Object.assign({
      debug: true,
      path: '/opt/factorio/bin/x64/factorio',
      startLatest: '--start-server-load-latest',
      startNew: '--start-server-load-scenario',
      name: 'forbidden_planet',
      config: '/opt/factorio/data/dev-server-settings.json',
      patterns: {
        chat: new RegExp(prefix + '\\[CHAT\\]\\s?(.*)',"m"),
        join: new RegExp(prefix + '\\[JOIN\\]\\s?(.*)',"m"),
        leave: new RegExp(prefix + '\\[LEAVE\\]\\s?(.*)',"m"),
        start: /^\s+\d+\.\d+ Info ServerMultiplayerManager\.cpp:705: Matching server connection resumed/m,
        stop: /^\s+\d+\.\d+ Goodbye/m,
        initializationFailed:/\s+\d+\.\d+ .*changing state from\(InitializationFailed\) to\(Closed\)/m
      }
    }, options)

  }

  start(param = 'latest') {

    const { events } = this
    const { path, startLatest, startNew, name, config, debug, patterns } = this.options
    return new Promise((resolve, reject) => {
      let process

      if (param == 'new') {
        process = spawn(path, [startNew, name, '--server-settings', config])
      } else if (param == 'latest') {
        process = spawn(path, [startLatest, '--server-settings', config])
      } else {
        reject(1)
      }

      process.stdout.on('data', raw => {

        const chunk = raw.toString('utf8');

        for (let [name, regex] of Object.entries(patterns)) {
          let match = chunk.match(regex)
          if (match)
            events.trigger(name, { name, time: new Date(), chunk, match, data: match[1], pattern: regex })
        }

        if (debug)
          console.log(`CHUNK START =======================\n${chunk}\nCHUNK END =======================`)
      })

      this._process = process
      resolve(0)
    })
  }

  stop() {
    return new Promise((resolve, reject) => {
      this.process.kill('SIGHUP')
      resolve(0)
    })
  }
  get process() {
    return this._process
  }
  restart() { }
  update() { }
  on(event, callback) {
    this.events.register(event, callback)
  }
}

class ServerCommands {

  constructor(server) {
    if (!server) throw new Error('You forgot to pass in a ServerController')
    if (!server instanceof ServerController) throw new Error('Argument is not instanceof ServerController')
    this.server = server


  }

  start(param = 'latest'){
    console.log(param)
    return this.server.start(param)
  }

  stop(){
    return this.server.stop()
  }

  kick(user, reason = '', invoker = 'system') {
    const { server } = this
    if (!user) {
      server.events.trigger('error', { name: 'kick', invoker, time: new Date(), data: 'No user specified' })
      return
    }
    server.process.stdin.write(`/silent-command game.kick_player('${user}', '${reason}')\n`)
    server.events.trigger('success', { name: 'kick', invoker, time: new Date(), data: [user, reason] })
  }

  ban(user, reason = '', invoker = 'system') {
    const { server } = this
    if (!user) {
      server.events.trigger('error', { name: 'ban', invoker, time: new Date(), data: 'No user specified' })
      return
    }
    server.process.stdin.write(`/silent-command game.ban_player('${user}', '${reason}')\n`)
    server.events.trigger('success', { name: 'ban', invoker, time: new Date(), data: [user, reason] })
  }

  unban(user, invoker = 'system') {
    const { server } = this
    if (!user) {
      server.events.trigger('error', { name: 'unban', invoker, time: new Date(), data: 'No user specified' })
      return
    }
    server.process.stdin.write(`/silent-command game.unban_player('${user}')\n`)
    server.events.trigger('success', { name: 'unban', invoker, time: new Date(), data: [user] })
  }

  promote(user, invoker = 'system') {
    const { server } = this
    if (!user) {
      server.events.trigger('error', { name: 'promote', invoker, time: new Date(), data: 'No user specified' })
      return
    }
    server.process.stdin.write(`/silent-command if game.players['${user}'] then game.players['${user}'].admin = true end\n`)
    server.events.trigger('success', { name: 'promote', invoker, time: new Date(), data: [user] })
  }

  demote(user, invoker = 'system') {
    const { server } = this
    if (!user) {
      server.events.trigger('error', { name: 'promote', invoker, time: new Date(), data: 'No user specified' })
      return
    }
    server.process.stdin.write(`/silent-command if game.players['${user}'] then game.players['${user}'].admin = false end\n`)
    server.events.trigger('success', { name: 'promote', invoker, time: new Date(), data: [user] })
  }

  discordMessage(user, message = '') {
    const { server } = this
    if (!user) {
      server.events.trigger('error', { name: 'discordMessage', invoker, time: new Date(), data: 'No user specified' })
      return
    }
    server.process.stdin.write(`/silent-command game.print('[Discord] ${user}: ${message}', {r = 0.3, g = 0.4, b = 1})\n`)
  }

}


module.exports = { ServerCommands, ServerController }
