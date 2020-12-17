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
# Mosfet.py
#
########################################################################
"""Module: Mosfet

This module implements a MosfetTemplate class for creating MOS
transistor PyCells.

MosfetTemplate provides the following capabilities:
    - (float  )  transistor width
    - (float  )  transistor length
    - (integer)  fingers, number of transistors

    - (boolean)  left   diffusion contact
    - (float  )  left   diffusion contact coverage
    - (boolean)  left   transistor gate contact
    - (float  )  left   transistor gate contact coverage

    - (boolean)  center diffusion contacts
    - (float  )  center diffusion contact coverage
    - (boolean)  center transistor gates contact
    - (float  )  center transistor gates contact coverage

    - (boolean)  right  diffusion contact
    - (float  )  right  diffusion contact coverage
    - (boolean)  right  transistor gate contact
    - (float  )  right  transistor gate contact coverage

    - Stretch handles for contacts
    - Stretch handles for gate w & l
    - Auto-abutment

    - Electrical connectivity, i.e. nets, pins, terminals.



Class variables:
    - (string )  poly,      Layer name
    - (string )  diffusion, Layer name
    - (string )  well,      Layer name
    - (string )  implant,   Layer name
    - (string )  contact,   Layer name
    - (string )  metal1,    Layer name



Technology file requirements:
    - (minEnclosure  poly       diffusion)
    - (minEnclosure  diffusion  poly     )
    - (minSpacing    contact    poly     )
    - (minSpacing    poly                )
    - (minWidth      contact             )

    Additional requirements exist in Via module.



Module dependencies:
    - cni.dlo,      CiraNova PyCell APIs.
    - Via,          Contact PyCells



Exceptions:
    - ValueError, for missing DRC rules in technology file.



EDA tool integration:
    Stretch handles are specific features of layout editors.
    Standard OpenAccess semantics do not exist.  To support
    stretch handles, we define a standard protocol, and create
    customized interpreters for each layout editor.  This
    enables us to support stretch handles in multiple layout
    editors without changes to the Python API or the PyCell
    implementation.



Other notes:
    [1] Dogbone configurations aren't implemented in this code.
        For current processes, 90nm and below, the transistor
        endcap to L-shaped source/drain diffusion spacing is
        typically bigger.  This type of conditional rule is
        better modeled in upcoming API functions; hence, we
        defer the implementation.

    [2] Only creates pins for leftmost diffusion, rightmost diffusion,
        and leftmost gate.  Unclear what to do about the center gates
        and diffusions, since this could be either a series or a
        parallel structure.
    """

__revision__ = "$Id: Mosfet_vth.py 151 2009-11-02 17:30:59Z wdavis@EOS.NCSU.EDU $"
__author__ = "Lyndon C. Lim"

from cni.dlo import (
    Box,
    Direction,
    DloGen,
    FailAction,
    Grouping,
    Instance,
    Layer,
    Location,
    ParamArray,
    ParamSpecArray,
    Pin,
    Point,
    RangeConstraint,
    Rect,
    Term,
    TermType,
    Text,
)

from cni.integ.common import (
    stretchHandle,
    autoAbutment,
)

import traceback

from Via import (
    ViaInstance,
)

class Dictionary:
    pass

#### Layer rules in Santana.tech must be kept up-to-date for this to run correctly!

