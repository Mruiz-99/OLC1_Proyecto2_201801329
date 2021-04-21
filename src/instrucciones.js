

// Constantes para los tipos de 'valores' que reconoce nuestra gramática.
const TIPO_VALOR = {
	NUMERO:         'VAL_NUMERO',
	IDENTIFICADOR:  'VAL_IDENTIFICADOR',
	CADENA:         'VAL_CADENA',
}

// Constantes para los tipos de 'operaciones' que soporta nuestra gramática.
const TIPO_OPERACION = {
	SUMA:           'OP_SUMA',
	RESTA:          'OP_RESTA',
	MULTIPLICACION: 'OP_MULTIPLICACION',
	DIVISION:       'OP_DIVISION',
	NEGATIVO:       'OP_NEGATIVO',
	MAYOR_QUE:      'OP_MAYOR_QUE',
	MENOR_QUE:      'OP_MENOR_QUE',

	MAYOR_IGUAL: 	'OP_MAYOR_IGUAL',
	MENOR_IGUAL:    'OP_MENOR_IGUAL',
	DOBLE_IGUAL:    'OP_DOBLE_IGUAL',
	NO_IGUAL:    	'OP_NO_IGUAL',

	AND:  			'OP_AND',
	OR: 			'OP_OR',
	NOT:   			'OP_NOT',  	

	CONCATENACION:  'OP_CONCATENACION'
};
// Constantes para los tipos de 'instrucciones' válidas en nuestra gramática.
const TIPO_INSTRUCCION = {
	IMPRIMIR:		'INSTR_IMPRIMIR',
	MIENTRAS:		'INSTR_MIENTRAS',
	DECLARACION:	'INSTR_DECLARACION',
	ASIGNACION:		'INSTR_ASIGANCION',
	IF:				'INSTR_IF',
	IF_ELSE:		'INSTR_ELSE',
	PARA: 			'INST_PARA',
	SWITCH:			'SWITCH',
	SWITCH_OP:		'SWITCH_OP',
	SWITCH_DEF:		'SWITCH_DEF',
	ASIGNACION_SIMPLIFICADA: 'ASIGNACION_SIMPLIFICADA'
}

// Constantes para los tipos de OPCION_SWITCH validas en la gramática
const TIPO_OPCION_SWITCH = { 
	CASO: 			'CASO',
	DEFECTO: 		'DEFECTO'
} 


/**
 * El objetivo de esta API es proveer las funciones necesarias para la construcción de operaciones e instrucciones.
 */
 const instruccionesAPI = {

/**
	 * Crea un objeto tipo Instrucción para la sentencia Imprimir.
	 * @param {*} expresionCadena 
	 */
 nuevoPrint: function(expresionCadena) {
    return {
        tipo: TIPO_INSTRUCCION.IMPRIMIR,
        expresionCadena: expresionCadena
    };
},

}
// Exportamos nuestras constantes y nuestra API

module.exports.TIPO_OPERACION = TIPO_OPERACION;
module.exports.TIPO_INSTRUCCION = TIPO_INSTRUCCION;
module.exports.TIPO_VALOR = TIPO_VALOR;
module.exports.instruccionesAPI = instruccionesAPI;
module.exports.TIPO_OPCION_SWITCH = TIPO_OPCION_SWITCH;