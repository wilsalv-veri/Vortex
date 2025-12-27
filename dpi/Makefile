# --- Makefile for alternate_dpi.so ---

# --- Variables ---

# Compiler and Flags
CXX         = g++
CXXFLAGS    = -shared -fPIC -Wall -Wextra  # Use -std=c++11 or higher
OUTPUT      = vortex_dpi.so

#-std=c++11 

# Define Environment Variables (Assuming $VORTEX is set in your shell environment)
# NOTE: If $VORTEX is not set when you run 'make', you MUST uncomment and set it here.
# VORTEX      = /path/to/your/vortex/project

# Define DSim Include Path (This path is specific to your installation)
DSIM_INCLUDE = $(DSIM)/2025.1/include

# Include Paths
INCLUDE_DIRS = -I $(VORTEX)/dpi/sim/common -I $(DSIM_INCLUDE)

# Source Files
SOURCES     = $(VORTEX)/dpi/float_dpi.cpp $(VORTEX)/dpi/util_dpi.cpp

# --- Targets ---

.PHONY: all clean

# Default target: Compiles the shared library
all: $(OUTPUT)

# Target to create the shared library (.so file)
$(OUTPUT): $(SOURCES)
	@echo "--- Compiling and Linking Shared Library: $@ ---"
	$(CXX) $(CXXFLAGS) -o $@ $(SOURCES) $(INCLUDE_DIRS)

# Target to remove the compiled shared library
clean:
	@echo "--- Cleaning project files ---"
	rm -f $(OUTPUT)

# --- End of Makefile ---