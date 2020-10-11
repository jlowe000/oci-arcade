const fdk=require('@fnproject/fdk');
const axios=require('axios');

async function addEvent(input,ctx) {
    hostname = ctx.config['ORDS_HOSTNAME'];
    workspace = ctx.config['APEX_WORKSPACE'];
    username = ctx.config['API_USER'];
    password = ctx.config['API_PASSWORD'];
    adwres = await axios.post('https://'+hostname+'/ords/'+workspace+'/event_table/', input, { auth: { username: username, password: password }});
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
