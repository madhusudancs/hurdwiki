s%i686-pc-linux-gnu%[ARCH]%g
s%i386-linux-gnu%[MULTIARCH]%g

s%-I../../../master/libgomp/config/linux/x86 -I../../../master/libgomp/config/linux %%
s%-march=i486 -mtune=i686 %%
s%-Werror -ftls-model=initial-exec -march=i486 -pthread -mtune=i686%-Werror -pthread -ftls-model=initial-exec%
s%libgomp/config/linux/%libgomp/config/[SYSDEP]/%g
s%libgomp/config/posix/%libgomp/config/[SYSDEP]/%g

s%-I../../../master/libitm/config/linux/x86 -I../../../master/libitm/config/linux %%
#s%-march=i486 -mtune=i686 %%

# Until laplace.SCHWINGE using glibc 2.17.
s%-ldl -lrt%-lrt -ldl%
