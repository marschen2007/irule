/* ###################################### */  
/* index.js counterpart for mysql_irulelx */  
  
/* Log debug to /var/log/ltm? 0=none, 1=errors only, 2=verbose */  
var debug = 2;  
if (debug >= 2) {console.log('Running extension1 index.js');}  
  
/* Import the f5-nodejs module. */  
var f5 = require('f5-nodejs');  
  
/* Create a new rpc server for listening to TCL iRule calls. */  
var ilx = new f5.ILXServer();  
  
/* Start listening for ILX::call and ILX::notify events. */  
ilx.listen();  
  
/* Add a method and expect a username parameter and reply with response */  
ilx.addMethod('myql_nodejs', function(username, response) {  
  
    if (debug >= 1) {console.log('my_nodejs' + ' ' + typeof(username.params()) + ' = ' + username.params());}  
  
    var mysql = require('mysql');  
    var connection = mysql.createConnection({  
        host     : '10.0.0.110',  
        user     : 'bigip',  
        password : 'bigip'  
    });  
  
    // Connect to the MySQL server  
    connection.connect(function(err) {  
        if (err) {  
            if (debug >= 1) {console.error('Error connecting to MySQL: ' + err.stack);}  
            return;  
        }  
        if (debug >= 2) {console.log('Connected to MySQL as ID ' + connection.threadId);}  
    });  
  
    // Perform the query. Escape the user-input using mysql.escape: https://www.npmjs.com/package/mysql#escaping-query-values  
    connection.query('SELECT * from users_db.users_table where name = ' + mysql.escape(username.params(0)), function(err, rows, fields) {  
        if (err) {  
            // MySQL query failed for some reason, so send a null response back to the Tcl iRule  
            if (debug >= 1) {console.error('Error with query: ' + err.stack);}  
            response.reply('');  
            return;  
        } else {  
            // Check for no result from MySQL  
            if (rows < 1){  
                if (debug >= 1) {console.log('No matching records from MySQL');}  
  
                // Return -1 to the Tcl iRule to show no matching records from MySQL  
                response.reply('-1');  
            } else {  
                if (debug >= 2) {console.log('First row from MySQL is: ', rows[0]);}  
                //Return the group field from the first row to the Tcl iRule  
                response.reply(rows.pop());  
            }  
        }  
    });  
    // Close the MySQL connection  
    connection.end();  
});  