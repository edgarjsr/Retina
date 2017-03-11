class Parser

	# Define la precedencia de los tokens
	prechigh
		
		nonassoc Not UMINUS
		left Multip DivisionEx RestoEx DivisionEnt RestoEnt
		left '+' Resta
		nonassoc Less LessOrEqual GreaterOrEqual Greater
		left And
		left Or
		right Equivalence Difference 
		right Equal
		left Semicolon
	preclow

	
	token Types Signs NumeralLit Identifier ReservedWords Strings UMINUS Ints InstMovi Number Bool Program True False With Repeat Do Times End If Then Else While For From To By Begin Func Return Equal Semicolon CurlyBracketR CurlyBracketL Comma Arrow Comillas Write Writeln Read Not And Or Less LessOrEqual Greater GreaterOrEqual  Equivalence Difference RestoEnt RestoEx DivisionEnt DivisionEx Resta Multip Comments Forward Arc SetPosition RotateR RotateL Backward CloseEye OpenEye Home Floats '+'

	convert
	Types 'Types'
	Signs 'Signs'
	NumeralLit 'NumeralLit'
	Identifier 'Identifier'
	ReservedWords 'ReservedWords'
	Strings 'Strings' 
	Ints 'Ints'
	InstMovi 'InstMovi'
	Number 'Number'
	Bool 'Bool'
	True 'True'
	False 'False'
	With 'With'
	Repeat 'Repeat'
	Do 'Do'
	Times 'Times'
	End 'End'
	If 'If'
	Then 'Then'
	Else 'Else'
	While 'While' 
	For 'For' 
	From 'From'
	To 'To'
	By 'By' 
	Begin 'Begin'
	Func 'Func'
	Return 'Return' 
	Equal 'Equal'
	Semicolon 'Semicolon'
	CurlyBracketR 'CurlyBracketR'
	CurlyBracketL 'CurlyBracketL'
	Comma 'Comma'
	Arrow 'Arrow'
	Comillas 'Comillas'
	Write 'Write'
	Writeln 'Writeln'
	Read 'Read'
	Not 'Not'
	And 'And'
	Or 'Or'
	Less 'Less'
	LessOrEqual 'LessOrEqual' 
	Greater 'Greater'
	GreaterOrEqual 'GreaterOrEqual' 
	Equivalence 'Equivalence'
	Difference 'Difference'
	RestoEnt 'RestoEnt'
	RestoEx 'RestoEx'
	DivisionEnt 'DivisionEnt'
	DivisionEx 'DivisionEx'
	'+' 'Suma'
	Resta 'Resta'
	Multip 'Multip'
	Comments 'Comments' 
	Forward 'Forward'
	Arc 'Arc'
	SetPosition 'SetPosition'
	RotateR 'RotateR'
	RotateL 'RotateL'
	Backward 'Backward'
	CloseEye 'CloseEye'
	OpenEye 'OpenEye'
	Home 'Home'
	Floats 'Floats'
	Program 'Program' 

