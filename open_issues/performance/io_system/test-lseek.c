#include <stdio.h>
#include <math.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/time.h>
#define N 100000
int main(void) {
	int fd = open("test.c", O_RDONLY);
	struct timeval tv1, tv2;
	int i;
	gettimeofday(&tv1, NULL);
	for (i = 0; i < N; i++)
		lseek(fd, 0, SEEK_CUR);
	gettimeofday(&tv2, NULL);
	printf("%fµs\n", (float)((tv2.tv_sec-tv1.tv_sec) * 1000000 + tv2.tv_usec - tv1.tv_usec)/N);
	return 0;
}
