#include <pthread.h>
#include <stdio.h>
#include <assert.h>

#define DEBUG

void del(void *x __attribute__((unused)))
{
}

void work(int val)
{
  pthread_key_t key1;
  pthread_key_t key2;

#ifdef DEBUG
  printf("work/%d: start\n", val);
#endif
  assert(pthread_key_create(&key1, &del) == 0);
  assert(pthread_key_create(&key2, &del) == 0);
#ifdef DEBUG
  printf("work/%d: pre-setspecific: %p,%p\n", val, pthread_getspecific(key1), pthread_getspecific(key2));
#else
  assert(pthread_getspecific(key1) == NULL);
  assert(pthread_getspecific(key2) == NULL);
#endif
  assert(pthread_setspecific(key1, (void *)(0x100 + val)) == 0);
  assert(pthread_setspecific(key2, (void *)(0x200 + val)) == 0);
#ifdef DEBUG
  printf("work/%d: post-setspecific: %p,%p\n", val, pthread_getspecific(key1), pthread_getspecific(key2));
#else
  assert(pthread_getspecific(key1) == (void *)(0x100 + val));
  assert(pthread_getspecific(key2) == (void *)(0x200 + val));
#endif
  assert(pthread_key_delete(key1) == 0);
  assert(pthread_key_delete(key2) == 0);
}

int main()
{
  int i;

  for (i = 0; i < 8; ++i) {
    work(i + 1);
  }

  return 0;
}
