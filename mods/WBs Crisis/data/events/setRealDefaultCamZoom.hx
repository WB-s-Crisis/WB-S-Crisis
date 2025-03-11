function onEvent(eventEvent) {
    var params:Array = eventEvent.event.params;
    if (eventEvent.event.name == "setRealDefaultCamZoom") {
        realDefaultCamZoom = params[0];
    }
}