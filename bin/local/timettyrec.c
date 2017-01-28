/*
 * Copyright (c) 2004, Jilles Tjoelker
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with
 * or without modification, are permitted provided that the
 * following conditions are met:
 *
 * 1. Redistributions of source code must retain the above
 *    copyright notice, this list of conditions and the
 *    following disclaimer.
 * 2. Redistributions in binary form must reproduce the
 *    above copyright notice, this list of conditions and
 *    the following disclaimer in the documentation and/or
 *    other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
 * CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED
 * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
 * PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
 * COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF
 * USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
 * USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY
 * OF SUCH DAMAGE.
 */

#include <sys/types.h>
#include <sys/time.h>

#include <errno.h>
#include <stdio.h>
#include <stdlib.h>

int
main(int argc, char *argv[])
{
    unsigned char buf[12];
    char data[65536];
    int n;
    int r;
    struct timeval totaltime, prev, cur, diff, thres;
    int first = 1;

    if (argc != 1)
    {
	fprintf(stderr, "Usage: %s\n", argv[0]);
	return 1;
    }

    timerclear(&totaltime);
    thres.tv_sec = 10;
    thres.tv_usec = 0;

    while ((errno = 0), fread(buf, 1, 12, stdin) == 12)
    {
	cur.tv_sec = (((((buf[3] << 8) | buf[2]) << 8) | buf[1]) << 8) | buf[0];
	cur.tv_usec = (((((buf[7] << 8) | buf[6]) << 8) | buf[5]) << 8) | buf[4];
	if (first)
	    first = 0;
	else
	{
	    timersub(&cur, &prev, &diff);
	    if (timercmp(&diff, &thres, >))
		diff = thres;
	    timeradd(&totaltime, &diff, &totaltime);
	}
	prev = cur;
	n = (((((buf[11] << 8) | buf[10]) << 8) | buf[9]) << 8) | buf[8];
	if ((unsigned int)n > sizeof(data))
	{
	    fprintf(stderr, "h->len too big (%d)\n", n);
	    exit(1);
	}
	r = fread(data, 1, n, stdin);
	if (n != r)
	{
	    perror("read stdin");
	    exit(1);
	}
    }

    if (errno != 0)
    {
	perror("read stdin");
	exit(1);
    }

    printf("%ld.%06ld\n", totaltime.tv_sec, totaltime.tv_usec);

    return 0;
}

/* vim:ts=8:cin:sw=4
 *  */
