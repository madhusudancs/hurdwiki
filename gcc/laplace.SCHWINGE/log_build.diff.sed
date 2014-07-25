s%i686-unknown-gnu0\.3%[ARCH]%g
s%i386-gnu%[MULTIARCH]%g

#
#
#
#
s%libgomp/config/posix/%libgomp/config/[SYSDEP]/%g

#
s%-march=i486 -mtune=i686 %%

# Until we're using glibc 2.17.
s%-ldl -lrt%-lrt -ldl%
