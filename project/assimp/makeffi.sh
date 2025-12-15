gcc -E -nostdinc -Dinclude=#include -I. -I./include -Isystem-headers include/assimp/cimport.h | grep -v '^# [0-9]' > libassimp.h
