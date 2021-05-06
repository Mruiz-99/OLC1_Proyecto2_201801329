import React, { Component } from 'react';

class AST extends Component {

    constructor(props){
        super(props);
    }
    render(){
        return(
            <div id="modulo">
                <textarea  cols={85} rows={35}  > 
                {this.props.txtAST.toString()}
                </textarea>
            </div>

        );
    }
}export default AST;