require_relative 'retina_ast'
require_relative 'retina_symTable'

$symTable = nil		# Tabla de simbolos.
$tableStack = []	# Pila de tablas.

################################################
# Manejo de la estructura general del programa #
################################################

# Manejador del programa principal.
def program_Handler(ast, printSymbolTable)
	return s_Handler(ast.s, printSymbolTable)
end

# Manejador de alcances.
def s_Handler(s, printSymbolTable = nil)
	# Asignación de una nueva tabla.
	symTableAux = SymbolTable.new($symTable)
	$symTable = symTableAux
	s.symTab = $symTable
	#Manejo de la estructura.
	funcError = 0
	if (s.funciones != nil)
		funcError = func_Handler(s.funciones)
	end

	bloqInstrError = bloqInstr_Handler(s.bloqIns)
	# Se empila la tabla del scope en la pila de tablas.
	$tableStack << $symTable
	$symTable = $symTable.father
	# Si ya se analizo todo el programa, se imprimen cada una
	# de las tablas (si no hubo errores).
	if ($symTable == nil)
		if (printSymbolTable)
			if (funcError > 0) or (bloqInstrError > 0)
				puts "Symbol table will not be shown."
				abort
			end
			puts "Symbol Table:"
			$tableStack.reverse!
			$tableStack.each do |st|
				st.print_Table
			end
		end
	end
	return funcError + bloqInstrError
end

# Manejador de funciones del usuario
def func_Handler(funciones)
	#Manejo de la estructura.
	ArgError = 0
	if (funciones.list_Arg != nil)
		ArgError = listArg_Handler(funciones.list_Arg)
	end
    #si la funcion tiene firma verificamos
    firmError = 0
    firma=false
	if (funciones.firma != nil)
		firma=true
		firmError = firm_Handler(funciones.firma)
	end

	instrError = linst_Handler(firma,funciones.list_inst,funciones.nombre)
	return ArgError + instrError + firmError
end

#Manejador para la firma de las funciones
def firm_Handler(firma)
    if (firma.type == Number) or (firma.type == Bool)
    	 firmError=0
    else
    	 firmError=1
	end

    return firmError
end

#Manejador para el bloque de instrucciones
def bloqInstr_Handler(bloque) 
	#Manejo de la estructura.
	declError = 0
	if (bloque.decla_list != nil)
		declError = lDecl_Handler(bloque.decla_list)
	end

	bloqError = bloqInstr2_Handler(bloque.inst_blq1)
	return declError + bloqError
end

# Auxiliar para el bloque de instrucciones
def bloqInstr2_Handler(bloque)
	#Manejo de la estructura.
	instError = 0
	if (bloque.instruction_list != nil)
		instError = linst_Handler(false,bloque.instruction_list,"bloque")
	end

    bloqError = 0
	if (bloque.inst_blq!= nil)
		bloqError = bloqInstr_Handler(bloque.inst_blq)
	end

	return instError + bloqError
end	

# Manejador de lista de instrucciones
def linst_Handler(firma,list_inst,nombre)
	
	if firma == true
  		# verificacion de que return pertenezca a la lista de instrucciones
  		#if (list_inst.inst == Return or
  		#	 list_inst.list_inst.to_a.member? Return)
  			returnError = 0  
  		else 
  			puts "Falta 'Return' en la declaracion de la funcion #{nombre}"	
  			returnError = 1
  		end  
	end

	instError = 0
	if (list_inst.inst!= nil)
		instError = inst_Handler(list_inst.inst)
	end

	asigError = 0
	if (list_inst.asig!= nil)
		asigError = asig_Handler(list_inst.asig)
	end

	loopError = 0
	if (list_inst.loopp!= nil)
		loopError = loop_Handler(list_inst.loopp)
	end

	listInstError = 0
	if (list_inst.list_inst!= nil)
		listInstError = linst_Handler(false,list_inst.list_inst,"funcion")
	end

	condError = 0
	if (list_inst.conditional!= nil)
		condError = cond_Handler(list_inst.conditional)
	end

	return returnError + instError + asigError + loopError + listInstError + condError
end

