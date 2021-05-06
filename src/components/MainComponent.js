import React, { Component } from 'react';
import {BrowserRouter, Switch, Route, Redirect } from 'react-router-dom';
import Header from './HeaderComponent';
import Editor from './EditorComponent';
import Tablas from './TablasComponent';
import AST from './TreeComponent';
import Navbar from './NavbarComponent';
import axios from 'axios'

const api  = axios.create({
    baseURL: 'http://localhost:3000/TablaErrores.json'
})

class Main extends Component {

    constructor(props){
        super(props);
        this.state = {
            code:["",""],
            salida:[],
            tbSimbolos:[],
            tbErrores:[],
            txtAST:''
        };
        //this.setTabs = this.setTabs.bind(this)
        //this.setTabActual = this.setTabActual.bind(this)
        this.setCode = this.setCode.bind(this)
        this.setSalida = this.setSalida.bind(this)
        this.setErrores = this.setErrores.bind(this)
        this.setTbSimbolos = this.setTbSimbolos.bind(this)
        this.setAST = this.setAST.bind(this)
        this.modifyCode = this.modifyCode.bind(this)
        this.removeCode = this.removeCode.bind(this)

    }
    setSalida = (sal)=> {
        this.setState(prevState => ({
            ...prevState,
            salida: sal
        }))
    }
    setTbSimbolos = (simbolos)=> {
        this.setState(prevState => ({
            ...prevState,
            tbSimbolos: simbolos
        }))
    }
    setErrores = (err)=> {
        this.setState(prevState => ({
            ...prevState,
            tbErrores: err
        }))
    }
    setAST = (ast)=> {
        this.setState(prevState => ({
            ...prevState,
            txtAST: ast
        }))
    }
    clearSalida = ()=> {
        this.setState(prevState => ({
            ...prevState,
            salida: []
        }))
    }
    clearTbSimbolos = ()=> {
        this.setState(prevState => ({
            ...prevState,
            tbSimbolos: []
        }))
    }
    clearErrores = ()=> {
        this.setState(prevState => ({
            ...prevState,
            tbErrores: []
        }))
    }
    clearAST = ()=> {
        this.setState(prevState => ({
            ...prevState,
            txtAST: ''
        }))
    }
    setCode = () => {
        let res = this.state.code;
        res.push("");
        this.setState(prevState => ({
            ...prevState,
            code: res
        }))
    }
    removeCode = () => {
        let res = this.state.code;
        res.pop();
        this.setState(prevState => ({
            ...prevState,
            code: res
        }))
    }
    modifyCode = (index,codigo) => {
        let res = this.state.code;
        res[index] = codigo;
        this.setState(prevState => ({
            ...prevState,
            code: res
        }))
    }

    setIndex = (i) => {
        let res = this.state.index;
        res.push(i);
        this.setState(prevState => ({
            ...prevState,
            index: res
        }))
    }

    render(){
        return(
            <BrowserRouter>
            <Header/>
            <div id = "pantalla">
            <Navbar />
            <Switch>
                <Route path="/editor" component={() => < Editor txtAST={this.state.txtAST} tbErrores={this.state.tbErrores} tbSimbolos={this.state.tbSimbolos} salida={this.state.salida} setSalida={this.setSalida} setErrores={this.setErrores} setTbSimbolos={this.setTbSimbolos} setAST={this.setAST} clearSalida={this.clearSalida} clearErrores={this.clearErrores} clearTbSimbolos={this.clearTbSimbolos} clearAST={this.clearAST} removeCode ={this.removeCode} modifyCode={this.modifyCode} setCode={this.setCode} code={this.state.code}/>} />
                <Route exact path="/tablas" component={() => < Tablas tbErrores={this.state.tbErrores} tbSimbolos={this.state.tbSimbolos}  />} />
                <Route exact path="/ast" component={() => < AST  txtAST={this.state.txtAST}  />} />
                <Redirect to="/editor" />
            </Switch>
            </div>
            </BrowserRouter>
        );
    }
}export default Main;