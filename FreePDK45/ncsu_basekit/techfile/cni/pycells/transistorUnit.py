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
# transistorUnit.py
#
########################################################################
"""Module: transistorUnit

This module implements a PyTransistorUnit class for creating
MOS transistor PyCells.

PyTransistorUnit provides the following capabilities:
    """

__revision__ = "$Id: transistorUnit.py 56 2007-07-17 20:04:59Z mdbucher $"
__author__ = "Lyndon C. Lim"

from cni.dlo import (
    Box,
    ChoiceConstraint,
    Contact,
    Direction,
    DloGen,
    FailAction,
    Grouping,
    Instance,
    Layer,
    ParamArray,
    ParamSpecArray,
    Pin,
    Point,
    RangeConstraint,
    Rect,
    ShapeFilter,
    Term,
    TermType,
)

import traceback



class PyTransistorUnit( DloGen):
    """Defines a PyTransistorUnit class for creating transistors with
    source and drain constacts.  This PyCell is a basic building block
    of other hierarchical PyCells.
        """
    @classmethod
    def defineParamSpecs(cls, specs):
        """Define the PyCell parameters.  The order of invocation of
        specs() becomes the order on the form.

        Arguments:
        specs - (ParamSpecArray)  PyCell parameters
            """
        tranType = "pmos_vtg"
        oxide    = "thin"
        length   = specs.tech.getMosfetParams( tranType, oxide, "minLength")

        # No dogbone allowed.  This PyCell is used for the
        # diffPair PyCell.  For differential pair design,
        # the assumption is that too much variability exists
        # for minimum width transistors; hence dogbone isn't
        # a useful configuration.
        width = specs.tech.getPhysicalRule( "minWidth", Layer("contact")) + \
                2.0 * specs.tech.getPhysicalRule( "minEnclosure", Layer("active"), Layer("contact"))
        width = max( width, specs.tech.getMosfetParams( tranType, oxide, "minWidth"))

        specs( "tranType", tranType, "MOSFET type (pmos_vtg or nmos_vtg)", ChoiceConstraint(["pmos_vtg", "nmos_vtg"]))
        specs( "width",  width,  constraint = RangeConstraint( width,  1000*width, FailAction.USE_DEFAULT))
        specs( "length", length, constraint = RangeConstraint( length, 1000*length, FailAction.USE_DEFAULT))
        specs( "oxide",  oxide, "oxide (thin or thick)", ChoiceConstraint(["thin", "thick"]))
        specs( "xtorFillLayer", Layer( "metal1"))
        specs( "sourceDiffOverlap", 0.0)
        specs( "drainDiffOverlap",  0.0)
     


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
        
        # Convert to process layer names
        self.gateLayer  = Layer( "poly" )
        self.strapLayer = Layer( "metal1")
        self.diffLayer  = Layer( "active"  )

        if self.tranType == "nmos_vtg":
            self.encLayers = [ Layer("pwell")]
            self.implantLayer = Layer("nimplant")
        else:
            self.encLayers = [ Layer( "nwell")]
            self.implantLayer = Layer("pimplant")

        if self.oxide == "thick":
            self.encLayers.append( Layer( "od2"))

        if not self.xtorFillLayer:
            self.xtorFillLayer = self.strapLayer

        # Get process design rule information
        self.endcap = self.tech.getPhysicalRule( "minExtension", self.gateLayer, self.diffLayer)
        self.grid   = self.tech.getGridResolution()

        # Despite previously set RangeConstraint, check again because
        # the minimum dimensions are larger for thick oxide devices.
        self.width  = max(
            self.width,
            self.tech.getMosfetParams( self.tranType, self.oxide, "minWidth" )
        )
        self.width = round( self.width  / self.grid) * self.grid

        self.length = max(
            self.length,
            self.tech.getMosfetParams( self.tranType, self.oxide, "minLength")
        )
        self.length = round( self.length / self.grid) * self.grid



    def genTopology( self):
        """Define topology (connectivity) for multi-device circuit PyCells.
            """
        pass



    def sizeDevices( self):
        """Define device sizes within multi-device circuit PyCells.
            """
        pass



    def genLayout( self):
        """Create the layout.  Main body of geometric construction code.
            """
        Term( "D", TermType.INPUT_OUTPUT)
        Term( "G", TermType.INPUT)
        Term( "S", TermType.INPUT_OUTPUT)
        Term( "B", TermType.INPUT_OUTPUT)

        # Create poly
        bbox       = Box( -self.endcap, 0, (self.width + self.endcap), self.length)
        polyRect   = Rect( self.gateLayer, bbox)
        Pin( "G", "G", Rect( self.gateLayer, bbox))

        # Create source contact
        contact = self.createContact( "S", Direction.SOUTH, polyRect, self.sourceDiffOverlap)
        bottom  = contact.getBBox().top

        # Create drain contact
        contact = self.createContact( "D", Direction.NORTH, polyRect, self.drainDiffOverlap )
        top     = contact.getBBox().bottom

        # Create diffusion
        Rect( self.diffLayer, Box( 0, bottom, self.width, top))
        Rect( self.implantLayer, Box( 0, bottom, self.width, top)) #create nonenclosing implant layer
        # Create other outline layers
        all = Grouping( "all", self.getComps())
        self.fgAddEnclosingRects( all, self.encLayers)



    def createContact( self, terminal, location, polyRect, moreOverlap):
        """Create the contact for source or drain.

        Arguments:
        terminal    - (string)  Name of terminal for pin.
        location    - (NORTH||SOUTH)  Relative location to place contact.
        polyRect    - (PhysicalComponent::Rect)  Shape to align contact.
        moreOverlap - (float)  Amount of additional diffusion overlap.
            """
        contact = Contact( self.diffLayer, self.xtorFillLayer, terminal, routeDir1 = Direction.EAST_WEST, routeDir2 = Direction.EAST_WEST)

        # Placement uses poly-to-diffusion spacing for dogbone
        # Demonstrate how dogbone should be done.
        isDogBone  = contact.getBBox( self.diffLayer).getWidth() > self.width

        if isDogBone:
            self.fgPlace( contact, location, polyRect)
        else:
            self.fgPlace( contact, location, polyRect, ShapeFilter([self.diffLayer], False))

        cbox = contact.getBBox( self.diffLayer)
        contact.moveBy( (cbox.left % self.grid), 0)

        if not isDogBone:
            pbox = polyRect.getBBox()
            contact.stretchTowards( Direction.EAST, pbox.right - self.endcap)
            contact.stretchTowards( Direction.WEST, pbox.left  + self.endcap)

        Pin( terminal, terminal, Rect( self.xtorFillLayer, contact.getBBox( self.xtorFillLayer)))



        # Add additional diffusion overlap
        cbox = contact.getBBox( self.diffLayer)
        if moreOverlap:
            if location == Direction.NORTH:
                cbox.setTop( cbox.top + moreOverlap)
            elif location == Direction.SOUTH:
                cbox.setBottom( cbox.bottom - moreOverlap)
            else:
                raise ValueError, "Unsupported Direction for more diffusion overlap."

            Rect( self.diffLayer, cbox)

        return( contact)

               
  
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



