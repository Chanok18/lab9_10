// Verificación visual opcional mediante Chrome DevTools, sin dependencias npm.
import { spawn } from 'node:child_process';
import { mkdir, writeFile } from 'node:fs/promises';
import path from 'node:path';

const pause = ms => new Promise(resolve => setTimeout(resolve, ms));
const chrome = spawn('C:/Program Files/Google/Chrome/Application/chrome.exe', [
  '--headless=new', '--remote-debugging-port=9223',
  `--user-data-dir=${path.resolve('build/chrome-check')}`,
  '--no-first-run', '--no-default-browser-check', 'about:blank',
], { windowsHide: true, stdio: 'ignore' });
let socket;
try {
  let targets;
  for (let i = 0; i < 30; i++) {
    try { targets = await (await fetch('http://127.0.0.1:9223/json')).json(); break; }
    catch { await pause(300); }
  }
  if (!targets) throw new Error('Chrome no inició el depurador.');
  const target = targets.find(t => t.type === 'page');
  socket = new WebSocket(target.webSocketDebuggerUrl);
  await new Promise(resolve => socket.addEventListener('open', resolve, { once: true }));
  let nextId = 0;
  const pending = new Map();
  const errors = [];
  const responses = [];
  socket.addEventListener('message', event => {
    const data = JSON.parse(event.data);
    if (data.id) {
      const callback = pending.get(data.id);
      pending.delete(data.id);
      if (data.error) callback?.reject(new Error(JSON.stringify(data.error)));
      else callback?.resolve(data.result);
    }
    if (data.method === 'Runtime.exceptionThrown') errors.push(data.params.exceptionDetails);
    if (data.method === 'Runtime.consoleAPICalled') {
      const message = data.params.args.map(a => a.value ?? a.description ?? '').join(' ');
      if (/RenderFlex|overflowed|EXCEPTION CAUGHT/i.test(message)) errors.push(message);
    }
    if (data.method === 'Network.responseReceived' && /images\.unsplash\.com|www\.omdbapi\.com|m\.media-amazon\.com/.test(data.params.response.url)) {
      const url = new URL(data.params.response.url);
      // No guardamos parámetros de consulta: podrían incluir una API key.
      responses.push({ url: url.origin + url.pathname, status: data.params.response.status });
    }
  });
  const call = (method, params = {}) => new Promise((resolve, reject) => {
    const id = ++nextId;
    pending.set(id, { resolve, reject });
    socket.send(JSON.stringify({ id, method, params }));
  });
  await call('Runtime.enable');
  await call('Network.enable');
  await call('Page.enable');
  await call('Emulation.setDeviceMetricsOverride', { width: 390, height: 844, deviceScaleFactor: 1, mobile: true });
  await call('Page.navigate', { url: process.env.LAB_URL || 'http://localhost:7359' });
  let ready = false;
  for (let i = 0; i < 80; i++) {
    const state = await call('Runtime.evaluate', {
      expression: '(() => { function rendered(root) { for (const el of root.querySelectorAll("*")) { if (el.tagName === "CANVAS") return true; if (el.shadowRoot && rendered(el.shadowRoot)) return true; } return false; } return rendered(document); })()',
      returnByValue: true,
    });
    if (state.result.value) { ready = true; break; }
    await pause(500);
  }
  console.log(`Canvas listo: ${ready}`);
  if (!ready) throw new Error('Flutter no terminó de renderizar en el tiempo esperado.');
  await pause(4000);
  await mkdir('docs/capturas', { recursive: true });
  const screenshot = async name => {
    const shot = await call('Page.captureScreenshot', { format: 'png' });
    await writeFile(`docs/capturas/${name}.png`, Buffer.from(shot.data, 'base64'));
  };
  const click = async (x, y) => {
    await call('Input.dispatchMouseEvent', { type: 'mousePressed', x, y, button: 'left', clickCount: 1 });
    await call('Input.dispatchMouseEvent', { type: 'mouseReleased', x, y, button: 'left', clickCount: 1 });
    await pause(700);
  };
  await screenshot('01-inicio');
  for (const [x, name] of [[146, '02-peliculas'], [244, '03-series'], [342, '04-suscripciones']]) {
    await click(x, 800);
    await screenshot(name);
  }
  await click(49, 800);
  await click(140, 490);
  await screenshot('05-detalle');
  await writeFile('docs/capturas/verificacion.json', JSON.stringify({ viewport: '390x844', errors, remoteImages: responses }, null, 2));
  console.log(JSON.stringify({ errors: errors.map(e => typeof e === 'string' ? e : e.exception?.description?.slice(0, 500)), remoteImages: responses, screenshots: 5 }));
  await call('Browser.close');
  if (errors.length) process.exitCode = 1;
} finally {
  socket?.close();
  chrome.kill();
}
