#
#
#  ☢ ☣NuclearTeam☣ ☢
#
#     OPTIMIZATIONS LEVELS!!
#
#

# 03
ifeq ($(USE_O3_OPTIMIZATIONS),true)
# General optimization level of target ARM compiled with GCC. Default: -O2
NUCLEAR_GCC_CFLAGS_ARM := -O3

# General optimization level of target THUMB compiled with GCC. Default: -Os
NUCLEAR_GCC_CFLAGS_THUMB := -Os

# Additional flags passed to all C targets compiled with GCC
NUCLEAR_GCC_CFLAGS := -O3


# Flags passed to all C targets compiled with GCC
NUCLEAR_GCC_CPPFLAGS := -O3

# Flags passed to linker (ld) of all C and C targets compiled with GCC
NUCLEAR_GCC_LDFLAGS := -Wl,--sort-common


# CLANG

# Flags passed to all C targets compiled with CLANG
NUCLEAR_CLANG_CFLAGS := -O3 -Qunused-arguments -Wno-unknown-warning-option

# Flags passed to all C targets compiled with CLANG
NUCLEAR_CLANG_CPPFLAGS := $(NUCLEAR_CLANG_CFLAGS)

# Flags passed to linker (ld) of all C and C targets compiled with CLANG
NUCLEAR_CLANG_LDFLAGS := -Wl,--sort-common
else
NUCLEAR_GCC_CFLAGS_ARM := \
	-O2 \
	-fomit-frame-pointer \
	-fstrict-aliasing    \
	-funswitch-loops

NUCLEAR_GCC_CFLAGS_THUMB := \
	-mthumb \
	-Os \
	-fomit-frame-pointer \
	-fno-strict-aliasing

NUCLEAR_GCC_CFLAGS := \
	-DNDEBUG \
	-Wstrict-aliasing=2 \
	-fgcse-after-reload \
	-frerun-cse-after-loop \
	-frename-registers

NUCLEAR_GCC_CPPFLAGS := \
	-fvisibility-inlines-hidden

NUCLEAR_CLANG_CFLAGS :=
NUCLEAR_CLANG_CPPFLAGS :=
NUCLEAR_CLANG_LDFLAGS :=
endif


# Extra flags
ifeq ($(ENABLE_EXTRAGCC),true)
   NUCLEAR_GCC_CFLAGS += -fgcse-las -fgraphite -ffast-math -fgraphite-identity -fgcse-sm -fivopts -fomit-frame-pointer -frename-registers -fsection-anchors -ftracer -ftree-loop-im -ftree-loop-ivcanon -funsafe-loop-optimizations -funswitch-loops -fweb -Wno-error=array-bounds -Wno-error=clobbered -Wno-error=maybe-uninitialized -Wno-error=strict-overflow -frerun-cse-after-loop -ffunction-sections -fdata-sections -fira-loop-pressure -fforce-addr -funroll-loops -ftree-loop-distribution -ffp-contract=fast -mvectorize-with-neon-quad -Wno-unused-parameter -Wno-unused-but-set-variable

   NUCLEAR_GCC_CPPFLAGS += -fgcse-las -fgcse-sm -fivopts -fomit-frame-pointer -frename-registers -fsection-anchors -ftracer -ftree-loop-im -ftree-loop-ivcanon -funsafe-loop-optimizations -funswitch-loops -fweb -Wno-error=array-bounds -Wno-error=clobbered -Wno-error=maybe-uninitialized -Wno-error=strict-overflow -frerun-cse-after-loop -ffunction-sections -fdata-sections -fira-loop-pressure -fforce-addr -funroll-loops -ftree-loop-distribution -ffp-contract=fast -mvectorize-with-neon-quad -Wno-unused-parameter -Wno-unused-but-set-variable
endif

 #Graphite
ifeq ($(GRAPHITE_OPTS),true)
   NUCLEAR_GCC_CPPFLAGS += -fgraphite -fgraphite-identity -floop-flatten -floop-parallelize-all -ftree-loop-linear -floop-interchange -floop-strip-mine -floop-block
   CLANG_CONFIG_EXTRA_CONLYFLAGS += -fgraphite -fgraphite-identity -floop-flatten -floop-parallelize-all -ftree-loop-linear -floop-interchange -floop-strip-mine -floop-block
endif

