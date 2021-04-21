import React, { Component } from 'react';
import {Link} from 'react-router-dom';

const Navbar = () => {
    return(
        <div id = "navegacion">
        <ul id = "nav">
            <li>
                <Link to='editor'>
                    Editor
                </Link>
            </li>
            <li>
                <Link to='tablas'>
                    Tablas
                </Link>
            </li>
            <li>
                <Link to='ast'>
                    AST
                </Link>
            </li>
        </ul>
    </div>
    );
    }
    export default Navbar;