#Manejador para una instruccion
def inst_Handler(inst)
	exprError = 0
	if (inst.exp!= nil)
		exprError = expr_Handler(inst.exp)
	end

	instMovError = 0
	if (inst.inst_movi1!= nil)
		instMovError = instMov_Handler(inst.inst_movi1)
	end

	listDeclError = 0
	if (inst.list_decl!= nil)
		listDeclError = lDecl_Handler(inst.list_decl)

	rReturnError = 0
	if (inst.rReturn!= nil)
		rReturnError = rReturn_Handler(inst.rReturn)
	end

	return exprError + instMovError + listDeclError + rReturnError
end

# Manejador de rReturn
def rReturn_Handler(rReturn)
	rReturnError = expr_Handler(rReturn.expr)
	return rReturnError
end

# Manejador de instMov1
def instMov_Handler(inst_movi1)
	instMov1Error = instMov2_Handler(inst_movi1.inst_movi2)
	return instMov1Error
end

# Manejador de instMovi2
def instMov2_Handler(inst_movi2)
	instMov2Error = expr_Handler(inst_movi2.expr)
	return instMov2Error
end

#Manejador de lista de declaraciones
def lDecl_Handler(ldecl)
	#Manejo de la estructura.
	listDeclError = 0
	if (ldecl.declaration_list != nil)
		listDeclError = lDecl_Handler(ldecl.declaration_list)
	end

    declError =  decl_Handler(ldecl.decl)

	return listDeclError + declError
end

#Manejador de declaraciones
def decl_Handler(decl)

	typeError = 0
	case decl.type
	when :Number
		typeError = decl1_Handler(:Number, decl.decl1)
	when :Bool
		typeError = decl1_Handler(:Bool, decl.decl1)
	else 
	    typeError = 1 
		puts "ERROR declaracion con un tipo desconocido #{decl.type}"
	end
	return typeError
end

# Manejador de decl_Handler1
def decl1_Handler(type, decl)
	
	error=0
    case type
	when :Number
		error = listId_Handler(:Number, decl.list_id)
	when :Bool
		error = listId_Handler(:Bool, decl.list_id)
	end
	asigError = 0
	if (decl.asig != nil)
		asigError = asig_Handler(decl.asig)
	end
	return error + asigError 
end

#Manejador para lista de Id
def listId_Handler(type, listI)

    if !($symTable.contains(listI.var))
		$symTable.insert(listI.var, [type, nil])
		if (listI.list_id != nil)                       # Cambie .listI por .list_id
			return listId_Handler(type, listI.list_id)  # Cambie .listI por .list_id
		end
		return 0
	else
		puts "ERROR: variable '#{listI.var}' was declared before" \
				" at the same scope."
		if (listI.list_id != nil)                           # Cambie .listI por .list_id
			return listId_Handler(type, listI.list_id) + 1  # Cambie .listI por .list_id
		end
		return 1
	end
end

# Manejador para asignaciones
def asig_Handler(asig)
	idVar = asig.id_expr[0].term
	#if (idVar == iterVar)
	#	puts "ASSIGN ERROR: iterator '#{idVar}' cannot be modified."
	#	return 1
	#end
	if ($symTable.lookup(idVar) == nil)
		puts "ASSIGN ERROR: variable '#{idVar}' has not been declared."
		return 1
	end
	typeVar = $symTable.lookup(idVar)[0]
	typeExpr = expr_Handler(asig.id_expr[1])
	if (typeVar != typeExpr)
		puts "ASSIGN ERROR: #{typeExpr} expression assigned to #{typeVar} "\
			"variable '#{idVar}'."
		return 1
	end
	return 0
end


def expr_Handler(type,expr)

     case type
     	:Bool




end

def listArg_Handler(list_Arg)
	typeError =  type_Handler(list_Arg.tipo)

	listArgError = 0
	if (list_Arg.list_Arg != nil)
		listArgError = listArg_Handler(list_Arg.list_Arg)
	end

	return typeError + listArgError
end


def type_Handler(type)
	error = 1
	if (type == :Number)
		error = 0
	elsif (type == :Bool)
		error = 0
	else
		puts "ERROR: unknown type: #{type}."
	end

	return error
end


################################################################################################################################################################################################################################################
#  CODIGO DE GENESIS
###################################################################################

