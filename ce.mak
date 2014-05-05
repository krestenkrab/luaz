!INCLUDE <$(WCECOMPAT)\wcedefs.mak>

CFLAGS=/MT /W3 /Ox /O2 /Ob2 /GF /Gy /Zl /nologo $(WCETARGETDEFS) \
	   /DUNICODE /D_UNICODE /D_WIN32 /DWIN32 /D_USE_32BIT_TIME_T \
	   /DWIN32_LEAN_AND_MEAN /D_WINDLL /D_DLL /Foobj/ \
	   -I$(WCECOMPAT)/include \
	   -Isrc -I..\luace\src -I..\zlib \
	   -DNO_SYS_TYPES_H \
	   -D_CRT_SECURE_NO_DEPRECATE \
	   -D_CRT_SECURE_NO_WARNINGS \
	   "-DLUZ_API=__declspec(dllexport)"

!IF "$(WCEPLATFORM)"=="MS_POCKET_PC_2000"
CFLAGS=$(CFLAGS) /DWIN32_PLATFORM_PSPC
!ENDIF

!IFDEF DEBUG
CFLAGS=$(CFLAGS) /Zi /DDEBUG /D_DEBUG
!ELSE
CFLAGS=$(CFLAGS) /Zi /DNDEBUG
!ENDIF

!IF "$(MSVS)"=="2008"
CFLAGS=$(CFLAGS) /Zc:wchar_t-,forScope- /GS-
LFLAGS=/DLL /MACHINE:$(WCELDMACHINE) /SUBSYSTEM:WINDOWSCE,$(WCELDVERSION) /NODEFAULTLIB /DYNAMICBASE /NXCOMPAT
!ELSE
LFLAGS=/DLL /MACHINE:$(WCELDMACHINE) /SUBSYSTEM:WINDOWSCE,$(WCELDVERSION) /NODEFAULTLIB
!ENDIF

CORELIBS=coredll.lib corelibc.lib ole32.lib oleaut32.lib uuid.lib commctrl.lib ws2.lib \
		     ../wcecompat/lib/wcecompat.lib \
		     ../luace/lib/lua51.lib

SRC = \
 src/unzip.c \
 src/iowin32.c \
 src/ioapi.c \
 src/luaz.c

OBJS = $(SRC:src=obj)
OBJS = $(OBJS:.cpp=.obj)
OBJS = $(OBJS:.c=.obj)

{src}.c{obj}.obj:
	$(CC) $(CFLAGS) -c $<

all: lib lib\luaz.lib
#	echo $(OBJS)

obj:
	@md obj 2> NUL

lib:
	@md lib 2> NUL

$(OBJS): ce.mak obj

clean:
	@echo Deleting target libraries...
	@del lib\*.lib
	@echo Deleting object files...
	@del obj\*.obj

lib\luaz.lib: lib $(OBJS) ce.mak
	lib /nologo /out:lib\luaz.lib $(OBJS)
