########################################################################
# Copyright (c) 2001-2006 Ciranova, Inc. All Rights Reserved.          #
#                                                                      #
# Permission is hereby granted, free of charge, to any person          #
# obtaining a copy of this software and associated documentation       #
# ("Ciranova Open Code"), to use the Ciranova Open Code without        #
# restriction, including without limitation the right to use, copy,    #
# modify, merge, publish, distribute, sublicense, and sell copies of   #
# the Ciranova Open Code, and to permit persons to whom the Ciranova   #
# Open Code is furnished to do so, subject to the following            #
# conditions:                                                          #
#                                                                      #
# The above copyright notice and this permission notice must be        #
# included in all copies and all distribution, redistribution, and     #
# sublicensing of the Ciranova Open Code. THE CIRANOVA OPEN CODE IS    #
# PROVIDED "AS IS" AND WITHOUT WARRANTY OF ANY KIND, EXPRESS, IMPLIED  #
# OR STATUTORY INCLUDING WITHOUT LIMITATION ANY WARRANTY OF            #
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, TITLE AND         #
# NONINFRINGEMENT. IN NO EVENT SHALL CIRANOVA, INC. BE LIABLE FOR ANY  #
# INDIRECT, PUNITIVE, SPECIAL, INCIDENTAL OR CONSEQUENTIAL DAMAGES     #
# ARISING FROM, OUT OF OR IN CONNECTION WITH THE CIRANOVA OPEN CODE    #
# OR ANY USE OF THE CIRANOVA OPEN CODE, OR BE LIABLE FOR ANY CLAIM,    #
# DAMAGES OR OTHER LIABILITY, HOWEVER IT ARISES AND ON ANY THEORY OF   #
# LIABILITY, WHETHER IN AN ACTION FOR CONTRACT, STRICT LIABILITY OR    #
# TORT (INCLUDING NEGLIGENCE), OR OTHERWISE, ARISING FROM, OUT OF OR   #
# IN CONNECTION WITH THE CIRANOVA OPEN CODE OR ANY USE OF THE          #
# CIRANOVA OPEN CODE. The Ciranova Open Code is subject to U.S.        #
# export control laws and may be subject to export or import           #
# regulations in other countries, and all use of the Ciranova Open     #
# Code must be in compliance with such laws and regulations.  If any   #
# license for the Ciranova Open Code is obtained pursuant to a         #
# government contract, all use, distribution and/or copying by the     #
# U.S. government shall be subject to this permission notice and any   #
# applicable FAR provisions.                                           #
########################################################################

########################################################################
#
# Via.py
#
########################################################################
"""Module:  Via

This module implements a ViaTemplate class for creating via PyCells.

ViaTemplate provides the following capabilities:
    - (integer) number of via geometries per column
    - (integer) number of via geometries per row
    - (string ) location of origin

Class variables:
    - (string ) poly,       Layer name
    - (string ) diffusion,  Layer name
    - (string ) well,       Layer name
    - (string ) implant,    Layer name
    - (string ) contact,    Layer name
    - (string ) via1,       Layer name
    - (string ) metal1,     Layer name

    - (string ) metalUpper, Layer name
    - (string ) metalLower, Layer name
    - (string ) via,        Layer name
    - (array  ) outline,    Layer name(s)

    - (integer) xCnt,       Number of vias per row
    - (integer) yCnt,       Number of vias per column
    - (string ) origin,     Location of origin



ViaInstance provides the following capabilities:
    - method to calculate the xCnt & yCnt for a via to fill the
      requested area.



Technology file requirements:
    - (minEnclosure    metalUpper via    )
    - (minEnclosureEnd metalUpper via    )
    - (minEnclosure    metalLower via    )
    - (minEnclosureEnd metalLower via    )

    - (minWidth      via                 )
    - (minSpacing    via, minimum        )
    - (minSpacing    via, increased      )
    - (minSpacing    via, farm           )



Module dependencies:
    - cni.dlo,      CiraNova PyCell APIs.



Exceptions:
    - ValueError, for missing DRC rules in technology file.
    """

__revision__ = "$Id: Via.py 109 2007-12-20 18:56:46Z mdbucher $"
__author__ = "Lyndon C. Lim"

from cni.dlo import (
    Box,
    ChoiceConstraint,
    DloGen,
    FailAction,
    Grouping,
    Instance,
    ParamArray,
    ParamSpecArray,
    Point,
    RangeConstraint,
    Rect,
)

