# EDATOOLS=/opt
HOSTNAME=`hostname`
# MACADDR=`${EDATOOLS}/snps/verdi201210/bin/lmhostid -n`
# #MACADDR=`${EDATOOLS}/snps/scl201612/linux64/bin/lmhostid -n`
# if [[ ${#MACADDR} > 12 ]] ; then
#   MACADDR=${MACADDR:1:12}
#   #echo ${MACADDR}
# fi

export VCS_ARCH_OVERRIDE=linux
export VCS_TARGET_ARCH=amd64
export DESIGNWARE_HOME=$EDATOOLS/snps/dw
#export PT_HOME="$EDATOOLS/snps/pt201412s2"
export PT_HOME="$EDATOOLS/snps/pt201606s3p2"
export PR_HOME="$EDATOOLS/snps/pr201706s1"
export SFPGA_HOME="$EDATOOLS/snps/sfpga201503"
export SYN_HOME="$EDATOOLS/snps/syn201603sp1"
# export SYN_HOME="$EDATOOLS/snps/syn201603s5p4"
export DC_HOME=$SYN_HOME
export SYNOPSYS_SYN_ROOT=$SYN_HOME
#export VCS_HOME="$EDATOOLS/snps/vcsmx201509s2p12"
#export VCS_HOME="$EDATOOLS/snps/vcsmx201509s2p14"
export VCS_HOME="$EDATOOLS/snps/vcsmx201606"
#export VCS_HOME="$EDATOOLS/snps/vcsmx201606s2p6"
#export VCS_HOME="$EDATOOLS/snps/vcsmx201703s1p1"
#export CORETOOL_HOME="$EDATOOLS/snps/coretool201609s2p3"
export CORETOOL_HOME="$EDATOOLS/snps/coretool201609s4p1"
export VERA_HOME="$EDATOOLS/snps/vera201403p2/vera_vI-2014.03-2_amd64"
#export FM_HOME="$EDATOOLS/snps/fm201603s5"
export FM_HOME="$EDATOOLS/snps/fm201612"
export LAKER_HOME="$EDATOOLS/snps/laker201612"
export TMAX_HOME="$EDATOOLS/snps/tx201603s5p4"
export MW_HOME="$EDATOOLS/snps/mw201603s5p2"
export LC_HOME="$EDATOOLS/snps/lc201606s3p1"
export SPYGLASS_HOME="$EDATOOLS/snps/spyglass201703p1/SPYGLASS_HOME"
export ICC_HOME="$EDATOOLS/snps/icc201612s5"
export ICC2_HOME="$EDATOOLS/snps/iccii201612s5"
export STARRC_HOME="$EDATOOLS/snps/starrc201612s3p1"
export PATH="$PATH:$PT_HOME/bin:$SFPGA_HOME/bin:$SYN_HOME/bin:$VCS_HOME/bin:$CORETOOL_HOME/bin:$VERA_HOME/bin"
export PATH="$PATH:$FM_HOME/bin:$MW_HOME/bin/linux64:$LAKER_HOME/bin:$TMAX_HOME/bin:$LC_HOME/bin"
export PATH="$PATH:$SPYGLASS_HOME/bin:$ICC_HOME/bin:$ICC2_HOME/bin:$STARRC_HOME/bin:$PR_HOME/bin"
# alias synp=synplify_premier_dp
# alias dv="design_vision"
# alias mw="Milkyway"
if [ -n "$LM_LICENSE_FILE" ]; then
  export LM_LICENSE_FILE="$LM_LICENSE_FILE:27000@$HOSTNAME"
else
  export LM_LICENSE_FILE="27000@$HOSTNAME"
fi

#export VERDI_HOME="$EDATOOLS/snps/verdi201210"
#export VERDI_HOME="$EDATOOLS/snps/verdi201309"
export VERDI_HOME="$EDATOOLS/snps/verdi201509s2p13"
export NOVAS_HOME=$VERDI_HOME
export VC_HOME=$VERDI_HOME
export PLATFORM=LINUX64
export PATH="$PATH:$VERDI_HOME/bin"
#export LM_LICENSE_FILE="$LM_LICENSE_FILE:27860@$HOSTNAME"

