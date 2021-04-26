%{
    var pilaCiclos = [];
    var pilaFunciones = [];
  	// entorno
  	const Entorno = function(anterior)
    {
    	return {
        	tablaSimbolos:new Map(),
          	anterior:anterior
        }
    }
  	var EntornoGlobal = Entorno(null)
  	//Ejecuciones
    function EjecutarBloque(instrucciones, ent)
	{
        var retorno=null;
        for(var elemento of instrucciones)
        {
        	switch(elemento.TipoInstruccion)
          	{
            	case "print":
                    var res=Evaluar(elemento.Operacion, ent);
                    console.log(res.Valor);
                    break;
                case "declaracion":
                    retorno = EjecutarDeclaracion(elemento, ent);
                    break;
                case "asignacion":
                    retorno = EjecutarAsignar(elemento, ent);
                    break;
                case "hacer":
                    retorno = EjecutarHacer(elemento, ent);
                    break;
                case "if":
                    retorno = EjecutarIF(elemento, ent);
                    break;
                case "mientras":
                    retorno = EjecutarMientras(elemento, ent);
                    break;
                case "desde":
                    retorno = EjecutarDesde(elemento, ent);
                    break;
                case "seleccionar":
                    retorno = EjecutarSeleccionar(elemento, ent);
                    break;
                case "funcion":
                    retorno = EjecutarFuncion(elemento,EntornoGlobal);
                    break;
                case "llamada":
                    EjecutarLlamada(elemento,ent);
                    retorno = null;
                    break;
                case "retorno":
                    if (pilaFunciones.length>0)
                    {
                        retorno = elemento.Expresion;
                    }
                    else
                    {
                        console.log("Intruccion retorno fuera de una funcion")
                    }
                    break;
                case "insBreak":
                    if (pilaCiclos.length>0)
                    {
                        return elemento;
                    }
                    else
                    {
                        console.log("Intruccion insBreak fuera de un seleccionar o un ciclo")
                    }
                    
          	}
            if(retorno)
            {
                return retorno;
            }
        }
        return null;
    }
    //Expresion
    const setSimbolos = function(Valor,Tipo)
    {
        return {
            Valor:Valor,
            Tipo:Tipo
        }
    }
    const setOperacion= function(factor_izq,factor_der,Tipo)
    {
        return {
            factor_izq:factor_izq,
            factor_der:factor_der,
            Tipo:Tipo
        }
    }
    function setOperacionUnario(Operando,Tipo)
	{
        return {
            factor_izq:Operando,
            factor_der:null,
            Tipo:Tipo
        }
    }
    function Evaluar(Operacion,ent)
    {
        var Valorizq=null;
        var Valorder=null;
      	//Simbolos
        switch(Operacion.Tipo)
        {
            case "booleano":
                return setSimbolos(Operacion.Valor,Operacion.Tipo);
            case "cadena":
                return setSimbolos(Operacion.Valor,Operacion.Tipo);
			case "caracter":
                return setSimbolos(Operacion.Valor,Operacion.Tipo);
            case "doble":
                return setSimbolos(parseFloat(Operacion.Valor),Operacion.Tipo);
			case "entero":
                return setSimbolos(Number(Operacion.Valor),Operacion.Tipo);
          	case "identificador":
                var temp=ent;
                while(temp!=null)
                {
                    if(temp.tablaSimbolos.has(Operacion.Valor))
                    {
                        var valorID = temp.tablaSimbolos.get(Operacion.Valor);
                        return setSimbolos(valorID.Valor,valorID.Tipo);
                    }
                    temp=temp.anterior;
                }
                console.log("No existe la variable " + Operacion.Valor);
                return setSimbolos("@error@","error");
            case "funcion":
                var res = EjecutarLlamada(Llamada(Operacion.Valor.Id,Operacion.Valor.Params), ent)
                return res
        }
      	//Operaciones
        Valorizq=Evaluar(Operacion.factor_izq, ent);
        if(Operacion.factor_der!=null)
        {
            Valorder=Evaluar(Operacion.factor_der, ent);
        }
      	var tipoRetorno = "error";
      	// identificar qué operaciones sí podemos realizar dependiendo del tipo
    	switch(Valorizq.Tipo)
        {
          case "cadena":
            // cadena puede sumarse con cualquier otro tipo
            if(!Valorder){
            	tipoRetorno="cadena";
            	break;
            }
            switch(Valorder.Tipo)
            {
            	case "cadena":
				case "caracter":
              	case "entero":
				case "doble":
                case "booleano":
                	tipoRetorno = "cadena";	
                	break;
            }
            break;
		case "caracter":
            // cadena puede sumarse con cualquier otro tipo
            if(!Valorder){
            	tipoRetorno="caracter";
            	break;
            }
            switch(Valorder.Tipo)
            {
            	case "cadena":
				case "caracter":
              	case "entero":
				case "doble":
                case "booleano":
                	tipoRetorno = "cadena";	
                	break;
            }
            break;	
          case "entero":
            if(!Valorder){
            	tipoRetorno="entero";
              	break;
            }
            switch(Valorder.Tipo)
            {
            	case "cadena":
                	tipoRetorno = "cadena";
                	break;
              	case "entero":
                	tipoRetorno = "entero";	
                	break;
				case "doble":
                	tipoRetorno = "doble";	
                	break;	
            }
            break;
		case "doble":
            if(!Valorder){
            	tipoRetorno="doble";
              	break;
            }
            switch(Valorder.Tipo)
            {
            	case "cadena":
                	tipoRetorno = "cadena";
                	break;
              	case "entero":
                	tipoRetorno = "entero";	
                	break;
				case "doble":
                	tipoRetorno = "doble";	
                	break;	
            }
            break;	
          case "booleano":
            if(!Valorder){
            	tipoRetorno="booleano";
              	break;
            }
            if(!Valorder){
            	break;
            }
            switch(Valorder.Tipo)
            {
            	case "booleano":
                	tipoRetorno = "booleano";
              		break;
            }
            break;
        }
      
        switch (Operacion.Tipo)
        {
            case "+":
                switch(tipoRetorno)
                {
                	case "cadena":
                    case "caracter":
                	case "entero":
            			return setSimbolos(Valorizq.Valor + Valorder.Valor, tipoRetorno);
                		break;
					case "doble":
            			return setSimbolos(Valorizq.Valor + Valorder.Valor, tipoRetorno);
                		break;
                }
            case "-":
                switch(tipoRetorno)
                {
                	case "entero":
            			return setSimbolos(Valorizq.Valor - Valorder.Valor, tipoRetorno);
                		break;
					case "doble":
            			return setSimbolos(Valorizq.Valor - Valorder.Valor, tipoRetorno);
                		break;	
                }
            case "umenos":
                switch(tipoRetorno)
                {
                	case "entero":
            			return setSimbolos(0-Valorizq.Valor, tipoRetorno);
					case "doble":
            			return setSimbolos(0-Valorizq.Valor, tipoRetorno);	
                }
            case "*":
                switch(tipoRetorno)
                {
                	case "entero":
                    	return setSimbolos(Valorizq.Valor * Valorder.Valor, tipoRetorno);
					case "doble":
                    	return setSimbolos(Valorizq.Valor * Valorder.Valor, tipoRetorno);	
                }
            case "/":
                switch(tipoRetorno)
                {
                	case "entero":	
                    	return setSimbolos(Valorizq.Valor / Valorder.Valor, tipoRetorno);
					case "doble":	
                    	return setSimbolos(Valorizq.Valor / Valorder.Valor, tipoRetorno);	
                }
			case "^":
                switch(tipoRetorno)
                {
                	case "entero":	
                    	return setSimbolos(Valorizq.Valor ** Valorder.Valor, tipoRetorno);
					case "doble":	
                    	return setSimbolos(Valorizq.Valor ** Valorder.Valor, tipoRetorno);	
                }	
            case "%":
                switch(tipoRetorno)
                {
                	case "entero":
            			return setSimbolos(Valorizq.Valor % Valorder.Valor, tipoRetorno);
					case "doble":
            			return setSimbolos(Valorizq.Valor % Valorder.Valor, tipoRetorno);		
                }
            case "not":
                switch(tipoRetorno)
                {
                	case "entero":
            			return setSimbolos(!Valorizq.Valor, tipoRetorno);
					case "doble":
            			return setSimbolos(!Valorizq.Valor, tipoRetorno);	
                    case "booleano":
            			return setSimbolos(!Valorizq.Valor, tipoRetorno);
                }
            case "and":
                switch(tipoRetorno)
                {
                	case "booleano":
            			return setSimbolos(Valorizq.Valor && Valorder.Valor, tipoRetorno);
                }
            case "or":
                switch(tipoRetorno)
                {
                	case "booleano":
                		return setSimbolos(Valorizq.Valor || Valorder.Valor, tipoRetorno);
                }
            case ">":
                switch(tipoRetorno)
                {
                	case "cadena":
                    case "caracter":
                	case "entero":
					case "doble":
                	case "booleano":
                    	return setSimbolos(Valorizq.Valor > Valorder.Valor, "booleano");
                }
            case "<":
                switch(tipoRetorno)
                {
                	case "cadena":
                	case "entero":
                    case "caracter":
					case "doble":
                	case "booleano":
                    	return setSimbolos(Valorizq.Valor < Valorder.Valor, "booleano");
                }
            case ">=":
                switch(tipoRetorno)
                {
                	case "cadena":
                	case "entero":
                    case "caracter":
					case "doble":
                	case "booleano":
                    	return setSimbolos(Valorizq.Valor >= Valorder.Valor, "booleano");
                }
            case "<=":
                switch(tipoRetorno)
                {
                	case "cadena":
                	case "entero":
                    case "caracter":
					case "doble":
                	case "booleano":
                    	return setSimbolos(Valorizq.Valor <= Valorder.Valor, "booleano");
                }
            case "==":
                switch(tipoRetorno)
                {
                	case "cadena":
                	case "entero":
                    case "caracter":
					case "doble":
                	case "booleano":
                    	return setSimbolos(Valorizq.Valor == Valorder.Valor, "booleano");
                }
            case "!=":
                switch(tipoRetorno)
                {
                	case "cadena":
                    case "caracter":
                	case "entero":
					case "doble":
                	case "booleano":
                		return setSimbolos(Valorizq.Valor != Valorder.Valor, "booleano");
                }
        }
      	console.log(
          "Tipos incompatibles " + ( Valorizq ? Valorizq.Tipo : "" ) + 
          " y " + ( Valorder ? Valorder.Tipo : "" )); 
      	return setSimbolos("@error@", "error");
    }
	/*-----------------------------------------------------------------------------------------------*/
    //print
    const print=function(TipoInstruccion,Operacion)
    {
        return {
            TipoInstruccion:TipoInstruccion,
            Operacion:Operacion
        }
    }
  	//Declaracion de variable
  	const Declaracion = function(id, tipo, expresion)
    {
    	return {
      		Id:id,
        	Tipo: tipo,
        	Expresion: expresion,
        	TipoInstruccion:"declaracion"
      }
    }
    
    function EjecutarDeclaracion(declaracion,ent) 
	{
      	// validar si existe la variable
      	if (ent.tablaSimbolos.has(declaracion.Id))
      	{
            console.log("La variable ",declaracion.Id," ya ha sido declarada en este ambito");
      		return;
      	}
    		// evaluar el resultado de la expresión 
		var valor ;	
      	if (declaracion && declaracion.Expresion)
      	{
        	valor = Evaluar(declaracion.Expresion, ent);
            if(valor.Tipo != declaracion.Tipo){
                console.log("El tipo no coincide con la variable a declaracion");
                return
            }
    	}
      	else
        {
            switch(declaracion.Tipo)
            {
                case "entero":
                    valor=setSimbolos(0,"entero");
                    break;
                case "doble":
                    valor=setSimbolos(0.0,"doble");
                    break;    
                case "cadena":
                    valor=setSimbolos("","cadena");
                    break;
                case "caracter":
                    valor=setSimbolos('0',"caracter");
                    break;    
                case "booleano":
                    valor=setSimbolos(true,"booleano");
                    break;
            }
        }
      	// crear objeto a insertar
      	ent.tablaSimbolos.set(declaracion.Id, valor);
    }
		// asignar
  	const Asignar = function(id, expresion)
    {
    	return {
      		Id:id,
        	Expresion: expresion,
        	TipoInstruccion: "asignacion"
      	}
    }
    
    function EjecutarAsignar (asignar,ent) 
	{
      	//Evaluar la expresion
      	var valor = Evaluar(asignar.Expresion,ent);
        // validar si existe la variable
      	temp=ent;
      	while(temp!=null)
        {
            if (temp.tablaSimbolos.has(asignar.Id))
            {
                // evaluar el resultado de la expresión 
                var simbolotabla = temp.tablaSimbolos.get(asignar.Id);	
              	
                // comparar los tipos
                if (simbolotabla.Tipo === valor.Tipo)
                {
                	// reasignar el valor
                    temp.tablaSimbolos.set(asignar.Id, valor);
                    return
                }
                else
                {
                    console.log("Tipos incompatibles ",simbolotabla.Tipo," , ",valor.Tipo)
                    return
                }
            }
            temp=temp.anterior;
        }
        console.log("No se encontro la variable ",asignar.Id);
    }
	//insBreak
  	const insBreak = function()
    {
      	return {
          TipoInstruccion:"insBreak"
        }
    }
	
    const Retorno = function(Expresion)
    {
        return {
            Expresion:Expresion,
        	TipoInstruccion: "retorno"
        }
    }
    // Retorna un objeto con los datos de la condicional if 
	const condIF=function(Condicion,BloqueIF,BloqueElse)
    {
          return {
            Condicion:Condicion,
            BloqueIF:BloqueIF,
            BloqueElse:BloqueElse,
            TipoInstruccion:"if"
          }
    }
    function EjecutarIF (si,ent)
    {
    	var res = Evaluar(si.Condicion, ent);
        if(res.Tipo=="booleano")
        {
        	if(res.Valor)
          	{
      	        var nuevoIF=Entorno(ent);
            	return EjecutarBloque(si.BloqueIF, nuevoIF);
          	}
          	else if(si.BloqueElse!=null)
          	{
      	        var nuevoELSE=Entorno(ent);
            	return EjecutarBloque(si.BloqueElse, nuevoELSE);
        	}
    	}
        else
        {
            console.log("Se esperaba una condicion dentro del Si");
        }
    }
    //Casos
    const Caso = function(Expresion,Bloque)
    {
        return {
            Expresion:Expresion,
            Bloque:Bloque
        }
    }
    
    const Seleccionar = function(Expresion, ListCase, BloqueSwitch)
    {
        return  {
            Expresion: Expresion,
            ListCase: ListCase,
            BloqueSwitch: BloqueSwitch,
            TipoInstruccion: "seleccionar"
        }
    }
	
  	function EjecutarSeleccionar(seleccionar, ent)
	{  
        pilaCiclos.push("seleccionar");
		var ejecutado = false;  
      	var nuevo = Entorno(ent);
        for(var elemento of seleccionar.ListCase)
        {
            var condicion=Evaluar(setOperacion(seleccionar.Expresion,elemento.Expresion,"=="), ent)
            if(condicion.Tipo=="booleano")
            {
              	if(condicion.Valor || ejecutado)
              	{
                	ejecutado=true;
                	var res = EjecutarBloque(elemento.Bloque, nuevo)
                	if(res && res.TipoInstruccion=="insBreak")
                	{
                        pilaCiclos.pop();
                  		return
                	}
                    else if (res)
                    {
                        pilaCiclos.pop();
                        return res
                    }
              	}
            }
          	else
            {
                pilaCiclos.pop();
                return
            }
        }
        if(seleccionar.BloqueSwitch && !ejecutado)
        {
            EjecutarBloque(seleccionar.BloqueSwitch, nuevo)
        }
        pilaCiclos.pop();
        return
    }
	//Mientras
	const Mientras = function(Condicion, Bloque)
    {
        return {
            Condicion: Condicion,
            Bloque: Bloque,
            TipoInstruccion:"mientras"
        }
    }
  
  	function EjecutarMientras(mientras,ent)
	{
        pilaCiclos.push("ciclo");        
      	nuevo=Entorno(ent);
        while(true)
        {
        	var resultadoCondicion = Evaluar(mientras.Condicion, ent)
            if(resultadoCondicion.Tipo=="booleano")
            {
            	if(resultadoCondicion.Valor)
            	{
                	var res=EjecutarBloque(mientras.Bloque, nuevo);
                	if(res && res.TipoInstruccion=="insBreak")
                	{
                		break;
                	}
                    else if (res)
                    {
                        pilaCiclos.pop();
                        return res
                    }
            	}
            	else
            	{
                	break;
              	}
            }
            else
            {
                console.log("Se esperaba una condicion dentro del Mientras")
                pilaCiclos.pop();
                return
            }
		}
        pilaCiclos.pop();
        return
	}
	const Desde = function(ExpDesde, ExpHasta, ExpPaso, Bloque, ent)
    {
        return {
            ExpDesde: ExpDesde,
            ExpHasta: ExpHasta,
            ExpPaso: ExpPaso,
            Bloque: Bloque,
            TipoInstruccion:"desde"
        }
    }
  
	function EjecutarDesde(Desde, ent)
	{
        pilaCiclos.push("ciclo"); 
      	var nuevo=Entorno(ent);
    	//controlador de la condicion
    	if( Desde.ExpDesde.TipoInstruccion == "crear" )
    	{
      		EjecutarCrear(Desde.ExpDesde, nuevo);
    	}
    	else
    	{
        	EjecutarAsignar(Desde.ExpDesde, nuevo);
    	}
      	//mientras no se llegue al hasta
    	var paso = Evaluar(Desde.ExpPaso, ent);
    	var hasta = Evaluar(Desde.ExpHasta, ent);
    	var Simbolo=setSimbolos(Desde.ExpDesde.Id,"ID")
        if( !(paso.Tipo=="numero" && hasta.Tipo=="numero") )
        {
            pilaCiclos.pop();
            console.log("Se esperaban valores numericos en el Desde");
            return;
        }
    	while(true)
    	{
        	var inicio=Evaluar(Simbolo, nuevo)
            if( inicio.Tipo != "numero" )
            {
                pilaCiclos.pop();
                console.log("Se esperabam valores numericos en el Desde");
                return;
            }
        	if(paso.Valor > 0)
        	{
                if(inicio.Valor <= hasta.Valor)
                {
                    var res=EjecutarBloque(Desde.Bloque, nuevo);
                    if(res && res.TipoInstruccion=="insBreak")
                    {
                        break;
                    }
                    else if (res)
                    {
                        pilaCiclos.pop();
                        return res
                    }
                }
                else
                {
                  break;
                }  
        	}
        	else
        	{
            	if(inicio.Valor >= hasta.Valor)
            	{
            		var res=EjecutarBloque(Desde.Bloque, nuevo);
            		if(res && res.TipoInstruccion=="insBreak")
                	{
                    	break;
                	}
                }
                else
                {
                	break;
                }
        	}
        	EjecutarAsignar(Asignar(Desde.ExpDesde.Id,setOperacion(Simbolo,paso,"+")), nuevo)
    	}
        pilaCiclos.pop();
        return;
	}
    //Funcion
    const Funcion=function(Id, Parametros, Tipo, Bloque)
    {
        return{
            Id: Id,
            Parametros: Parametros,
            Bloque: Bloque,
            Tipo: Tipo,
            TipoInstruccion: "funcion"
        }
    }
    function EjecutarFuncion(elemento,ent)
    {
        var nombrefuncion = elemento.Id + "$";
        for(var Parametro of elemento.Parametros)
        {
            nombrefuncion+=Parametro.Tipo;
        }
        if (ent.tablaSimbolos.has(nombrefuncion))
      	{
            console.log("La funcion ",crear.Id," ya ha sido declarada");
      		return;
      	}
        ent.tablaSimbolos.set(nombrefuncion, elemento);
    }
    //Llamada
    const Llamada=function(Id,Params)
    {
        return {
            Id: Id,
            Params: Params,
            TipoInstruccion: "llamada"
        }
    }
    function EjecutarLlamada(Llamada,ent)
    {
        var nombrefuncion = Llamada.Id+"$";
        var Resueltos = [];
        for(var param of Llamada.Params)
        {
            var valor = Evaluar(param,ent);
            nombrefuncion += valor.Tipo;
            Resueltos.push(valor);
        }
        var temp = ent;
        var simboloFuncion = null;
      	while(temp!=null)
        {
            if (temp.tablaSimbolos.has(nombrefuncion))
            {
                // evaluar el resultado de la expresión 
                simboloFuncion = temp.tablaSimbolos.get(nombrefuncion);	
                break;
            }
            temp=temp.anterior;
        }
        if(!simboloFuncion){
            console.log("No se encontró la funcion "+Llamada.Id + " con esa combinacion de parametros")
            return setSimbolos("@error@","error");
        } 
        pilaFunciones.push(Llamada.Id);
        var nuevo=Entorno(EntornoGlobal)
        var index=0;
        for(var crear of simboloFuncion.Parametros)
        {
            crear.Expresion=Resueltos[index];
            EjecutarCrear(crear,nuevo);
            index++;
        }
        var retorno=setSimbolos("@error@","error");
        var res = EjecutarBloque(simboloFuncion.Bloque, nuevo)
        if(res)
        {
            if(res.Tipo=="void" )
            {
                if(simboloFuncion.Tipo!="void")
                {
                    console.log("No se esperaba un retorno");
                    retorno=setSimbolos("@error@","error");
                }
                else
                {
                    retorno=setSimbolos("@vacio@","vacio")
                }
            }
            else
            {
                var exp=Evaluar(res,nuevo);
                if(exp.Tipo!=simboloFuncion.Tipo)
                {
                    console.log("El tipo del retorno no coincide");
                    retorno=setSimbolos("@error@","error");
                }
                else
                {
                    retorno=exp;
                }
            }
        }
        else
        {
            if(simboloFuncion.Tipo!="void")
            {
                console.log("Se esperaba un retorno");
                retorno=setSimbolos("@error@","error");
            }
            else
            {
                retorno=setSimbolos("@vacio@","vacio")
            }
        }
        pilaFunciones.pop();
        return retorno;
    }
%}

