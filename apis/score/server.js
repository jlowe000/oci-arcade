'use strict';

const axios = require('axios');
const cors = require('cors')
const express = require('express');

// Constants
const PORT = 8081;
const HOST = '0.0.0.0';

const ORDS_HOSTNAME = process.env.ORDS_HOSTNAME;
const APEX_WORKSPACE = process.env.APEX_WORKSPACE;
const API_USER = process.env.API_USER;
const API_PASSWORD = process.env.API_PASSWORD;

// App
const app = express();

app.use(express.json());
app.use(cors());

app.get('/', (req, res) => {
  res.send('Hello World');
});

app.get('/score', (req, res) => {
  let game_id = req.query.game_id;
  axios.get('https://'+ORDS_HOSTNAME+'/ords/'+APEX_WORKSPACE+'/score_table/?q={"game_id":'+game_id+',"score":{"$notnull": null},"$orderby":{"score":"desc"}}', { auth: { username: API_USER, password: API_PASSWORD  }})
  .then(adwres => {
    res.send(adwres.data);
  })
  .catch(err => {
    console.log(err);
    res.send('{ "response" : "bad" }');
  });
});

app.post('/score', (req, res) => {
  axios.post('https://'+ORDS_HOSTNAME+'/ords/'+APEX_WORKSPACE+'/score_table/', req.body,{ auth: { username: API_USER, password: API_PASSWORD  }})
  .then(adwres => {
    res.send(adwres.data);
  })
  .catch(err => {
    console.log(err);
    res.send('{ "response" : "bad" }');
  });
});

app.post('/event', (req, res) => {
  axios.post('http://fnserver:8080/invoke/@EVENT_FN_ID@', req.body, {headers: { 'Content-Type': 'application/json'}})
  .then(fnres => {
    res.send(fnres.data);
  })
  .catch(err => {
    console.log(err);
    res.send('{ "response" : "bad" }');
  });
});

app.listen(PORT, HOST);
console.log('Running on http://'+HOST+':'+PORT);