#export IES_HOME="$EDATOOLS/cadence/INCISIV132"
export IES_HOME="$EDATOOLS/cadence/INCISIVE151"
#export LEC_HOME="$EDATOOLS/cadence/CONFRML131"
export LEC_HOME="$EDATOOLS/cadence/CONFRML152"
export PATH="$PATH:$IES_HOME/bin:$IES_HOME/tools.lnx86/bin:$LEC_HOME/bin:$LEC_HOME/tools.lnx86/bin"
export IVS_HOME="$EDATOOLS/cadence/INNOVUS151"
export IC6_HOME="$EDATOOLS/cadence/IC617"
export PATH="$PATH:$IVS_HOME/bin:$IVS_HOME/tools.lnx86/bin:$IC6_HOME/bin:$IC6_HOME/tools.lnx86/bin"
export GEN_HOME="$EDATOOLS/cadence/GENUS152"
export PATH="$PATH:$GEN_HOME/bin:$GEN_HOME/tools.lnx86/bin"
export EXT_HOME="$EDATOOLS/cadence/EXT151"
export PATH="$PATH:$EXT_HOME/bin:$EXT_HOME/tools.lnx86/bin"
export SSV_HOME="$EDATOOLS/cadence/SSV152"
export PATH="$PATH:$SSV_HOME/bin:$SSV_HOME/tools.lnx86/bin"
export LM_LICENSE_FILE="$LM_LICENSE_FILE:$EDATOOLS/license/cadence.lic"
if [ -n "$LD_LIBRARY_PATH" ]; then
  export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$VERDI_HOME/share/PLI/IUS/LINUX64"
else
  export LD_LIBRARY_PATH="$VERDI_HOME/share/PLI/IUS/LINUX64"
fi

# export SCILAB_HOME="$EDATOOLS/scilab-5.5.2"
# export PATH="$PATH:$SCILAB_HOME/bin"

export MATLAB_HOME="$EDATOOLS/MATLAB/R2012a"
export PATH="$PATH:$MATLAB_HOME/bin"
export LM_LICENSE_FILE="$LM_LICENSE_FILE:$EDATOOLS/license/mat_standalone.dat"

# export QUARTUS_HOME="$EDATOOLS/altera/14.1/quartus"
# export QSYS_ROOTDIR="$EDATOOLS/altera/14.1/quartus/sopc_builder/bin"
# export ALTERAOCLSDKROOT="$EDATOOLS/altera/14.1/hld"
# export PATH="$PATH:$QUARTUS_HOME/bin"
# export LM_LICENSE_FILE="$LM_LICENSE_FILE:$EDATOOLS/license/altera_$MACADDR.lic"

#export PATH="$PATH:$EDATOOLS/X-Tek/xbrowse-2.0.0/bin"
#export PATH="$PATH:$EDATOOLS/X-Tek/xcalc-2.0.0/bin"
#export PATH="$PATH:$EDATOOLS/X-Tek/xedit-2.0.0/bin"
#export PATH="$PATH:$EDATOOLS/X-Tek/xhdl-4.2.5/bin"
#
#export QUESTASIM_HOME="$EDATOOLS/mentor/questasim"
#export PATH="$PATH:$QUESTASIM_HOME/bin"
#export DFT_HOME="$EDATOOLS/mentor/tessent20131"
export DFT_HOME="$EDATOOLS/mentor/tessent20163"
export PATH="$PATH:$DFT_HOME/bin"
export CALIBRE_HOME="$EDATOOLS/mentor/aoi_cal_2016.3_28.17"
export PATH="$PATH:$CALIBRE_HOME/bin"
export LM_LICENSE_FILE="$LM_LICENSE_FILE:27001@$HOSTNAME"
#export LM_LICENSE_FILE="$LM_LICENSE_FILE:$EDATOOLS/license/mentor_$MACADDR.lic"

# source $EDATOOLS/Xilinx/14.7/ISE_DS/settings64.sh > /dev/null
# export XKEYSYMDB=/usr/share/X11/XKeysymDB
# source $EDATOOLS/Xilinx/Vivado/2018.1/settings64.sh > /dev/null
# export LM_LICENSE_FILE="$LM_LICENSE_FILE:$EDATOOLS/license/xilinx_ise14.lic:$EDATOOLS/license/Vivado.lic"
# if [ -n "$LD_LIBRARY_PATH" ]; then
#   export LD_LIBRARY_PATH="/lib64:/usr/lib64:$LD_LIBRARY_PATH"
# else
#   export LD_LIBRARY_PATH="/lib64:/usr/lib64"
# fi

# # ARM compiler
# export ARMGCC_HOME="$EDATOOLS/ARM/gcc-arm-none-eabi-5_4-2016q3"
# export PATH=$ARMGCC_HOME/bin:$PATH

# # SystemC
# export SYSTEMC_HOME="$EDATOOLS/systemc/systemc-2.3.0a"
