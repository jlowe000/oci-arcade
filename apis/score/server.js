'use strict';

const axios = require('axios');
const cors = require('cors')
const express = require('express');

// Constants
const SSL_PORT = 8081;
const PORT = 8080;
const HOST = '0.0.0.0';

const ORDS_HOSTNAME = process.env.ORDS_HOSTNAME;
const APEX_WORKSPACE = process.env.APEX_WORKSPACE;
const API_USER = process.env.API_USER;
const API_PASSWORD = process.env.API_PASSWORD;
const EVENT_FNID = process.env.EVENT_FNID;
const token_refresh_interval = 1800000;

let access_token = '';

function getToken() {
    console.log('retrieve token');
    axios.post('https://'+ORDS_HOSTNAME+'/ords/'+APEX_WORKSPACE+'/oauth/token', 'grant_type=client_credentials', { auth: { username: API_USER, password: API_PASSWORD }})
    .then(oauthres => {
        access_token = oauthres.data.access_token;
        console.log('token:'+access_token);
    })
    .catch(err => {
        console.log(err);
        exit(-1);
    });
}

getToken();
setInterval(getToken, token_refresh_interval);

// App
const app = express();

let event_fns = {};
let app_id = null;

app.use(express.json());
app.use(cors());

app.get('/', (req, res) => {
  res.send('Hello World');
});

app.get('/score', (req, res) => {
  let game_id = req.query.game_id;
  axios.get('https://'+ORDS_HOSTNAME+'/ords/'+APEX_WORKSPACE+'/score_table/?q={"game_id":'+game_id+',"score":{"$notnull": null},"$orderby":{"score":"desc"}}', { headers: { 'Authorization': 'Bearer '+access_token }})
  .then(adwres => {
    res.send(adwres.data);
  })
  .catch(err => {
    console.log(err);
    res.send('{ "response" : "bad" }');
  });
});

app.post('/score', (req, res) => {
  axios.post('https://'+ORDS_HOSTNAME+'/ords/'+APEX_WORKSPACE+'/score_table/', req.body, { headers: { 'Authorization': 'Bearer '+access_token }})
  .then(adwres => {
    res.send(adwres.data);
  })
  .catch(err => {
    console.log(err);
    res.send('{ "response" : "bad" }');
  });
});

app.post('/event/:action', (req, res) => {
  let fn_id = event_fns[req.params.action];
  console.log('action:',req.params.action);
  // let fn_id = event_fns['publishevent'];
  console.log('fn_id:',fn_id);
  console.log('body:',req.body);
  axios.post('http://fnserver:8080/invoke/'+fn_id, req.body, {headers: { 'Content-Type': 'application/json'}})
  .then(fnres => {
    res.send(fnres.data);
  })
  .catch(err => {
    console.log(err);
    res.send('{ "response" : "bad" }');
  });
});

axios.get('http://fnserver:8080/v2/apps?name=events')
.then(fnres => {
    console.log('data:',fnres.data);
    app_id = fnres.data.items[0]['id'];
    console.log('app:'+app_id);
    axios.get('http://fnserver:8080/v2/fns?app_id='+app_id)
    .then(fnres => {
        console.log('data:',fnres.data);
        for (let idx in fnres.data.items) {
            console.log('item:',fnres.data.items[idx]);
            let item = fnres.data.items[idx];
            event_fns[item['name']] = item['id'];
        }
        console.log('fns:',event_fns);
    })
    .catch(err => {
        console.log(err);
    });
})
.catch(err => {
  console.log(err);
});

// app.listen(PORT, HOST);

const http = require('http');
const https = require('https');
const fs = require('fs');

const options = {
  key: fs.readFileSync('/root/keys/key.pem'),
  cert: fs.readFileSync('/root/keys/cert.pem'),
  passphrase: API_PASSWORD
};

http.createServer(app.handle.bind(app)).listen(PORT, HOST);
https.createServer(options,app.handle.bind(app)).listen(SSL_PORT, HOST);

console.log('Running on http://'+HOST+':'+PORT);
console.log('Running on https://'+HOST+':'+SSL_PORT);