class PyTransistorUnitInstance( Instance):
    """Implements a PyTransistorUnitInstance class, for creating
    instances of PyTransistorUnit PyCells.  Provides additional methods
    as compared to the Instance class.
        """
    def getMergeOverlap( self, drainFlag):
        """Return the necessary distance to adjust abutting vertical
        placements of PyTransistorUnit instances to cause shared
        contacts to overlap.
            """
        if drainFlag:
            pBox = self.instPin( "D").getShapeRefs()[0].getBBox()
        else:
            pBox = self.instPin( "S").getShapeRefs()[0].getBBox()

        iBox     = self.getBBox()
        revXform = self.getTransform().invert()
        pBox.transform( revXform)
        iBox.transform( revXform)

        ext1 = pBox.bottom - iBox.bottom
        ext2 = iBox.top    - pBox.top

        return( pBox.getHeight() + (2.0 * min( ext1, ext2)))

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

        for width in [ 0.6, 2.0]:
         for length in [ 0.18, 0.6]:
          for sourceDiffOverlap in [0.0, 0.1]:
           for drainDiffOverlap in [0.0, 0.1]:
            for oxide in ["thin", "thick"]:
             for tranType in ["nmos_vtg", "pmos_vtg"]:
              for xtorFillLayer in ["metal1"]:

                param = ParamArray(
                    width = width,
                    length = length,
                    sourceDiffOverlap = sourceDiffOverlap,
                    drainDiffOverlap  = drainDiffOverlap,
                    oxide = oxide,
                    tranType = tranType,
                    xtorFillLayer = xtorFillLayer,
                )

                inst = Instance("PyTransistor", param, None, ("I%d" % i))
                inst.setOrigin( Point( x, y))

                i += 1

                if (i % 20):
                    x += 10
                else:
                    x = 0
                    y += 10

        self.save()



    def bigtest( self):
        """Create layout instances for comprehensive testing, such as DRC or
        regression testing.
            """
        i = 0
        x = 0
        y = 0

        for width in [ 0.3, 0.45, 0.5, 1.553, 2.0]:
         for length in [ 0.1, 0.18, 0.194, 0.2, 0.55]:
          for sourceDiffOverlap in [0.0, 0.1, 0.12, 0.15, 0.55]:
           for drainDiffOverlap in [0.0, 0.1, 0.12, 0.15, 0.55]:
            for oxide in ["thin", "thick"]:
             for tranType in ["nmos_vtg", "pmos_vtg"]:
              for xtorFillLayer in ["metal1"]:

                param = ParamArray(
                    width = width,
                    length = length,
                    sourceDiffOverlap = sourceDiffOverlap,
                    drainDiffOverlap  = drainDiffOverlap,
                    oxide = oxide,
                    tranType = tranType,
                    xtorFillLayer = xtorFillLayer,
                )

                inst = PyTransistorUnitInstance("PyTransistor", param, None, ("I%d" % i))
                inst.setOrigin( Point( x, y))

                i += 1

                if (i % 20):
                    x += 10
                else:
                    x = 0
                    y += 10

        print("Total number of instances created:  %d" % i)
        self.save()



    # TEST is defined externally from this file.
    # For building the test cases, invoke like this:
    # cnpy -c "TEST='SMALL';execfile('transistorUnit.py')"
    if "TEST" in vars():
        if vars()["TEST"] == "SMALL":
            PyTransistorUnit.unitTest(lambda: ParamArray(), "MyPyCellLib", "UNITTEST_transistorUnit", "layout")
            DloGen.withNewDlo( smalltest, "MyPyCellLib", "SMALLTEST_transistorUnit", "layout")
        elif vars()["TEST"] == "BIG":
            DloGen.withNewDlo( bigtest, "MyPyCellLib", "BIGTEST_transistorUnit", "layout")
    else:
        DloGen.withNewDlo( smalltest, "MyPyCellLib", "SMALLTEST_transistorUnit", "layout")

# end
