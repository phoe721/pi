#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <sys/ioctl.h>

int main(int argc, char *argv[]) {
	if (argc == 2) {
		//printf("Argument 1 %s\n", argv[1]);
		int tty = open("/dev/tty1", O_WRONLY|O_NONBLOCK);
		ioctl(tty, TIOCSTI, argv[1]);

		close(tty);
		return 0;
	} else {
		printf("Usage: sendKey [key]\n");
		return 1;
	}
}
