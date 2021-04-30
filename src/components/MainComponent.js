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
            index: [0,1]
        };
        //this.setTabs = this.setTabs.bind(this)
        //this.setTabActual = this.setTabActual.bind(this)
        this.setCode = this.setCode.bind(this)
        this.modifyCode = this.modifyCode.bind(this)
        this.removeCode = this.removeCode.bind(this)

        axios.get('http://localhost:3000/TablaErrores.json').then(res => {
                alert(res.data);
        })
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
                <Route path="/editor" component={() => < Editor removeCode ={this.removeCode} modifyCode={this.modifyCode} setCode={this.setCode} code={this.state.code}/>} />
                <Route exact path="/tablas" component={() => < Tablas />} />
                <Route exact path="/ast" component={() => < AST  />} />
                <Redirect to="/editor" />
            </Switch>
            </div>
            </BrowserRouter>
        );
    }
}export default Main;