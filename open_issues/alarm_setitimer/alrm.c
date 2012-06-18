#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

static const char msg[] = "< got alarm\n";

static void sighandler(int signo __attribute__((unused)))
{
  write(STDOUT_FILENO, msg, sizeof(msg) - 1);
}

int main()
{
  struct sigaction sa;
  sa.sa_handler = sighandler;
  sigemptyset(&sa.sa_mask);
  sa.sa_flags = 0;
  if (sigaction(SIGALRM, &sa, NULL) == -1)
    return 1;

  printf("> alarm in 2 secs...\n");
  alarm(2);
  pause();

  printf("> alarm!\n");

  pause();
  printf("> got a signal...\n");

  return 0;
}
