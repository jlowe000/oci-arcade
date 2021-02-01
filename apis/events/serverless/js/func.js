const fdk=require('@fnproject/fdk');
const axios=require('axios');

let access_token = '';

let ORDS_HOSTNAME = '';
let APEX_WORKSPACE = '';
let API_USER = '';
let API_PASSWORD = '';

const token_refresh_interval = 1800000;

function getToken() {
    console.log('retrieve token');
    if (ORDS_HOSTNAME != '') {
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
}

getToken();
setInterval(getToken, token_refresh_interval);

async function addEvent(input,ctx) {
    ORDS_HOSTNAME = ctx.config['ORDS_HOSTNAME'];
    APEX_WORKSPACE= ctx.config['APEX_WORKSPACE'];
    API_USER = ctx.config['API_USER'];
    API_PASSWORD= ctx.config['API_PASSWORD'];
    getToken();
    adwres = await axios.post('https://'+ORDS_HOSTNAME+'/ords/'+APEX_WORKSPACE+'/event_table/', input, { headers: { 'Authorization': 'Bearer '+access_token }});
    return adwres.data;
}

fdk.handle(function(input,ctx){
  try {
    return addEvent(input,ctx);
  } catch (error) {
    console.log(error);
    return { 'response' : 'bad' };
  }
})