%lex

%options case-insensitive

%%


\"((\\\")|[^\n\"])*\"   { yytext = yytext.substr(1,yyleng-2); return 'CADENA'; }
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
"int"				return 'RENTERO';
"double"			return 'RDOUBLE';
"boolean"			return 'Rbooleano';
"char"				return 'RCARACTER';
"string"			return 'RCADENA';

// Secuencias de Escape
\\\n				return 'SALTOLINEA';
\\\\				return 'BARINVERSA';
\\\'				return 'COMILLASIM';
\\\"				return 'COMILLADOB';
\\\t				return 'TABULAR';

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


//OPERACIONES RELACIONALES
"<="				return 'MENIGQUE';
">="				return 'MAYIGQUE';
"=="				return 'DOBLEIGUAL';
"!="				return 'NOIGUAL';
"<"					return 'MENQUE';
">"					return 'MAYQUE';

//OPERADORES LOGICOS
"!"					return 'NOT';
"&&"				return 'AND'
"||"				return 'OR';

//valores booleanos
"true" 				return 'TRUE';
"false" 			return 'FALSE';

"="					return 'IGUAL';
"?"       			return 'OPTERNARIO'
"&"					return 'CONCAT';

\'((\\\')|[^\n\'])\'	{ yytext = yytext.substr(1,yyleng-2); return 'CARACTER'; }