end
    start S

	rule 

		# programa: Define un programa
		S
		: Program InstBlq End Semicolon 			    {result = S.new(val[1])} 
		| Declfuncion Program InstBlq End Semicolon 	{result = S.new(val[0],val[2])} 
		;

		# InstBlq: Bloque de instrucciones
		InstBlq 
        : With ListDecl Do InstBlq1  	                {result = InstBlq.new(val[3],val[1])}
        | Do InstBlq1                                   {result = InstBlq.new(val[1])}
        ;

        # InstBlq1: Complemento del InstBlq derivado del left-factoring
        InstBlq1
        : ListInst End Semicolon                        {result = InstBlq1.new(val[0])}
        | InstBlq End Semicolon                         {result = InstBlq1.new(val[0])}
        ;

        # ListDecl: Lista de declaraciones
        ListDecl
        : Decl                                          {result = ListDecl.new(val[0])}
        | ListDecl Decl                                 {result = ListDecl.new(val[1], val[0])}
        ;

        # Decl: Declaracion
		Decl
		: Type Decl1			                        {result = Decl.new(val[1], val[0])} 
		;

		# Decl1: Complemento del Decl derivado del left-factoring
		Decl1
		: ListId Semicolon                              {result = Decl1.new(val[0])}
		| Asig Semicolon                                {result = Decl1.new(val[0])}
		;
        
		# ListId: Lista de variables
		ListId
		: Var 				                            {result = ListId.new(val[0])}
		| ListId Comma Var 	                            {result = ListId.new(val[2], val[0])}
		;

		# Var: Variable
        Var
        : Identifier                                   {result = Term.new(:Identifier , val[0])}
        ;       
		
		# Asig: Asignaciones
        Asig
        : Var Equal Expr                                {result = Asig.new(:Var,val[0],:Expr val[2])}
        ;

        # Term: Terminos validos
        Term
		: Boolean   		                    
		| Num
		| Var                                         
		; 


		# Numeros: define al tipo de los numeros en LANSCII.
		Num
		: Ints				{result = Term.new(:Ints , val[0])}
		| Floats			{result = Term.new(:Floats , val[0])}
		;

		# Booleanos: define al tipo de variables booleanas en LANSCII.
		Boolean
		: True					{result = Term.new(:True , val[0])}
		| False					{result = Term.new(:False , val[0])}
		;

		# Type: Tipos validos 
		Type
		: Number 				                        {result = :Number}
		| Bool						                    {result = :Bool}
		;

		# Expr: Expresione validas
		Expr
		: Term                                          {result = Term.new(val[0])}
		| Expr RestoEnt  Expr                           {result = BinOp.new(val[2], val[0])}
		| Expr RestoEx  Expr                            {result = BinOp.new(val[2], val[0])}
		| Expr DivisionEnt  Expr                        {result = BinOp.new(val[2], val[0])}
		| Expr DivisionEx  Expr                         {result = BinOp.new(val[2], val[0])}
		| Expr '+' Expr                                 {result = BinOp.new(val[2], val[0])}
		| Expr Resta  Expr                              {result = BinOp.new(val[2], val[0])}
		| Expr Multip  Expr                             {result = BinOp.new(val[2], val[0])}
		| Resta Expr 	    =UMINUS                     {result = UnOp.new(val[1])}
    	| Not Expr                                      {result = UnOp.new(val[1])}
    	| Expr And Expr                                 {result = BinOp.new(val[2], val[0])}
    	| Expr Or Expr                                  {result = BinOp.new(val[2], val[0])}
    	| Expr Less Expr                                {result = BinOp.new(val[2], val[0])}
    	| Expr LessOrEqual Expr                         {result = BinOp.new(val[2], val[0])}
    	| Expr Greater Expr                             {result = BinOp.new(val[2], val[0])}
    	| Expr GreaterOrEqual Expr                      {result = BinOp.new(val[2], val[0])}
    	| Expr Equivalence Expr                         {result = BinOp.new(val[2], val[0])}
    	| Expr Difference Expr                          {result = BinOp.new(val[2], val[0])}
    	| CurlyBracketL Expr CurlyBracketR              {result = ParenEx.new(val[1])}
        ;

        # ListInst: Lista de instrucciones posibles
        ListInst
    	: inst                                          {result = ListInst.new(val[0])}
    	| Asig                                          {result = ListInst.new(val[0])}
    	| Conditional                                   {result = ListInst.new(val[0])}
    	| Loop                                          {result = ListInst.new(val[0])}
    	| ListInst inst                                 {result = ListInst.new(val[0], val[1])}
    	| ListDecl                                      {result = ListInst.new(val[0])}
    	;

    	# inst: Instrucciones validas
	    inst
	    : Read Identifier Semicolon                                 
	    | Write Expr Semicolon                                              { result = Inst.new(val[1])}
	    | Writeln Expr Semicolon                                            { result = Inst.new(val[1])}
	    | Identifier CurlyBracketL InstMovi1 CurlyBracketR Semicolon          { result = Inst.new(val[2])}
	    | Return Rreturn  									           {result = Inst.new(val[1])}
	    ;

	    #Rreturn: Regla para el return
        Rreturn
        : Semicolon
        | Expr Semicolon     {result = Rreturn.new(val[0])}                               
	    ;

	    # InstMovi1: Complemento del inst derivado del left-factoring
	    InstMovi1
	    : /* empty */                                                     { result = nil}
	    | Expr InstMovi2                                                  { result = InstMovi1.new(val[1])}
	    ;

	    # InstMovi2: Complemento del InstMovi1 derivado del left-factoring
	    InstMovi2
	    : /* empty */                                                           { result = nil}
	    | Comma Expr InstMovi2                                                  { result = InstMovi2.new(val[1])}
	    ;

	    # Conditional: Instruccion condicional
	    Conditional
	    : If Expr Then ListInst Cond1                   { result = Conditional.new(val[1], val[3], val[4]) }
	    ;

	    # Cond1: Complemento del Conditional derivado del left-factoring
	    Cond1
	    : End Semicolon
	    | Else ListInst End Semicolon                   { result = Cond1.new(val[1])}
	    ;

	    # Loop: Instrucciones de ciclo
	    Loop
	    : For Var From Ints To Ints Do ListInst End Semicolon               {result = Loop.new(val[1], val[7]) }
 	    | While Expr Do ListInst End Semicolon                              { result = Loop.new(val[1], val[3])}
	    | Repeat Ints Times ListInst End Semicolon                          { result = Loop.new(val[3])}
	    ;

	    # Declfuncion: Declaracion de funciones
        Declfuncion
        : Func Identifier CurlyBracketL ListArg CurlyBracketR Firm Begin ListInst End Semicolon  { result = DeclFunc.new(val[1],val[3], val[5],val[7])}
        ;

        # Firm: Complemento del Declfuncion derivado del left-factoring
        Firm
        : /* empty */
        | Arrow Type      { result = Firm.new(val[1])}
        ;

        # ListArg: Lista de argumentos validos
        ListArg
        : Type Var                                 { result = ListArg.new(val[0], val[1])}    
        | ListArg Comma Type Var                   { result = ListArg.new(val[0], val[2], val[3])}
        ;


---- header

require_relative "retina_lexer"
require_relative "retina_ast"

class SyntacticError < RuntimeError

    def initialize(tok)
        @token = tok
    end

    def to_s
        "Syntactic error on: #{@token}"   
    end
end

---- inner

def on_error(id, token, stack)
    raise SyntacticError::new(token)
end
   
def next_token
    token = @lexer.catch_lexeme
    puts "esto es una prueba"
    puts "Token del next_token: #{token}"
    #puts [token.class, token.idAndValue[1]]

    return [false,false] unless token
    return [token.class,token]

end
   
def parse(lexer)
    @yydebug = true
    @lexer = lexer
    @tokens = []
    ast = do_parse
    return ast
end
