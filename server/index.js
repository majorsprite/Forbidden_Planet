const { spawn } = require('child_process');
const readline = require('readline');

const cmd = '/opt/factorio/bin/x64/factorio'

const constants = {
  LATEST : '--start-server-load-latest',
  NEW: '--start-server-load-scenario'
}

let factorio_process = undefined


const rl = readline.createInterface({
  input: process.stdin,
});

const startServer = (params, msg = "started") => {


  if(factorio_process)
    return

  if(params == 'NEW')
    factorio_process = spawn(cmd, [constants.NEW, "forbidden_planet", "--server-settings", "/opt/factorio/scenarios/forbidden_planet/server-settings.json"]);
  else if (params == 'LATEST')
    factorio_process = spawn(cmd, [constants.LATEST, "--server-settings", "/opt/factorio/scenarios/forbidden_planet/server-settings.json"]);

  message("bananas", `[SERVER] ${msg}.`)
  
  rl.on("line", data => {
    console.log(`[Internal] ${data}`)
    factorio_process.stdin.write(`${data}\n`)
  })
  
  factorio_process.stderr.on('data', (data) => {
    console.log(`stderr: ${data}`);
  });
  
  
  factorio_process.stdout.on("data", data => {



    const messageFilter = /.*\[CHAT\]\s?(.*)/
    const match = messageFilter.exec(`${data}`)

    const fail_filter = /.*Error(.*)/
    const fail = fail_filter.exec(`${data}`)
    if(match)
      message("bananas", match[1])

    if(fail)
      message("bananas",`[FAILED] ${fail[1]}`)
  })
  
  factorio_process.on('error', (err) => {
    console.log('Failed to start subprocess.');
  });

  factorio_process.on('close', (code) => {
    factorio_process = undefined
    console.log(`child process exited with code ${code}`);
  });
}

const stopServer = (params) => {
  if(factorio_process)
    factorio_process.kill('SIGHUP')
  message("bananas", "[SERVER] stopped.")
  return true
}

const restartServer = (params) => {

  if(!factorio_process)
    return startServer(params)

  message("bananas", "[SERVER] stopping the server please hold... restarting in ~30 sec")
  stopServer()
  setTimeout(() => startServer(params, "restarted"), 1000 * 30)
  return true
}



// --------------------------------------------- Discord stuff

const Discord = require('discord.js');
const client = new Discord.Client();
const auth = require('./auth')

const escapeMessage = message => {

  let escaped = message.replace(/\n/g, "")
  escaped = escaped.replace(/(["'\\])/g, "\\$1")
  return escaped
}

client.on('ready', () => {
  console.log(`Logged in as ${client.user.tag}!`);
});

client.on('message', message => {
  if(message.type != "DEFAULT") return
  const text = escapeMessage(message.cleanContent)
  if(message.author.bot) return
  if(message.channel.name == "bananas"){

    const commandFilter = /^!(.*)/
    const command = commandFilter.exec(text)
    if(command){
      if(command.length > 1){
        if(message.member.roles.find(r => r.name === "Administrator") || message.member.roles.find(r => r.name === "Moderator")){
          const temp = command[1].split(" ")
          const cmd = temp[0]
          const target = temp[1]
          const args = temp.slice(2, temp.length).join(" ")

          if(cmd == "kick"){
            if(factorio_process)
              factorio_process.stdin.write(`/silent-command game.kick_player("${target}")\n`)
            message.channel.send(`${message.author.username} ran command: ${cmd} with args: ${args}`)
          }else if(cmd == "restart"){
            const temp = target == "new" ? "NEW" : "LATEST" 
            console.log(`restart ${target}`)
            const restarted = restartServer(temp)
          }else if(cmd == "stop"){
            console.log(`stop`)
            const stopped = stopServer()
          }else if(cmd == "start"){
            const temp = target == "new" ? "NEW" : "LATEST" 
            console.log(`start ${target}`)
            const started = startServer(temp)
          }
        }
      }
    }else{
      if(factorio_process)
        factorio_process.stdin.write(`/silent-command game.print("[Discord](${message.author.username}): ${text}", { r = 0.4, g = 0.6, b = 0.7})\n`)
    }
  }
});

client.login(auth.token);


const message = (channelName, message) => {
  const bananas = client.channels.find(channel => channel.name === channelName)
  if(!bananas) return
  bananas.send(message)
}