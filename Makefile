############################
# Part 1: LOCAL DEFINITIONS

       TOP = .


#############################
# Part 2: COMMON MAKE PARAMETERS

include $(TOP)/make.proj

# Standard bourne shell doesn't update PWD on directory change.
#       SHELL = /bin/ksh
#
#ifneq ($(PLATFORM),_SUNOS)
#ifneq ($(PLATFORM),_NETBSD)
#       SHELL = /usr/bin/ksh
#else
#       SHELL = /bin/ksh
#endif
#endif

#############################
# Part 3: LOCAL SOURCES 
#DIRS = ./config\
	$(TOP_DIR)/module/stdClib/src\
        ./src\
	./new_main \
	./test \
	./module


DIRS = ./config\
        ./src\
	./test \
	./module\
	./main\
	./new_main

##############################
# Part 4: LOCAL TARGETS  

##################
TREE =	include \
	include/sys \
	include/module\
	lib 

install::
	@for i in $(TREE)  ;\
	do \
		if [ ! -d $$i ] ; then \
			echo $(MKDIR) $(MKDIRFLAGS) $$i ;\
			$(MKDIR) $(MKDIRFLAGS) $$i ;\
		fi \
	done


###################
#
install:: headers

include $(CONFIG_DIR)/NormalNodeTargets


#########################
# Make binary distribution


#########################
# Make binary distribution

# EiC version number
EiC_NUM = 4.4

BINTREE = EiC\
        EiC/include \
        EiC/include/sys \
        EiC/doc\
        EiC/bin\
        EiC/module\
        include\
        include/sys

bintree:
	@for i in $(BINTREE)  ;\
	do \
		if [ ! -d $$i ] ; then \
			echo $(MKDIR) $(MKDIRFLAGS) $$i ;\
			$(MKDIR) $(MKDIRFLAGS) $$i ;\
		fi \
	done

INCFILES = ./include/*.h 
            
INCSYSFILES = ./include/sys/*.h

DOCFILES =  ./eic.man

MODULES = ./module/MathStats\
          ./module/gnuplot\
          ./module/link2eic\
          ./module/stdClib

modules:
	@for i in $(MODULES)  ;\
	do \
		echo cp -r $$i/* EiC/$$i ;\
		mkdir EiC/$$i;\
		cp -r $$i/* EiC/$$i ;\
	done

binary: bintree modules install
	cp new_main/eicc  EiC/eicc
	strip EiC/eicc
	cp $(INCFILES)   EiC/include 
	cp $(INCSYSFILES) EiC/include/sys
	cp $(DOCFILES)   EiC/doc
	cp LICENCE       EiC/LICENCE
	cp $(CONFIG_DIR)/make.rules    EiC/
	rm -f `find ./EiC/module -name "Makefile"`
	echo  "PLATFORM = $(PLATFORM)" > EiC/make.proj
	tar cvf EiC$(PLATFORM)_$(EiC_NUM).tar  EiC
	gzip EiC$(PLATFORM)_$(EiC_NUM).tar 
	mv  EiC$(PLATFORM)_$(EiC_NUM).tar.gz  EiC$(PLATFORM)_$(EiC_NUM).tgz

#############################
# Part 5: COMMON RULES and 
#     and default Targets

include $(CONFIG_DIR)/make.rules

#############################
# Part 6: DEPENDENCIES


clean::
	find . -name "*~"     | xargs $(RM)
	find . -name EiChist.lst  | xargs $(RM)
	find . -name a.out | xargs $(RM)
	find . -name "*.[ao]" | xargs $(RM) 
	$(RM) config/genstdio

clobber::clean


