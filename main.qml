import QtQuick 2.12
import QtQuick.Window 2.12

Window {
    visible: true
    width: 640
    height: 480

	 title: "Hello World"

    Component.onCompleted: {
        var sample_list = []

        for(var i=0;i<10;i++) {
            var sample_item = {}
            sample_item["Status"] = "Status " + i
            sample_item["File Name"] = "File Name " + i

            sample_list.push(sample_item)
        }

        var msg = {'model': tableView.model, 'list_data': sample_list}

        tableView.worker.sendMessage(msg)
    }

    EasyTableView {
        id: tableView

        width: parent.width * 0.9; height: parent.height * 0.8

        anchors.centerIn: parent

        arrHeaderTitles: ["Status", "File Name"]
        arrWidthRatio: [0.25, 0.75]
    }
}
