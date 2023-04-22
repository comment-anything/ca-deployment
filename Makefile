deps.npm:
	cd ca-front-end & npm i
	cd ca-static & npm i

dist.front.end:
	cd ca-front-end & npm run dist

zip.front.end:
	del .\ca-static\content\home\ca.zip
	cd ca-front-end/dist & 7z a -tzip ca.zip .
	move ca-front-end\dist\ca.zip ca-static\content\home
	cd ca-front-end/dist & 7z a -tzip comment-anywhere-distributed.zip .
	move ca-front-end\dist\comment-anywhere-distributed.zip .

build.static:
	cd ca-static & hugo

static:
	$(MAKE) dist.front.end
	$(MAKE) zip.front.end 
	$(MAKE) build.static