[0-9]+("."[0-9]+)\b  	return 'DECIMAL';
[0-9]+\b				return 'ENTERO';
([a-zA-Z])[a-zA-Z0-9_]*	return 'IDENTIFICADOR';


<<EOF>>				return 'EOF';
.					{ console.error('Este es un error léxico: ' + yytext + ', en la linea: ' + yylloc.first_line + ', en la columna: ' + yylloc.first_column); }

/lex


/* Asociación de operadores y precedencia */
%left 'OR'
%left 'AND'
%right 'NOT'
%left 'DOBLEIGUAL' 'NOIGUAL' 'MENQUE' 'MAYQUE' 'MAYIGQUE' 'MENIGQUE' 
%left 'MAS' 'MENOS'
%left 'POR' 'DIVIDIDO' 'MOD'
%nonassoc 'POTENCIA'
%right UMENOS

%start inicio

%% /* Definición de la gramática */

inicio
    : instrucciones EOF {console.log(JSON.stringify($1,null,2)); EjecutarBloque($1,EntornoGlobal)  }
	
    
;

instrucciones 
    : instrucciones instruccion  { $$=$1; $$.push($2); }
    | instruccion       { $$=[]; $$.push($1); }
    | error  {console.log("Sintactico","Error en : '"+yytext+"'",this._$.first_line,this._$.first_column)}
	