import traceback



class ViaTemplate( DloGen):
    """Defines a ViaTemplate class, for creating vias.
        """
    metalUpper   = "metal2"
    metalLower   = "metal1"
    via          = "via1"
    outline      = ()

    xCnt         = 1
    yCnt         = 1
    origin       = "centerCenter"



    @classmethod
    def defineParamSpecs( cls, specs):
        """Define the PyCell parameters.  The order of invocation of
        specs() becomes the order on the form.

        Arguments:
        specs - (ParamSpecArray)  PyCell parameters
            """
        c = RangeConstraint( 1, 100000, FailAction.USE_DEFAULT)
        specs( "xCnt",   1, constraint=c)
        specs( "yCnt",   1, constraint=c)

        c = ChoiceConstraint( [ "centerCenter", "lowerCenter", "lowerLeft", "centerLeft"], FailAction.USE_DEFAULT)
        specs( "origin", "centerCenter", constraint=c)



    def setupParams( self, params):
        """Process PyCell parameters, prior to geometric construction.
        Decisions about process rules and PyCell-specific behaviors
        should be confined to this method.
        
        Create most useful format for variables to be used in later
        methods.

        Arguments:
        params - (ParamArray)  PyCell parameters
            """
        for key in params:
            self.__dict__[key] = params[key]

        # Convert to process layers
        self.metalUpper        = self.tech.getLayer(self.metalUpper)
        self.metalLower        = self.tech.getLayer(self.metalLower)
        self.via               = self.tech.getLayer(self.via       )

        outline = []
        for layer in self.outline:
            outline.append( self.tech.getLayer( layer))
        self.outline = outline



        # Get process design rule information
        self.grid      = self.tech.getGridResolution()
        self.xEnc      = {}
        self.yEnc      = {}

        self.viaWidth        = self.tech.getPhysicalRule( "minWidth",   self.via)
        self.viaSpacingSmall = self.tech.getPhysicalRule( "minSpacing", self.via)



        if self.tech.physicalRuleExists( "limitBig", self.via):
            self.limitBig  = self.tech.getPhysicalRule( "limitBig", self.via)
        else:
            self.limitBig  = 10000  # Big number to disable option

        if self.tech.physicalRuleExists( "limitFarm", self.via):
            self.limitFarm = self.tech.getPhysicalRule( "limitFarm", self.via)
        else:
            self.limitFarm = 10000  # Big number to disable option



        if self.tech.physicalRuleExists( "minSpacingBig", self.via):
            self.viaSpacingBig  = self.tech.getPhysicalRule( "minSpacingBig", self.via)
        else:
            self.viaSpacingBig  = self.viaSpacingSmall

        if self.tech.physicalRuleExists( "minSpacingFarm", self.via):
            self.viaSpacingFarm = self.tech.getPhysicalRule( "minSpacingFarm", self.via)
        else:
            self.viaSpacingFarm = self.viaSpacingSmall



        self.xEnc[ (self.metalUpper, self.via)] = self.tech.getPhysicalRule( "minEnclosure", self.metalUpper, self.via)
        if self.tech.physicalRuleExists( "minEnclosureEnd", self.metalUpper, self.via):
            self.yEnc[ (self.metalUpper, self.via)] = self.tech.getPhysicalRule( "minEnclosureEnd", self.metalUpper, self.via)
        else:
            self.yEnc[ (self.metalUpper, self.via)] = self.xEnc[ (self.metalUpper, self.via)]



        self.xEnc[ (self.metalLower, self.via)] = self.tech.getPhysicalRule( "minEnclosure", self.metalLower, self.via)
        if self.tech.physicalRuleExists( "minEnclosureEnd", self.metalLower, self.via):
            self.yEnc[ (self.metalLower, self.via)] = self.tech.getPhysicalRule( "minEnclosureEnd", self.metalLower, self.via)
        else:
            self.yEnc[ (self.metalLower, self.via)] = self.xEnc[ (self.metalLower, self.via)]



        for layer in self.outline:
            for innerLayer in ( self.via, self.metalLower, self.metalUpper):
                if self.tech.physicalRuleExists( "minEnclosure", layer, innerLayer):
                    self.xEnc[ (layer, innerLayer)] = self.tech.getPhysicalRule( "minEnclosure", layer, innerLayer)
                else:
                    self.xEnc[ (layer, innerLayer)] = 0

                if self.tech.physicalRuleExists( "minEnclosureEnd", layer, innerLayer):
                    self.yEnc[ (layer, innerLayer)] = self.tech.getPhysicalRule( "minEnclosureEnd", layer, innerLayer)
                else:
                    self.yEnc[ (layer, innerLayer)] = self.xEnc[ (layer, innerLayer)]



        # Haven't defined a rule name yet in Santana.tech, so hard-code
        # this value for temporary testing and demonstration.
        # DEMO VALUES
        self.limitBig   = 3
        self.limitFarm  = 3
        self.viaSpacingBig  = 0.4
        self.viaSpacingFarm = 2.0



    def genTopology( self):
        """Define topology (connectivity) for multi-device circuit PyCells.
            """
        pass



    def sizeDevices( self):
        """Define device sizes within multi-device circuit PyCells.
            """
        pass



    def genLayout( self):
        """Main body of geometric construction code. 

        Avoid modifying or overriding this method.  PyCell-specific
        behaviors and calculations should be kept out of this method.
            """
        # Decide whether small or big via spacing applies
        if ( ((self.xCnt >  self.limitBig) and (self.yCnt >= self.limitBig)) or
             ((self.xCnt == self.limitBig) and (self.yCnt >  self.limitBig))   ):
            # Over  big spacing limit, use big spacing rules
            viaSpacing = self.viaSpacingBig
        else:
            # Under big spacing limit, use small spacing rules
            viaSpacing = self.viaSpacingSmall

        xViaPitch = self.viaWidth + viaSpacing
        yViaPitch = self.viaWidth + viaSpacing



        # Decide whether via farm rules apply
        if ( ((self.xCnt >  self.limitFarm) and (self.yCnt >= self.limitFarm)) or
             ((self.xCnt == self.limitFarm) and (self.yCnt >  self.limitFarm))   ):
            # Over  farm limit, use farm spacing rules
            viaSpacingFarm = self.viaSpacingFarm
        else:
            # Under farm limit, use same spacing rules
            viaSpacingFarm = viaSpacing

        xViaPitchFarm = (self.limitFarm - 1) * xViaPitch + self.viaWidth + viaSpacingFarm
        yViaPitchFarm = (self.limitFarm - 1) * yViaPitch + self.viaWidth + viaSpacingFarm



        #
        # Place the via geometries.
        #

        xCoordMax  = 0
        yCoordMax  = 0

        # Loop iterates over farms to build up complete columns.
        #
        # Each o represents a via geometry.
        #
        # ooo  ooo  ooo  ooo
        # ooo  ooo  ooo  ooo
        # ooo  ooo  ooo  ooo
        #
        # ooo  ooo  ooo  ooo
        # ooo  ooo  ooo  ooo
        # ooo  ooo  ooo  ooo
        #
        # ooo  ooo  ooo  ooo
        # ooo  ooo  ooo  ooo
        # ooo  ooo  ooo  ooo
        #
        yTotal     = 0
        yCoord     = 0
        yFarmCoord = 0
        while yTotal < self.yCnt:

            # Loop interates over rows to build up columns,
            # but only for part of each column within a farm.
            #
            # Each o represents a via geometry.
            #
            # ooo  ooo  ooo  ooo
            # ooo  ooo  ooo  ooo
            # ooo  ooo  ooo  ooo
            #
            y = 0
            while (y < self.limitFarm) and (yTotal < self.yCnt):

                # Loop iterates over farms to build a complete row
                #
                # Each o represents a via geometry.
                #
                # ooo  ooo  ooo  ooo
                #
                xTotal     = 0
                xCoord     = 0
                xFarmCoord = 0
                while xTotal < self.xCnt:

                    # Innermost loop builds part of each row within
                    # a farm.
                    #
                    # Each o represents a via geometry.
                    #
                    # ooo
                    #
                    x = 0
                    while (x < self.limitFarm) and (xTotal < self.xCnt):
                        Rect( self.via,
                            Box( xCoord, yCoord,
                                (xCoord + self.viaWidth), (yCoord + self.viaWidth)
                            )
                        )
                        x      += 1
                        xTotal += 1
                        xCoord += xViaPitch

                    xCoordMax = xCoord - xViaPitch + self.viaWidth
                    xFarmCoord += xViaPitchFarm
                    xCoord = xFarmCoord

                yCoordMax = yCoord + self.viaWidth
                y      += 1
                yTotal += 1
                yCoord += yViaPitch

            yFarmCoord += yViaPitchFarm
            yCoord = yFarmCoord



        # Construct upper metal plate.
        Rect( self.metalUpper,
            Box( -self.xEnc[ (self.metalUpper, self.via)],
                 -self.yEnc[ (self.metalUpper, self.via)],
                 xCoordMax + self.xEnc[ (self.metalUpper, self.via)],
                 yCoordMax + self.yEnc[ (self.metalUpper, self.via)],
            )
        )

        # Construct lower metal plate.
        Rect( self.metalLower,
            Box( -self.xEnc[ (self.metalLower, self.via)],
                 -self.yEnc[ (self.metalLower, self.via)],
                 xCoordMax + self.xEnc[ (self.metalLower, self.via)],
                 yCoordMax + self.yEnc[ (self.metalLower, self.via)],
            )
        )

        # Construct any outlining geometries, such as implant
        # layers needed for substrate/well contacts.
        for layer in self.outline:
            box = self.getBBox()
            for innerLayer in ( self.via, self.metalLower, self.metalUpper):
                innerBox = self.getBBox( innerLayer)
                innerBox.left   -= self.xEnc[ (layer, innerLayer)]
                innerBox.right  += self.xEnc[ (layer, innerLayer)]
                innerBox.bottom -= self.yEnc[ (layer, innerLayer)]
                innerBox.top    += self.yEnc[ (layer, innerLayer)]

                box.merge( innerBox)

            Rect( layer, box)



        # Move origin if requested
        all = Grouping( "all", self.getComps())
        if self.origin == "centerCenter":
            xCoord = round( (-xCoordMax / 2) / self.grid) * self.grid
            yCoord = round( (-yCoordMax / 2) / self.grid) * self.grid
        elif self.origin == "lowerCenter":
            xCoord = round( (-xCoordMax / 2) / self.grid) * self.grid
            yCoord = max( self.yEnc[ (self.metalUpper, self.via)], self.yEnc[ (self.metalLower, self.via)])
        elif self.origin == "lowerLeft":
            xCoord = max( self.xEnc[ (self.metalUpper, self.via)], self.xEnc[ (self.metalLower, self.via)])
            yCoord = max( self.yEnc[ (self.metalUpper, self.via)], self.yEnc[ (self.metalLower, self.via)])
        elif self.origin == "centerLeft":
            xCoord = max( self.xEnc[ (self.metalUpper, self.via)], self.xEnc[ (self.metalLower, self.via)])
            yCoord = round( (-yCoordMax / 2) / self.grid) * self.grid

        all.moveBy( xCoord, yCoord)



    @classmethod
    def unitTest( cls, paramsMaker, lib, cell, view, ignoreError=True):
        """Test single instance or specific method of the PyCell.
            """
        # Note:  Pass in paramMaker so parameters are constructed in
        #        the correct tech context (within the current DloGen).
 
        def unitTestMethod( self):
            """Define how to build the unit test.
                """
            # Get default parameters from specs, then update
            # with explicitly supplied specs for unitTest.
            specs = ParamSpecArray()
            self.defineParamSpecs( specs)
            params = ParamArray( specs)
            params.update( paramsMaker())

            print
            print( "Creating design: %s" % repr(self))
            print( "   using technology: %s" % self.tech.id())
            print( "   by %s.generate(%r)" % (self.__class__.__name__, params))

            specs.verify( params)
            self.generate( params)
            self.save()
 
        try:
            cls.withNewDlo( unitTestMethod, lib, cell, view)
        except:
            if ignoreError:
                # Error messages go to debug log
                print
                print( "Exception caught.")
                traceback.print_exc()
            else:
                raise