#FFAST-MATH
ifeq ($(FFAST_MATH),true)
    CLANG_CONFIG_EXTRA_CONLYFLAGS += -ffast-math -ftree-vectorize
    NUCLEAR_GCC_CPPFLAGS += -ffast-math -ftree-vectorize
endif

# IPA Analyser
ifeq ($(ENABLE_IPA_ANALYSER),true)
       NUCLEAR_GCC_CFLAGS += -fipa-sra -fipa-pta -fipa-cp -fipa-cp-clone
       NUCLEAR_GCC_LDFLAGS += -fipa-sra -fipa-pta -fipa-cp -fipa-cp-clone
endif

# pipe
ifeq ($(TARGET_USE_PIPE),true)
   CLANG_CONFIG_EXTRA_CONLYFLAGS += -pipe
   NUCLEAR_GCC_CPPFLAGS += -pipe
endif

# Krait
ifeq ($(KRAIT_TUNINGS),true)
    CLANG_CONFIG_EXTRA_CONLYFLAGS += -mcpu=cortex-a15 -mtune=cortex-a15
    NUCLEAR_GCC_CPPFLAGS += -mcpu=cortex-a15 -mtune=cortex-a15
endif

# pthread
ifeq ($(ENABLE_PTHREAD),true)
   #NUCLEAR_GCC_CFLAGS += -pthread
   NUCLEAR_GCC_CPPFLAGSS += -pthread
endif

# OpenMP
ifeq ($(ENABLE_GOMP),true)
   NUCLEAR_GCC_CFLAGS += -lgomp -ldl -lgcc -fopenmp
endif

# Memory Sanitize
ifeq ($(ENABLE_SANITIZE),true)
     CLANG_CONFIG_EXTRA_CONLYFLAGS += -fsanitize=leak
endif

# Strict
ifeq ($(STRICT_ALIASING),true)
   CLANG_CONFIG_EXTRA_CONLYFLAGS += -fstrict-aliasing -Werror=strict-aliasing -fno-strict-aliasing -Wstrict-aliasing=3
   NUCLEAR_GCC_CPPFLAGS += -fstrict-aliasing -Werror=strict-aliasing -fno-strict-aliasing -Wstrict-aliasing=3
endif

# No error
ifeq ($(DONT_ERROROUT),true)
 ifneq ($(filter 5.3& 5.2% 6.0%,$(TARGET_GCC_VERSION)),)
    NUCLEAR_GCC_CFLAGS += -Wno-error
    NUCLEAR_GCC_CPPFLAGS += -Wno-error
 endif
endif

# Flags that are used by GCC, but are unknown to CLANG. If you get "argument unused during compilation" error, add the flag here
NUCLEAR_CLANG_UNKNOWN_FLAGS := \
  -mvectorize-with-neon-double \
  -mvectorize-with-neon-quad \
  -fgcse-after-reload \
  -fgcse-las \
  -fgcse-sm \
  -fivopts \
  -ftracer \
  -fgraphite \
  -ffast-math \
  -ftree-vectorize \
  -fgraphite-identity \
  -fipa-pta \
  -fipa-sra \
  -fipa-cp \
  -fipa-cp-clone \
  -floop-flatten \
  -ftree-loop-linear \
  -floop-strip-mine \
  -floop-block \
  -floop-interchange \
  -floop-nest-optimize \
  -floop-parallelize-all \
  -ftree-parallelize-loops=2 \
  -ftree-parallelize-loops=4 \
  -ftree-parallelize-loops=8 \
  -ftree-parallelize-loops=16 \
  -fira-loop-pressure \
  -ftree-loop-distribution \
  -fmodulo-sched \
  -fmodulo-sched-allow-regmoves \
  -frerun-cse-after-loop \
  -frename-registers \
  -fsection-anchors \
  -ftree-loop-im \
  -ftree-loop-ivcanon \
  -funsafe-loop-optimizations \
  -fsection-anchors \
  -Wstrict-aliasing=3 \
  -Wno-error=clobbered \
  -fweb


# Most of the flags are increasing code size of the output binaries, especially O3 instead of Os for target THUMB
# This may become problematic for small blocks, especially for boot or recovery blocks (ramdisks)
# If you don't care about the size of recovery.img, e.g. you have no use of it, and you want to silence the
# error "image too large" for recovery.img, use this definition
NUCLEAR_IGNORE_RECOVERY_SIZE := true 
