#! /usr/bin/ruby
#  Etapa 1 - Analizador Lexicográfico para el lenguaje Retina
#   Alumnos: Johanny Prado 11-10801
#            Edgar Silva   11-10968
# Fecha Ultima modificacion: 12/02/2017

Ident = 2

class AST
  #def identador(cant=iden,token)
  #    token.rjust(iden +token.to_s.length,' ') + "\n" 
  #end  
  def print_ast indent=""
        puts "#{indent}#{self.class}:"

        attrs.each do |a|
            a.print_ast indent + "  " if a.respond_to? :print_ast
        end
    end

    def attrs
        instance_variables.map do |a|
            instance_variable_get a
        end
    end
end

class S < AST # Completada
    attr_accessor :bloqIns,
                  :funciones,
                  :symTab

    def initialize bloqIns,funciones=nil
        @bloqIns = bloqIns
        @funciones = funciones
        @symTab = nil
    end 

    def to_s
        ident=Ident
        sig_nivel = ident + Ident
        token = "\nAST:\n"

        if @bloqIns
          token = identador("Bloque:",ident) + token
          token = @bloqIns.to_s(sig_nivel)
        end
       
    end
end    

class InstBlq < AST # Completada
   attr_accessor :decla_list,
                 :inst_blq1

    def initialize decla = nil, inst_blq1
        @decla_list = decla
        @inst_blq1 = inst_blq1
    end
end

class InstBlq1 < AST # Completada
   attr_accessor :instruction_list,
                 :inst_blq

    def initialize instruc=nil, inst_blq = nil
        @instruction_list = instruc
        @inst_blq = inst_blq
    end
end 

class ListDecl < AST # Completada
  attr_accessor :declaration_list,
                :decl

  def initialize decl,declaList = nil 
    @declaration_list= declaList
    @decl = decl
  end
end 

#class Comentarios < AST
# attr_accessor:instruction_list

#    def initialize instruc
#        @instrucciones_list = instruc
#    en
#end

class Decl < AST # Completada
 attr_accessor :tipo,
               :decl1 

    def initialize decl1, t
        @decl1 = decl1
        @tipo = t
    end
end

class Decl1 < AST # Completada
 attr_accessor :list_id,
               :asig 

    def initialize li,a=nil
        @list_id = li
        @asig = a
    end
end 


class ListId < AST # Completada
 attr_accessor :var,
               :list_id

    def initialize v,li = nil
        @var =v
        @list_id = li
    end
end 

=begin
class Var < AST
 attr_accessor :id

    def initialize id
        @id = id
    end
end
=end



class Asig < AST # Completada
 attr_accessor :types,
               :id_expr

    def initialize type1, type2, var, expr
        @types = [type1, type2]
        @id_expr = [var,expr]
    end
end 


class LisTerm < AST
 attr_accessor :term,
               :list_term

    def initialize ter,lisTerm=nil
        @term = ter
        @list_term = lisTerm
    end
end 


class BinOp < AST
    attr_accessor :left, :right

    def initialize lh, rh
        @left = lh
        @right = rh
    end
end 


class UnOp < AST
 attr_accessor :right

    def initialize rh
        @right = rh
    end
end 


class ParenEx < AST
 attr_accessor :expr

    def initialize e
        @expr = e
    end
end 


class ListInst < AST # Completada
 attr_accessor :inst,
               :asig,
               :loopp,
               :list_inst,
               :list_decl,
               :conditional

    def initialize i=nil,a=nil,l=nil,listInst=nil, cond=nil,list_decl=nil
        @inst =i
        @asig =a
        @loopp =l
        @list_decl=list_decl
        @list_inst = listInst
        @conditional = cond
    end
end 


class Inst < AST # Completada
    attr_accessor :exp,
                  :inst_movi1,
                  :rReturn

    def initialize inst_movi1=nil,exp=nil,rReturn
        @inst_movi1=inst_movi1
        @exp=exp
        
        @rReturn =rReturn
    end
end


class Rreturn < AST # Completada
    attr_accessor :expr
    def initialize expr
        @expr=expr
    end

end  


class InstMovi1 < AST # Completada
    attr_accessor :inst_movi2

    def initialize inst
        @inst_movi2 = inst
    end
end


class InstMovi2 < AST # Completada
    attr_accessor :expr

    def initialize expr
        @expr = expr
    end
end


class Conditional < AST

    attr_accessor :list_inst,
                  :exp,
                  :cond1

    def initialize expr,listInst,cond1
        @exp =expr
        @list_inst =listInst
        @cond1 = cond1
    end
end


class Cond1 < AST

    attr_accessor :list_inst

    def initialize listInst
        @list_inst =listInst
    end
end


class Loop < AST
    attr_accessor :var,
                  :list_inst,
                  :exp


    def initialize v=nil,expr=nil,listInst
        @var=v
        @exp =expr
        @list_inst =listInst
    end
end 


class ListArg < AST
    attr_accessor :tipo,
                  :var,
                  :list_Arg

    def initialize t,v,listArg=nil
        @tipo =t
        @var =v
        @list_Arg =listArg
    end
end 


class DeclFunc < AST # Completada
    attr_accessor :nombre
                  :list_Arg,
                  :firma,
                  :list_inst

    def initialize listArg=nil,listInst, firm = nil,name
        @nombre =name
        @list_Arg =listArg
        @list_inst =listInst
        @firma = firm
    end
end


class Firm < AST # Completada
    attr_accessor :type

    def initialize type = nil
        @type = type
    end
end


class Term < AST
     attr_accessor :term,
                   :nameTerm

     def initialize term,name
         @term = term
         @nameTerm = name
     end
end