# Manejador de declaraciones.
def decl_Handler(decl)
	result2 = 0
	case decl.type
	when :AT
		result1 = listI_Handler(:CANVAS, decl.listI)
	when :PERCENT
		result1 = listI_Handler(:NUMBER, decl.listI)
	when :EXCLAMATION_MARK
		result1 = listI_Handler(:BOOLEAN, decl.listI)
	end
	if (decl.decl != nil)
		result2 = decl_Handler(decl.decl)
	end
	return result1 + result2
end

# Manejador de lista de identificadores
def listI_Handler(type, listI)
	if !($symTable.contains(listI.id.term))
		$symTable.insert(listI.id.term, [type, nil])
		if (listI.listI != nil)
			return listI_Handler(type, listI.listI)
		end
		return 0
	else
		puts "ERROR: variable '#{listI.id.term}' was declared before" \
				" at the same scope."
		if (listI.listI != nil)
			return listI_Handler(type, listI.listI) + 1
		end
		return 1
	end
end

# Manejador de instrucciones
def instr_Handler(instr, iterVar=nil)
	case instr.opID[0]
	when :INSTR
		totResult = 0
		instr.branches.each do |i|
			totResult += instr_Handler(i,iterVar)
		end
		return totResult
	when :ASSIGN
		if iterVar != nil
			return assign_Handler(instr.branches[0], iterVar)
		else
			return assign_Handler(instr.branches[0])
		end
	when :READ
		return read_Handler(instr)
	when :WRITE
		return write_Handler(instr)
	when :CONDITIONAL_STATEMENT
		return conditional_statement_Handler(instr.branches[0])
	when :IND_LOOP
		return iLoop_Handler(instr.branches[0])
	when :DET_LOOP
		return dLoop_Handler(instr.branches[0])
	when :SCOPE
		return scope_Handler(instr.branches[0])
	end
end

############################################
# Manejo de las instrucciones del programa #
############################################

# Manejador de la instruccion ASSIGN.
def assign_Handler(assign, iterVar=nil)
	idVar = assign.branches[0].term
	if (idVar == iterVar)
		puts "ASSIGN ERROR: iterator '#{idVar}' cannot be modified."
		return 1
	end
	if ($symTable.lookup(idVar) == nil)
		puts "ASSIGN ERROR: variable '#{idVar}' has not been declared."
		return 1
	end
	typeVar = $symTable.lookup(idVar)[0]
	typeExpr = expression_Handler(assign.branches[1])
	if (typeVar != typeExpr)
		puts "ASSIGN ERROR: #{typeExpr} expression assigned to #{typeVar} "\
			"variable '#{idVar}'."
		return 1
	end
	return 0
end

# Manejador de la instruccion READ.
def read_Handler(read)
	idVar = read.branches[0].term
	if ($symTable.lookup(idVar) == nil)
		puts "READ ERROR: variable '#{idVar}' has not been declared."
		return 1
	end
	typeVar = $symTable.lookup(idVar)[0]
	if (typeVar != :NUMBER) and (typeVar != :BOOLEAN)
		puts "READ ERROR: variable '#{idVar}' must be an int or a boolean."
		return 1
	end
	return 0
end

# Manejador de la instruccion WRITE.
def write_Handler(write)
	expr = write.branches[0]
	typeExpr = expression_Handler(expr)
	if (typeExpr != :CANVAS)
		puts "WRITE ERROR: the expression given must be a canvas."
		return 1
	end
	return 0
end

# Manejador de la instruccion CONDITIONAL STATEMENT.
def conditional_statement_Handler(cs)
	expr = cs.elems[0]
	instr1 = cs.elems[1]
	result = instr_Handler(instr1)
	if (cs.elems[2] != nil)
		instr2 = cs.elems[2]
		result += instr_Handler(instr2)
	end
	if (expression_Handler(expr) != :BOOLEAN)
		puts "CONDITIONAL STATEMENT ERROR: expression must be boolean."
		result += 1
	end
	return result
end

# Manejador de la instruccion IND LOOP.
def iLoop_Handler(iLoop)
	result = 0
	expr = iLoop.elems[0]
	if (expression_Handler(expr) != :BOOLEAN)
		puts "IND LOOP ERROR: expression must be boolean."
		result += 1
	end
	instr = iLoop.elems[1]
	result += instr_Handler(instr)
	return result
end

