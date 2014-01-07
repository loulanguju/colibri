#include "console.h"
#include <stdarg.h>

void kprintf(const char *fmt, ...) {
  int c;					/* next character in fmt */
  int d;
  unsigned long u;				/* hold number argument */
  int base;					/* base of number arg */
  int negative;					/* print minus sign */
  static char x2c[] = "0123456789ABCDEF";	/* nr conversion table */
  char ascii[8 * sizeof(long) / 3 + 2];		/* string for ascii number */
  char *s;					/* string to be printed */
  va_list argp;					/* optional arguments */

  va_start(argp, fmt);				/* init variable arguments */

  while((c=*fmt++) != 0) {

      if (c == '%') {				/* expect format '%key' */
	  negative = 0;				/* (re)initialize */
	  s = (void *)0;				/* (re)initialize */
          switch(c = *fmt++) {			/* determine what to do */

          /* Known keys are %d, %u, %x, %s, and %%. This is easily extended
           * with number types like %b and %o by providing a different base.
           * Number type keys don't set a string to 's', but use the general
           * conversion after the switch statement.
           */
          case 'd':				/* output decimal */
              d = va_arg(argp, signed int);
              if (d < 0) { negative = 1; u = -d; }  else { u = d; }
              base = 10;
              break;
          case 'u':				/* output unsigned long */
              u = va_arg(argp, unsigned long);
              base = 10;
              break;
          case 'x':				/* output hexadecimal */
              u = va_arg(argp, unsigned long);
              base = 0x10;
              break;
          case 's': 				/* output string */
              s = va_arg(argp, char *);
              if (s == (void *)0) s = "(null)";
              break;
          case '%':				/* output percent */
              s = "%";
              break;

          /* Unrecognized key. */
          default:				/* echo back %key */
              s = "%?";
              s[1] = c;				/* set unknown key */
          }

          /* Assume a number if no string is set. Convert to ascii. */
          if (s == (void *)0) {
              s = ascii + sizeof(ascii)-1;
              *s = 0;
              do {  *--s = x2c[(u % base)]; }	/* work backwards */
              while ((u /= base) > 0);
          }

          /* This is where the actual output for format "%key" is done. */
          if (negative) putch('-');  		/* print sign if negative */
          while(*s != 0) { putch(*s++); }	/* print string/ number */
      }
      else {
          putch(c);				/* print and continue */
      }
  }
  va_end(argp);
}
