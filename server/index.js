/**
 * TODO: Need to add a check to ensure server is running/process exists before running in-game commands (kick, ban, promote)
 */



const { Client, RichEmbed, Attachment } = require('discord.js');
const { ServerCommands, ServerController } = require('./lib/server_control')
const Event = require('./lib/event')

const auth = require('./auth')

const escapeString = message => {
  let escaped = message.replace(/\n/g, "")
  escaped = escaped.replace(/(["'\\])/g, "\\$1")
  return escaped
}


class DiscordCommands{

  constructor(discord, options){

    if(!discord) throw new Error('No discord client')
    this.discord = discord 
    this.options = Object.assign({
      prefix: '!',
      channel: 'bananas',
      roles: ['Administrator', 'Moderator', 'Trusted', 'Everyone'],
      commands: {
        help:{
          params: ['command'],
          info: 'List commands',
          usage: '!help',
          permissions: 'Everyone',
          enabled: true
        },
        kick: {
          params: ['name', '⃰reason'],
          info: 'Kicks a player from the server',
          usage: '!kick Banana',
          permissions: 'Trusted',
          enabled: true
        },
        ban: {
          params: ['name', '⃰reason'],
          info: 'Bans a player from the server',
          usage: '!ban Banana',
          permissions: 'Moderator',
          enabled: true
        },
        unban: {
          params: ['name'],
          info: 'Unban a player from the server',
          usage: '!unban Banana',
          permissions: 'Moderator',
          enabled: true
        },
        promote: {
          params: ['name'],
          info: 'Promotes a player',
          usage: '!promote Banana',
          permissions: 'Administrator',
          enabled: true
        },
        demote: {
          params: ['name'],
          info: 'Demotes a player',
          usage: '!demote Banana',
          permissions: 'Administrator',
          enabled: true
        },
        start: {
          params: ['⃰new | ⃰latest', '⃰save'],
          info: 'Starts the server',
          usage: '!start',
          permissions: 'Moderator',
          enabled: true
        },
        stop: {
          params: [],
          info: 'Stops the server',
          usage: '!stop',
          permissions: 'Administrator',
          enabled: true
        },
      }
    }, options)
  }

  isCommand(message){
    const { discord } = this
    const { prefix, commands, channel } = this.options
    const content = message.content
    
    if(content.startsWith(prefix)){
      const command = content.substr(1).split(/\s+/)[0]
      const found = commands[command] ? true : false
      if(!found)
      discord.embed(channel, 'Error:','Command not found.\nSee !help for a list of all commands')
      return found
    }else{
      return false
    }
  }

  checkPermissions(command, message){

    const { roles, commands } = this.options
    const permission = commands[command].permissions
    let userRole = roles.length - 1

    for(let index in roles){
      if(message.member.roles.find(r => r.name === roles[index])){
        userRole = index
        break
      }
    }
    
    
    const requiredRole = roles.indexOf(permission)
  
    if(requiredRole >= userRole)
      return true
    else
      return false
  }

  runCommand(message){

    const { discord } = this
    const { channel, commands } = this.options
    const content = message.content
    const command = content.substr(1).split(/\s+/)[0]
    let params  = content.substr(command.length+2).split(/\s+/)
    const author = message.author.username


    params.unshift(author)



    if(!commands[command].enabled){
      discord.embed(channel, 'Error:','Command has been disabled.\nSee !help for a list of all commands')
      return
    }

    if(!this.checkPermissions(command, message)){
      discord.embed(channel, 'Error:','You do not have the right permissions to run this command 😢')
      return
    }

    switch(command){
      case 'help':
        this.help(...params)
        break
      case 'kick':
        this.kick(...params)
        break
      case 'ban':
        this.ban(...params)
        break
      case 'unban':
        this.unban(...params)
        break
      case 'promote':
        this.promote(...params)
        break
      case 'demote':
        this.demote(...params)
        break
      case 'start':
        this.start(...params)
        break
      case 'stop':
        this.stop(...params)
        break
    }
  }

  help(invoker, command){
    const { commands, channel } = this.options
    const { discord } = this
    

    if(command && !commands[command]){
      discord.embed(channel, 'Error:','Unknown command.\nSee !help for a list of all commands')
      return
    }

    const tmp = {}
    tmp[command] = commands[command]

    const list = command ? tmp: commands
    
    
    let string = ''
    for (let [name, value] of Object.entries(list)) {
      const params = value.params.length >= 1 ? `<**${value.params.join('**> <**')}**>` : ''
      value.enabled
      string += `**!${name}** ${params}\n\t↳ ${value.info}\n\t↳ Usage: \`${value.usage}\`\n↳ Permissions: **${value.permissions}**\n↳ Enabled: **${value.enabled}**\n\n`
    }
    discord.embed(channel, 'Server Commands', string, 0xffff00)
  }

  kick(invoker, target, ...params){
    const { discord } = this
    const { channel } = this.options
    params = params.length >= 1 ? params : undefined

    if(!target){
      discord.embed(channel, 'Error:','User not specified.\nSee **!help kick** for more information')
      return
    }
    discord.serverCommands.kick(target, params ? params.join(' ') : params, invoker)
    discord.embed(channel, 'Success:',`**${invoker}** kicked **${target}** with reason '${params ? params.join(' ') : params}'`, 0x00ff00)
  }

  ban(invoker, target, ...params){
    const { discord } = this
    const { channel } = this.options
    params = params.length >= 1 ? params : undefined

    if(!target){
      discord.embed(channel, 'Error:','User not specified.\nSee **!help ban** for more information')
      return
    }
    discord.serverCommands.ban(target, params ? params.join(' ') : params, invoker)
    discord.embed(channel, 'Success:',`**${invoker}** banned **${target}** with reason '${params ? params.join(' ') : params}'`, 0x00ff00)
  }

  unban(invoker , target){
    const { discord } = this
    const { channel } = this.options


    if(!target){
      discord.embed(channel, 'Error:','User not specified.\nSee **!help ban** for more information')
      return
    }
    discord.serverCommands.unban(target, invoker)
    discord.embed(channel, 'Success:',`**${invoker}** un-banned **${target}**`, 0x00ff00)
  }

  promote(invoker, target){
    const { discord } = this
    const { channel } = this.options


    if(!target){
      discord.embed(channel, 'Error:','User not specified.\nSee **!help ban** for more information')
      return
    }
    discord.serverCommands.promote(target, invoker)
    discord.embed(channel, 'Success:',`**${invoker}** promoted **${target}**`, 0x00ff00)
  }

  demote(invoker, target){
    const { discord } = this
    const { channel } = this.options


    if(!target){
      discord.embed(channel, 'Error:','User not specified.\nSee **!help ban** for more information')
      return
    }
    discord.serverCommands.demote(target, invoker)
    discord.embed(channel, 'Success:',`**${invoker}** demoted **${target}**`, 0x00ff00)
  }

  start(invoker, params){
    const { discord } = this
    const { channel } = this.options
    params = params.length >= 1 ? params : undefined
    discord.serverCommands.start(params)
    .then(() => discord.send(channel, `**${invoker}** Initialized a server start. Please hold`))
    .catch(e => discord.embed(channel, 'Error:', 'Something went wrong during the Initialization 😢'))
  }

  stop(invoker){
    const { discord } = this
    const { channel } = this.options
    discord.serverCommands.stop()
    .then(() => discord.send(channel, `**${invoker}** Initialized a server stop. Please hold`))
    .catch(e => discord.embed(channel, 'Error:', 'Something went wrong during the Initialization 😢'))
  }
}


class Discord {

  constructor(client, options) {
    if(!client) throw new Error('No client')
    const serverController = new ServerController()
    const serverCommands = new ServerCommands(serverController)
    this.events = new Event()
    this.client = client
    this.serverCommands = serverCommands 

    this.options = Object.assign({
      channel: 'bananas'
    }, options)

    client.on('message', message => {
      if (message.author.bot) return
      this.events.trigger('message', message)
    })


    
    const { channel } = this.options
    let gameChannel
    serverController.on('start', (event) => {
      this.embed(channel, 'Success:', 'The server has started 👍', 0x00ff00)
      const guild = client.guilds.first()
      const gameChannel = guild.channels.find(c => c.name == "in-game" || c.name == "offline")
      if(gameChannel){
        if(gameChannel.name === "offline")
            gameChannel.setName('in-game')
      }
    })

    serverController.on('stop', (event) => {
      this.embed(channel, 'Success:', 'The server has stopped 👍', 0x00ff00)

      const guild = client.guilds.first()
      const gameChannel = guild.channels.find(c => c.name == "in-game")
      if(gameChannel)
        gameChannel.setName('offline')

    })

    serverController.on('initializationFailed', (event) => {
      this.embed(channel, 'Initialization failed:', 'Something went wrong. check the logs for more info')
    })

    

    serverController.on('chat', (event) => {
      const guild = client.guilds.first()
      const gameChannel = guild.channels.find(c => c.name == "in-game" || c.name == "offline")
      if(!gameChannel) {
        console.log("no game channel")
        return
      }
      const data = event.data.split(/\s+/)
      const user = data.shift();
      const message = data.join(' ')
      this.send(gameChannel.name, `**${user}** ${message}`)
    })

    serverController.on('join', (event) => {
      console.log("join")
      const guild = client.guilds.first()
      const gameChannel = guild.channels.find(c => c.name == "in-game" || c.name == "offline")
      if(!gameChannel) {
        console.log("no game channel")
        return
      }
      const data = event.data.split(/\s+/)
      this.send(gameChannel.name, `⟶ **${data[0]}** *joined* the **game** ⟵`)
    })

    serverController.on('leave', (event) => {
      console.log("leave")
      const guild = client.guilds.first()
      const gameChannel = guild.channels.find(c => c.name == "in-game" || c.name == "offline")
      if(!gameChannel) {
        console.log("no game channel")
        return
      }
      const data = event.data.split(/\s+/)
      this.send(gameChannel.name, `⟶ **${data[0]}** *left* the **game** ⟵`)
    })


  }

  on(event, callback) {
    this.events.register(event, callback)
  }

  embed(channelName, title, message, color = 0xff0000, attachment){

    const channel = client.channels.find(channel => channel.name === channelName)
    if (!channel) return
  
    const embed = new RichEmbed()
      .setTimestamp()
      .setTitle(`**${title}**`)
      .setColor(color)
      .setDescription(message)
  
    if(attachment)
      return channel.send(embed.attachFile(attachment))
    else
      return channel.send(embed)
  }

  send(channelName, message){
    const channel = client.channels.find(channel => channel.name === channelName)
    if (!channel) return

    return channel.send(message)
  }
}



const client = new Client();
client.login(auth.token)

const discord = new Discord(client)
const commands = new DiscordCommands(discord)

discord.on('message', (message) => {

  if(commands.isCommand(message)){
    if(message.channel.name !== discord.options.channel) return
    commands.runCommand(message)
    return
  }
  if(message.channel.name !== 'in-game') return
  console.log("normal chat")
  const user = message.author.username
  const text = escapeString(message.cleanContent)
  console.log(user, text)
  discord.serverCommands.discordMessage(message.author.username,text)
  
}) 


process.on('SIGINT', function() {
  discord.serverCommands.stop()
  setTimeout(() => process.exit(), 3000)
});


