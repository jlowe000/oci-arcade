const fdk=require('@fnproject/fdk');
const axios=require('axios');

async function addEvent(input) {
    adwres = await axios.post('https://@APEX_HOSTNAME@/ords/@APEX_SCHEMA@/event_table/', input, { auth: { username: '@APEX_USER@', password: '@APEX_PASSWORD@' }});
    return adwres.data;
}

fdk.handle(function(input,ctx){
  try {
    return addEvent(input);
  } catch (error) {
    console.log(error);
    return { 'response' : 'bad' };
  }
})
