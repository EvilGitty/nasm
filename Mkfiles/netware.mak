# -*- makefile -*- GNU Makefile for NetWare target

PROOT=.
OBJDIR=release

-include $(OBJDIR)/version.mak

TARGETS=nasm.nlm ndisasm.nlm

PERL=perl

CROSSPREFIX=i586-netware-

CC=$(CROSSPREFIX)gcc
LD=$(CC)

BINSUFFIX=.nlm

VERSION=$(NASM_MAJOR_VER).$(NASM_MINOR_VER).$(NASM_SUBMINOR_VER)

CFLAGS=-g -O2 -Wall -std=c99 -pedantic -D__NETWARE__ -D_POSIX_SOURCE -DHAVE_CONFIG_H -I.
LDFLAGS=-Wl,--nlm-description="NASM $(NASM_VER) - the Netwide Assembler (gcc build)"
LDFLAGS+=-Wl,--nlm-copyright="NASM is licensed under LGPL."
LDFLAGS+=-Wl,--nlm-version=$(VERSION)
LDFLAGS+=-Wl,--nlm-kernelspace
LDFLAGS+=-Wl,--nlm-posixflag
LDFLAGS+=-s

O = o

#-- Begin File Lists --#
# Edit in Makefile.in, not here!
NASM =	nasm.o nasmlib.o ver.o \
	raa.o saa.o rbtree.o \
	float.o insnsa.o insnsb.o \
	directiv.o \
	assemble.o labels.o hashtbl.o crc64.o parser.o \
	outform.o outlib.o nulldbg.o \
	nullout.o \
	outbin.o outaout.o outcoff.o \
	outelf.o outelf32.o outelf64.o \
	outelfx32.o \
	outobj.o outas86.o outrdf2.o \
	outdbg.o outieee.o outmac32.o \
	outmac64.o preproc.o quote.o pptok.o \
	macros.o listing.o eval.o exprlib.o stdscan.o \
	strfunc.o tokhash.o regvals.o regflags.o \
	ilog2.o \
	strlcpy.o

NDISASM = ndisasm.o disasm.o sync.o nasmlib.o ver.o \
	insnsd.o insnsb.o insnsn.o regs.o regdis.o
#-- End File Lists --#

NASM_OBJ = $(addprefix $(OBJDIR)/,$(notdir $(NASM))) $(EOLIST)
NDIS_OBJ = $(addprefix $(OBJDIR)/,$(notdir $(NDISASM))) $(EOLIST)

VPATH  = *.c $(PROOT) $(PROOT)/output


all: $(OBJDIR) config.h $(TARGETS)

$(OBJDIR)/%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $<

nasm$(BINSUFFIX): $(NASM_OBJ)
	$(LD) $(LDFLAGS) -o $@ $^

ndisasm$(BINSUFFIX): $(NDIS_OBJ)
	$(LD) $(LDFLAGS) -o $@ $^

$(OBJDIR):
	@mkdir $@

