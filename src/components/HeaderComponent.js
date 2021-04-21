import React, { Component } from 'react';



class Header extends Component {

    constructor(props){
        super(props);
    }
    render(){
        return(
            <div id = "encabezado">
            <div id = "titulo"><h1>TYPESTY</h1></div>
            <div id = "carne"><h3> Mynor Ruiz 201801329</h3></div>
            </div>
        );
    }
}export default Header;