;


instruccion 
    : PRINT PARIZQ expresion PARDER PTCOMA	                { $$ = print("print",$3); }
    | DECLARACION                                           { $$ = $1 }
    | ASIGNACION                                            { $$ = $1 }
    | condIF                                                { $$ = $1 }
    | switchCASE                                            { $$ = $1 }
    | BREAK PTCOMA                                          { $$ = insBreak();}
;

switchCASE
    : SWITCH expresion LLAVIZQ ListCase LLAVDER                    { $$ = Seleccionar($2, $4); }
    | SWITCH expresion LLAVIZQ ListCase DEFAULT BLOQUECASE LLAVDER { $$ = Seleccionar($2, $4, $6); } 
;

ListCase
    : ListCase CASE expresion  BLOQUECASE   { $$ = $1; $$.push(Caso($3, $4)); }
    | CASE expresion BLOQUECASE             { $$ = []; $$.push(Caso($2, $3)); }
;

BLOQUECASE
    : DOSPTS                          { $$ = []; }
    | DOSPTS instrucciones            { $$ = $2; }
; 

condIF
    : IF expresion BLOQUE                   { $$ = condIF($2, $3, null); }
    | IF expresion BLOQUE ELSE condIF   { $$ = condIF($2, $3, Array ($5) );}
    | IF expresion BLOQUE ELSE BLOQUE       { $$ = condIF($2, $3, $5 ); }
