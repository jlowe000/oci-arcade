'use strict';

const axios = require('axios');
const cors = require('cors')
const express = require('express');

// Constants
const PORT = 8081;
const HOST = '0.0.0.0';

// App
const app = express();

app.use(express.json());
app.use(cors());

app.get('/', (req, res) => {
  res.send('Hello World');
});

app.get('/score', (req, res) => {
  axios.get('https://@ADW_APEX_HOSTNAME@/ords/@APEX@/score_table/?q={"game_id":"1","score":{"$notnull": null},"$orderby":{"score":"desc"}}', { auth: { username: '@APEX_USER@', password: '@APEX_PASSWORD@' }})
  .then(adwres => {
    res.send(adwres.data);
  })
  .catch(err => {
    console.log(err);
    res.send('{ "response" : "bad" }');
  });
});

app.post('/score', (req, res) => {
  axios.post('https://@ADW_APEX_HOSTNAME@/ords/@APEX@/score_table/', req.body, { auth: { username: '@APEX_USER@', password: '@APEX_PASSWORD@' }});
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
