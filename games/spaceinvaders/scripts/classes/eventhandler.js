const EVENT_BASE_URL = 'https://'+API_HOSTNAME+':8081/event/serverless';

var EventHandler = (function() {
    return {
        addEvent: async function (input) {
            try {
		console.log("instance_id (event):"+instance_id);
                let response = await axios.post(EVENT_BASE_URL,input);
                console.log('event-response:'+response)
                return response;
            } catch (err) {
                console.log('event-error:'+err)
            }
        },
    };
})();

