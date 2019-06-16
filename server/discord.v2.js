const { Client, RichEmbed, Attachment } = require('discord.js');
const { ServerCommands, ServerController } = require('./server_control.js')

const auth = require('./auth')



class DiscordCommands {
  constructor(client) {
    if(!client) throw new Error("No client")
    const serverController = new ServerController()
    const serverCommands = new ServerCommands(serverController)

    this.client = client
    this.serverCommands = serverCommands 
    this.commands = {
      start: {
        params: "*<**new** | **latest**>* *default:* **latest**",
        info: "starts the server",
        usage: "!start latest",
        permissions: "@Trusted",
        execute: () => console.log("executed start")
      }
    }

    
  }

  messageEmbedded(channelName, title, message, color = 0xff0000, attachment){

    const channel = client.channels.find(channel => channel.name === channelName)
    if (!channel) return
  
    const embed = new RichEmbed()
      .setTimestamp()
      .setTitle(`**${title}**`)
      .setColor(color)
      .setDescription(message)
  
    if(attachment)
    channel.send(embed.attachFile(attachment))
    else
    channel.send(embed)
  }

  listCommands(channelName){
    const { client, commands } = this
    const channel = client.channels.find(channel => channel.name === channelName)
    if (!channel) return
    
    let string = ""
    for (let [name, value] of Object.entries(commands)) {
      string += `**!${name}** ${value.params}\n\t↳ ${value.info}\n\t↳ Usage: \`${value.usage}\`\n↳Permissions: **${value.permissions}**\n\n`
    }
    this.messageEmbedded(channelName, "Commands", string, 0xaa55ff)
  }
}

const client = new Client();
client.login(auth.token)

const discord = new DiscordCommands(client)
setTimeout(() => discord.listCommands("bananas"), 1000)



