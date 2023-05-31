// Example follows StackOverflow.com
// http://stackoverflow.com/questions/18108932/linux-c-serial-port-reading-writing
//
// Modified by Steffen Moeller, 2016, to work with the iCE40 HX1K

#include <stdio.h>      // standard input / output functions
#include <stdlib.h>
#include <string.h>     // string function definitions
#include <unistd.h>     // UNIX standard function definitions
#include <fcntl.h>      // File control definitions
#include <errno.h>      // Error number definitions
#include <termios.h>    // POSIX terminal control definitions

static const unsigned char cmd[] = "INIT \r";
static char response[2048];

char* const write_and_read(const int device,
                    char const * const writeme,
                    char       * const readtome) {

   int n_written = 0,
       spot_w = 0;

   int n_read = 0,
       spot_r = 0;
   char buf = '\0';

   do {

       // Write:

       if (strlen(writeme)>n_written) {
           n_written = write( device, writeme+spot_w, 1 );
           fprintf(stderr,"Written: %c\n", *(writeme+spot_w));
           spot_w += n_written;
       }

       //It should definitely not be necessary to write byte per byte,
       //also int n_written = write( device, cmd, sizeof(cmd) -1) would be nice to work
       //It does not, though, our device answers to quickly.
       //
       // Since this is the echo firmware, and we only sent a single character,
       // we also expect to read no more than a single character.
    
       // Read:

       n_read = read( device, &buf, 1 );
       sprintf( &readtome[spot_r], "%c", buf );
       fprintf(stderr,"Read: %c\n", readtome[spot_r]);
       spot_r += n_read;
       
       if (n_read < 0) {
           fprintf(stderr,"Error %d reading: %s\n", errno, strerror(errno));
       }
       else if (n_read == 0) {
           fprintf(stderr,"Read nothing!\n");
       }
   } while (writeme[spot_w] != 0 && n_written > 0);

   readtome[spot_r]=0;
   return(readtome);
}


char main(int argc, char *argv[]) {

   if (argc < 2 || 0==strcmp("-h",argv[1]) || 0==strcmp("--help",argv[1])) {
      printf("Usage: %s <device> some text\n",argv[0]);
      exit(0);
   }

   // open the device expected to be specified in first argument

   const int USB = open( argv[1], O_RDWR| O_NOCTTY );

   if (USB<0) {
      fprintf(stderr,"Error %d opening %s : %s\n", errno, argv[1], strerror (errno));
      exit(errno);
   }

   struct termios tty;
   memset (&tty, 0, sizeof tty);

   /* Error Handling */
   if ( tcgetattr ( USB, &tty ) != 0 ) {
      fprintf(stderr, "Error %d from tcgetattr: %s\n", errno, strerror(errno));
      exit(errno);
   }

   /* Set Baud Rate */
   int ospeed = cfsetospeed (&tty, (speed_t)B9600);
   int ispeed = cfsetispeed (&tty, (speed_t)B9600);
   // This is seemingly a bug in the man page - those routines return 0, no the speed
   //fprintf(stderr,"Set speeds\n  input:  %d\n  output: %d\n",ispeed,ospeed);

   /* Setting other Port Stuff */
   tty.c_cflag     &=  ~PARENB;            // Make 8n1
   tty.c_cflag     &=  ~CSTOPB;
   tty.c_cflag     &=  ~CSIZE;
   tty.c_cflag     |=  CS8;

   tty.c_cflag     &=  ~CRTSCTS;           // no flow control
   tty.c_cc[VMIN]   =  1;                  // read doesn't block
   tty.c_cc[VTIME]  =  5;                  // 0.5 seconds read timeout
   tty.c_cflag     |=  CREAD | CLOCAL;     // turn on READ & ignore ctrl lines

   /* Make raw */
   cfmakeraw(&tty);

   /* Flush Port, then applies attributes */
   if (0 != tcflush( USB, TCIFLUSH )) {
      fprintf(stderr, "Error %d from tcflush: %s\n", errno, strerror(errno));
      exit(errno);
   }

   if ( tcsetattr ( USB, TCSANOW, &tty ) != 0) {
      fprintf(stderr, "Error %d from tcsetattr: %s\n", errno, strerror(errno));
      exit(errno);
   }

   if (2 >= argc) {
      // nothing to write specified by user
      write_and_read(USB,cmd,response);
      printf("Response: %s\n",response);
   } else {
      // iterating over all arguments provided
      for(int a=2; a<argc; a++) {
         write_and_read(USB,argv[a],response);
         printf("Response: %s\n",response);
      }
   }

   close(USB);

}

