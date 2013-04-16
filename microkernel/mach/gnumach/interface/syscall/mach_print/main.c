#include <assert.h>
#include <stdio.h>
#include <stdlib.h>

void mach_print(char *);

int
main(int argc, char *argv[])
{
    int size;
    char *s;

    size = snprintf(NULL, 0, "%s\n", argv[1]);
    assert(size > 0);
    s = malloc(size);
    assert(s != NULL);
    sprintf(s, "%s\n", argv[1]);
    mach_print(s);
    free(s);
    return EXIT_SUCCESS;
}
