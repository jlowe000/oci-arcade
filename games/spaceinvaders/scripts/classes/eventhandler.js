window.pubType = sessionStorage.getItem("pubtype");
var EVENT_BASE_URL = 'https://'+API_HOSTNAME+':8081/event/'+window.pubType;

var EventHandler = (function() {
    return {
        addEvent: async function (input) {
            try {
		if (window.pubType !== "none") {
                    let response = await axios.post(EVENT_BASE_URL,input);
                    console.log('event-response:'+response)
                    return response;
                }
            } catch (err) {
                console.log('event-error:'+err)
            }
        },
    };
})();

