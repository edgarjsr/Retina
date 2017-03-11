class SymbolTable

	attr_accessor :father

	def initialize(father = nil)
		@symTable = Hash.new
		@father = father
	end
	
	def insert(key, values)
		return @symTable.store(key, values)
	end

	def delete(key)
		return @symTable.delete(key)
	end
	
	def contains(key)
		return @symTable.include?(key)
	end

	def update(key, value)
		if !(contains(key))
			if (@father != nil)
				return @father.update(key, value)
			else
				puts "ERROR: variable '#{key}' has not been declared."
				return false
			end
		else
			@symTable[key] = value
			return true
		end		
	end

	def lookup(key)
		if !(contains(key))
			if (@father != nil)
				return @father.lookup(key)
			else
				return nil
			end
		else
			return @symTable[key]
		end
	end

	def get_lvl
		auxTab = self
		lvl = 0
		while (auxTab.father != nil)
			auxTab = auxTab.father
			lvl += 1
		end
		return lvl
	end

	def print_Table
		lvl = get_lvl
		for i in 1..lvl
			print "\t"
		end
		if (@symTable.empty?)
			print "- No variables declared at this scope -"
		else
			@symTable.each do |k|
				print "#{k[1][0]} #{k[0]} "
			end
		end
		puts
	end
end