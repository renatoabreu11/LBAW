#!/bin/bash
for filename in *.js; do
	name=${filename%.js}
	uglifyjs --compress --mangle --output $name.min.js -- $filename
done
