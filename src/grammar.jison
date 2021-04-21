%lex

%options case-insensitive

%%

\s+											// se ignoran espacios en blanco
"//".*									{console.error('Este es un comentario simple');}	// comentario simple línea
[/][*][^*]*[*]+([^/*][^*]*[*]+)*[/]		{console.error('Este es un comentario multiple');}	// comentario multiple líneas


"print"				return 'PRINT';
"toLower"			return 'LOWER';
"toUpper"			return 'UPPER';
"length"			return 'LENGTH';
"truncate"			return 'TRUNCATE';
"round"				return 'ROUND';
"typeof"			return 'TYPEOF';
"toCharArray"		return 'CHARARRAY';
"exec"				return 'EXEC';
"new"				return 'NEW';

//tipos de dato
"int"				return 'ENTERO';
"double"			return 'DOUBLE';
"boolean"			return 'BOOLEANO';
"char"				return 'CARACTER';
"string"			return 'CADENA';
// Secuencias de Escape
"\n"				return 'SALTOLINEA';
"\\"				return 'BARINVERSA';
"\'"				return 'COMILLASIM';
"\""				return 'COMILLADOB';
"\t"				return 'TABULAR';
// Sentencias de control
"while"				return 'WHILE';
"do"				return 'DO';
"if"				return 'IF';
"else"				return 'ELSE';
"for"				return 'FOR';
"switch"			return 'SWITCH';
"case"				return 'CASE';
"default"			return 'DEFAULT';

//sentencias de transferencia
"break"				return 'BREAK';
"continue"			return 'CONTINUE';
"return"			return 'RETURN';

// para metodos
"void"				return 'VOID';

":"					return 'DOSPTS';
","					return 'COMA';
";"					return 'PTCOMA';
"{"					return 'LLAVIZQ';
"}"					return 'LLAVDER';
"("					return 'PARIZQ';
")"					return 'PARDER';
"["					return 'CORIZQ';
"]"					return 'CORDER';

"+="				return 'O_MAS';
"-="				return 'O_MENOS';
"*="				return 'O_POR';
"/="				return 'O_DIVIDIDO';


//operaddores aritmeticos
"+"					return 'MAS';
"-"					return 'MENOS';
"*"					return 'POR';
"/"					return 'DIVIDIDO';
"^"					return 'POTENCIA';
"%"					return 'MOD';
"++"				return 'INCREMENTO'
"--"				return 'DECREMENTO'
//OPERADORES LOGICOS
"!"					return 'NOT';
"&&"				return 'AND'
"||"				return 'OR';

//OPERACIONES RELACIONALES
"<="				return 'MENIGQUE';
">="				return 'MAYIGQUE';
"=="				return 'DOBLEIGUAL';
"!="				return 'NOIGUAL';
"<"					return 'MENQUE';
">"					return 'MAYQUE';
//valores booleanos
"true" 				return 'TRUE';
"false" 			return 'FALSE';

"="					return 'IGUAL';
"?"       			return 'OPTERNARIO'
"&"					return 'CONCAT';

\"[^\"]*\"				{ yytext = yytext.substr(1,yyleng-2); return 'CADENA'; }
[0-9]+("."[0-9]+)?\b  	return 'DECIMAL';
[0-9]+\b				return 'ENTERO';
([a-zA-Z])[a-zA-Z0-9_]*	return 'IDENTIFICADOR';


<<EOF>>				return 'EOF';
.					{ console.error('Este es un error léxico: ' + yytext + ', en la linea: ' + yylloc.first_line + ', en la columna: ' + yylloc.first_column); }

/lex


%{
	const TIPO_OPERACION	= require('./instrucciones').TIPO_OPERACION;
	const TIPO_VALOR 		= require('./instrucciones').TIPO_VALOR;
	const TIPO_DATO			= require('./tabla_simbolos').TIPO_DATO; 
	const instruccionesAPI	= require('./instrucciones').instruccionesAPI;	
%}


/* Asociación de operadores y precedencia */
%left 'OR'
%left 'AND'
%right 'NOT'
%left 'DOBLEIGUAL' 'NOIGUAL' 'MENQUE' 'MAYQUE' 'MAYIGQUE' 'MENIGQUE' 
%left 'MAS' 'MENOS'
%left 'POR' 'DIVIDIDO'
nonassoc 'POTENCIA'
%right UMENOS

%start inicio

%% /* Definición de la gramática */

inicio
    : instrucciones EOF { console.log($1);  }
    | error EOF {console.log("Sintactico","Error en : '"+yytext+"'",this._$.first_line,this._$.first_column)}
;

instrucciones 
    : instrucciones instruccion  { $$=$1; }
    | instruccion       { $$=$1; }
;


instruccion 
    : RPRINT PARIZQ expresion_cadena PARDER PTCOMA	{ $$ = instruccionesAPI.nuevoPrint($3); }
;