config.h: $(PROOT)/Mkfiles/netware.mak
	@echo Creating $@
	@echo $(DL)/* $@ for NetWare target.$(DL) > $@
	@echo $(DL)** Do not edit this file - it is created by make!$(DL) >> $@
	@echo $(DL)** All your changes will be lost!!$(DL) >> $@
	@echo $(DL)*/$(DL) >> $@
	@echo $(DL)#ifndef __NETWARE__$(DL) >> $@
	@echo $(DL)#error This $(notdir $@) is created for NetWare platform!$(DL) >> $@
	@echo $(DL)#endif$(DL) >> $@
	@echo $(DL)#define PACKAGE_VERSION "$(NASM_VER)"$(DL) >> $@
	@echo $(DL)#define OS "i586-pc-libc-NetWare"$(DL) >> $@
	@echo $(DL)#define HAVE_DECL_STRCASECMP 1$(DL) >> $@
	@echo $(DL)#define HAVE_DECL_STRICMP 1$(DL) >> $@
	@echo $(DL)#define HAVE_DECL_STRNCASECMP 1$(DL) >> $@
	@echo $(DL)#define HAVE_DECL_STRNICMP 1$(DL) >> $@
	@echo $(DL)#define HAVE_INTTYPES_H 1$(DL) >> $@
	@echo $(DL)#define HAVE_LIMITS_H 1$(DL) >> $@
	@echo $(DL)#define HAVE_MEMORY_H 1$(DL) >> $@
	@echo $(DL)#define HAVE_SNPRINTF 1$(DL) >> $@
	@echo $(DL)#define HAVE_STDBOOL_H 1$(DL) >> $@
	@echo $(DL)#define HAVE_STDINT_H 1$(DL) >> $@
	@echo $(DL)#define HAVE_STDLIB_H 1$(DL) >> $@
	@echo $(DL)#define HAVE_STRCASECMP 1$(DL) >> $@
	@echo $(DL)#define HAVE_STRCSPN 1$(DL) >> $@
	@echo $(DL)#define HAVE_STRICMP 1$(DL) >> $@
	@echo $(DL)#define HAVE_STRINGS_H 1$(DL) >> $@
	@echo $(DL)#define HAVE_STRING_H 1$(DL) >> $@
	@echo $(DL)#define HAVE_STRNCASECMP 1$(DL) >> $@
	@echo $(DL)#define HAVE_STRNICMP 1$(DL) >> $@
	@echo $(DL)#define HAVE_STRSPN 1$(DL) >> $@
	@echo $(DL)#define HAVE_SYS_STAT_H 1$(DL) >> $@
	@echo $(DL)#define HAVE_SYS_TYPES_H 1$(DL) >> $@
	@echo $(DL)#define HAVE_UNISTD_H 1$(DL) >> $@
	@echo $(DL)#define HAVE_VSNPRINTF 1$(DL) >> $@
	@echo $(DL)#define STDC_HEADERS 1$(DL) >> $@
	@echo $(DL)#ifndef _GNU_SOURCE$(DL) >> $@
	@echo $(DL)#define _GNU_SOURCE 1$(DL) >> $@
	@echo $(DL)#endif$(DL) >> $@
	@echo $(DL)#define ldiv __CW_ldiv$(DL) >> $@

clean:
	-$(RM) -r $(OBJDIR)
	-$(RM) config.h

distclean: clean
	-$(RM) $(TARGETS)

$(OBJDIR)/version.mak: $(PROOT)/version $(PROOT)/version.pl $(OBJDIR)
	@$(PERL) $(PROOT)/version.pl make < $< > $@

#-- Magic hints to mkdep.pl --#
# @object-ending: ".o"
# @path-separator: ""
# @continuation: "\"
#-- Everything below is generated by mkdep.pl - do not edit --#
assemble.o: assemble.c assemble.h compiler.h config.h directiv.h insns.h \
 insnsi.h nasm.h nasmlib.h opflags.h pptok.h preproc.h regs.h tables.h \
 tokens.h
crc64.o: crc64.c compiler.h config.h nasmlib.h
directiv.o: directiv.c compiler.h config.h directiv.h hashtbl.h insnsi.h \
 nasm.h nasmlib.h opflags.h pptok.h preproc.h regs.h
disasm.o: disasm.c compiler.h config.h directiv.h disasm.h insns.h insnsi.h \
 nasm.h nasmlib.h opflags.h pptok.h preproc.h regdis.h regs.h sync.h \
 tables.h tokens.h
eval.o: eval.c compiler.h config.h directiv.h eval.h float.h insnsi.h \
 labels.h nasm.h nasmlib.h opflags.h pptok.h preproc.h regs.h
exprlib.o: exprlib.c compiler.h config.h directiv.h insnsi.h nasm.h \
 nasmlib.h opflags.h pptok.h preproc.h regs.h
float.o: float.c compiler.h config.h directiv.h float.h insnsi.h nasm.h \
 nasmlib.h opflags.h pptok.h preproc.h regs.h
hashtbl.o: hashtbl.c compiler.h config.h directiv.h hashtbl.h insnsi.h \
 nasm.h nasmlib.h opflags.h pptok.h preproc.h regs.h
