const express = require('express')
const app = express()
const port = 3000
const cors = require('cors');
const mysql = require('mysql');
const conn = {
	host: '127.0.0.1',
	port: '3306',
	user: 'root',
	password: '1234',
	database: 'madang'	
}
let connection = mysql.createConnection(conn);
connection.connect();

app.use(express.urlencoded());
app.use(express.json());

app.use(cors({
    origin: '*', 
}));

app.get('/', (req, res) => {
    res.send('Hello World!')
})

app.post('/loginREST', (req, res) => {		
	let sql = "SELECT * FROM tbl_memberinfo WHERE id='" + req.body.userid + 
				"' and password='" + req.body.userpassword + "'";  
	connection.query(sql, function(err, results, fields) {
		if(err) {
			console.log("에러발생!");	
		} 
		if(results.length > 0) {
			res.send("{\"result\": \"success\"}")
		} else {
			res.send("{\"result\": \"fail\"}")	
		}
	});	
    
});

app.listen(port, () => {
    console.log(`Example app listening on port ${port}`)
})