;  
   

BLOQUE
    : LLAVIZQ LLAVDER                       { $$ = []; }
    | LLAVIZQ instrucciones LLAVDER         { $$ = $2; }
; 

ASIGNACION 
    :IDENTIFICADOR IGUAL expresion  PTCOMA	        { $$ = Asignar($1,$3); }
;

DECLARACION 
    : TIPO IDENTIFICADOR IGUAL expresion  PTCOMA	        { $$ = Declaracion($2,$1,$4); }
    | TIPO IDENTIFICADOR PTCOMA	                            { $$ = Declaracion($2,$1,null); }
;

TIPO 
    : RENTERO               { $$ = "entero" }
    | Rbooleano             { $$ = "booleano" }   
    | RCADENA               { $$ = "cadena" }   
    | RCARACTER             { $$ = "caracter" }   
    | RDOUBLE               { $$ = "doble" }   
;

expresion
	: expresion MAS expresion				{ $$ = setOperacion($1,$3,"+");}
	| expresion MENOS expresion				{ $$ = setOperacion($1,$3,"-");}
	| expresion POR expresion				{ $$ = setOperacion($1,$3,"*");}
	| expresion DIVIDIDO expresion			{ $$ = setOperacion($1,$3,"/");}
	| expresion POTENCIA expresion			{ $$ = setOperacion($1,$3,"^");}
	| expresion MOD expresion				{ $$ = setOperacion($1,$3,"%");}
	| expresion DOBLEIGUAL expresion		{ $$ = setOperacion($1,$3,"==");}
	| expresion NOIGUAL expresion			{ $$ = setOperacion($1,$3,"!=");}
	| expresion MENQUE expresion			{ $$ = setOperacion($1,$3,"<");}
	| expresion MAYQUE expresion			{ $$ = setOperacion($1,$3,">");}
	| expresion MENIGQUE expresion			{ $$ = setOperacion($1,$3,"<=");}
	| expresion MAYIGQUE expresion			{ $$ = setOperacion($1,$3,">=");}
	| expresion AND expresion				{ $$ = setOperacion($1,$3,"and");}
	| expresion NOT expresion				{ $$ = setOperacion($1,$3,"not");}
	| expresion OR expresion				{ $$ = setOperacion($1,$3,"or");}
	| NOT expresion							{ $$ = setOperacionUnario($2,"not");}
	| MENOS expresion %prec UMENOS			{ $$ = setOperacionUnario($2,"umenos");}
	| PARIZQ expresion PARDER     			{ $$ = $2}
	| TRUE				     				{ $$ = setSimbolos(true,"booleano");}
	| FALSE				     				{ $$ = setSimbolos(false,"booleano");}
	| CADENA				     			{ $$ = setSimbolos($1,"cadena");}
	| CARACTER				     			{ $$ = setSimbolos($1,"caracter");}
	| DECIMAL				     			{ $$ = setSimbolos(parseFloat($1),"doble");}
	| ENTERO				     			{ $$ = setSimbolos($1,"entero");}
	| IDENTIFICADOR							{ $$ = setSimbolos($1,"identificador");}
	
;