ilog2.o: ilog2.c compiler.h config.h nasmlib.h
insnsa.o: insnsa.c compiler.h config.h directiv.h insns.h insnsi.h nasm.h \
 nasmlib.h opflags.h pptok.h preproc.h regs.h tokens.h
insnsb.o: insnsb.c compiler.h config.h directiv.h insns.h insnsi.h nasm.h \
 nasmlib.h opflags.h pptok.h preproc.h regs.h tokens.h
insnsd.o: insnsd.c compiler.h config.h directiv.h insns.h insnsi.h nasm.h \
 nasmlib.h opflags.h pptok.h preproc.h regs.h tokens.h
insnsn.o: insnsn.c compiler.h config.h insnsi.h opflags.h tables.h
labels.o: labels.c compiler.h config.h directiv.h hashtbl.h insnsi.h nasm.h \
 nasmlib.h opflags.h pptok.h preproc.h regs.h
snprintf.o: snprintf.c compiler.h config.h nasmlib.h
strlcpy.o: strlcpy.c compiler.h config.h
vsnprintf.o: vsnprintf.c compiler.h config.h nasmlib.h
listing.o: listing.c compiler.h config.h directiv.h insnsi.h listing.h \
 nasm.h nasmlib.h opflags.h pptok.h preproc.h regs.h
macros.o: macros.c compiler.h config.h directiv.h hashtbl.h insnsi.h nasm.h \
 nasmlib.h opflags.h outform.h pptok.h preproc.h regs.h tables.h
nasm.o: nasm.c assemble.h compiler.h config.h directiv.h eval.h float.h \
 insns.h insnsi.h labels.h listing.h nasm.h nasmlib.h opflags.h outform.h \
 parser.h pptok.h preproc.h raa.h regs.h saa.h stdscan.h tokens.h
nasmlib.o: nasmlib.c compiler.h config.h directiv.h insns.h insnsi.h nasm.h \
 nasmlib.h opflags.h pptok.h preproc.h regs.h tokens.h
ndisasm.o: ndisasm.c compiler.h config.h directiv.h disasm.h insns.h \
 insnsi.h nasm.h nasmlib.h opflags.h pptok.h preproc.h regs.h sync.h \
 tokens.h
nulldbg.o: nulldbg.c compiler.h config.h directiv.h insnsi.h nasm.h \
 nasmlib.h opflags.h pptok.h preproc.h regs.h
nullout.o: nullout.c compiler.h config.h directiv.h insnsi.h nasm.h \
 nasmlib.h opflags.h outlib.h pptok.h preproc.h regs.h
outaout.o: outaout.c compiler.h config.h directiv.h eval.h insnsi.h nasm.h \
 nasmlib.h opflags.h outform.h outlib.h pptok.h preproc.h raa.h regs.h saa.h \
 stdscan.h
outas86.o: outas86.c compiler.h config.h directiv.h insnsi.h nasm.h \
 nasmlib.h opflags.h outform.h outlib.h pptok.h preproc.h raa.h regs.h saa.h
outbin.o: outbin.c compiler.h config.h directiv.h eval.h insnsi.h labels.h \
 nasm.h nasmlib.h opflags.h outform.h outlib.h pptok.h preproc.h regs.h \
 saa.h stdscan.h
outcoff.o: outcoff.c compiler.h config.h directiv.h eval.h insnsi.h nasm.h \
 nasmlib.h opflags.h outform.h outlib.h pecoff.h pptok.h preproc.h raa.h \
 regs.h saa.h
outdbg.o: outdbg.c compiler.h config.h directiv.h insnsi.h nasm.h nasmlib.h \
 opflags.h outform.h pptok.h preproc.h regs.h
outelf.o: outelf.c compiler.h config.h directiv.h insnsi.h nasm.h nasmlib.h \
 opflags.h dwarf.h elf.h outelf.h outform.h pptok.h preproc.h regs.h
outelf32.o: outelf32.c compiler.h config.h directiv.h eval.h insnsi.h nasm.h \
 nasmlib.h opflags.h dwarf.h elf.h outelf.h outform.h outlib.h stabs.h \
 pptok.h preproc.h raa.h rbtree.h regs.h saa.h stdscan.h