class ViaInstance( Instance):
    """Implements a ViaInstance class, for creating instances of
    via PyCells.  Provides additional methods as compared to the
    Instance class.
        """
    def resize( self, width=0, height=0, via=None, metalLayer=None):
        """Modify the via instance to fit within a specific width or
        height.
            """
        if width:
            (cols, tmp) = self.calculateViaCount( width=width, height=0, via=via, metalLayer=metalLayer)
            self.setParams( ParamArray( xCnt=cols))

        if height:
            (tmp, rows) = self.calculateViaCount( width=0, height=height, via=via, metalLayer=metalLayer)
            self.setParams( ParamArray( yCnt=rows))



    def calculateViaCount( self, width=0, height=0, via=None, metalLayer=None):
        """Calculate the number of rows or columns to modify the via
        instance to fit with a specific width or height.
            """
        if width  < 0:
            raise ValueError, ("Illegal width,  %f" % width )

        if height < 0:
            raise ValueError, ("Illegal height, %f" % height)



        # Get process design rule information
        viaWidth        = self.getMaster().tech.getPhysicalRule( "minWidth",   via)
        viaSpacingSmall = self.getMaster().tech.getPhysicalRule( "minSpacing", via)



        if self.getMaster().tech.physicalRuleExists( "limitBig", via):
            limitBig  = self.getMaster().tech.getPhysicalRule( "limitBig", via)
        else:
            limitBig  = 10000  # Big number to disable option

        if self.getMaster().tech.physicalRuleExists( "limitFarm", via):
            limitFarm = self.getMaster().tech.getPhysicalRule( "limitFarm", via)
        else:
            limitFarm = 10000  # Big number to disable option



        if self.getMaster().tech.physicalRuleExists( "minSpacingBig", via):
            viaSpacingBig = self.getMaster().tech.getPhysicalRule( "minSpacingBig",  via)
        else:
            viaSpacingBig = viaSpacingSmall

        if self.getMaster().tech.physicalRuleExists( "minSpacingFarm", via):
            viaSpacingFarm = self.getMaster().tech.getPhysicalRule( "minSpacingFarm", via)
        else:
            viaSpacingFarm = viaSpacingSmall



        xEnc = self.getMaster().tech.getPhysicalRule( "minEnclosure",  metalLayer, via)
        if self.getMaster().tech.physicalRuleExists( "minEnclosureEnd", metalLayer, via):
            yEnc = self.getMaster().tech.getPhysicalRule( "minEnclosureEnd", metalLayer, via)
        else:
            yEnc = xEnc



        # Calculate the number of vias, xCnt and yCnt, which
        # can fit in a specified width x height area of specified
        # metal layer

        # The calculation is naturally iterative, since it isn't
        # known beforehand whether extended spacing rules, such
        # as via farms will be triggered.

        viaPitchSmall = viaWidth + viaSpacingSmall
        viaPitchBig   = viaWidth + viaSpacingBig
        fPitch        = viaSpacingFarm + viaWidth + (limitFarm - 1) * viaPitchBig



        # First case, minimum spacing rules
        wLimit = (2 * xEnc) + viaWidth + ((limitBig - 1) * viaPitchBig)
        hLimit = (2 * yEnc) + viaWidth + ((limitBig - 1) * viaPitchBig)

        if ( ((width <  wLimit) and (height <= hLimit)) or 
             ((width == wLimit) and (height <  hLimit))   ):
            cols = 1 + ((width  - (2 * xEnc) - viaWidth) / viaPitchSmall)
            cols = max( cols, 1)

            rows = 1 + ((height - (2 * yEnc) - viaWidth) / viaPitchSmall)
            rows = max( rows, 1)

            return( int(cols), int(rows))



        # Second case, increased spacing rules
        wLimit = (2 * xEnc) + viaWidth + ((limitFarm - 1) * viaPitchBig)
        hLimit = (2 * yEnc) + viaWidth + ((limitFarm - 1) * viaPitchBig)

        if ( ((width <  wLimit) and (height <= hLimit)) or 
             ((width == wLimit) and (height <  hLimit))   ):
            cols = 1 + ((width  - (2 * xEnc) - viaWidth) / viaPitchBig)
            rows = 1 + ((height - (2 * yEnc) - viaWidth) / viaPitchBig)

            return( int(cols), int(rows))



        # Third case, via farm spacing rules
        fxCnt  = (width  - (2 * xEnc) - viaWidth) / fPitch
        xCnt   = (width  - (2 * xEnc) - viaWidth - (fxCnt * fPitch)) / viaPitchBig
        xCnt   = min( 1 + xCnt, limitFarm)
        cols   = xCnt + (fxCnt * limitFarm)

        fyCnt  = (height - (2 * yEnc) - viaWidth) / fPitch
        yCnt   = (height - (2 * yEnc) - viaWidth - (fyCnt * fPitch)) / viaPitchBig
        yCnt   = min( 1 + yCnt, limitFarm)
        rows   = yCnt + (fyCnt * limitFarm)

        return( int(cols), int(rows))



    def promoteMetal( self, layer):
        """Create a matching rectangle from the specified metal layer.
            """
        box = self.getBBox( layer)
        return( Rect( layer, box))



