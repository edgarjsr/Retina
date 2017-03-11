RACC = racc
PARSER = retina_parser.y

retina_parser.rb: ${PARSER}
	${RACC} $< -o $@

clean:
	rm retina_parser.rb
