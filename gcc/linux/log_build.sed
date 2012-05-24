s%i686-pc-linux-gnu%[ARCH]%g

s%-I../../../master/libgomp/config/linux/x86 -I../../../master/libgomp/config/linux %%
s%-ftls-model=initial-exec -march=i486 -mtune=i686 %%
s%-Werror -ftls-model=initial-exec -march=i486 -pthread -mtune=i686%-pthread -Werror%
s%libgomp/config/linux/%libgomp/config/[SYSDEP]/%g
s%libgomp/config/posix/%libgomp/config/[SYSDEP]/%g

s%/i386-linux-gnu%/[ARCH]%g