class PwellContact( ViaTemplate):
    """Class implements a pplus diffusion contact.
        """
    metalUpper   = "metal1"
    metalLower   = "active"
    via          = "contact"
    outline      = ("pimplant","pwell")



class NwellContact( ViaTemplate):
    """Class implements a pplus diffusion contact.
        """
    metalUpper   = "metal1"
    metalLower   = "active"
    via          = "contact"
    outline      = ("nwell","nimplant")



class PolyContact( ViaTemplate):
    """Class implements a polysilicon contact.
        """
    metalUpper   = "metal1"
    metalLower   = "poly"
    via          = "contact"
    outline      = ()



class DiffContact( ViaTemplate):
    """Class implements a diffusion contact.
        """
    metalUpper   = "metal1"
    metalLower   = "active"
    via          = "contact"
    outline      = ()



class PdiffContact( ViaTemplate):
    """Class implements a pplus diffusion contact.
        """
    metalUpper   = "metal1"
    metalLower   = "active"
    via          = "contact"
    outline      = ("pimplant","pwell")



class NdiffContact( ViaTemplate):
    """Class implements a nplus diffusion contact.
        """
    metalUpper   = "metal1"
    metalLower   = "active"
    via          = "contact"
    outline      = ("nimplant","nwell")



#class Via1( ViaTemplate):
#    """Class implements a metal1/metal2 via.
#        """
#    metalUpper   = "metal2"
#    metalLower   = "metal1"
#    via          = "via1"
#    outline      = ()



