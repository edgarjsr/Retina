#! /usr/bin/ruby
#  Etapa 1 - Analizador Lexicográfico para el lenguaje Retina
#   Alumnos: Johanny Prado 11-10801
#            Edgar Silva   11
# Fecha Ultima modificacion: 12/02/2017


################################################
#                 Clase: Token                 #
################################################

class Token
  attr_reader :t
  
  def initialize text
    @t = text
  end

  def to_s
    "Tk#{self.class}"
  end

  def idAndValue
    return [@t.class, @t]
  end
end

################################################
#               Hash de regex                  #
################################################

$tokens = {
  Number:            /\Anumber(?!\w)/,
  Bool:              /\Aboolean(?!\w)/,
  Program:           /\Aprogram(?!\w)/,
  True:              /\Atrue(?!\w)/,
  False:             /\Afalse(?!\w)/,
  With:              /\Awith(?!\w)/,
  Repeat:            /\Arepeat(?!\w)/,
  Do:                /\Ado(?!\w)/,
  Times:             /\Atimes(?!\w)/,
  End:               /\Aend(?!\w)/,
  If:                /\Aif(?!\w)/,
  Then:              /\Athen(?!\w)/,
  Else:              /\Aelse(?!\w)/,
  While:             /\Awhile(?!\w)/,
  For:               /\Afor(?!\w)/,
  From:              /\Afrom(?!\w)/,
  To:                /\Ato(?!\w)/,
  By:                /\Aby(?!\w)/,
  Begin:             /\Abegin(?!\w)/,
  Func:              /\Afunc(?!\w)/,
  Return:            /\Areturn(?!\w)/,
  Equal:             /\A=(?!=)/,
  Semicolon:         /\A;/,
  Comillas:          /\A"/,
  Arrow:             /\A->/,
  Comma:             /\A,/,
  Floats:            /\A-?[1-9]\d*\.\d*|\A-?0\.\d*/,
  Ints:              /\A0|\A-?[1-9]\d*/,
  Comments:          /\A#+(\w*[^\n]*)*/,
  Not:               /\Anot(?!\w)/,
  And:               /\Aand(?!\w)/,
  Or:                /\Aor(?!\w)/,
  Equivalence:       /\A==/,
  Difference:        /\A\/=/,
  GreaterOrEqual:    /\A>=/,
  LessOrEqual:       /\A<=/,
  Greater:           /\A>/,
  Less:              /\A</,
  Suma:              /\A\+/,
  Resta:             /\A-/,
  Multip:            /\A\*/,
  DivisionEx:        /\A\//,
  RestoEx:           /\A%/,
  DivisionEnt:       /\Adiv(?!\w)/,
  RestoEnt:          /\Amod(?!\w)/,
  CurlyBracketL:     /\A\(/,
  CurlyBracketR:     /\A\)/,
  Write:             /\Awrite(?!\w)/,
  WriteLn:           /\Awriteln(?!\w)/,
  Read:              /\Aread(?!\w)/,
  Identifier:        /\A[a-z]\w*/,
  Strings:           /\A"(\w*\W*)*"/,
  OpenEye:           /\Aopeneye(?!\w)/,
  Home:              /\Ahome(?!\w)/,
  CloseEye:          /\Acloseeye(?!\w)/,
  Backward:          /\Abackward(?!\w)/,
  RotateL:           /\Arotatel(?!\w)/,
  RotateR:           /\Arotater(?!\w)/,
  SetPosition:       /\Asetposition(?!\w)/,
  Arc:               /\Aarc(?!\w)/,
  Forward:           /\Aforward(?!\w)/
}
#signs = [ /"/, /\\/, /\\n/,  ]

################################################
#             Clase: LexicographicError        #
################################################

class LexicographicError < RuntimeError
  def initialize t
    @t = t
  end

  def to_s
    "Caracter inesperado '#{@t}'"
  end

  def idAndValue
    return [@t.class, @t]
  end
end

################################################
#                Clase: Types                  # 
################################################

class Types < Token
  attr_reader :t
  
  def initialize text
    @t = text
  end

  def to_s
    "Tipo de datos '#{@t}'"
  end

  def idAndValue
    return [@t.class, @t]
  end
end

class Bool < Types; end
class Number < Types; end

################################################
#                Clase: LogicalOp              #
################################################

class LogicalOp < Token
  attr_reader :t
  
  def initialize text
    @t = text
  end

  def to_s
    "Operador logico '#{@t}'"
  end

  def idAndValue
    return [@t.class, @t]
  end
end

class Or < LogicalOp; end
class And < LogicalOp; end
class Not < LogicalOp; end

################################################
#          Clase: ComparisonOp                 #
################################################

class ComparisonOp < Token
  attr_reader :t
  
  def initialize text
    @t = text
  end

  def to_s
    "Operador de comparacion '#{@t}'"
  end

  def idAndValue
    return [@t.class, @t]
  end
end

class Less < ComparisonOp; end
class LessOrEqual < ComparisonOp; end
class Greater < ComparisonOp; end
class GreaterOrEqual < ComparisonOp; end
class Equivalence < ComparisonOp; end
class Difference < ComparisonOp; end

################################################
#              Clase: ArithmeticOp             #
################################################

class ArithmeticOp < Token
  attr_reader :t
  
  def initialize text
    @t = text
  end

  def to_s
    "Operador aritmetico '#{@t}'"
  end

  def idAndValue
    return [@t.class, @t]
  end
end

