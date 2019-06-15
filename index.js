const { spawn } = require('child_process');
const readline = require('readline');

/*
const cmd = '/opt/factorio/bin/x64/factorio'
const factorio = spawn(cmd, ["--start-server-load-scenario", "forbidden_planet", "--server-settings", "/opt/factorio/scenarios/forbidden_planet/server-settings.json"]);


const rl = readline.createInterface({
  input: process.stdin,
});


rl.on("line", data => {
  console.log(`[Internal] ${data}`)
 factorio.stdin.write(`${data}\n`)
})

factorio.stderr.on('data', (data) => {
  console.log(`stderr: ${data}`);
});


factorio.stdout.on("data", data => {
  console.log(`stdout: ${data}`);
})

factorio.on('error', (err) => {
  console.log('Failed to start subprocess.');
});
*/

// --------------------------------------------- Discord stuff

const Discord = require('discord.js');
const client = new Discord.Client();
const auth = require('./auth')

client.on('ready', () => {
  console.log(`Logged in as ${client.user.tag}!`);
});

client.on('message', msg => {
  if (msg.content === 'ping') {
    msg.reply('Pong!');
  }
});

client.login(auth.token);