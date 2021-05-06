import React, { Component } from 'react';
import Editor from './Editor'
import Parser from '../grammar.js'
const {errores} = require('../Errores.ts');
const {simbolos} = require('../Simbolos.ts');

class Tabs extends React.Component{
  constructor(props){
    super(props);
    this.state ={
      activeTab: this.props.children[0].props.label
    }
}
    
    changeTab = (tab) => {
      
      this.setState({ activeTab: tab });
      this.props.code[this.props.index]=this.props.codigo;
      if(tab=="Pestaña1"){
        this.props.setIndex(0);
        this.props.selectCodigo(0);
      }if(tab=="Pestaña2"){
        this.props.setIndex(1);
        this.props.selectCodigo(1);
      }if(tab=="Pestaña3"){
        this.props.setIndex(2);
        this.props.selectCodigo(2);
      }if(tab=="Pestaña4"){
        this.props.setIndex(3);
        this.props.selectCodigo(3);
      }if(tab=="Pestaña5"){
        this.props.setIndex(4);
        this.props.selectCodigo(4);
      }if(tab=="Pestaña6"){
        this.props.setIndex(5);
        this.props.selectCodigo(5);
      }if(tab=="Pestaña7"){
        this.props.setIndex(6);
        this.props.selectCodigo(6);
      }if(tab=="Pestaña8"){
        this.props.setIndex(7);
        this.props.selectCodigo(7);
      }

    };
    
    render(){
      
      let content;
      let buttons = [];
      return (
        <div>
          {React.Children.map(this.props.children, child =>{
            buttons.push(child.props.label)
            if (child.props.label === this.state.activeTab) content = child.props.children
          })}
           
          <TabButtons activeTab={this.state.activeTab} buttons={buttons} changeTab={this.changeTab} />
          <div className="tab-content">{content}</div>
          
        </div>
      );
    }
  }
  
  const TabButtons = ({buttons, changeTab, activeTab}) =>{
     
    return(
      <div className="tab-buttons">
      {buttons.map(button =>{
         return <button className={button === activeTab? 'active': ''} onClick={()=>changeTab(button)}>{button}</button>
      })}
      </div>
    )
  }
  
  const Tab = props =>{
    return(
      <React.Fragment>
        {props.children}
      </React.Fragment>
    )
  }

class Entrada extends Component {
  
    constructor(props){
        super(props);
        this.state = {
          codigo: this.props.code[0],
          index:0
        }
        this.setCodigo = this.setCodigo.bind(this)
        this.Ejecutar = this.Ejecutar.bind(this)
        this.selectCodigo = this.selectCodigo.bind(this)
    }
      setCodigo = (cod)=> {
        this.setState(prevState => ({
            ...prevState,
            codigo: cod
        }))
    }
    selectCodigo = (index)=>{
      this.setState(prevState => ({
        ...prevState,
        codigo: this.props.code[index]
    }))
    }
    setIndex = (i) => {
      this.setState(prevState => ({
          ...prevState,
          index: i
      }))
  }
  Ejecutar = (texto) => {
      this.props.clearSalida();
      while(errores.length > 0)
      errores.pop(); 
      while(simbolos.length > 0)
      simbolos.pop(); 
      let resultado = Parser.parse(texto.toString());
      this.props.code[this.state.index]=texto.toString();
      this.props.setSalida(resultado.salida.toString().replaceAll(",","\n"));
      this.props.clearAST();
      this.props.setAST(JSON.stringify(resultado.ast,null,2));
  }

    render(){
        return(
            <div id = "codigo">
              <button onClick={this.props.setCode} id = "boton">Nueva Pestaña</button>
              <button onClick={this.props.removeCode} id = "boton">Cerrar Pestaña</button>
              <button  id = "boton" onClick={()=>this.Ejecutar(this.state.codigo)}>Compilar</button>
              <button  id = "boton">Abrir archivo</button>
              <button  id = "boton">Guardar archivo</button>
               <Tabs selectCodigo={this.selectCodigo} setIndex = {this.setIndex} codigo={this.state.codigo} setCodigo={this.setCodigo} removeCode ={this.props.removeCode} modifyCode={this.props.modifyCode} setCode={this.props.setCode} code={this.props.code} index={this.state.index}>
               {this.props.code.map((value, index) => {
                  return <Tab label ={"Pestaña"+(index+1)} key={index} eventKey={index}  >
                 <div key={index} >
                  <Editor 
                    language = "javascript"
                    displayName ="JS"
                    value = {this.state.codigo}
                    onChange={this.setCodigo}
                  />
                   </div>
                  </Tab>
                 
                })}
                </Tabs>
                
              </div>
        );
    }
    
}export default Entrada;