class RestoEnt < ArithmeticOp; end
class RestoEx < ArithmeticOp; end
class DivisionEnt < ArithmeticOp; end
class DivisionEx < ArithmeticOp; end
class Suma < ArithmeticOp; end
class Resta < ArithmeticOp; end
class Multip < ArithmeticOp; end

################################################
#                  Clase: Signs                #
################################################

class Signs < Token
  attr_reader :t
  
  def initialize text
    @t = text
  end

  def to_s
    "Signo '#{@t}'"
  end

  def idAndValue
    return [@t.class, @t]
  end
end

class CurlyBracketR < Signs; end
class CurlyBracketL < Signs; end
class Comma < Signs; end
class Arrow < Signs; end
class Comillas < Signs; end
class Semicolon < Signs; end
class Equal < Signs; end

################################################
#             Clase: NumeralLit                #
################################################

class NumeralLit < Number
  attr_reader :t
  
  def initialize text
    @t = text
  end

  def to_s
    "Literal numerico '#{@t}'"
  end

  def idAndValue
    return [@t.class, @t]
  end
end

class Floats < NumeralLit; end
class Ints < NumeralLit; end

################################################
#              Clase: Identifier               #
################################################

class Identifier < Token
  attr_reader :t
  
  def initialize text
    @t = text
  end

  def to_s
    "Identificador '#{@t}'"
  end

  def idAndValue
    return [@t.class, @t]
  end
end

class InstMovi < Identifier; end
class Home < InstMovi; end
class OpenEye < InstMovi; end
class CloseEye < InstMovi; end
class Backward < InstMovi; end
class RotateL < InstMovi; end
class RotateR < InstMovi; end
class SetPosition < InstMovi; end
class Arc < InstMovi; end
class Forward < InstMovi; end

################################################
#           Clase: ReservedWords               #
################################################

class ReservedWords < Token
  attr_reader :t
  
  def initialize text
    @t = text
  end

  def to_s
    "Palabra reservada '#{@t}'"
  end

  def idAndValue
    return [@t.class, @t]
  end
end

class Return < ReservedWords; end
class With < ReservedWords; end
class Do < ReservedWords; end
class End < ReservedWords; end
class If < ReservedWords; end
class Else < ReservedWords; end
class Then < ReservedWords; end
class While < ReservedWords; end
class For < ReservedWords; end
class From < ReservedWords; end
class By < ReservedWords; end
class Repeat < ReservedWords; end
class Times < ReservedWords; end
class Func < ReservedWords; end
class Begin < ReservedWords; end
class Program < ReservedWords; end
class True < ReservedWords; end
class False < ReservedWords; end
class To < ReservedWords; end
class Read < ReservedWords; end
class Write < ReservedWords; end
class Writeln < ReservedWords; end

################################################
#               Clase: Comments                #
################################################

class Comments < Token
  attr_reader :t
  
  def initialize text
    @t = text
  end

  def to_s
    "Comentario '#{@t}'"
  end

  def idAndValue
    return [@t.class, @t]
  end
end

################################################
#                Clase: Strings                #
################################################

class Strings < Token
  attr_reader :t
  
  def initialize text
    @t = text
  end

  def to_s
    "String '#{@t}'"
  end

  def idAndValue
    return [@t.class, @t]
  end
end

class Lexer
  attr_reader :tokens, :inesperado, :col, :colG_array, :colB_array

  def initialize input
    @tokens = []
    @inesperado = []
    @input = input
    @col = 1
    @colG_array = []
    @colB_array = []
  end

  def catch_lexeme
    errores = false
    #puts @input
    # Return nil, if there is no input
    
    return if @input.empty?
    # Ignore every white space at the begining

    #if (@input =~ /\s/) == 0
    #	@input = ''
    #end 
   
    #if @input.empty? == false
    @col= @col + (@input =~ /\S/)
    @input =~ /\A\s*/
    @input = $'.gsub("\n",'')
    longitud= @input.length
   
    
    #end
    # $' hold the text in the subject string to the left and
    # to the right of the regex match.

    # Local variable initialize with error, if all regex don't succeed
    class_to_be_instanciated = LexicographicError # Yes, this is class. Amaze here
    # For every key and value, check if the input match with the actual regex
    $tokens.each do |k,v|
      if @input =~ v
        # Taking advantage with the reflexivity and introspection of the
        # language is nice
        class_to_be_instanciated = Object::const_get(k)
        # Da la clase de ese key particular
        lol = $&.length
        #puts " columna = #{@col}"
        @colG_array << @col
        @tokens << class_to_be_instanciated.new($&)
        #puts "PRUEBA TOKENS #{@tokens}"
        @col = @col + lol 
        break
      end
    end
    if $&.nil? and class_to_be_instanciated.eql? LexicographicError
      # Checks the unknown character
        if @input =~ /\S/
          until @input.empty?
            @input =~ /\S/
            @inesperado << class_to_be_instanciated.new($&)
            lol = $&.length
            @colB_array << @col
            #puts "columna = #{@col}" 
            @col= @col + lol
            # Updates input
            break
          end   
        end
    end
    # Append token found to the token list
      
    # Update input
    #col= col+1
    
    #if @input.empty? == false
    @input = @input[$&.length..@input.length-1]
    #end
    
    # Return token found
    #puts "Lo que da el catch_lexeme #{@tokens[-1]}"
    return @tokens[-1]

  end

# Probando
#  def next_token
#    if ((tok = @tokens.shift) != nil)
#      @tokensAux << tok
#      return tok.idAndValue
#    else
#      return nil
#    end
#  end
end
