%{
    var pilaCiclos = [];
    var pilaFunciones = [];
    var Salida = [];
    const {errores} = require('./Errores.ts');
    const {Error_} = require('./Error.ts');
    const {simbolos} = require('./Simbolos.ts');
    const {Simbolo_} = require('./Simbolo.ts');
    var principal = 0;
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
                    Salida.push(res.Valor);
                    console.log(res.Valor);
                    break;
                case "declaracion":
                    retorno = EjecutarDeclaracion(elemento, ent);
                    break;
                case "asignacion":
                    retorno = EjecutarAsignar(elemento, ent);
                    break;
                case "incremento":
                    retorno = EjecutarIncremento(elemento, ent);
                    break;
                case "decremento":
                    retorno = EjecutarDecremento(elemento, ent);
                    break;    
                case "if":
                    retorno = EjecutarIF(elemento, ent);
                    break;
                case "while":
                    retorno = EjecutarWHILE(elemento, ent);
                    break;
                case "dowhile":
                    retorno = EjecutarDOWHILE(elemento, ent);
                    break;    
                case "for":
                    retorno = EjecutarFOR(elemento, ent);
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
                case "llamadaexec":
                    EjecutarLlamadaEXEC(elemento,ent);
                    retorno = null;
                    break;    
                case "retorno":
                    if (pilaFunciones.length>0)
                    {
                        retorno = elemento.Expresion;
                    }
                    else
                    {
                        Salida.push("Error semantico, intruccion return fuera de una funcion");
                        errores.push(new Error_(0,0,"Semantico", "Intruccion return fuera de una funcion"));
                        console.log("Intruccion return fuera de una funcion")
                    }
                    break;
                case "insBreak":
                    if (pilaCiclos.length>0)
                    {
                        return elemento;
                    }
                    else
                    {
                        Salida.push("Error semantico, Intruccion break fuera de un switch o un ciclo");
                        errores.push(new Error_(0,0,"Semantico", "Intruccion break fuera de un switch o un ciclo"));
                        console.log("Intruccion break fuera de un switch o un ciclo")
                    }
                    break;
                case "insContinue":
                    if (pilaCiclos.length>0)
                    {
                        return elemento;
                    }
                    else
                    {
                        Salida.push("Error semantico, Intruccion break fuera de un switch o un ciclo");
                        errores.push(new Error_(0,0,"Semantico", "Intruccion break fuera de un switch o un ciclo"));
                        console.log("Intruccion break fuera de un switch o un ciclo")
                    }
                    break;
                    
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
                Salida.push("Error semantico, No existe la variable " + Operacion.Valor);
                errores.push(new Error_(0,0,"Semantico", "No existe la variable " + Operacion.Valor));
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
            // caracter puede sumarse con cualquier otro tipo
            if(!Valorder){
            	tipoRetorno="caracter";
            	break;
            }
            switch(Valorder.Tipo)
            {
            	case "cadena":
                	tipoRetorno = "cadena";
                	break;
				case "caracter":
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
          case "entero":
            if(!Valorder){
            	tipoRetorno="entero";
              	break;
            }
            switch(Valorder.Tipo)
            {
                case "booleano":
                	tipoRetorno = "entero";
                	break;
                case "caracter":
                	tipoRetorno = "entero";
                	break;    
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
                case "caracter":
                	tipoRetorno = "doble";
                	break;    
              	case "entero":
                	tipoRetorno = "doble";	
                	break;
				case "doble":
                	tipoRetorno = "doble";	
                	break;	
                case "booleano":
                	tipoRetorno = "doble";
                	break;    
            }
            break;	
          case "booleano":
            if(!Valorder){
            	tipoRetorno="booleano";
              	break;
            }
            switch(Valorder.Tipo)
            {
            	case "booleano":
                	tipoRetorno = "booleano";
              		break;
                case "entero":
                	tipoRetorno = "entero";
                	break;
                case "doble":
                	tipoRetorno = "doble";
                	break; 
                case "cadena":
                	tipoRetorno = "cadena";
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
                	case "entero":
            			return setSimbolos(Valorizq.Valor + Valorder.Valor, tipoRetorno);
					case "doble":
            			return setSimbolos(parseFloat(Valorizq.Valor + Valorder.Valor), tipoRetorno);
                }
                break;
            case "-":
                switch(tipoRetorno)
                {
                	case "entero":
            			return setSimbolos(Valorizq.Valor - Valorder.Valor, tipoRetorno);
                		break;
					case "doble":
            			return setSimbolos(parseFloat(Valorizq.Valor - Valorder.Valor), tipoRetorno);
                }
                break;
            case "umenos":
                switch(tipoRetorno)
                {
                	case "entero":
            			return setSimbolos(0-Valorizq.Valor, tipoRetorno);
					case "doble":
            			return setSimbolos(parseFloat(0-Valorizq.Valor), tipoRetorno);	
                }
                break;
            case "*":
                if(Valorder.Tipo != "booleano" && Valorizq.Tipo != "booleano" && Valorder.Tipo != "cadena" && Valorizq.Tipo != "cadena" && (Valorizq.Tipo != 'caracter' || Valorder.Tipo != 'caracter')) {

                switch(tipoRetorno)
                {
                	case "entero":
                    	return setSimbolos(Number(Valorizq.Valor * Valorder.Valor), tipoRetorno);
					case "doble":
                    	return setSimbolos(parseFloat(Valorizq.Valor * Valorder.Valor), tipoRetorno);	
                }
                
                }
                break;
            case "/":
                if(Valorder.Tipo != "booleano" && Valorizq.Tipo != "booleano" && Valorder.Tipo != "cadena" && Valorizq.Tipo != "cadena" && (Valorizq.Tipo != 'caracter' || Valorder.Tipo != 'caracter')) {

                switch(tipoRetorno)
                {
                    case "cadena":	
                    	return setSimbolos(parseFloat(Valorizq.Valor / Valorder.Valor), "doble");
                	case "entero":	
                    	return setSimbolos(parseFloat(Valorizq.Valor / Valorder.Valor), "doble");
					case "doble":	
                    	return setSimbolos(parseFloat(Valorizq.Valor / Valorder.Valor), tipoRetorno);	
                }
                }
                break;
			case "^":
                if(Valorder.Tipo != "booleano" && Valorizq.Tipo != "booleano" && Valorder.Tipo != "cadena" && Valorizq.Tipo != "cadena" && Valorizq.Tipo != 'caracter' && Valorder.Tipo != 'caracter') {

                switch(tipoRetorno)
                {
                	case "entero":	
                    	return setSimbolos(Number(Valorizq.Valor ** Valorder.Valor), tipoRetorno);
					case "doble":	
                    	
                        return setSimbolos(parseFloat(Valorizq.Valor ** Valorder.Valor), tipoRetorno);	
                }
            }
                break;	
            case "%":
                if(Valorder.Tipo != "booleano" && Valorizq.Tipo != "booleano" && Valorder.Tipo != "cadena" && Valorizq.Tipo != "cadena" && Valorizq.Tipo != 'caracter' && Valorder.Tipo != 'caracter') {

                switch(tipoRetorno)
                {
                	case "entero":
            			return setSimbolos(Valorizq.Valor % Valorder.Valor, tipoRetorno);
					case "doble":
            			return setSimbolos(Number(Valorizq.Valor % Valorder.Valor), "entero");		
                }
                }
                break;
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
                break;
            case "and":
                switch(tipoRetorno)
                {
                	case "booleano":
            			return setSimbolos(Valorizq.Valor && Valorder.Valor, tipoRetorno);
                }
                break;
            case "or":
                switch(tipoRetorno)
                {
                	case "booleano":
                		return setSimbolos(Valorizq.Valor || Valorder.Valor, tipoRetorno);
                }
                break;
            case ">":
                if(Valorder.Tipo != "booleano" && Valorizq.Tipo != "booleano" && (Valorizq.Tipo != 'caracter' || Valorder.Tipo != 'cadena') && (Valorizq.Tipo != 'cadena' || Valorder.Tipo != 'caracter')) {
                    
                switch(tipoRetorno)
                {
                    
                	case "cadena":
                    case "caracter":
                	case "entero":
					case "doble":
                	case "booleano":
                    	return setSimbolos(Valorizq.Valor > Valorder.Valor, "booleano");
                }
                }
                switch(tipoRetorno)
                {
                	case "booleano":
                    	return setSimbolos(Valorizq.Valor > Valorder.Valor, "booleano");
                }
                break;
            case "<":
                if(Valorder.Tipo != "booleano" && Valorizq.Tipo != "booleano" && (Valorizq.Tipo != 'caracter' || Valorder.Tipo != 'cadena') && (Valorizq.Tipo != 'cadena' || Valorder.Tipo != 'caracter')) {
                    
                switch(tipoRetorno)
                {
                    
                	case "cadena":
                    case "caracter":
                	case "entero":
					case "doble":
                	case "booleano":
                    	return setSimbolos(Valorizq.Valor < Valorder.Valor, "booleano");
                }
                }
                switch(tipoRetorno)
                {
                	case "booleano":
                    	return setSimbolos(Valorizq.Valor < Valorder.Valor, "booleano");
                }
                break;
            case ">=":
                if(Valorder.Tipo != "booleano" && Valorizq.Tipo != "booleano" && (Valorizq.Tipo != 'caracter' || Valorder.Tipo != 'cadena') && (Valorizq.Tipo != 'cadena' || Valorder.Tipo != 'caracter')) {
                    
                switch(tipoRetorno)
                {
                    
                	case "cadena":
                    case "caracter":
                	case "entero":
					case "doble":
                	case "booleano":
                    	return setSimbolos(Valorizq.Valor >= Valorder.Valor, "booleano");
                }
                }
                switch(tipoRetorno)
                {
                	case "booleano":
                    	return setSimbolos(Valorizq.Valor >= Valorder.Valor, "booleano");
                }
                break;
            case "<=":
                if(Valorder.Tipo != "booleano" && Valorizq.Tipo != "booleano" && (Valorizq.Tipo != 'caracter' || Valorder.Tipo != 'cadena') && (Valorizq.Tipo != 'cadena' || Valorder.Tipo != 'caracter')) {
                    
                switch(tipoRetorno)
                {
                    
                	case "cadena":
                    case "caracter":
                	case "entero":
					case "doble":
                	case "booleano":
                    	return setSimbolos(Valorizq.Valor <= Valorder.Valor, "booleano");
                }
                }
                switch(tipoRetorno)
                {
                	case "booleano":
                    	return setSimbolos(Valorizq.Valor <= Valorder.Valor, "booleano");
                }
                break;
            case "==":
                if(Valorder.Tipo != "booleano" && Valorizq.Tipo != "booleano" && (Valorizq.Tipo != 'caracter' || Valorder.Tipo != 'cadena') && (Valorizq.Tipo != 'cadena' || Valorder.Tipo != 'caracter')) {
                
                switch(tipoRetorno)
                {
                    
                	case "cadena":
                    case "caracter":
                	case "entero":
					case "doble":
                	case "booleano":
                    	return setSimbolos(Valorizq.Valor == Valorder.Valor, "booleano");
                }
                }
                switch(tipoRetorno)
                {
                	case "booleano":
                    	return setSimbolos(Valorizq.Valor == Valorder.Valor, "booleano");
                }
                break;
            case "!=":
                if(Valorder.Tipo != "booleano" && Valorizq.Tipo != "booleano" && (Valorizq.Tipo != 'caracter' || Valorder.Tipo != 'cadena') && (Valorizq.Tipo != 'cadena' || Valorder.Tipo != 'caracter')) {
                    
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
                switch(tipoRetorno)
                {
                	case "booleano":
                    	return setSimbolos(Valorizq.Valor != Valorder.Valor, "booleano");
                }
                break;
            case "lower":
                switch(tipoRetorno)
                {
                	case "cadena":
            			return setSimbolos(Valorizq.Valor.toLowerCase(), tipoRetorno);
                }
                break;
            case "upper":
                switch(tipoRetorno)
                {
                	case "cadena":
            			return setSimbolos(Valorizq.Valor.toUpperCase(), tipoRetorno);
                }
                break;  
            case "length":
                switch(tipoRetorno)
                {
                	case "cadena":
            			return setSimbolos(Valorizq.Valor.length, "entero");
                }
                break;  
            case "truncate":
                switch(tipoRetorno)
                {
                    case "entero":
            			return setSimbolos(Valorizq.Valor, tipoRetorno);
					case "doble":
            			return setSimbolos(Math.trunc(Valorizq.Valor), "entero");
                }
                break;
             case "round":
                switch(tipoRetorno)
                {
                    case "entero":
            			return setSimbolos(Valorizq.Valor, tipoRetorno);
					case "doble":
            			return setSimbolos(Math.round(Valorizq.Valor), "entero");
                }
                break;
            case "typeof":
                switch(tipoRetorno)
                {
                    case "cadena":
                        return setSimbolos("cadena", "cadena");
                    case "caracter":
                        return setSimbolos("caracter", "cadena");
                	case "entero":
                        return setSimbolos("entero", "cadena");
					case "doble":
                        return setSimbolos("doble", "cadena");
                	case "booleano":
                    	return setSimbolos("booleano", "cadena");
                }
                break; 
            case "tostring":
                switch(tipoRetorno)
                {
                	case "entero":
                        return setSimbolos(Valorizq.Valor.toString(), "cadena");
					case "doble":
                        return setSimbolos(Valorizq.Valor.toString(), "cadena");
                	case "booleano":
                    	return setSimbolos(Valorizq.Valor.toString(), "cadena");
                }
                break;
            case "casteo":
                if(Valorizq.Tipo == "entero" && Valorder.Tipo == "doble"){
                    return setSimbolos(Number(Valorder.Valor), "entero");
                } else if(Valorizq.Tipo == "doble" && Valorder.Tipo == "entero"){
                    return setSimbolos(parseFloat(Valorder.Valor), "doble");
                }else if(Valorizq.Tipo == "cadena" && Valorder.Tipo == "entero"){
                    return setSimbolos(Valorder.Valor.toString(), "cadena");
                }else if(Valorizq.Tipo == "caracter" && Valorder.Tipo == "entero"){
                    return setSimbolos(String.fromCharCode(Valorder.Valor), "caracter");
                }else if(Valorizq.Tipo == "cadena" && Valorder.Tipo == "doble"){
                    return setSimbolos(Valorder.Valor.toString(), "cadena");
                }else if(Valorizq.Tipo == "entero" && Valorder.Tipo == "caracter"){
                    return setSimbolos(Number(Valorder.Valor), "entero");
                }else if(Valorizq.Tipo == "doble" && Valorder.Tipo == "caracter"){
                    return setSimbolos(Number(Valorder.Valor), "doble");
                }

                break;                    
        }
        Salida.push("Error semantico, Error de operacion con las expresiones: '"+ ( Valorizq ? Valorizq.Tipo : "" ) + " y " + ( Valorder ? Valorder.Tipo : "" ) +"'");
        errores.push(new Error_(0,0,"Semantico", "Semantico","Error de operacion con las expresiones: '"+ ( Valorizq ? Valorizq.Tipo : "" ) + " y " + ( Valorder ? Valorder.Tipo : "" ) +"'"));
        console.log("Semantico","Error de operacion con las expresiones: '"+ ( Valorizq ? Valorizq.Tipo : "" ) + " y " + ( Valorder ? Valorder.Tipo : "" ) +"'");
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
        Salida.push("Error semantico, La variable "+declaracion.Id+" ya ha sido declarada en este ambito");
        errores.push(new Error_(0,0,"Semantico", "La variable ",declaracion.Id," ya ha sido declarada en este ambito"));
        console.log("La variable ",declaracion.Id," ya ha sido declarada en este ambito");
      		return;
      	}
    		// evaluar el resultado de la expresión 
		var valor ;	
      	if (declaracion && declaracion.Expresion)
      	{
        	valor = Evaluar(declaracion.Expresion, ent);
            if(valor.Tipo != declaracion.Tipo){
                Salida.push("Error semantico, tipos de datos incompatibles : '"+ declaracion.Tipo + " y " + valor.Tipo +"'");
                errores.push(new Error_(0,0,"Semantico","tipos de datos incompatibles : '"+ declaracion.Tipo + " y " + valor.Tipo +"'"));
                console.log("Semantico","tipos de datos incompatibles : '"+ declaracion.Tipo + " y " + valor.Tipo +"'");
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
        let aux = new Simbolo_(0,0,"Variable",declaracion.Tipo,declaracion.Id);
        let cont = 0;
        let bandera = false;
        while(simbolos.length > cont){
            if(simbolos[cont].identificador == declaracion.Id){
                bandera = true
            }
            cont++;
        }
        if(bandera==false){
             simbolos.push(new Simbolo_(0,0,"Variable",declaracion.Tipo,declaracion.Id));
        }
       
    }
		// objeto que almacena los datos para hacer una asignacion 
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
      	var temp=ent;
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
                    Salida.push("Error semantico, tipos de datos incompatibles : '"+ simbolotabla.Tipo + " y " + valor.Tipo +"'");
                    errores.push(new Error_(0,0,"Semantico","tipos de datos incompatibles : '"+ simbolotabla.Tipo + " y " + valor.Tipo +"'"));
                    console.log("Semantico","tipos de datos incompatibles : '"+ simbolotabla.Tipo + " y " + valor.Tipo +"'");
                    return
                }
            }
            temp=temp.anterior;
        }
        Salida.push("Error semantico, No se encontro la variable "+asignar.Id);
        errores.push(new Error_(0,0,"Semantico","No se encontro la variable "+asignar.Id));
        console.log("No se encontro la variable "+asignar.Id);
    }
    //objeto que guarda los datos del incremento
    const Incremento = function(id)
    {
    	return {
      		Id:id,
        	TipoInstruccion: "incremento"
      	}
    }
    function EjecutarIncremento(asignar,ent) {
        // validar si existe la variable
      	var temp=ent;
      	while(temp!=null)
        {
            if (temp.tablaSimbolos.has(asignar.Id))
            {
              	// reasignar el valor
                  var simbolotabla = temp.tablaSimbolos.get(asignar.Id);
                  var numero = simbolotabla.Valor +1;
                 temp.tablaSimbolos.set(asignar.Id, setSimbolos(numero, "entero"));
                    return
            }
            temp=temp.anterior;
        }
        Salida.push("Error semantico, No se encontro la variable "+asignar.Id);
        errores.push(new Error_(0,0,"Semantico","No se encontro la variable "+asignar.Id));
        console.log("No se encontro la variable "+asignar.Id);
    }
    //objeto que guarda los datos del decremento
    const Decremento = function(id)
    {
    	return {
      		Id:id,
        	TipoInstruccion: "decremento"
      	}
    }
    function EjecutarDecremento(asignar,ent) {
        // validar si existe la variable
      	var temp=ent;
      	while(temp!=null)
        {
            if (temp.tablaSimbolos.has(asignar.Id))
            {
              	// reasignar el valor
                  var simbolotabla = temp.tablaSimbolos.get(asignar.Id);
                  var numero = simbolotabla.Valor - 1;
                 temp.tablaSimbolos.set(asignar.Id, setSimbolos(numero, "entero"));
                    return
            }
            temp=temp.anterior;
        }
        Salida.push("Error semantico, No se encontro la variable "+asignar.Id);
        errores.push(new Error_(0,0,"Semantico","No se encontro la variable "+asignar.Id));
        console.log("No se encontro la variable ",asignar.Id);
    }
	//insBreak
  	const insBreak = function()
    {
      	return {
          TipoInstruccion:"insBreak"
        }
    }
    const insContinue = function()
    {
      	return {
          TipoInstruccion:"insContinue"
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
            Salida.push("Error semantico, Se esperaba una condicion dentro del if");
            errores.push(new Error_(0,0,"Semantico","Se esperaba una condicion dentro del if"));
            console.log("Se esperaba una condicion dentro del if");
        }
    }
    //Objeto donde se guardaran los datos de los casos
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
	//objeto donde se agruparan los datos del wihle
	const condWHILE = function(Condicion, Bloque)
    {
        return {
            Condicion: Condicion,
            Bloque: Bloque,
            TipoInstruccion:"while"
        }
    }
  
  	function EjecutarWHILE(mientras,ent)
	{
        pilaCiclos.push("ciclo");        
      	var nuevo;
        while(true)
        {
            nuevo=Entorno(ent);
        	var resultadoCondicion = Evaluar(mientras.Condicion, nuevo)
            if(resultadoCondicion.Tipo=="booleano")
            {
            	if(resultadoCondicion.Valor)
            	{
                	var res=EjecutarBloque(mientras.Bloque, nuevo);
                	if(res && res.TipoInstruccion=="insBreak")
                	{
                		break;
                	}
                    else if(res && res.TipoInstruccion=="insContinue")
                    {
                        continue;
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
                Salida.push("Error semantico, el while esperaba una condicion que retorne un booleano, no un => '"+ resultadoCondicion.Tipo);
                errores.push(new Error_(0,0,"Semantico"," el while esperaba una condicion que retorne un booleano, no un => '"+ resultadoCondicion.Tipo));
                console.log("Semantico","Error, el while esperaba una condicion que retorne un booleano, no un => '"+ resultadoCondicion.Tipo );
                pilaCiclos.pop();
                return
            }
		}
        pilaCiclos.pop();
        return
	}
    	//objeto donde se agruparan los datos del do wihle
	const condDOWHILE = function(Condicion, Bloque)
    {
        return {
            Condicion: Condicion,
            Bloque: Bloque,
            TipoInstruccion:"dowhile"
        }
    }
    function EjecutarDOWHILE(mientras,ent)
	{
        pilaCiclos.push("ciclo");        
      	var nuevo;
        while(true)
        {
            nuevo=Entorno(ent);
        	var resultadoCondicion = Evaluar(mientras.Condicion, nuevo)
            if(resultadoCondicion.Tipo=="booleano")
            {
            	
                	var res=EjecutarBloque(mientras.Bloque, nuevo);
                	if(res && res.TipoInstruccion=="insBreak")
                	{
                		break;
                	}else if(res && res.TipoInstruccion=="insContinue")
                    {
                        continue;
                    }
                    else if (res)
                    {
                        pilaCiclos.pop();
                        return res
                    }
                resultadoCondicion = Evaluar(mientras.Condicion, nuevo)    
            	if(!resultadoCondicion.Valor)
            	{
                	break;
              	}
            }
            else
            {
                Salida.push("Error semantico, el while esperaba una condicion que retorne un booleano, no un => '"+ resultadoCondicion.Tipo);
                errores.push(new Error_(0,0,"Semantico"," el while esperaba una condicion que retorne un booleano, no un => '"+ resultadoCondicion.Tipo));
                console.log("Semantico","Error, el while esperaba una condicion que retorne un booleano, no un => '"+ resultadoCondicion.Tipo );
                pilaCiclos.pop();
                return
            }
		}
        pilaCiclos.pop();
        return
	}
	const condFOR = function(ExpDesde, ExpHasta, ExpPaso, Bloque)
    {
        return {
            ExpDesde: ExpDesde,
            ExpHasta: ExpHasta,
            ExpPaso: ExpPaso,
            Bloque: Bloque,
            TipoInstruccion:"for"
        }
    }
  
	function EjecutarFOR(insfor, ent)
	{
        pilaCiclos.push("ciclo"); 
      	var nuevo=Entorno(ent);
    	//controlador de la condicion
    	if( insfor.ExpDesde.TipoInstruccion == "declaracion" )
    	{
      		EjecutarDeclaracion(insfor.ExpDesde, nuevo);
    	}
    	else
    	{
        	EjecutarAsignar(insfor.ExpDesde, nuevo);
    	}
        var hasta = Evaluar(insfor.ExpHasta, nuevo);
    	var Simbolo=setSimbolos(insfor.ExpDesde.Id,"identificador")
        if( !(hasta.Tipo=="booleano") )
        {
            pilaCiclos.pop();
            Salida.push("Error semantico, Se esperaban valores numericos en el for");
            errores.push(new Error_(0,0,"Semantico","Se esperaban valores numericos en el for"));
            console.log("Se esperaban valores numericos en el for");
            return;
        }
    	while(true)
    	{
            
            hasta = Evaluar(insfor.ExpHasta, nuevo);
        	var inicio=Evaluar(Simbolo, nuevo)
            if( inicio.Tipo != "entero" )
            {
                pilaCiclos.pop();
                Salida.push("Error semantico, el for esperaba un entero no un => '"+ inicio.Tipo);
                errores.push(new Error_(0,0,"Semantico","el for esperaba un entero no un => '"+ inicio.Tipo));
                console.log("Semantico","Error, el for esperaba un entero no un => '"+ inicio.Tipo );
                return;
            }
        	if(hasta.Valor == true)
        	{
                    var res=EjecutarBloque(insfor.Bloque, nuevo);
                    if(res && res.TipoInstruccion=="insBreak")
                    {
                        break;
                    }else if(res && res.TipoInstruccion=="insContinue")
                    {
                        if( insfor.ExpPaso.TipoInstruccion == "incremento")
                    {
                        EjecutarIncremento(insfor.ExpPaso, nuevo);
                    } else if( insfor.ExpPaso.TipoInstruccion == "decremento")
                    {
                        EjecutarDecremento(insfor.ExpPaso, nuevo);
                    }
                    else
                    {
                        EjecutarAsignar(insfor.ExpPaso, nuevo);
                    }
                        continue;
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
        	if( insfor.ExpPaso.TipoInstruccion == "incremento")
            {
                EjecutarIncremento(insfor.ExpPaso, nuevo);
            } else if( insfor.ExpPaso.TipoInstruccion == "decremento")
            {
                EjecutarDecremento(insfor.ExpPaso, nuevo);
            }
            else
            {
                EjecutarAsignar(insfor.ExpPaso, nuevo);
            }
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
        if (ent.tablaSimbolos.has(elemento.Id))
      	{
            Salida.push("Error semantico, el nombre de la funcion o metodo: '"+ elemento.Id +" ya existe");
            errores.push(new Error_(0,0,"Semantico","el nombre de la funcion o metodo: '"+ elemento.Id +" ya existe"));
            console.log("Error Semantico","el nombre de la funcion o metodo: '"+ elemento.Id +" ya existe");
      		return;
      	}
        ent.tablaSimbolos.set(elemento.Id, elemento);
        if(elemento.Tipo=="void"){
            simbolos.push(new Simbolo_(0,0,"Metodo",elemento.Tipo,elemento.Id));
        }else{
            simbolos.push(new Simbolo_(0,0,"Funcion",elemento.Tipo,elemento.Id));
        }
        
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
        var Resueltos = [];
        for(var param of Llamada.Params)
        {
            var valor = Evaluar(param,ent);
            Resueltos.push(valor);
        }
        var temp = ent;
        var simboloFuncion = null;
      	while(temp!=null)
        {
            if (temp.tablaSimbolos.has(Llamada.Id))
            {
                // evaluar el resultado de la expresión 
                simboloFuncion = temp.tablaSimbolos.get(Llamada.Id);	
                break;
            }
            temp=temp.anterior;
        }
        if(!simboloFuncion){
            Salida.push("Error semantico, No se encontró la funcion: "+Llamada.Id );
            errores.push(new Error_(0,0,"Semantico","No se encontró la funcion: "+Llamada.Id ));
            console.log("Error Semantico","No se encontró la funcion: "+Llamada.Id );
            return setSimbolos("@error@","error");
        } 
        pilaFunciones.push(Llamada.Id);
        var nuevo=Entorno(EntornoGlobal)
        var index=0;
        for(var crear of simboloFuncion.Parametros)
        {
            crear.Expresion=Resueltos[index];
            EjecutarDeclaracion(crear,nuevo);
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
                    Salida.push("Error semantico, No se esperaba un retorno" );
                    errores.push(new Error_(0,0,"Semantico","No se esperaba un retorno"));
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
                    Salida.push("Error semantico, El tipo del retorno no coincide");
                    errores.push(new Error_(0,0,"Semantico","El tipo del retorno no coincide"));
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
                Salida.push("Error semantico, Se esperaba un retorno");
                errores.push(new Error_(0,0,"Semantico","Se esperaba un retorno"));
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
    //Llamada EXEC
    const LlamadaEXEC=function(Id,Params)
    {
        return {
            Id: Id,
            Params: Params,
            TipoInstruccion: "llamadaexec"
        }
    }
    function EjecutarLlamadaEXEC(Llamada,ent)
    {   
        if(principal==0){
        var Resueltos = [];
        for(var param of Llamada.Params)
        {
            var valor = Evaluar(param,ent);
            Resueltos.push(valor);
        }
        var temp = ent;
        var simboloFuncion = null;
      	while(temp!=null)
        {
            if (temp.tablaSimbolos.has(Llamada.Id))
            {
                // evaluar el resultado de la expresión 
                simboloFuncion = temp.tablaSimbolos.get(Llamada.Id);	
                break;
            }
            temp=temp.anterior;
        }
        if(!simboloFuncion){
            Salida.push("Error semantico, No se encontró la funcion: "+Llamada.Id);
            errores.push(new Error_(0,0,"Semantico","No se encontró la funcion: "+Llamada.Id));
            console.log("Error Semantico","No se encontró la funcion: "+Llamada.Id );
            return setSimbolos("@error@","error");
        } 
        pilaFunciones.push(Llamada.Id);
        var nuevo=Entorno(EntornoGlobal)
        var index=0;
        for(var crear of simboloFuncion.Parametros)
        {
            crear.Expresion=Resueltos[index];
            EjecutarDeclaracion(crear,nuevo);
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
                    Salida.push("Error semantico, No se esperaba un retorno");
                    errores.push(new Error_(0,0,"Semantico","No se esperaba un retorno"));
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
                    Salida.push("Error semantico, El tipo del retorno no coincide");
                    errores.push(new Error_(0,0,"Semantico","El tipo del retorno no coincide"));
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
                Salida.push("Error semantico, Se esperaba un retorno");
                errores.push(new Error_(0,0,"Semantico","Se esperaba un retorno"));
                console.log("Se esperaba un retorno");
                retorno=setSimbolos("@error@","error");
            }
            else
            {
                retorno=setSimbolos("@vacio@","vacio")
            }
        }
        pilaFunciones.pop();
        principal = principal+1;
        return retorno;
        }else{
            Salida.push("Error semantico, Solo se puede aplicar la funcion EXEC a una funcion, no a mas");
            errores.push(new Error_(0,0,"Semantico","Solo se puede aplicar la funcion EXEC a una funcion, no a mas"));
            console.log("Solo se puede aplicar la funcion EXEC a una funcion, no a mas");
        }
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
"toString"			return 'TOSTRING';
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
"++"				return 'INCREMENTO'
"--"				return 'DECREMENTO'
"+"					return 'MAS';
"-"					return 'MENOS';
"*"					return 'POR';
"/"					return 'DIVIDIDO';
"^"					return 'POTENCIA';
"%"					return 'MOD';



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
.					{ Salida.push('Este es un error léxico: ' + yytext + ', en la linea: ' + yylloc.first_line + ', en la columna: ' + yylloc.first_column);
                    errores.push(new Error_(yylloc.first_line,yylloc.first_column,"Lexico","Este es un error léxico: " + yytext));
                    console.error('Este es un error léxico: ' + yytext + ', en la linea: ' + yylloc.first_line + ', en la columna: ' + yylloc.first_column); }

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
    : instrucciones EOF {console.log(JSON.stringify($1,null,2)); EjecutarBloque($1,EntornoGlobal);
    let sal  = Salida;
    Salida = [];
    principal = 0; 
    EntornoGlobal = Entorno(null); return {salida: sal, ast: $1 };  }
	
    
;

instrucciones 
    : instrucciones instruccion  { $$=$1; $$.push($2); }
    | instruccion       { $$=[]; $$.push($1); }
    
	
;


instruccion 
    : PRINT PARIZQ expresion PARDER PTCOMA	                { $$ = print("print",$3); }
    | DECLARACION                                           { $$ = $1 }
    | ASIGNACION                                            { $$ = $1 }
    | condIF                                                { $$ = $1 }
    | switchCASE                                            { $$ = $1 }
    | condWHILE                                             { $$ = $1 }
    | condDOWHILE                                           { $$ = $1 }
    | condFOR                                               { $$ = $1 }
    | FUNCION                                               { $$ = $1 }
    | LLAMADA                                               { $$ = $1 }
    | IDENTIFICADOR INCREMENTO PTCOMA		                { $$ = Incremento($1);}
    | IDENTIFICADOR DECREMENTO PTCOMA		                { $$ = Decremento($1);}
    | BREAK PTCOMA                                          { $$ = insBreak();}
    | CONTINUE PTCOMA                                      {$$ = insContinue();}
    | RETORNO
    | error  {Salida.push('Este es un error Sintactico: ' + yytext + ', en la linea: ' + this._$.first_line + ', en la columna: ' + this._$.first_line.first_column);
                    errores.push(new Error_(this._$.first_line,this._$.first_column,"Sintactico","No se esperaba la expresion: " + yytext));
                    console.log('Este es un error Sintactico: ' + yytext + ', en la linea: ' + yylineno.first_line + ', en la columna: ' + yylineno.first_column);}
;

RETORNO   
    : RETURN expresion  PTCOMA   { $$ = Retorno($2); }
    | RETURN PTCOMA       { $$ = Retorno(setSimbolos("@Vacio@","void")); }
;

LLAMADA
    : IDENTIFICADOR PARIZQ PARDER  PTCOMA                         { $$ = Llamada($1,[]);}
    | IDENTIFICADOR PARIZQ L_exp PARDER  PTCOMA                   { $$ = Llamada($1,$3);}
    | EXEC IDENTIFICADOR PARIZQ PARDER  PTCOMA                    { $$ = LlamadaEXEC($2,[]);}
    | EXEC IDENTIFICADOR PARIZQ L_exp PARDER  PTCOMA              { $$ = LlamadaEXEC($2,$4);}
;

FUNCION
    : TIPO IDENTIFICADOR PARIZQ PARDER BLOQUE                       { $$ = Funcion($2,[],$1,$5); }
    | VOID IDENTIFICADOR PARIZQ PARDER BLOQUE                       { $$ = Funcion($2,[],"void",$5); }
    | TIPO IDENTIFICADOR PARIZQ PARAMETROS PARDER BLOQUE            { $$ = Funcion($2, $4, $1, $6); }
    | VOID IDENTIFICADOR PARIZQ PARAMETROS PARDER BLOQUE            { $$ = Funcion($2, $4, "void", $6); }
;

PARAMETROS
    : PARAMETROS COMA TIPO IDENTIFICADOR                        { $$ = $1; $$.push(Declaracion($4, $3, null));}
    | TIPO IDENTIFICADOR                                        { $$ = []; $$.push(Declaracion($2, $1, null));}
;

condFOR
    : FOR PARIZQ DECLARACION expresion PTCOMA refeshFOR PARDER  BLOQUE       { $$ = condFOR($3, $4, $6, $8);}
    | FOR PARIZQ ASIGNACION  expresion PTCOMA refeshFOR PARDER  BLOQUE       { $$ = condFOR($3, $4, $6, $8);}
;

refeshFOR
    : IDENTIFICADOR INCREMENTO				            { $$ = Incremento($1);}
    | IDENTIFICADOR DECREMENTO				            { $$ = Decremento($1);}
    | ASIGNACION                                        {$$ = $1;}
;

condWHILE
    : WHILE expresion BLOQUE                { $$ = condWHILE($2, $3);}
;

condDOWHILE
    : DO BLOQUE WHILE expresion PTCOMA               { $$ = condDOWHILE($4, $2);}
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
    | PARIZQ expresion PARDER     			{ $$ = $2}
    | LOWER PARIZQ expresion PARDER         { $$ = setOperacionUnario($3,"lower"); }
    | UPPER PARIZQ expresion PARDER         { $$ = setOperacionUnario($3,"upper"); }
    | LENGTH PARIZQ expresion PARDER         { $$ = setOperacionUnario($3,"length"); }
    | TRUNCATE PARIZQ expresion PARDER         { $$ = setOperacionUnario($3,"truncate"); }
    | ROUND PARIZQ expresion PARDER         { $$ = setOperacionUnario($3,"round"); }
    | TYPEOF PARIZQ expresion PARDER         { $$ = setOperacionUnario($3,"typeof"); }
    | TOSTRING PARIZQ expresion PARDER         { $$ = setOperacionUnario($3,"tostring"); }
	| NOT expresion							{ $$ = setOperacionUnario($2,"not");}
	| MENOS expresion %prec UMENOS			{ $$ = setOperacionUnario($2,"umenos");}
	| TRUE				     				{ $$ = setSimbolos(true,"booleano");}
	| FALSE				     				{ $$ = setSimbolos(false,"booleano");}
	| CADENA				     			{ $$ = setSimbolos($1,"cadena");}
	| CARACTER				     			{ $$ = setSimbolos($1,"caracter");}
	| DECIMAL				     			{ $$ = setSimbolos(parseFloat($1),"doble");}
	| ENTERO				     			{ $$ = setSimbolos($1,"entero");}
	| IDENTIFICADOR							{ $$ = setSimbolos($1,"identificador");}
    | IDENTIFICADOR PARIZQ PARDER           { $$ = setSimbolos({Id: $1, Params: []}, "funcion");}
    | IDENTIFICADOR PARIZQ L_exp PARDER     { $$ = setSimbolos({Id: $1, Params:$3}, "funcion");}
    	
;
L_exp
    : L_exp COMA expresion              { $$ = $1; $$.push($3);}
    | expresion                         { $$ = []; $$.push($1);}
;
