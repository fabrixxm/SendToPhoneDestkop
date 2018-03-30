.pragma library
.import QtQuick.LocalStorage 2.0 as Storage

var db=null;

function openDatabase() {
    if (db === null) {
        db = Storage.LocalStorage.openDatabaseSync("SendToPhoneDesktop", "0.1", "SendToPhoneDesktopDatabase", 100);
    }

    db.transaction(function(tx){
        tx.executeSql('CREATE TABLE IF NOT EXISTS settings(setting TEXT UNIQUE, value TEXT)');
    });

    return db;
}

function set(setting, value) {
  var db = openDatabase();
  var res = "";
   db.transaction(function(tx) {
    var rs = tx.executeSql('INSERT OR REPLACE INTO settings VALUES (?,?);', [setting,value]);
      if (rs.rowsAffected > 0) {
       res = "OK";
      } else {
       res = "Error";
      }
    }
   );
   return res;
}

function get(setting, default_value) {
   var db = openDatabase();
   var res="";
   try {
    db.transaction(function(tx) {
     var rs = tx.executeSql('SELECT value FROM settings WHERE setting=?;', [setting]);
      if (rs.rows.length > 0) {
       res = rs.rows.item(0).value;
      } else {
       res = default_value;
      }
    })
   } catch (err) {
     console.log("Database " + err);
    res = default_value;
   };
   return res
}
