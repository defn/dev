default:
	$(MAKE) prod

build: ./node_modules/.bin/grunt
	./node_modules/.bin/grunt

prod: ./node_modules/.bin/grunt
	./node_modules/.bin/grunt serve

dev: ./node_modules/.bin/grunt
# can't get this to work, piskel loads and stalls
	./node_modules/.bin/grunt play

./node_modules/.bin/grunt:
	npm install grunt-cli