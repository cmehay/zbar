cmake_minimum_required(VERSION 3.12)

# project name and languages
project(zbar LANGUAGES C VERSION 2.0.2)

include(CheckIncludeFile)

check_include_file(errno.h HAVE_ERRNO_H)
check_include_file(fcntl.h HAVE_FCNTL_H)
check_include_file(inttypes.h HAVE_INTTYPES_H)
check_include_file(poll.h HAVE_POLL_H)
check_include_file(stdlib.h HAVE_STDLIB_H)
check_include_file(sys/ioctl.h HAVE_SYS_IOCTL_H)
check_include_file(sys/mman.h HAVE_SYS_MMAN_H)
check_include_file(sys/stat.h HAVE_SYS_STAT_H)
check_include_file(sys/time.h HAVE_SYS_TIME_H)
check_include_file(sys/types.h HAVE_SYS_TYPES_H)
check_include_file(unistd.h HAVE_UNISTD_H)
check_include_file(setjmp.h HAVE_LONGJMP)
check_include_file(pthread.h HAVE_LIBPTHREAD)

find_package(Threads)
if (Threads_FOUND)
    set(HAVE_THREADS 1)
endif()

check_include_file(X11/extensions/XShm.h HAVE_X11_EXTENSIONS_XSHM_H)
check_include_file(X11/extensions/Xvlib.h HAVE_X11_EXTENSIONS_XVLIB_H)

include_directories(.)

set(SOURCES
    config.c
    error.c
    symbol.c
    image.c
    convert.c
    processor.c
    processor/lock.c
    refcnt.c
    window.c
    video.c
    img_scanner.c
    scanner.c
    decoder.c)

set(LIBADD iconv)

option(ENABLE_EAN "Use EAN" ON)
option(ENABLE_DATABAR "Use DATABAR" ON)
option(ENABLE_CODE128 "Use CODE128" ON)
option(ENABLE_CODE93 "Use CODE93" ON)
option(ENABLE_CODE39 "Use CODE39" ON)
option(ENABLE_CODABAR "Use CODABAR" ON)
option(ENABLE_I25 "Use I25" ON)
option(ENABLE_PDF417 "Use PDF417" ON)
option(ENABLE_QRCODE "Use QRCode" ON)
option(HAVE_V4L2 "Have V4L2" OFF)
option(HAVE_V4L1 "Have V4L1" OFF)
if (WIN32)
    option(HAVE_VIDEO "Have VIDEO" ON)
else()
    option(HAVE_VIDEO "Have VIDEO" OFF)
endif

find_package(X11)
find_package(JPEG)

if (ENABLE_EAN)
    list(APPEND SOURCES decoder/ean.c)
endif()
if (ENABLE_DATABAR)
    list(APPEND SOURCES decoder/databar.c)
endif()
if (ENABLE_CODE128)
    list(APPEND SOURCES decoder/code128.c)
endif()
if (ENABLE_CODE93)
    list(APPEND SOURCES decoder/code93.c)
endif()
if (ENABLE_CODE39)
    list(APPEND SOURCES decoder/code39.c)
endif()
if (ENABLE_CODABAR)
    list(APPEND SOURCES decoder/codabar.c)
endif()
if (ENABLE_I25)
    list(APPEND SOURCES decoder/i25.c)
endif()
if (ENABLE_PDF417)
    list(APPEND SOURCES decoder/pdf417.c)
endif()
if (ENABLE_QRCODE)
    list(APPEND SOURCES
        decoder/qr_finder.c qrcode/qrdec.c qrcode/qrdectxt.c
        qrcode/rs.c
        qrcode/isaac.c
        qrcode/bch15_5.c
        qrcode/binarize.c
        qrcode/util.c)
endif()

if (WIN32)
    enable_language(RC)
    list(APPEND SOURCES processor/win.c libzbar.rc)
else()
    list(APPEND SOURCES processor/posix.c)
endif()

if (HAVE_V4L2)
    list(APPEND SOURCES video/v4l.c video/v4l2.c)
endif()
if (HAVE_V4L1)
    if (!HAVE_V4L2)
        list(APPEND SOURCES video/v4l.c)
    endif()
    list(APPEND SOURCES video/v4l1.c)
endif()
if (WIN32)
    if (HAVE_VIDEO)
        list(APPEND SOURCES video/vfw.c)
        list(APPEND LIBADD vfw32)
    endif()
endif()
if (!HAVE_VIDEO)
    list(APPEND SOURCES video/null.c)
endif()

if (JPEG_FOUND)
    list(APPEND SOURCES jpeg.c)
    include_directories(${JPEG_INCLUDE_DIR})
    list(APPEND LIBADD ${JPEG_LIBRARIES})
    set(HAVE_LIBJPEG 1)
endif()

if (X11_FOUND)
    set(HAVE_X 1)
    list(APPEND SOURCES processor/x.c window/x.c window/ximage.c)
    if (X11_Xv_FOUND)
        list(APPEND SOURCES window/xv.c)
    endif()
    include_directories(${X11_INCLUDE_DIR})
    list(APPEND LIBADD ${X11_LIBRARIES})
else()
    if (WIN32)
        list(APPEND SOURCES window/win.c window/dib.c)
    else()
        list(APPEND SOURCES processor/null.c window/null.c)
    endif()
    list(APPEND LIBADD gdi32 winmm)
endif()

configure_file(config.cmake config.h)

add_library(zbar STATIC ${SOURCES})
target_link_libraries(zbar ${LIBADD})
