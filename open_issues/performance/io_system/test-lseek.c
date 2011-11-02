#include <stdio.h>
#include <math.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/time.h>
int main(void) {
	int fd = open("test.c", O_RDONLY);
	struct timeval tv1, tv2;
	int i;
	gettimeofday(&tv1, NULL);
	for (i = 0; i < 100000; i++)
		lseek(fd, 0, SEEK_CUR);
	gettimeofday(&tv2, NULL);
	printf("%07lu\n", (tv2.tv_sec-tv1.tv_sec) * 1000000 + tv2.tv_usec - tv1.tv_usec);
	return 0;
}
