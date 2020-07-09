WorkerScript.onMessage = function(msg){

    WorkerScript.sendMessage({'isWorking': true})

    var values = msg.list_data
    var model = msg.model

    model.clear()

    for(var i=0;i<values.length;i++) {
        var map_data = values[i]

        model.append({'map_data' : map_data})
        model.sync()
    }

    WorkerScript.sendMessage({'isWorking': false})
}