class MosfetTemplate( DloGen):
    """Defines a MosfetTemplate class.
        """
    poly      = "poly"
    diffusion = "active"
    well      = "nwell or pwell"
    implant   = "pimplant"
    contact   = "contact"
    metal1    = "metal1"

    @classmethod
    def defineParamSpecs(cls, specs):
        """Define the PyCell parameters.  The order of invocation of
        specs() becomes the order on the form.

        Arguments:
        specs - (ParamSpecArray)  PyCell parameters
            """
        oxide    = "thin"
        tranType = {"pimplant":"pmos_vth", "nimplant":"nmos_vth"}[cls.implant]

        l = specs.tech.getMosfetParams( tranType, oxide, "minLength")
            
        # No dogbone allowed.
        w = specs.tech.getPhysicalRule( "minWidth", specs.tech.getLayer(cls.contact)) + \
                2.0 * specs.tech.getPhysicalRule( "minEnclosure", specs.tech.getLayer(cls.diffusion), specs.tech.getLayer(cls.contact))
        w = max( w, specs.tech.getMosfetParams( tranType, oxide, "minWidth"))

        specs( "w", w, constraint = RangeConstraint( w, 1000*w, FailAction.USE_DEFAULT))
        specs( "l", l, constraint = RangeConstraint( l, 1000*l, FailAction.USE_DEFAULT))
        specs( "fingers", 1),



        parameters = (
            ("diffContactLeft",      True ),
            ("diffContactLeftCov",   1.0  ),
            ("gateContactLeft",      False ),
            ("gateContactLeftCov",   1.0  ),

            ("diffContactCenter",    False ),
            ("diffContactCenterCov", 1.0  ),
            ("gateContactCenter",    False ),
            ("gateContactCenterCov", 1.0  ),

            ("diffContactRight",     True ),
            ("diffContactRightCov",  1.0  ),
            ("gateContactRight",     False ),
            ("gateContactRightCov",  1.0  ),
        )

        rangeConstraint = RangeConstraint(0.0, 1.0, FailAction.USE_DEFAULT)
        for parameter in parameters:
            if isinstance( parameter[1], float):
                specs( parameter[0], parameter[1], constraint=rangeConstraint)
            else:
                specs( parameter[0], parameter[1])



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
            self.__dict__[key] = params[ key]

        for key in (
            "diffContactLeftCov",
            "gateContactLeftCov",
            "diffContactCenterCov",
            "gateContactCenterCov",
            "diffContactRightCov",
            "gateContactRightCov" ):

            # Contact coverage parameters are 0.0 - 1.0
            self.__dict__[key] = min( max( self.__dict__[key], 0), 1.0)



        # Convert to process layer names
        if self.implant == "pimplant":
            self.encLayers = [ self.tech.getLayer( "nwell")]
            self.well = self.tech.getLayer( "nwell")
        else:
            self.encLayers = [ self.tech.getLayer( "pwell")]
            self.well = self.tech.getLayer( "pwell")
        self.alt = self.tech.getLayer( "vth")
        self.poly      = self.tech.getLayer( self.poly      )
        self.diffusion = self.tech.getLayer( self.diffusion    )
        self.implant   = self.tech.getLayer( self.implant   )
        self.contact   = self.tech.getLayer( self.contact   )
        self.metal1    = self.tech.getLayer( self.metal1    )

