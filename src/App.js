import { render } from '@testing-library/react';
import React, { useState } from 'react';
import Main from "./components/MainComponent"
import './App.css';
import Editor from './components/Editor'


let contador = 1;
function App() {
  return (
    <div>
      <Main/>
      
    </div>
  );
}
/*
class Tabs extends React.Component{
  state ={
    activeTab: this.props.children[0].props.label
  }
  changeTab = (tab) => {

    this.setState({ activeTab: tab });
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
         
        <TabButtons activeTab={this.state.activeTab} buttons={buttons} changeTab={this.changeTab}/>
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

class Pantallaeditor extends React.Component{
  constructor(props) {
    super(props);
  }
  mas = () =>{
    if(contador<6){
    contador++;
    this.setState({show: true});
    }
  }
  menos = () =>{
    if(contador>1){
    contador--;
    this.setState({show: true});
    }
  }
  
  render(){
    if (contador==1) {
      return(
        <div id = "pantalla">
          <div id = "codigo" className="tabs">
          <button onClick={this.mas} id = "boton">Nueva Pestaña</button>
          <button onClick={this.menos} id = "boton">Cerrar Pestaña</button>
            <Tabs  >
              <Tab 
                label="Pestaña 1" >
                <div >
                <Editor 
                  language = "javascript"
                  displayName ="JS"
                  value = {this.state.js1}
                  onChange={()=>this.setState({ js1: this.state.js1 + this.state.text })}
                />
                </div>
                    </Tab>
                    <Tab  
                      label="Pestaña 2"  >
                    <div >
                    <Editor 
                  language = "javascript"
                  displayName ="JS"
                  value = {this.state.js2}
                  onChange={()=>this.setState({ js2: this.state.js2 + this.state.text })}
                />
                </div>
               </Tab>
            </Tabs>
        </div>
        <div id= "consola">
          <h2>Consola:</h2>
        <textarea  cols={90} rows={35} />
        </div>
      </div>
      )
    }
    if (contador==2) {
      return(
        <div id = "pantalla">
          <div id = "codigo" className="tabs">
          <button onClick={this.mas} id = "boton">Nueva Pestaña</button>
          <button onClick={this.menos} id = "boton">Cerrar Pestaña</button>
            <Tabs>
              <Tab label="Pestaña 1">
              <div >
              <Editor 
                  language = "javascript"
                  displayName ="JS"
                  value = {this.state.js}
                  onChange={this.state.js}
                />
                </div>
                    </Tab>
                    <Tab  label="Pestaña 2"  >
                    <div >
                </div>
               </Tab>
               <Tab label="Pestaña 3"  >
               <div >
                </div>
               </Tab>
            </Tabs>
        </div>
        <div id= "consola">
          <h2>Consola:</h2>
        <textarea  cols={90} rows={35} />
        </div>
      </div>
      )
    }
    if (contador==3) {
      return(
        <div id = "pantalla">
          <div id = "codigo" className="tabs">
          <button onClick={this.mas} id = "boton">Nueva Pestaña</button>
          <button onClick={this.menos} id = "boton">Cerrar Pestaña</button>
            <Tabs>
              <Tab label="Pestaña 1">
              <div >
                </div>
                    </Tab>
                    <Tab  label="Pestaña 2"  >
                    <div >
                </div>
               </Tab>
               <Tab label="Pestaña 3"  >
               <div >
                </div>
               </Tab>
               <Tab label="Pestaña 4"  >
               <div >
                </div>
               </Tab>
            </Tabs>
        </div>
        <div id= "consola">
          <h2>Consola:</h2>
        <textarea  cols={90} rows={35} />
        </div>
      </div>
      )
    }
  }
}*/
export default App;
