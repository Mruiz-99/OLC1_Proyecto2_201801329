import React, { Component } from 'react';



class Salida extends Component {

    constructor(props){
        super(props);
    }
    render(){
        return(
            <div id= "consola">
                <h2>Consola:</h2>
                <textarea  cols={85} rows={35} />
            </div>
        );
    }
}export default Salida;