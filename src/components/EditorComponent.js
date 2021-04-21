import React, { Component } from 'react';
import Entrada from './EntradaComponent';
import Salida from './SalidaComponent';



class Editor extends Component {

    constructor(props){
        super(props);
    }
    render(){
        return(
            <div id="modulo">
                <Entrada removeCode ={this.props.removeCode} modifyCode={this.props.modifyCode} setActual={this.props.setActual} setCode={this.props.setCode} code={this.props.code}></Entrada>
                <Salida></Salida>
            </div>
            
        );
    }
}export default Editor;