# Manejador de la instruccion DET LOOP.
def dLoop_Handler(dLoop)
	result = 0
	if (dLoop.types[0] == :VARIABLE)
		iterVar = dLoop.elems[0].term
		# Busca la variable, si la encuentra, la actualiza, si no, la inserta.
		if ($symTable.lookup(iterVar) == nil)
			$symTable.insert(iterVar, [:NUMBER, nil])
		else
			$symTable.update(iterVar, [:NUMBER, nil])
		end
		expr1 = dLoop.elems[1]
		typeExpr1 = expression_Handler(expr1)
		expr2 = dLoop.elems[2]
		typeExpr2 = expression_Handler(expr2)
		if (typeExpr1 != :NUMBER) or (typeExpr2 != :NUMBER)
			puts "DET LOOP ERROR: expressions must be arithmetic."
			result += 1
		end
		instr = dLoop.elems[3]
		result += instr_Handler(instr, iterVar)
		return result
	else
		expr1 = dLoop.elems[0]
		typeExpr1 = expression_Handler(expr1)
		expr2 = dLoop.elems[1]
		typeExpr2 = expression_Handler(expr2)
		if (typeExpr1 != :NUMBER) or (typeExpr2 != :NUMBER)
			puts "DET LOOP ERROR: expressions must be arithmetic."
			result += 1
		end
		instr = dLoop.elems[2]
		result += instr_Handler(instr)
		return result
	end
end

##########################################
# Manejo de las expresiones del programa #
##########################################

# Manejador de expresiones:
# Esta función recibe una expresión y devuelve su tipo.
def expression_Handler(expr)
	# Procesar como binaria
	if expr.instance_of?(BinExp)
		return binExp_Handler(expr)
	# Procesar como unaria
	elsif expr.instance_of?(UnaExp)
		return unaExp_Handler(expr)
	# Procesar como parentizada
	elsif expr.instance_of?(ParExp)
		return parExp_Handler(expr)
	# Procesar como un caso base, un termino.
	elsif expr.instance_of?(Terms)
		type = expr.nameTerm
		case type
		when :IDENTIFIER			
			idVar = expr.term
			typeVar = $symTable.lookup(idVar)[0]
			return typeVar
		when :CANVAS
			return :CANVAS
		when :TRUE
			return :BOOLEAN
		when :FALSE
			return :BOOLEAN
		when :NUMBER
			return :NUMBER			
		end
	else
		puts "ERROR: hubo un errror expression_Handler."		
	end
end

# Manejador de expresiones binarias:
# Devuelve el tipo de las expresiones binarias
# => si hay un error de tipo, devuelve nil.
def binExp_Handler(expr)
	typeExpr1 = expression_Handler(expr.elems[0])
	typeExpr2 = expression_Handler(expr.elems[1])
	if (typeExpr1 != typeExpr2)
		return nil
	end
	case expr.op
	when /^\/\\/
		if typeExpr1 == :BOOLEAN
			return :BOOLEAN
		else
			return nil
		end
	when /^\\\//
		if typeExpr1 == :BOOLEAN
			return :BOOLEAN
		else
			return nil
		end
	when /^(=|\/=)/
		return :BOOLEAN
	when /^[\+\-\*\/%]/
		if typeExpr1 == :NUMBER
			return :NUMBER
		else
			return nil
		end
	when /^[~&]/
		if typeExpr1 == :CANVAS
			return :CANVAS
		else
			return nil
		end
	when /^(<|>|<=|>=)/
		if (typeExpr1 == :NUMBER) and (typeExpr2 == :NUMBER)
			return :BOOLEAN
		else
			return nil
		end
	end
end

# Manejador de expresiones parentizadas.
def parExp_Handler(expr)
	return expression_Handler(expr.expr)
end

# Manejador de expresiones unarias.
# Devuelve el tipo de las expresiones unarias
# => si hay un error de tipo, devuelve nil.
def unaExp_Handler(expr)
	typeExpr = expression_Handler(expr.elem)
	case expr.op
	when /^[$']/
		if typeExpr == :CANVAS
			return :CANVAS
		else
			return nil
		end
	when /\^/
		if typeExpr == :BOOLEAN
			return :BOOLEAN
		else
			return nil
		end
	when /-/
		if typeExpr == :NUMBER
			return :NUMBER
		else
			return nil
		end
	end
end