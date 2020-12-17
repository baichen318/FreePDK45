################################################################################
################################################################################
#                                                                              #
# Copyright (c) 2001-2006 CiraNova, Inc. All Rights Reserved.                  #
#                                                                              #
# Permission is hereby granted, free of charge, to any person obtaining a copy #
# of this software and associated documentation ("CiraNova Open Code"), to use #
# the CiraNova Open Code without restriction, including without limitation the #
# right to use, copy, modify, merge, publish, distribute, sublicense, and sell #
# copies of the CiraNova Open Code, and to permit persons to whom the CiraNova #
# Open Code is furnished to do so, subject to the following conditions:        #
#                                                                              #
# The above copyright notice and this permission notice must be included in    #
# all copies and all distribution, redistribution, and sublicensing of the     #
# CiraNova Open Code. THE CIRANOVA OPEN CODE IS PROVIDED "AS IS" AND WITHOUT   #
# WARRANTY OF ANY KIND, EXPRESS, IMPLIED OR STATUTORY INCLUDING WITHOUT        #
# LIMITATION ANY WARRANTY OF MERCHANTABILITY, FITNESS FOR A PARTICULAR         #
# PURPOSE, TITLE AND NONINFRINGEMENT. IN NO EVENT SHALL CIRANOVA, INC. BE      #
# LIABLE FOR ANY INDIRECT, PUNITIVE, SPECIAL, INCIDENTAL OR CONSEQUENTIAL      #
# DAMAGES ARISING FROM, OUT OF OR IN CONNECTION WITH THE CIRANOVA OPEN CODE    #
# OR ANY USE OF THE CIRANOVA OPEN CODE, OR BE LIABLE FOR ANY CLAIM, DAMAGES OR #
# OTHER LIABILITY, HOWEVER IT ARISES AND ON ANY THEORY OF LIABILITY, WHETHER   #
# IN AN ACTION FOR CONTRACT, STRICT LIABILITY OR TORT (INCLUDING NEGLIGENCE),  #
# OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE CIRANOVA OPEN   #
# CODE OR ANY USE OF THE CIRANOVA OPEN CODE. The CiraNova Open Code is subject #
# to U.S. export control laws and may be subject to export or import           #
# regulations in other countries, and all use of the CiraNova Open Code must   #
# be in compliance with such laws and regulations.  If any license for the     #
# CiraNova Open Code is obtained pursuant to a government contract, all use,   #
# distribution and/or copying by the U.S. government shall be subject to this  #
# permission notice and any applicable FAR provisions.                         #
#                                                                              #
################################################################################
################################################################################


import Mosfet_vtl
import Mosfet_vtg
import Mosfet_vth
import Mosfet_thkox
#import Via
import transistorUnit
#import diffPair

def definePcells(lib):
#     lib.definePcell(Via.Via1,          "via1"        )
#     lib.definePcell(Via.Via2,          "via2"        )
#     lib.definePcell(Via.Via3,          "via3"        )
#     lib.definePcell(Via.NwellContact,  "nwcont"      )
#     lib.definePcell(Via.PwellContact,  "pwcont"      )
     lib.definePcell(Via.NdiffContact,  "ndcont"      )
     lib.definePcell(Via.PdiffContact,  "pdcont"      )
     lib.definePcell(Via.DiffContact,   "dcont"       )
     lib.definePcell(Via.PolyContact,   "pcont"       )
     lib.definePcell(Mosfet_vtl.Nmos_vtl,       "nmos_vtl"        )
     lib.definePcell(Mosfet_vtl.Pmos_vtl,       "pmos_vtl"        )
     lib.definePcell(Mosfet_vtg.Nmos_vtg,       "nmos_vtg"        )
     lib.definePcell(Mosfet_vtg.Pmos_vtg,       "pmos_vtg"        )
     lib.definePcell(Mosfet_vth.Nmos_vth,       "nmos_vth"        )
     lib.definePcell(Mosfet_vth.Pmos_vth,       "pmos_vth"        )
     lib.definePcell(Mosfet_thkox.Nmos_thkox,       "nmos_thkox"      )
     lib.definePcell(Mosfet_thkox.Pmos_thkox,       "pmos_thkox"      )
#     lib.definePcell(transistorUnit.PyTransistorUnit,  "PyTransistor")
#     lib.definePcell(diffPair.PyDiffPair,        "PyDiffPair"  )
