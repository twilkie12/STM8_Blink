# Name
MAINNAME = main
OUTNAME = Blink

# This is used by the STVP to program and must be the same as the device name used in the GUI
PROG_DEVICE = STM8L101x3
PROGRAMMER = ST-LINK
PROG_INTERFACE = SWIM

# This is used with the header files, uncomment the appropriate line
# Note that you may want to put another instance of this define at the top of your main file so that intellisense will work correctly with the header file

# STM8S family devices

# PARTFAMILY = STM8S208# STM8S High density devices with CAN
# PARTFAMILY = STM8S207# STM8S High density devices without CAN
# PARTFAMILY = STM8AF62Ax# STM8A High density devices without CAN
# PARTFAMILY = STM8AF52Ax# STM8A High density devices with CAN
# PARTFAMILY = STM8S903# STM8S Low density devices
# PARTFAMILY = STM8S105# STM8S Medium density devices
# PARTFAMILY = STM8S103# STM8S Low density devices
# PARTFAMILY = STM8S007# STM8S Value Line High density devices
# PARTFAMILY = STM8S005# STM8S Value Line Medium density devices
# PARTFAMILY = STM8S003# STM8S Value Line Low density devices
# PARTFAMILY = STM8S001# STM8S Value Line Low denisty devices
# PARTFAMILY = STM8AF626x# STM8A Medium density devices
# PARTFAMILY = STM8AF622x# STM8A Low density devices

# Most STM8L family devices

# PARTFAMILY = STM8AL31_L_MD# STM8AL31_L_MD: STM8AL3x Medium density devices
# PARTFAMILY = STM8L15X_HD# STM8L15X_HD: STM8L15x/16x High density devices
# PARTFAMILY = STM8L15X_MDP# STM8L15X_MDP: STM8L15x Medium density plus devices
# PARTFAMILY = STM8L15X_MD# STM8L15X_MD: STM8L15x Medium density devices
# PARTFAMILY = STM8L15X_LD# STM8L15X_LD: STM8L15x Low density devices
# PARTFAMILY = STM8L05X_HD_VL# STM8L05X_HD_VL: STM8L052xx8 High density value line devices
# PARTFAMILY = STM8L05X_MD_VL# STM8L05X_MD_VL: STM8L052xx6 Medium density value line devices
# PARTFAMILY = STM8L05X_LD_VL# STM8L05X_LD_VL: STM8L051xx3 Low density value line devices

# Low-density STM8L devices
# These are less picky then the others

PARTFAMILY = STM8L10x# Generic family to keep Make happy
# PARTFAMILY = STM8L050
# PARTFAMILY = STM8L001


# Compiler
CC = sdcc
COMPILER_DEF = __SDCC__

# Platform
PLATFORM = stm8

# Folders
OUTDIR = release
DEBUGDIR = debug
DEBUGOUTPUT = $(DEBUGDIR)\$(DEBUGDIR)

#Directory for helpers
INCDIR = inc
SRCDIR = src
S_SPLDIR = ..\STM8_Headers\SPL_S_Headers
L_SPLDIR = ..\STM8_Headers\SPL_L_Headers
L10X_SPLDIR = ..\STM8_Headers\SPL_L10x_Headers

MAINPATH = src\$(MAINNAME).c

OUTPUT = $(OUTDIR)\$(OUTNAME)

# Adds all the sources in the \src directory, not including main
SOURCES = $(filter-out $(SRCDIR)/main.c, $(wildcard $(SRCDIR)/*.c))
# TODO
# Adds all the sources in the library \src directory
# SOURCES += $(wildcard ..\STM8_libs\*\src\*.c)
RELS = $(SOURCES:.c=.rel)

# SPL header files, they can all be included as they don't affect the output size
INCLUDESPL = -I$(S_SPLDIR)
INCLUDESPL += -I$(L_SPLDIR)
INCLUDESPL += -I$(L10X_SPLDIR)

CFLAGS = -m$(PLATFORM)
CFLAGS += -l$(PLATFORM)
# The second defines in each are to stop them being included from main where they are needed to make intellisense behave
CFLAGS += -D$(PARTFAMILY) -DPARTFAMILY
CFLAGS += -D$(COMPILER_DEF) -DCOMPILER_DEF --all-callee-saves

# Ensures that the output from SDCC is an ELF file to allow for debugging with OpenOCD
DEBUGFLAGS += --debug 
DEBUGFLAGS += --out-fmt-elf


INCLUDES += -I$(INCDIR)
INCLUDES += $(INCLUDESPL)

.PHONY: all clean flash release release_no_clean clean_release debug debug_no_clean clean_debug
# All the things to do for a full build, debug is included but it is probably unnecessary
all:
	@make clean
	@make release_no_clean
	@make debug_no_clean
	@echo Flashing
	@make flash
#
# The target is main.c and the prerequisites are all the rel files
# Make then looks for how to create all the rel files and so goes off and compiles them before running the final compilation with main.c and all the .rels which are now in the output directory
release:
	@make clean_release
	@make release_no_clean
#
release_no_clean: $(MAINPATH) $(RELS)
	@echo Compiling release build into directory
	@$(CC) $(MAINPATH)  $(wildcard $(OUTDIR)/*.rel) -o$(OUTPUT).hex $(INCLUDES) $(CFLAGS)
	@echo Release build done
	@echo Size of hex file in bytes:
	@powershell "((Get-ChildItem $(OUTPUT).hex).length )"
#
# It's just easier to do both at once, yes there is almost certainly a better way to do this but it is so fast that it is unnecessary 
%.rel:%.c
	@$(CC) -c $< $(INCLUDES) $(CFLAGS) $(LIBS) $(DEBUGFLAGS) -o$(DEBUGDIR)\\
	@$(CC) -c $< $(INCLUDES) $(CFLAGS) $(LIBS) -o$(OUTDIR)\\
#
.SUFFIXES: .c .rel
#
# Flashes the release build to the device using STVP and a ST-LINK
flash:
	@echo Flashing with verbose output
	@STVP_CmdLine -BoardName=$(PROGRAMMER) -Port=USB -ProgMode=$(PROG_INTERFACE) -Device=$(PROG_DEVICE) -verbose -verif -no_log -no_loop -FileProg='$(OUTPUT).hex' -FileOption='option_bytes.hex'
	@echo Done
#
# Builds .elf file for debugging using OpenOCD and the STM8 Debug extension
debug:
	@make clean_debug
	@make debug_no_clean
#
debug_no_clean: $(MAINPATH) $(RELS)
	@echo Compiling debug build into directory
	@$(CC) $(MAINPATH)  $(wildcard $(DEBUGDIR)/*.rel) -o$(DEBUGOUTPUT).elf $(INCLUDES) $(CFLAGS) $(DEBUGFLAGS)
	@echo Debug build done
#
# This is pretty hacky but essentialy all files generated have three character extensions, the '?' is a single character wildcard and so .keep files are untouched
# The delay may need to be made longer depending on your computer, if it is not long enough Make can throw errors related to opening files 
clean:
	@echo Cleaning both release and debug directories
	@del /q $(OUTDIR)\*.??? 
	@del /q $(DEBUGDIR)\*.???
	@timeout /t 1
#
clean_debug:
	@echo Cleaning debug directory
	@del /q $(DEBUGDIR)\*.???
	@timeout /t 1
#
clean_release:
	@echo Cleaning release directory
	@del /q $(OUTDIR)\*.???
	@timeout /t 1