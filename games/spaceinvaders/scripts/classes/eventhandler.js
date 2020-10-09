const EVENT_BASE_URL = 'http://'+window.location.hostname+':8081/event';

var EventHandler = (function() {
    return {
        addEvent: async function (input) {
            try {
                let response = await axios.post(EVENT_BASE_URL,input);
                console.log('event-response:'+response)
                return response;
            } catch (err) {
                console.log('event-error:'+err)
            }
        },
    };
})();

