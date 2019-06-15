const { spawn } = require('child_process');
const readline = require('readline');


const cmd = '/opt/factorio/bin/x64/factorio'


const factorio = spawn(cmd, ["--start-server-load-scenario", "forbidden_planet", "--server-settings", "/opt/factorio/scenarios/forbidden_planet/server-settings.json"]);
const rl = readline.createInterface({
  input: process.stdin,
  output: factorio.stdout
});

rl.on("line", data => {
  console.log(`[Internal] ${data}`)
  rl.write(data)
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