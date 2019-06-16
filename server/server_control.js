const { spawn, exec } = require('child_process');

class Event {
  constructor() {
    this.events = {}
  }

  register(name, callback) {
    if (!this.events[name])
      this.events[name] = []
    this.events[name].push(callback)
  }

  trigger(name, event) {
    const { events } = this
    if (events[name])
      for (let callback of events[name])
        setTimeout(() => callback(event), 0)
  }
}

class ServerController {

  constructor(options) {
    const prefix = '^[0-9]+-[0-9]+-[0-9]+ [0-9]+:[0-9]+:[0-9]+ '
    this.events = new Event()
    this._process = undefined
    this.options = Object.assign({
      debug: false,
      path: '/opt/factorio/bin/x64/factorio',
      startLatest: '--start-server-load-latest',
      startNew: '--start-server-load-scenario',
      name: 'forbidden_planet',
      config: '/opt/factorio/data/dev-server-settings.json',
      patterns: {
        chat: new RegExp(prefix + '\\[CHAT\\]\\s?(.*)'),
        join: new RegExp(prefix + '\\[JOIN\\]\\s?(.*)'),
        leave: new RegExp(prefix + '\\[LEAVE\\]\\s?(.*)'),
        start: /^\s+\d+\.\d+ Info ServerMultiplayerManager\.cpp:705: Matching server connection resumed/,
        stop: /^\s+\d+\.\d+ Goodbye/,
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

      process.stdout.on('data', async raw => {

        const chunk = raw.toString('utf8');

        for (let [name, regex] of Object.entries(patterns)) {
          let match = chunk.match(regex)
          if (match)
            events.trigger(name, { name, time: new Date(), chunk, match, data: match[1], pattern: regex })
        }

        if (debug)
          console.log(chunk)
      })

      this._process = process
      resolve(0)
    })
  }

  stop() {
    this.process.kill('SIGHUP')
  }
  get process() {
    return this._process
  }
  restart() { }
  update() { }
  registerEvent(event, callback) {
    this.events.register(event, callback)
  }
}

class ServerCommands {

  constructor(server) {
    if (!server) throw new Error("You forgot to pass in a ServerController")
    if (!server instanceof ServerController) throw new Error("Argument is not instanceof ServerController")
    this.server = server
  }

  kick(user, reason = '', invoker = "system") {
    const { server } = this
    if (!user) {
      server.events.trigger("error", { name: 'kick', invoker, time: new Date(), data: 'No user specified' })
      return
    }
    server.process.stdin.write(`/silent-command game.kick_player("${user}", "${reason}")\n`)
    server.events.trigger("success", { name: 'kick', invoker, time: new Date(), data: [user, reason] })
  }

  ban(user, reason = '', invoker = "system") {
    const { server } = this
    if (!user) {
      server.events.trigger("error", { name: 'ban', invoker, time: new Date(), data: 'No user specified' })
      return
    }
    server.process.stdin.write(`/silent-command game.ban_player("${user}", "${reason}")\n`)
    server.events.trigger("success", { name: 'ban', invoker, time: new Date(), data: [user, reason] })
  }

  umban(user, reason = '', invoker = "system") {
    const { server } = this
    if (!user) {
      server.events.trigger("error", { name: 'unban', invoker, time: new Date(), data: 'No user specified' })
      return
    }
    server.process.stdin.write(`/silent-command game.unban_player("${user}", "${reason}")\n`)
    server.events.trigger("success", { name: 'unban', invoker, time: new Date(), data: [user, reason] })
  }

  promote(user, invoker = "system") {
    const { server } = this
    if (!user) {
      server.events.trigger("error", { name: 'promote', invoker, time: new Date(), data: 'No user specified' })
      return
    }
    server.process.stdin.write(`/silent-command if game.players["${user}"] then game.players["${user}"].admin = true end\n`)
    server.events.trigger("success", { name: 'promote', invoker, time: new Date(), data: [user] })
  }

  demote(user, invoker = "system") {
    const { server } = this
    if (!user) {
      server.events.trigger("error", { name: 'promote', invoker, time: new Date(), data: 'No user specified' })
      return
    }
    server.process.stdin.write(`/silent-command if game.players["${user}"] then game.players["${user}"].admin = false end\n`)
    server.events.trigger("success", { name: 'promote', invoker, time: new Date(), data: [user] })
  }

}


module.exports = { ServerCommands, ServerController }