# Implant not an enclosing layer in our kit
#        self.encLayers.append( self.implant)

        self.instance  = 0  # counter for instance names


        # Get process design rule information
        self.Endcap        = self.tech.getPhysicalRule( "minEnclosure", self.poly, self.diffusion)
        self.ContSpacePoly = self.tech.getPhysicalRule( "minSpacing",   self.contact, self.poly)
        self.DiffSpace     = self.tech.getPhysicalRule( "minSpacing",   self.diffusion)
        self.GateSpace     = self.tech.getPhysicalRule( "minSpacing",   self.poly)
        self.ContWidth     = self.tech.getPhysicalRule( "minWidth",     self.contact)

        self.grid   = self.tech.getGridResolution()
        self.gridX2 = self.grid * 2.0
        self.gridd2 = self.grid / 2.0

        self.w      = round(self.w / self.gridX2) * self.gridX2
        self.l      = round(self.l / self.gridX2) * self.gridX2
        self.lDiv2  = self.l / 2.0

        self.GatePitch     = self.GateSpace + self.l
        self.GatePitchDiv2 = (self.GateSpace + self.l) / 2.0
        self.GateSpaceDiv2 = self.GateSpace / 2.0
        self.ContGatePitch = self.ContSpacePoly + self.lDiv2 + (self.ContWidth / 2.0)



    def genTopology( self):
        """Define topology (connectivity) for multi-device circuit PyCells.
            """
        pass



    def sizeDevices( self):
        """Define device sizes within multi-device circuit PyCells.
            """
        pass



    def createGate( self,
        x=0,
        y=0,
        terminal=False):
        """Create the poly rectangle which represents the MOS
        transistor gate.

        Override this method to create custom gates.

        Arguments:
        x           - (integer)  x coordinate of gate center
        y           - (integer)  y coordinate of lower diffusion edge
            """
        left  = x - self.lDiv2 
        right = x + self.lDiv2

        # Create transistor gate
        gateRect =  Rect( self.poly,
            Box( left,  (y - self.Endcap),
                 right, (y + self.w + self.Endcap),
            )
        )

        # Stretch handles for w & l
        stretchHandle(
            shape       = gateRect,
            name        = ("stretch%d" % self.instance),
            parameter   = "w",
            location    = Location.UPPER_CENTER,
            direction   = Direction.NORTH_SOUTH,
            display     = ("w = %.2f" % self.w),
            stretchType = "relative",
            userScale   = "1.0",
            userSnap    = "0.0025",
        )

        stretchHandle(
            shape       = gateRect,
            name        = ("stretch%d" % self.instance),
            parameter   = "l",
            location    = Location.CENTER_RIGHT,
            direction   = Direction.EAST_WEST,
            display     = ("l = %.2f" % self.l),
            stretchType = "relative",
            userScale   = "1.0",
            userSnap    = "0.0025",
        )



        # Create weakly-connected pins
        if terminal:
            # Bottom gate pin
            Pin(
                "%sS%d" % (terminal, self.instance),
                terminal,
                Rect(
                    self.poly,
                    Box( left, (y - self.Endcap),
                         right, y,
                    )
                )
            )

            # Top gate pin
            Pin(
                "%sN%d" % (terminal, self.instance),
                terminal,
                Rect(
                    self.poly,
                    Box( left,  (y + self.w),
                         right, (y + self.w + self.Endcap),
                    )
                )
            )

        self.instance += 1
        return( gateRect)



    def createGateCont( self,
        gateRect=False,
        coverage=1.0,
        stretch=False,
        terminal=False):
        """Create a gate contact by instantiating a poly contact PyCell.

        Arguments:
        gateRect    - (PhysicalComponent)  Gate rectangle for alignment.
        coverage    - (float  )  Percentage of poly width to be covered
                                 by contact
        stretch     - (string )  Name of stretch handle property for
                                 gate contact
            """
        gateCont = ViaInstance(
            "pcont",
            ParamArray(),
            None,
            "I%d" % self.instance,
        )
        self.place( gateCont, Direction.SOUTH, gateRect, 0)

        width = self.l * coverage
        gateCont.resize(
            width      = width,
            via        = self.contact,
            metalLayer = self.poly,
        )

        # Create overlapping poly rectangle for stretch handle
        polyRect      = gateCont.promoteMetal( self.poly)
        bbox          = polyRect.getBBox()
        width         = max( width, bbox.getWidth()) / 2
        center        = bbox.getCenterX()
        bbox.setLeft(  center - width)
        bbox.setRight( center + width)
        polyRect.setBBox( bbox)

        # Stretch handle for gate contact coverage
        stretchHandle(
            shape       = polyRect,
            name        = ("stretch%d" % self.instance),
            parameter   = stretch,
            location    = Location.CENTER_RIGHT,
            direction   = Direction.EAST_WEST,
            stretchType = "relative",
            userScale   = "1.0",
            userSnap    = "0.0025",
            minVal      = 0.0,
            maxVal      = 1.0,
        )



        # Create weakly-connected pins
        if terminal:
            Pin(
                ("%sC%d" % (terminal, self.instance)),
                terminal, 
                Rect( self.poly, bbox)
            )

        self.instance += 1
        return( gateCont)



    def createSourceDrain( self,
        diffusionType="full",
        withContact=True,
        x=0,
        y=0,
        coverage=1.0,
        stretch=False,
        terminal=False):
        """Create a source or drain diffusion.
        
        Option to create diffusion contact instance.

        Option to create matching diffusion terminal.

        Option to create a stretch handle property.

        Override this method to create custom contacts.

        Arguments:
        diffusionType - (string) "full", "left", "right"
        withContact - (boolean)  Create contact
        x           - (float  )  x coordinate for center of contact
        y           - (float  )  y coordinate for lower diffusion edge
        coverage    - (float  )  Percentage of source/drain diffusion to
                                 be covered by contact
        stretch     - (string )  Name of stretch handle property
            """
        # Create source/drain contact
        if withContact:
            diffCont = ViaInstance(
                "dcont",
                ParamArray( origin="lowerCenter"),
                None,
                "I%d" % self.instance,
            )
            diffCont.setOrigin( Point(x, y-0.03))

            height = self.w * coverage
            diffCont.resize(
                height      = height,
                via         = self.contact,
                metalLayer  = self.diffusion,
            )

            # Create overlapping diffusion rectangle for stretch handle
            diffRect    = diffCont.promoteMetal( self.diffusion)
            bbox        = diffRect.getBBox()
            height      = max( height, bbox.getHeight())
            bbox.setTop( bbox.getBottom() + height)
            diffRect.setBBox( bbox)

            # Stretch handle for diffusion contact coverage
            stretchHandle(
                shape       = diffRect,
                name        = ("stretch%d" % self.instance),
                parameter   = stretch,
                location    = Location.UPPER_CENTER,
                direction   = Direction.NORTH_SOUTH,
                stretchType = "relative",
                userScale   = "1.0",
                userSnap    = "0.0025",
                minVal      = 0.0,
                maxVal      = 1.0,
            )

            self.instance += 1



        # Create source/drain diffusion
        if withContact:
            bbox = Box(
                bbox.getLeft(), y,
                bbox.getRight(), (y + self.w),
            )
        else:
            if (diffusionType == "left"):
                bbox = Box(
                    x, y,
                    (x + self.GateSpaceDiv2), (y + self.w),
                )
            elif (diffusionType == "right"):
                bbox = Box(
                    (x - self.GateSpaceDiv2), y,
                    x, (y + self.w),
                )
            elif (diffusionType == "full"):
                bbox = Box(
                    (x - self.GateSpaceDiv2), y,
                    (x + self.GateSpaceDiv2), (y + self.w),
                )
            else:
                raise ValueError, "Unknown:  diffusionType=%s" % diffusionType

        if terminal:
            p0 = Pin(
                terminal,
                terminal,
                Rect( self.diffusion, bbox)
            )

            pinRect     = p0.getShapes()[0]

            autoAbutment(
                pinRect,
                self.w,
                [ Direction.WEST],
                "cniMOS",
                abut2PinEqual   = [ { "spacing":0.0}, { "diffLeftStyle":"DiffHalf"        },  { "diffLeftStyle":"DiffHalf"        } ],
                abut2PinBigger  = [ { "spacing":0.0}, { "diffLeftStyle":"DiffEdgeAbut"    },  { "diffLeftStyle":"DiffEdgeAbut"    } ],
                abut3PinBigger  = [ { "spacing":0.0}, { "diffLeftStyle":"ContactEdgeAbut2"},  { "diffLeftStyle":"ContactEdgeAbut2"} ],
                abut3PinEqual   = [ { "spacing":0.0}, { "diffLeftStyle":"DiffAbut"        },  { "diffLeftStyle":"ContactEdgeAbut2"} ],
                abut2PinSmaller = [ { "spacing":0.0}, { "diffLeftStyle":"DiffEdgeAbut"    },  { "diffLeftStyle":"DiffEdgeAbut"    } ],
                abut3PinSmaller = [ { "spacing":0.0}, { "diffLeftStyle":"DiffEdgeAbut"    },  { "diffLeftStyle":"DiffEdgeAbut"    } ],
                noAbut          = [ { "spacing":0.4}],
                function	= "cniAbut",


                
                #shape         = pinRect,
                #abutDirection = diffusionType,
                #abutClass     = "cniMOS",
                #abutFunction  = "cniAbut",
                #spacingRule   = self.DiffSpace,
            )
        else:
            pinRect = Rect( self.diffusion, bbox)



        return( pinRect)



    def genLayout( self):
        """Main body of geometric construction code.  Create the
        leftmost contact and transistor gate.  Loop to create center
        contacts and gates.  Create the rightmost gate and contact.

        Avoid modifying or overriding this method.  PyCell-specific
        behaviors and calculations should be kept out of this method.
            """
        # obj is used to track the rightmost object, to calculate
        # the diffusion coordinates.

        # dbox is the bounding box of the underlying diffusion.
        dbox        = Dictionary()
        dbox.bottom = 0
        dbox.top    = self.w

        origin      = Dictionary()

        xCoord      = 0
        origin.y    = 0

        objectPitch = {
            True:self.ContGatePitch,
            False:self.GatePitchDiv2,
        }



        # Mark PyCell as containing stretch handles
        self.props["cniStretch"] = "CiraNova"

        # For integration with layout editors, save parameter
        # settings in the submaster.  They are not saved on the
        # instance in the default case.

        # For auto-abutment
        self.props["diffContactLeft"]  = self.diffContactLeft
        self.props["diffContactRight"] = self.diffContactRight

        # For stretch handles
        self.props["w"] = self.w
        self.props["l"] = self.l

        # Create electrical terminals needed for pins
        Term("G", TermType.INPUT)
        Term("S", TermType.INPUT_OUTPUT)
        Term("D", TermType.INPUT_OUTPUT)



        # Create leftmost diffusion contact
        obj = self.createSourceDrain(
            diffusionType = "left",
            withContact   = self.diffContactLeft,
            coverage      = self.diffContactLeftCov,
            stretch       = "diffContactLeftCov",
            terminal      = "S",
            x             = xCoord,
        )
        dbox.left = obj.getBBox( self.diffusion).getLeft()

        # Create leftmost gate w/optional gate contact
        xCoord += objectPitch[self.diffContactLeft]# + 0.0025
        obj = self.createGate( x=xCoord, terminal="G")
        origin.x = obj.getBBox().left

        if self.gateContactLeft:
            self.createGateCont(
                gateRect = obj,
                coverage = self.gateContactLeftCov,
                stretch  = "gateContactLeftCov",
                terminal = "G",
            )



        # Loop to create center gates and contacts
        for i in range( self.fingers - 2):

            # Create diffusion contact on left of gate
            xCoord += objectPitch[self.diffContactCenter] + 0.0025
            self.createSourceDrain(
                diffusionType = "full",
                withContact   = self.diffContactCenter,
                coverage      = self.diffContactCenterCov,
                stretch       = "diffContactCenterCov",
                x             = xCoord,
            )

            # Create gate w/optional gate contact
            if self.diffContactCenter:
                xCoord += objectPitch[self.diffContactCenter] + 0.0025
            else:
                xCoord += objectPitch[self.diffContactCenter] - 0.0025
            obj = self.createGate( x=xCoord, terminal="G")

            if self.gateContactCenter:
                self.createGateCont(
                    gateRect = obj,
                    coverage = self.gateContactCenterCov,
                    stretch  = "gateContactCenterCov",
                    terminal = "G",
                )



        # Create rightmost gate w/optional gate contact
        if self.fingers > 1:
            if self.diffContactCenter:
                xCoord += objectPitch[self.diffContactCenter] + 0.0025
            else:
                xCoord += objectPitch[self.diffContactCenter] - 0.0025
            self.createSourceDrain(
                diffusionType = "full",
                withContact   = self.diffContactCenter,
                coverage      = self.diffContactCenterCov,
                stretch       = "diffContactCenterCov",
                x             = xCoord,
            )

            xCoord += objectPitch[self.diffContactCenter] + 0.0025
            obj = self.createGate( x=xCoord, terminal="G")

            if self.gateContactRight:
                self.createGateCont(
                    gateRect = obj,
                    coverage = self.gateContactRightCov,
                    stretch  = "gateContactRightCov",
                    terminal = "G",
                )



        # Create rightmost diffusion contact
        xCoord += objectPitch[self.diffContactRight]# + 0.0025
        obj = self.createSourceDrain(
            diffusionType = "right",
            withContact   = self.diffContactRight,
            coverage      = self.diffContactRightCov,
            stretch       = "diffContactRightCov",
            x             = xCoord,
            terminal      = "D",
        )
        dbox.right = obj.getBBox(self.diffusion).getRight()



        # Create overall diffusion box
        Rect(
            self.diffusion,
            Box( dbox.left, dbox.bottom, dbox.right, dbox.top)
        )
        # Create implant box, to overlap diffusion rather than whole cell
        Rect(
            self.implant,
            Box( dbox.left, dbox.bottom, dbox.right, dbox.top)
        )
        Rect(
            self.well,
            Box( dbox.left - 0.055, dbox.bottom - 0.055, dbox.right + 0.055, dbox.top + 0.055 )
        )
        Rect(
            self.alt,
            Box( dbox.left - 0.055, dbox.bottom - 0.055, dbox.right + 0.055, dbox.top + 0.055 )
        )
        # Create other outline layers
        all = Grouping( "all", self.getComps())