outelf64.o: outelf64.c compiler.h config.h directiv.h eval.h insnsi.h nasm.h \
 nasmlib.h opflags.h dwarf.h elf.h outelf.h outform.h outlib.h stabs.h \
 pptok.h preproc.h raa.h rbtree.h regs.h saa.h stdscan.h
outelfx32.o: outelfx32.c compiler.h config.h directiv.h eval.h insnsi.h \
 nasm.h nasmlib.h opflags.h dwarf.h elf.h outelf.h outform.h outlib.h \
 stabs.h pptok.h preproc.h raa.h rbtree.h regs.h saa.h stdscan.h
outform.o: outform.c compiler.h config.h directiv.h insnsi.h nasm.h \
 nasmlib.h opflags.h outform.h pptok.h preproc.h regs.h
outieee.o: outieee.c compiler.h config.h directiv.h insnsi.h nasm.h \
 nasmlib.h opflags.h outform.h outlib.h pptok.h preproc.h regs.h
outlib.o: outlib.c compiler.h config.h directiv.h insnsi.h nasm.h nasmlib.h \
 opflags.h outlib.h pptok.h preproc.h regs.h
outmac32.o: outmac32.c compiler.h config.h directiv.h eval.h insnsi.h nasm.h \
 nasmlib.h opflags.h outform.h outlib.h pptok.h preproc.h raa.h regs.h saa.h
outmac64.o: outmac64.c compiler.h config.h directiv.h insnsi.h nasm.h \
 nasmlib.h opflags.h outform.h outlib.h pptok.h preproc.h raa.h regs.h saa.h
outobj.o: outobj.c compiler.h config.h directiv.h eval.h insnsi.h nasm.h \
 nasmlib.h opflags.h outform.h outlib.h pptok.h preproc.h regs.h stdscan.h
outrdf2.o: outrdf2.c compiler.h config.h directiv.h insnsi.h nasm.h \
 nasmlib.h opflags.h outform.h outlib.h pptok.h preproc.h rdoff.h regs.h \
 saa.h
parser.o: parser.c compiler.h config.h directiv.h eval.h float.h insns.h \
 insnsi.h nasm.h nasmlib.h opflags.h parser.h pptok.h preproc.h regs.h \
 stdscan.h tables.h tokens.h
pptok.o: pptok.c compiler.h config.h hashtbl.h nasmlib.h pptok.h preproc.h
preproc.o: preproc.c compiler.h config.h directiv.h eval.h hashtbl.h \
 insnsi.h nasm.h nasmlib.h opflags.h pptok.h preproc.h quote.h regs.h \
 stdscan.h tables.h tokens.h
quote.o: quote.c compiler.h config.h nasmlib.h quote.h
raa.o: raa.c compiler.h config.h nasmlib.h raa.h
rbtree.o: rbtree.c compiler.h config.h rbtree.h
regdis.o: regdis.c regdis.h regs.h
regflags.o: regflags.c compiler.h config.h directiv.h insnsi.h nasm.h \
 nasmlib.h opflags.h pptok.h preproc.h regs.h tables.h
regs.o: regs.c compiler.h config.h insnsi.h opflags.h tables.h
regvals.o: regvals.c compiler.h config.h insnsi.h opflags.h tables.h
saa.o: saa.c compiler.h config.h nasmlib.h saa.h
stdscan.o: stdscan.c compiler.h config.h directiv.h insns.h insnsi.h nasm.h \
 nasmlib.h opflags.h pptok.h preproc.h quote.h regs.h stdscan.h tokens.h
strfunc.o: strfunc.c compiler.h config.h directiv.h insnsi.h nasm.h \
 nasmlib.h opflags.h pptok.h preproc.h regs.h
sync.o: sync.c compiler.h config.h nasmlib.h sync.h
tokhash.o: tokhash.c compiler.h config.h directiv.h hashtbl.h insns.h \
 insnsi.h nasm.h nasmlib.h opflags.h pptok.h preproc.h regs.h tokens.h
ver.o: ver.c compiler.h config.h directiv.h insnsi.h nasm.h nasmlib.h \
 opflags.h pptok.h preproc.h regs.h version.h
