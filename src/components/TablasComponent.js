import { Table } from '@material-ui/core';
import React, { Component } from 'react';
const {errores} = require('../Errores.ts');
const {simbolos} = require('../Simbolos.ts');


class Tablas extends Component {

    constructor(props){
        super(props);
    }
    render(){
        let c =0;
        let c2 =0;
        return(
        <div>
            <div id = "tbTitulo">
                <h2>Tabla de Errores:</h2>
                </div>
            <div id="Tablas">
                
            <table id = "tb">
                <thead>
                <tr>
                    <th id="td">#</th>
                    <th id="td">Tipo de error</th>
                    <th id="td">Descripcion</th>
                    <th id="td">Linea</th>
                    <th id="td">Columna</th>
                </tr>
                </thead>
                <tbody>
                {errores.map((value, index) => {
                    c=c+1;
                    return (
                        <tr>
                        <td id="td">{c}</td>
                        <td id="td">{value.tipo}</td>
                        <td id="td">{value.descripcion}</td>
                        <td id="td">{value.linea}</td>
                        <td id="td">{value.columna}</td>
                        </tr>
                    )
                })}
                </tbody>
            </table>
            </div>
            <div id = "tbTitulo">
                <h2>Tabla de Simbolos:</h2>
                </div>
            <div id="Tablas">
                
            <table id = "tb">
                <thead>
                <tr>
                    <th id="td">#</th>
                    <th id="td">Identificador</th>
                    <th id="td">Tipo</th>
                    <th id="td">Tipo</th>
                    <th id="td">Linea</th>
                    <th id="td">Columna</th>
                </tr>
                </thead>
                <tbody>
                {simbolos.map((value, index) => {
                    c2=c2+1;
                    return (
                        <tr>
                        <td id="td">{c2}</td>
                        <td id="td">{value.identificador}</td>
                        <td id="td">{value.tipo}</td>
                        <td id="td">{value.tipo2}</td>
                        <td id="td">{value.linea}</td>
                        <td id="td">{value.columna}</td>
                        </tr>
                    )
                })}
                </tbody>
            </table>
            </div>
            </div>
        );
    }
}export default Tablas;