#        all.add( self.fgAddEnclosingRects( all, self.encLayers)) This wasn't working, replaced with above rectangles



        # Setting the origin is important.
        # Avoid shifting of instance locations during auto-abutment.  
        # Correctly track mouse motion during stretching.
        all.moveBy( -origin.x, -origin.y)



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



class Nmos_vth( MosfetTemplate):
    """Define Nmos class to implement NMOS MOS transistors.
        """
    implant = "nimplant"



class Pmos_vth( MosfetTemplate):
    """Define Nmos class to implement PMOS MOS transistors.
        """
    implant = "pimplant"



########################################################################
#
# End
#
########################################################################


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

        param = ParamArray(
            w = 0.6,
            l = 0.18,
            fingers = 1,
            diffContactLeft = True,
            diffContactLeftCov = 0.7,
            gateContactLeft = False,
            gateContactLeftCov = 0.7,

            diffContactCenter = False,
            diffContactCenterCov = 0.5,
            gateContactCenter = False,
            gateContactCenterCov = 0.5,

            diffContactRight = False,
            diffContactRightCov = 1.0,
            gateContactRight = True,
            gateContactRightCov = 1.0,
        )

        for master in [ "nmos_vth", "pmos_vth"]:
            inst = Instance(("%s" % master), param, None, ("I%d" % i))
            inst.setOrigin( Point( x,y))

            i += 1

            if (i % 4):
                x += 10
            else:
                x = 0
                y += 10

        param = ParamArray(
            w = 2.0,
            l = 1.5,
            fingers = 1,
            diffContactLeft = True,
            diffContactLeftCov = 0.3,
            gateContactLeft = True,
            gateContactLeftCov = 0.3,

            diffContactCenter = True,
            diffContactCenterCov = 0.5,
            gateContactCenter = True,
            gateContactCenterCov = 0.5,

            diffContactRight = True,
            diffContactRightCov = 0.7,
            gateContactRight = True,
            gateContactRightCov = 0.7,
        )

        for master in [ "nmos_vth", "pmos_vth"]:
            inst = Instance(("%s" % master), param, None, ("I%d" % i))
            inst.setOrigin( Point( x,y))

            i += 1

            if (i % 4):
                x += 10
            else:
                x = 0
                y += 10

        param = ParamArray(
            w = 2.0,
            l = 1.5,
            fingers = 2,
            diffContactLeft = True,
            diffContactLeftCov = 0.3,
            gateContactLeft = True,
            gateContactLeftCov = 0.3,

            diffContactCenter = True,
            diffContactCenterCov = 0.5,
            gateContactCenter = True,
            gateContactCenterCov = 0.5,

            diffContactRight = True,
            diffContactRightCov = 1.0,
            gateContactRight = True,
            gateContactRightCov = 1.0,
        )

        for master in [ "nmos_vth", "pmos_vth"]:
            inst = Instance(("%s" % master), param, None, ("I%d" % i))
            inst.setOrigin( Point( x,y))

            i += 1

            if (i % 4):
                x += 10
            else:
                x = 0
                y += 10

        param = ParamArray(
            w = 2.0,
            l = 1.5,
            fingers = 2,
            diffContactLeft = False,
            diffContactLeftCov = 1.0,
            gateContactLeft = True,
            gateContactLeftCov = 1.0,

            diffContactCenter = False,
            diffContactCenterCov = 0.5,
            gateContactCenter = True,
            gateContactCenterCov = 0.6,

            diffContactRight = True,
            diffContactRightCov = 0.4,
            gateContactRight = False,
            gateContactRightCov = 0.4,
        )

        for master in [ "nmos_vth", "pmos_vth"]:
            inst = Instance(("%s" % master), param, None, ("I%d" % i))
            inst.setOrigin( Point( x,y))

            i += 1

            if (i % 4):
                x += 10
            else:
                x = 0
                y += 20

        self.save()



    def bigtest( self):
        """Create layout instances for comprehensive testing, such as DRC or
        regression testing.
            """
        i = 0
        x = 0
        y = 0

        for w in [ 0.09, 2.0]:
         for l in [ 0.05, 1.0]:
          for fingers in [ 1, 2]:
           for diffContactLeftCov   in [ 0.0, 0.33, 1.0]:
            for gateContactLeftCov   in [ 0.0, 0.33, 1.0]:
             for diffContactCenterCov in [ 0.0, 0.33, 1.0]:
              for gateContactCenterCov in [ 0.0, 0.33, 1.0]:
               for diffContactRightCov  in [ 0.0, 0.33, 1.0]:
                for gateContactRightCov  in [ 0.0, 0.33, 1.0]:

                    param = ParamArray(
                        w = w,
                        l = l,
                        fingers = fingers,
                        diffContactLeft      = (not diffContactLeftCov),
                        diffContactLeftCov   = diffContactLeftCov,

                        gateContactLeft      = (not gateContactLeftCov),
                        gateContactLeftCov   = gateContactLeftCov,

                        diffContactCenter    = (not diffContactCenterCov),
                        diffContactCenterCov = diffContactCenterCov,

                        gateContactCenter    = (not gateContactCenterCov),
                        gateContactCenterCov = gateContactCenterCov,

                        diffContactRight     = (not diffContactRightCov),
                        diffContactRightCov  = diffContactRightCov,

                        gateContactRight     = (not gateContactRightCov),
                        gateContactRightCov  = gateContactRightCov,
                    )

                    for master in [ "nmos_vth", "pmos_vth"]:
                        inst = Instance(("%s" % master), param, None, ("I%d" % i))
                        inst.setOrigin( Point( x,y))

                        i += 1

                        if (i % 100):
                            x += 20
                        else:
                            x = 0
                            y += 20

        print("Total number of instances created:  %d" % i)
        self.save()

    # TEST is defined externally from this file.
    # For building the test cases, invoke like this:
    # cnpy -c "TEST='SMALL';execfile('Mosfet.py')"
    if "TEST" in vars():
        if vars()["TEST"] == "SMALL":
            MosfetTemplate.unitTest(lambda: ParamArray(), "MyPyCellLib", "UNITTEST_Mosfet", "layout")
            DloGen.withNewDlo( smalltest, "MyPyCellLib", "SMALLTEST_Mosfet", "layout")
        elif vars()["TEST"] == "BIG":
            DloGen.withNewDlo( bigtest, "MyPyCellLib", "BIGTEST_Mosfet", "layout")
    else:
        DloGen.withNewDlo( smalltest, "MyPyCellLib", "SMALLTEST_Mosfet", "layout")

# end
