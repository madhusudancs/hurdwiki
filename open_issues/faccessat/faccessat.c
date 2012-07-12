#include <fcntl.h>
#include <unistd.h>
#include <stdio.h>
#include <errno.h>
#include <string.h>
#include <stdlib.h>

#define TESTFN "faccessat-test-file"

int main()
{
  int fd;
  int ret;

  system("touch " TESTFN );
  fd = open(".", O_RDONLY);
  printf("> open: %d\n", fd);

  errno = 0;
  ret = faccessat(fd, TESTFN, R_OK, 0);
  printf("> faccessat: %d, %d (%s)\n", ret, errno, strerror(errno));

  close(fd);

  return 0;
}
