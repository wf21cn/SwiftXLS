#ifndef LIBXLS_CONFIG_H
#define LIBXLS_CONFIG_H

#define HAVE_ASPRINTF 1
#define HAVE_VASPRINTF 1
#define HAVE_STRDUP 1
#define HAVE_STDINT_H 1
#define HAVE_STDLIB_H 1
#define HAVE_STRING_H 1
#define HAVE_UNISTD_H 1
#define HAVE_ICONV 1
#define HAVE_MEMORY_H 1
#define HAVE_SYS_STAT_H 1
#define HAVE_SYS_TYPES_H 1
#define HAVE_XLOCALE_H 1

#ifdef __APPLE__
#include <xlocale.h>
#endif

#define ICONV_CONST const

#define PACKAGE "libxls"
#define PACKAGE_BUGREPORT ""
#define PACKAGE_NAME "libxls"
#define PACKAGE_STRING "libxls 1.6.3"
#define PACKAGE_TARNAME "libxls"
#define PACKAGE_URL ""
#define PACKAGE_VERSION "1.6.3"
#define VERSION "1.6.3"

#endif /* LIBXLS_CONFIG_H */ 