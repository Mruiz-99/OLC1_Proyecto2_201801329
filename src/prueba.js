var fs = require('fs');
var parser = require('./grammar');

fs.readFile('./Entrada.txt', (err,data) => {
    if(!err){
        parser.parse(data.toString());
    }
});