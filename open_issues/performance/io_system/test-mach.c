#define _GNU_SOURCE
#include <stdio.h>
#include <fcntl.h>
#include <mach/mach.h>
#define N 1000000
int main(void) {
	struct timeval tv1, tv2;
	int i;
	task_t task;
	task = mach_task_self();
	mach_port_urefs_t refs;
	gettimeofday(&tv1, NULL);
	for (i = 0; i < N; i++) {
		mach_port_get_refs(task, task, MACH_PORT_RIGHT_RECEIVE, &refs);
	}
	gettimeofday(&tv2, NULL);
	printf("%fµs\n", (float)((tv2.tv_sec-tv1.tv_sec) * 1000000 + tv2.tv_usec - tv1.tv_usec)/N);
	return 0;
}
