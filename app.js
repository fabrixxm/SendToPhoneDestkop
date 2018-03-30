.import "storage.js" as Storage


function loadSettings() {
    return {
        ip: Storage.get("ip", ""),
        port: Storage.get("port", ""),
        code: Storage.get("code",""),

        set: function(ip, port, code) {
            this.ip = ip;
            this.port = port;
            this.code = code;
            saveSettings(this);
        }
    }
}


function saveSettings(setings) {
    for(var k in settings) {
        if (k!=="set") Storage.set(k, settings[k]);
    }
}



function connect() {
    _fetch("options")
    .then(function(data){
        window.api_list = data.api_list;
        window.platform = data.platform;
        window.api_version = data.api_version;
        window.connected = true;
    }).catch(function(e){
        console.error(e);
        errorMessage.showError(e);
        window.connected = false;
    });

}


function startup() {
    if (window.settings.ip !=="") connect();
}


function _fetch(api, data, method, postdata) {

    var ret = {
        resolve: function(data, doc){},
        error: function(error, doc){},
        then: function(cbk){ if (cbk!==undefined) this.resolve = cbk.bind(this); return this  },
        catch: function(cbk){ if (cbk!==undefined) this.error = cbk.bind(this); return this },
    }

    var doc = new XMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState === XMLHttpRequest.DONE){
            if(doc.status >= 200 && doc.status < 400) {
                console.log(doc.responseText)
                try {
                    if (doc.responseText==="") {
                        ret.resolve("", doc);
                    } else {
                        ret.resolve(JSON.parse(doc.responseText), doc);
                    }
                } catch(e) {
                    ret.error(e.toString(), doc);
                }
            } else if ( doc.status >= 400) {
                ret.error(doc.statusText.toString() + " ("+doc.status+")", doc);
            } else if ( doc.status < 100) {
                window.connected = false;
                ret.error("Unable to connect", doc);
            }
        }
    }

    var url = "http://"+window.settings.ip+":"+window.settings.port+"/?app="+window.settings.code+"&api="+api;
    if (data !== undefined) url = url + "&data="+data

    if (method===undefined) method="get";

    if (method==="get") {
        console.log("GET", url);
        doc.open("GET", url);
        doc.send();

    } else if (method==="post") {
        doc.open("POST", url)
        doc.setRequestHeader("Content-Type", "application/json; charset=utf-8");
        if (postdata !== undefined) {
            postdata = JSON.stringify(postdata);
        } else {
            postdata = "";
        }

        console.log("POST", url, postdata);
        doc.send(postdata)

    } else {
        return null; // errore se il metodo è sbagliato
    }
    return ret;
}

