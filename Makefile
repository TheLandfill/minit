PRODUCT :=
DEBUG_PRODUCT := $(PRODUCT)-debug
WIN_PRODUCT := $(PRODUCT).exe
WIN_DEBUG_PRODUCT := $(PRODUCT)-debug.exe

MAINDIR := ${CURDIR}
BINDIR  := $(MAINDIR)/bin

INCDIR  := $(MAINDIR)/includes
INCDIR_EXT := $(MAINDIR)/external_includes

SRCDIR  := $(MAINDIR)/src
SRCDIR_EXT := $(MAINDIR)/external_src

LIBDIR	:= $(MAINDIR)/libs
OBJDIR  := $(MAINDIR)/obj
RELEASE_OBJDIR := $(OBJDIR)/release/
DEBUG_OBJDIR := $(OBJDIR)/debug/
DEPDIR := $(OBJDIR)/dep/
WIN_RELEASE_OBJDIR := $(OBJDIR)/win-release/
WIN_DEBUG_OBJDIR := $(OBJDIR)/win-debug/

MKDIR_P := mkdir -p
RM_RF := rm -rf
ALL := /*

# Language --------------------------------------------------------------------
EXTENSION := cpp
LANGUAGE_STANDARD := -std=c++11
COMPILER := g++
LINKER := g++
WIN_COMPILER := x86_64-w64-mingw32-g++
WIN_LINKER := x86_64-w64-mingw32-g++

# Flags -----------------------------------------------------------------------
# ----- General ---------------------------------------------------------------
INCLUDES := -I $(INCDIR) -I $(INCDIR_EXT)
SYS_LIBRARIES :=
WIN_LIBRARIES :=
LINUX_LIBRARIES :=
LIBRARIES := -L$(LIBDIR) $(SYS_LIBRARIES)
WARNING_FLAGS := -Wall -Wextra
DEPENDENCY_GENERATION_FLAGS := -MMD -MP

# ----- Release ---------------------------------------------------------------
UNUSED_CODE_COMPILER_FLAGS := #-ffunction-sections -fdata-sections -flto
OPTIMIZATION_LEVEL := -O3
RELEASE_FLAGS := $(OPTIMIZATION_LEVEL) $(UNUSED_CODE_COMPILER_FLAGS)
RELEASE_LINKER_FLAGS := #-Wl,--gc-sections
RELEASE_MACROS :=

# ----- Debug -----------------------------------------------------------------
DEBUG_FLAGS := -O0 -g
DEBUG_MACROS :=






# -----------------------------------------------------------------------------
# DON'T MESS WITH ANYTHING AFTER THIS UNLESS YOU KNOW WHAT YOU'RE DOING -------
# -----------------------------------------------------------------------------

GENERAL_COMPILER_FLAGS := $(LANGUAGE_STANDARD) $(WARNING_FLAGS) $(DEPENDENCY_GENERATION_FLAGS)

LINKER_FLAGS := $(RELEASE_LINKER_FLAGS)
COMPILER_FLAGS := $(RELEASE_FLAGS) $(GENERAL_COMPILER_FLAGS) $(RELEASE_MACROS)

# -----------------------------------------------------------------------------
# Getting all the source files ------------------------------------------------
# -----------------------------------------------------------------------------

# Finds all .$(EXTENSION) files and puts them into SRC
SRC := $(wildcard $(SRCDIR)/*.$(EXTENSION))
SRC_EXT := $(wildcard $(SRCDIR_EXT)/*/*.$(EXTENSION))
SRC_TESTS := $(wildcard $(SRCDIR_TESTS)/*.$(EXTENSION))

# -----------------------------------------------------------------------------
# Generating all the relevant object files ------------------------------------
# -----------------------------------------------------------------------------

# Creates .o files for every .$(EXTENSION) file in SRC (patsubst is pattern substitution)
RELEASE_OBJ     := $(patsubst $(SRCDIR)/%.$(EXTENSION),$(RELEASE_OBJDIR)/%.o,$(SRC))
DEBUG_OBJ       := $(patsubst $(SRCDIR)/%.$(EXTENSION),$(DEBUG_OBJDIR)/%.o,$(SRC))
WIN_RELEASE_OBJ := $(patsubst $(SRCDIR)/%.$(EXTENSION),$(WIN_RELEASE_OBJDIR)/%.o,$(SRC))
WIN_DEBUG_OBJ   := $(patsubst $(SRCDIR)/%.$(EXTENSION),$(WIN_DEBUG_OBJDIR)/%.o,$(SRC))

RELEASE_OBJ     += $(patsubst $(SRCDIR_EXT)/%.$(EXTENSION),$(RELEASE_OBJDIR)/%.o,$(SRC_EXT))
DEBUG_OBJ       += $(patsubst $(SRCDIR_EXT)/%.$(EXTENSION),$(DEBUG_OBJDIR)/%.o,$(SRC_EXT))
WIN_RELEASE_OBJ += $(patsubst $(SRCDIR_EXT)/%.$(EXTENSION),$(WIN_RELEASE_OBJDIR)/%.o,$(SRC_EXT))
WIN_DEBUG_OBJ   += $(patsubst $(SRCDIR_EXT)/%.$(EXTENSION),$(WIN_DEBUG_OBJDIR)/%.o,$(SRC_EXT))

RELEASE_OBJ     += $(patsubst $(SRCDIR_TESTS)/%.$(EXTENSION),$(RELEASE_OBJDIR)/tests/%.o,$(SRC_TESTS))
DEBUG_OBJ       += $(patsubst $(SRCDIR_TESTS)/%.$(EXTENSION),$(DEBUG_OBJDIR)/tests/%.o,$(SRC_TESTS))
WIN_RELEASE_OBJ += $(patsubst $(SRCDIR_TESTS)/%.$(EXTENSION),$(WIN_RELEASE_OBJDIR)/tests/%.o,$(SRC_TESTS))
WIN_DEBUG_OBJ   += $(patsubst $(SRCDIR_TESTS)/%.$(EXTENSION),$(WIN_DEBUG_OBJDIR)/tests/%.o,$(SRC_TESTS))

# -----------------------------------------------------------------------------
# Creates .d files (dependencies) for every .$(EXTENSION) file in SRC ---------
# -----------------------------------------------------------------------------

DEP := $(patsubst $(SRCDIR)/%.$(EXTENSION),$(DEPDIR)/%.d,$(SRC)) $(patsubst $(SRCDIR)/%.$(EXTENSION),$(DEPDIR)/%.d,$(SRC))
# Finds all lib*.a files and puts them into LIB
LIB := $(wildcard $(LIBDIR)/lib*.a)

# -----------------------------------------------------------------------------
# Generate all the target files -----------------------------------------------
# -----------------------------------------------------------------------------

# $^ is list of dependencies and $@ is the target file
$(BINDIR)/$(PRODUCT): directories $(RELEASE_OBJ) $(LIB)
	$(LINKER) $(LINKER_FLAGS) $(COMPILER_FLAGS) $(RELEASE_OBJ) $(LIBRARIES) $(LINUX_LIBRARIES) -o $@

$(BINDIR)/$(DEBUG_PRODUCT): directories $(DEBUG_OBJ) $(LIB)
	$(LINKER) $(LINKER_FLAGS) $(COMPILER_FLAGS) $(DEBUG_OBJ) $(LIBRARIES) $(LINUX_LIBRARIES) -o $@

$(BINDIR)/$(WIN_DEBUG_PRODUCT): directories $(WIN_DEBUG_OBJ) $(LIB)
	$(WIN_LINKER) $(LINKER_FLAGS) $(COMPILER_FLAGS) $(WIN_DEBUG_OBJ) -L/usr/x86_64-w64-mingw32/lib/ $(LIBRARIES) $(WIN_LIBRARIES) -o $@

$(BINDIR)/$(WIN_PRODUCT): directories $(WIN_RELEASE_OBJ) $(LIB)
	$(WIN_LINKER) $(LINKER_FLAGS) $(COMPILER_FLAGS) $(WIN_RELEASE_OBJ) -L/usr/x86_64-w64-mingw32/lib/ $(LIBRARIES) $(WIN_LIBRARIES) -o $@

# -----------------------------------------------------------------------------
# Generate all the object files -----------------------------------------------
# -----------------------------------------------------------------------------

# Compile individual .$(EXTENSION) source files into object files
$(RELEASE_OBJDIR)/%.o: $(SRCDIR)/%.$(EXTENSION)
	$(COMPILER) $(COMPILER_FLAGS) -MF $(DEPDIR)/$*.d $(INCLUDES) -c $< -o $@

$(DEBUG_OBJDIR)/%.o: $(SRCDIR)/%.$(EXTENSION)
	$(COMPILER) $(COMPILER_FLAGS) -MF $(DEPDIR)/%.d $(INCLUDES) -c $< -o $@

$(WIN_RELEASE_OBJDIR)/%.o: $(SRCDIR)/%.$(EXTENSION)
	$(WIN_COMPILER) $(COMPILER_FLAGS) -MF $(DEPDIR)/$*.d $(INCLUDES) -c $< -o $@

$(WIN_DEBUG_OBJDIR)/%.o: $(SRCDIR)/%.$(EXTENSION)
	$(WIN_COMPILER) $(COMPILER_FLAGS) -MF $(DEPDIR)/$*.d $(INCLUDES) -c $< -o $@

-include $(DEP)

.PHONY: directories

directories: $(OBJDIR) $(RELEASE_OBJDIR) $(DEBUG_OBJDIR) $(WIN_RELEASE_OBJDIR) $(WIN_DEBUG_OBJDIR) $(DEPDIR)
$(OBJDIR):
	$(MKDIR_P) $(OBJDIR)

$(RELEASE_OBJDIR):
	$(MKDIR_P) $(RELEASE_OBJDIR)

$(DEBUG_OBJDIR):
	$(MKDIR_P) $(DEBUG_OBJDIR)

$(WIN_RELEASE_OBJDIR):
	$(MKDIR_P) $(WIN_RELEASE_OBJDIR)

$(WIN_DEBUG_OBJDIR):
	$(MKDIR_P) $(WIN_DEBUG_OBJDIR)

$(DEPDIR):
	$(MKDIR_P) $(DEPDIR)

.PHONY: clean

clean:
	$(RM_RF) $(OBJDIR)$(ALL) $(BINDIR)/$(PRODUCT) $(BINDIR)/$(DEBUG_PRODUCT) $(BINDIR)/$(WIN_PRODUCT) $(BINDIR)/$(WIN_DEBUG_PRODUCT)

.PHONY: release

release: COMPILER_FLAGS := $(RELEASE_FLAGS) $(GENERAL_COMPILER_FLAGS)
release: LINKER_FLAGS := $(RELEASE_LINKER_FLAGS)
release: directories $(RELEASE_OBJ) $(BINDIR)/$(PRODUCT)

.PHONY: debug

debug: COMPILER_FLAGS := $(DEBUG_FLAGS) $(GENERAL_COMPILER_FLAGS)
debug: LINKER_FLAGS :=
debug: directories $(DEBUG_OBJ) $(BINDIR)/$(DEBUG_PRODUCT)

.PHONY: win-release

win-release: COMPILER_FLAGS := $(RELEASE_FLAGS) $(GENERAL_COMPILER_FLAGS)
win-release: LINKER_FLAGS := $(RELEASE_LINKER_FLAGS)
win-release: directories $(WIN_RELEASE_OBJ) $(BINDIR)/$(WIN_PRODUCT)

.PHONY: win-debug

win-debug: COMPILER_FLAGS := $(DEBUG_FLAGS) $(GENERAL_COMPILER_FLAGS)
win-debug: LINKER_FLAGS :=
win-debug: directories $(WIN_DEBUG_OBJ) $(BINDIR)/$(WIN_DEBUG_PRODUCT)
