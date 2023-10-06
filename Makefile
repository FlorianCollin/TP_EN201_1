# vhdl files
SRC_DIR = src
FILES = $(SRC_DIR)/*

TESTBENCHPATH = testbench/${TESTBENCHFILE}*
TESTBENCHFILE = ${TESTBENCH}_tb

WORKDIR = work

#GHDL CONFIG
GHDL_CMD = ghdl

#Permet d'utiliser std_logic_unsigned et ne pas avoir de problème de overload operator ATTENTION NON PORTABLE !!
#Malgré leurs noms les bibliothèques ieee.std_logic_arith, ieee.std_logic_unsigned et ieee.std_logic_signed ne font pas partie du standard IEEE mais sont des extensions propriétaires développées par Synopsys et dont l'implémentation peut varier suivant les outils de développement.
GHDL_FLAGS_NO_STD_LIB = -fexplicit -fsynopsys

GHDL_FLAGS = $(GHDL_FLAGS_NO_STD_LIB) --ieee=synopsys --warn-no-vital-generic --workdir=$(WORKDIR)

STOP_TIME = 1ms
# Simulation break condition
#GHDL_SIM_OPT = --assert-level=error
GHDL_SIM_OPT = --stop-time=$(STOP_TIME)

WAVEFORM_VIEWER = gtkwave

.PHONY: clean

all: clean make run view

make:
ifeq ($(strip $(TESTBENCH)),)
	@echo "TESTBENCH not set. Use TESTBENCH=<value> to set it."
	@exit 1
endif
	@mkdir -p $(WORKDIR)
	@$(GHDL_CMD) -a -fexplicit -fsynopsys -Wall $(GHDL_FLAGS) $(FILES)
	@$(GHDL_CMD) -a -fexplicit -fsynopsys -Wall $(GHDL_FLAGS) $(TESTBENCHPATH)
	@$(GHDL_CMD) -e -fexplicit -fsynopsys $(GHDL_FLAGS) $(TESTBENCHFILE)

run:
	@echo run
	@$(GHDL_CMD) -r -fexplicit -fsynopsys $(GHDL_FLAGS) --workdir=$(WORKDIR) $(TESTBENCHFILE) --vcd=$(TESTBENCHFILE).vcd $(GHDL_SIM_OPT)
	@echo run_finish
	@mv $(TESTBENCHFILE).vcd $(WORKDIR)/

view:
	@$(WAVEFORM_VIEWER) $(WORKDIR)/$(TESTBENCHFILE).vcd

clean:
	@rm -rf $(WORKDIR)
