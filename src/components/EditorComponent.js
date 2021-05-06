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
                <Entrada txtAST={this.props.txtAST} tbErrores={this.props.tbErrores} tbSimbolos={this.props.tbSimbolos} salida={this.props.salida} setSalida={this.props.setSalida} setErrores={this.props.setErrores} setTbSimbolos={this.props.setTbSimbolos} setAST={this.props.setAST} clearSalida={this.props.clearSalida} clearErrores={this.props.clearErrores} clearTbSimbolos={this.props.clearTbSimbolos} clearAST={this.props.clearAST} removeCode ={this.props.removeCode} modifyCode={this.props.modifyCode} setActual={this.props.setActual} setCode={this.props.setCode} code={this.props.code}></Entrada>
                <Salida salida={this.props.salida} ></Salida> 
            </div>
            
        );
    }
}export default Editor;