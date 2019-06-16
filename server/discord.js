const { Client, RichEmbed } = require('discord.js');
const client = new Client();

const auth = require('./auth')

const escapeString = message => {

  let escaped = message.replace(/\n/g, "")
  escaped = escaped.replace(/(["'\\])/g, "\\$1")
  return escaped
}

class Event{
  constructor(){
    this.events = {}
  }

  register(name, callback){
    this.events[name] = callback
  }

  trigger(name){
    console.log(`trigger: ${name}`)
    if(this.events[name])
      this.events[name]()
  }
}

const event = new Event()


client.login(auth.token);


const messageEmbedded = (channelName, title, message, color = 0xff0000) => {

  const bananas = client.channels.find(channel => channel.name === channelName)
  if (!bananas) return

  const embed = new RichEmbed()
    .setTimestamp()
    .setTitle(`**${title}**`)
    .setColor(color)
    .setDescription(message)
  bananas.send(embed)
}


const joinOrLeaveMessage = (channelName, user, joinOrLeave) => {
  const bananas = client.channels.find(channel => channel.name === channelName)
  if (!bananas) return
  bananas.send(`**⟶ ${user} ${joinOrLeave} the server ⟵**`)
}

const chatMessage = (channelName, user, message) => {
  const bananas = client.channels.find(channel => channel.name === channelName)
  if (!bananas) return

  const msg = `**${user}** *${message}*`
  bananas.send(msg)

}


const commands = {
  start: {
    params: "*<**new** | **latest**>* *default:* **latest**",
    info: "starts the server",
    usage: "!start latest"
  },
  stop: {
    params: "",
    info: "stops the server",
    usage: "!stop"
  },
  restart: {
    params: "*<**new** | **latest**>* *default:* **latest**",
    info: "restarts the server",
    usage: "!restart"
  },
  online: {
    params: "",
    info: "Logs the current online player count",
    usage: "!online"
  }
}
const printHelp = (channelName) => {
  const bananas = client.channels.find(channel => channel.name === channelName)
  if (!bananas) return


  let string = ""

  for (let [name, value] of Object.entries(commands)) {
    string += `**!${name}** ${value.params}\n\t↳ ${value.info}\n\t↳ Usage: \`${value.usage}\`\n\n`
  }
  messageEmbedded("bananas", "Commands", string, 0xaa55ff)

}


const statusMessages = {
  start: `Server was **Started** by __USER__`,
  stop: `Server was **Stopped** by __USER__`,
  restart: `Server was **Restarted** by __USER__`,
  update: `Server was **Updated** to __VERSION__ by __USER__`,
  online: `Players **Online** __ONLINE__`,
  error: `\`\`\`__ERROR__\`\`\``
}

/*
setTimeout(() => {
  messageEmbedded("announcements",statusMessages.start.replace('__USER__', 'Decu'), 0x00ff00)
  messageEmbedded("announcements",statusMessages.stop.replace('__USER__', 'Decu'), 0xff0000)
  messageEmbedded("announcements",statusMessages.restart.replace('__USER__', 'Decu'), 0xffff00)
  messageEmbedded("announcements",statusMessages.update.replace('__USER__', 'Decu').replace('__VERSION__', '*0.17.49*'), 0xff00ff)
  messageEmbedded("announcements",statusMessages.online.replace('__ONLINE__', 12), 0x0000ff)
}, 1000)


setInterval(() => joinOrLeaveMessage("bananas"), 5000)
setInterval(() => chatMessage("bananas"), 2500)
*/
const { spawn, exec } = require('child_process');
const readline = require('readline');
class Server {
  constructor(opts) {

    this.process = undefined
    this._online = false
    this.options = Object.assign({
      launch: {
        path: '/opt/factorio/bin/x64/factorio',
        latest: '--start-server-load-latest',
        new: '--start-server-load-scenario',
        name: 'forbidden_planet',
        config: '/opt/factorio/data/dev-server-settings.json'
      },
    }, opts)
  }

  start(param = "latest") {
    return new Promise((resolve, reject) => {
      if(!param) reject("no start param")
      const { options } = this
      if(param == "new"){
        this.process = spawn(options.launch.path, [options.launch.new, options.launch.name, "--server-settings", options.launch.config])
        this._set_triggers(this.process)
      }else if(param == "latest"){
        this.process = spawn(options.launch.path, [options.launch.latest, "--server-settings", options.launch.config])
        this._set_triggers(this.process)
      }else{
        reject("unknown param")
      }
      resolve("started")
    })
  }

  stop() {
    return new Promise((resolve, reject) => {
      if(!this.process){
        messageEmbedded("bananas", "Error", "Server is currently not running", 0xff0000)
        reject("server not running")
        return
      }
      this.process.kill('SIGHUP')
      resolve("stopped")
    })
  }

  online_players(){
    if(!this.process) return
    this.process.stdin.write(`/silent-command log("[ONLINE] " ..#game.connected_players)\n`)
  }

  restart() { }
  
  message(user, text) {
    if(!this.process) return
    this.process.stdin.write(`/silent-command game.print("[Discord] ${user}: ${text}", { r = 0.4, g = 0.6, b = 1})\n`)
  }

  set online(o){
    this._online = o
  }
  get online(){
    return this._online
  }

  _set_triggers(factorio_process){

    factorio_process.stdout.on("data", data => {
      console.log(`${data}`)
      const error_filter = /.*Error(.*)/
      const error = error_filter.exec(`${data}`)

      const started = /.*ServerMultiplayerManager.cpp:705: Matching server connection resumed.*/

      const messageFilter = /.*\[CHAT\]\s?(.*)/
      const onlinePlayersFilter = /.*Script log.*\[ONLINE\]\s?(\d+)/
      const joinFilter = /.*\[JOIN\]\s?(.*)/
      const leaveFilter = /.*\[LEAVE\]\s?(.*)/
      const join = joinFilter.exec(`${data}`)
      const leave = leaveFilter.exec(`${data}`)
      const message = messageFilter.exec(`${data}`)
      const online = onlinePlayersFilter.exec(`${data}`)

      if(error)
       messageEmbedded("bananas", "Error", statusMessages.error.replace('__ERROR__', error[1]), 0xff0000)

      if(started.test(data)){
        event.trigger("started")
        server.online =true
      }

      if(join){
        const user = join[1].split(" ")[0]
        joinOrLeaveMessage("bananas", user, "joined")
      }else if(leave){
        const user = leave[1].split(" ")[0]
        joinOrLeaveMessage("bananas", user, "left")
      }else if(message){
        const data = message[1].split(" ")
        const user = data[0]
        const text = data.slice(1, data.length)
        chatMessage("bananas", user, text.join(" "))
      }else if(online){
        messageEmbedded("bananas", "Status", statusMessages.online.replace('__ONLINE__', online[1]), 0x0000ff)
      }
    })

    factorio_process.on('close', (code) => {
      event.trigger("stop")
      server.online = false
    });
    
    factorio_process.on('error', (err) => {
      console.log('Failed to start sub_process.');
    });

    process.on('SIGINT', async () => {
      console.log("Caught interrupt signal");
      factorio_process.kill('SIGHUP')
      this.process = undefined
      setTimeout(() => process.exit(), 1000)
    });
  
  }
}

const server = new Server()


client.on('message', async message => {

  if (message.author.bot) return
  if(message.type != "DEFAULT") return
  if(message.channel.name !== "bananas") return
  const messageAuthor = message.author.username



  if (message.content.startsWith('!')) {
    if (message.content.startsWith('!help'))
      printHelp("bananas")

    if (!message.member.roles.find(r => (r.name === "Administrator" || r.name === "Moderator"))) {
      message.reply("You don't have permissions to run that command :(")
      return
    }

    const param = message.content.split(/\s/g)[1]
    if (message.content.startsWith('!online')) {
      if(!server.online)
        messageEmbedded("bananas", "Error", "Server is currently not running", 0xff0000)
      else
        server.online_players()
    } else if (message.content.startsWith('!start')) {

      event.register("started", () => {
        messageEmbedded("bananas", "Status", statusMessages.start.replace('__USER__', messageAuthor), 0x00ff00)
      })

      await server.start("new")
      
    } else if (message.content.startsWith('!stop')) {

      await server.stop()
      event.register("stop", () => {
        messageEmbedded("bananas", "Status", statusMessages.stop.replace('__USER__', messageAuthor), 0xff0000)
      })

      
    } else if (message.content.startsWith('!restart')) {
      messageEmbedded("bananas", "Status", statusMessages.restart.replace('__USER__', messageAuthor), 0xffff00)
    }
  } else {
    if(!server.online) return
    const text = escapeString(message.cleanContent)
    server.message(message.author.username,text)

  }
})