#class Via2( ViaTemplate):
#    """Class implements a metal2/metal3 via.
#        """
#    metalUpper   = "metal3"
#    metalLower   = "metal2"
#    via          = "via2"
#    outline      = ()



#class Via3( ViaTemplate):
#    """Class implements a metal3/metal4 via.
#        """
#    metalUpper   = "metal4"
#    metalLower   = "metal3"
#    via          = "via3"
#    outline      = ()

###############################################################################
#
# Define self-tests
#
###############################################################################
if __name__ == "__main__":
    def smalltest( self):
        """Create layout instances for quick development debugging.
            """
        i = 0
        x = 0
        y = 0

        param = ParamArray()

        for master in [ "via1", "via2", "via3", "ndcont", "pdcont", "dcont", "pcont"]:
            inst = Instance(("%s" % master), param, None, ("I%d" % i))
            inst.setOrigin( Point( x, y))

            i += 1

            if (i % 4):
                x += 5
            else:
                x = 0
                y += 5

        self.save()



    def bigtest( self):
        """Create layout instances for comprehensive testing, such as DRC or
        regression testing.
            """
        i = 0
        x = 0
        y = 0


        for master in [ "via1", "via2", "via3", "ndcont", "pdcont", "pcont"]:
            for xCnt in range( 10):
                for yCnt in range( 10):
                    for origin in [ "centerCenter", "lowerCenter", "lowerLeft", "centerLeft"]:

                        param = ParamArray(
                            xCnt   = xCnt,
                            yCnt   = yCnt,
                            origin = origin,
                        )
                        inst = Instance(("%s" % master), param, None, ("I%d" % i))
                        inst.setOrigin( Point( x, y))

                        i += 1

                        if (i % 20):
                            x += 20
                        else:
                            x = 0
                            y += 20

        print("Total number of instances created:  %d" % i)
        self.save()



    # TEST is defined externally from this file.
    # For building the test cases, invoke like this:
    # cnpy -c "TEST='SMALL';execfile('Via.py')"
    if "TEST" in vars():
        if vars()["TEST"] == "SMALL":
            ViaTemplate.unitTest(lambda: ParamArray(), "MyPyCellLib", "UNITTEST_Via", "layout")
            DloGen.withNewDlo( smalltest, "MyPyCellLib", "SMALLTEST_Via", "layout")
        elif vars()["TEST"] == "BIG":
            DloGen.withNewDlo( bigtest, "MyPyCellLib", "BIGTEST_Via", "layout")
    else:
        DloGen.withNewDlo( smalltest, "MyPyCellLib", "SMALLTEST_Via", "layout")

# end
