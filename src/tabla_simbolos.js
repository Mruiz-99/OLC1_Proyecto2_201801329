// Constantes para los tipos de datos.
const TIPO_DATO = {
    ENTERO: 'ENTERO',
    DOUBLE: 'DOUBLE',
    BOOLEAN: 'BOOLEAN',
    CARACTER: 'CARACTER',
    CADENA: 'CADENA'

}


// crea un nuevo simbolo
function crearSimbolo(id, tipo, tipo_dato, entorno, linea, columna, valor) {
    return {
        id: id,
        tipo: tipo,
        tipo_dato: tipo_dato,
        entorno: entorno,
        linea: linea,
        columna: columna,
        valor:valor
    }
}



 //Clase que representa una Tabla de Símbolos.
class TablaSimbolos {

    //el constructor recibe como parametros los simbolos de la tabla
    constructor (simbolos) {
        this._simbolos = simbolos;
    }

    //funcion para la declaracion de variable y crea el simbolo dentro de la tabla
    add(id, tipo, tipo_dato, entorno, linea, columna) {
        const nuevoSimbolo = crearSimbolo(id, tipo, tipo_dato, entorno, linea, columna, valor);
        this._simbolos.push(nuevoSimbolo);
    }

    //Se utiliza para el asignar valor a na variable
    setValor(id, valor) { //AQUI VAMOS A VALIDAR TIPOS
        const simbolo = this._simbolos.filter(simbolo => simbolo.id === id)[0];
        if (simbolo) {
            if(simbolo.tipo===valor.tipo){
                if(simbolo.tipo===TIPO_DATO.NUMERO){
                    if(valor.valor instanceof String){ 
                        simbolo.valor = parseInt(valor.valor,10);
                    }else{
                        simbolo.valor = valor.valor;
                    }
                }else{
                    if(valor.valor instanceof Number){ 
                        simbolo.valor = valor.valor.toString();
                    }else{
                        simbolo.valor = valor.valor;
                    }
                }
                
            }else{
                throw 'ERROR DE TIPOS -> variable: ' + id + ' tiene tipo: '+simbolo.tipo +' y el valor a asignar es de tipo: '+valor.tipo;
            }
        }
        else {
            throw 'ERROR: variable: ' + id + ' no ha sido definida';
        }
    }

    //obtener valor de un simbolo
    getValor(id) {
        const simbolo = this._simbolos.filter(simbolo => simbolo.id === id)[0];

        if (simbolo) return simbolo; 
        else throw 'ERROR: variable: ' + id + ' no ha sido definida';
    }

    //obtener simbolos de la tabla
    get simbolos() {
        return this._simbolos;
    }
}

// Exportamos las constantes y la clase.

module.exports.TIPO_DATO = TIPO_DATO;
module.exports.TablaSimbolos = TablaSimbolos;