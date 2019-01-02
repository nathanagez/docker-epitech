### How to install 

```
curl -O https://raw.githubusercontent.com/NastyZ98/docker-epitech/master/macOS/docker-compile.sh && chmod +x docker-compile.sh

mv docker-compile /usr/local/bin/

Also remember to add docker-compile to your PATH
```


### How to use 
```
USAGE :
	 docker-compile [PATH] [FLAG] [OPTION]
FLAGS :
	-m          Compile project
OPTIONS :
	-v          Start valgrind after compilation, binary name is required
	-i          Start project after compilation, binary name is required
```