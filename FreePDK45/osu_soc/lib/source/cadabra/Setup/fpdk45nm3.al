/*

This file may look like it is human-editable, but it is not.
Editing it could corrupt your design data.
Saved with release Y-2006.03-SP1

*/
{
    cout << "Building the technology ..." << endl;

    auto rule;
    auto t = makeTechnology( "freepdk45nm", 0.0025, 0.000625, " " );
    t->lateralDiffusion = 0;

    // Layers
    t->addLayer( "N-WELL" );
    t->addLayer( "P-WELL" );
    t->addLayer( "N-IMPLANT" );
    t->addLayer( "P-IMPLANT" );
    t->addLayer( "N-ACT" );
    t->addLayer( "P-ACT" );
    t->addLayer( "N-STRAP" );
    t->addLayer( "P-STRAP" );
    t->addLayer( "POLY" );
    t->addLayer( "GATE" );
    t->addLayer( "CONT" );
    t->addLayer( "PCONT" );
    t->addLayer( "METAL1" );
    t->addLayer( "VIA1" );
    t->addLayer( "METAL2" );
    t->addLayer( "BOUNDARY" );
    t->addLayer( "VGHOST" );
    t->addLayer( "VIA2" );
    t->addLayer( "METAL3" );
    t->addLayer( "@text_cellName" );
    t->addLayer( "@text_VDD Power Rail" );
    t->addLayer( "@text_VSS Power Rail" );
    t->addLayer( "@text_METAL1 Port" );
    t->addLayer( "@text_METAL2" );
    t->addLayer( "@text_METAL2 Port" );

    // Representative layers

    // @text_METAL1 Port
    t->addDimensionRule( "@text_METAL1 Port", 0 );
    t->addSeparationRule( "@text_METAL1 Port", "@text_METAL1 Port", 0 );

    // @text_METAL2
    t->addDimensionRule( "@text_METAL2", 0 );
    t->addSeparationRule( "@text_METAL2", "@text_METAL2", 0 );

    // @text_METAL2 Port
    t->addDimensionRule( "@text_METAL2 Port", 0 );
    t->addSeparationRule( "@text_METAL2 Port", "@text_METAL2 Port", 0 );

    // @text_VDD Power Rail
    t->addDimensionRule( "@text_VDD Power Rail", 0 );
    t->addSeparationRule( "@text_VDD Power Rail", "@text_VDD Power Rail", 0 );

    // @text_VSS Power Rail
    t->addDimensionRule( "@text_VSS Power Rail", 0 );
    t->addSeparationRule( "@text_VSS Power Rail", "@text_VSS Power Rail", 0 );

    // @text_cellName
    t->addDimensionRule( "@text_cellName", 0 );
    t->addSeparationRule( "@text_cellName", "@text_cellName", 0 );

    // BOUNDARY
    t->addDimensionRule( "BOUNDARY", 0 );
    t->addSeparationRule( "BOUNDARY", "BOUNDARY", 0 );

    // CONT
    t->addDimensionRule( "CONT", 0.065 );
    t->addSeparationRule( "CONT", "CONT", 0.075 );
    t->addSeparationRule( "CONT", "POLY", 0.09 );

    // GATE
    t->addDimensionRule( "GATE", 0.05 );
    t->addSeparationRule( "GATE", "CONT", 0.035 );
    t->addSeparationRule( "GATE", "GATE", 0.14 );
    t->addExtensionRule( "GATE", "N-ACT", 0.055 );
    t->addExtensionRule( "GATE", "P-ACT", 0.055 );

    // METAL1
    t->addDimensionRule( "METAL1", 0.065 );
    t->addSeparationRule( "METAL1", "METAL1", 0.065 );
    t->addExtensionRule( "METAL1", "CONT", 0 );
    t->addExtensionRule( "METAL1", "PCONT", 0 );
    t->addExtensionRule( "METAL1", "VIA1", 0 );
    t->addAsymmetricalExtensionRule( "METAL1", "CONT", 0.035 );
    t->addAsymmetricalExtensionRule( "METAL1", "PCONT", 0.035 );
    t->addAsymmetricalExtensionRule( "METAL1", "VIA1", 0.035 );
    t->addAreaRule( "METAL1", 0.00875 );

    // METAL2
    t->addDimensionRule( "METAL2", 0.07 );
    t->addSeparationRule( "METAL2", "METAL2", 0.07 );
    t->addExtensionRule( "METAL2", "VGHOST", 0 );
    t->addExtensionRule( "METAL2", "VIA1", 0 );
    t->addExtensionRule( "METAL2", "VIA2", 0.0025 );
    t->addAsymmetricalExtensionRule( "METAL2", "VIA1", 0.035 );
    t->addAreaRule( "METAL2", 0.01 );

    // METAL3
    t->addDimensionRule( "METAL3", 0.07 );
    t->addSeparationRule( "METAL3", "METAL3", 0.07 );
    t->addExtensionRule( "METAL3", "VIA2", 0.0025 );
    t->addAreaRule( "METAL3", 0.01 );

    // N-ACT
    t->addDimensionRule( "N-ACT", 0.09 );
    t->addSeparationRule( "N-ACT", "GATE", 0.05 );
    t->addSeparationRule( "N-ACT", "N-ACT", 0.08 );
    t->addSeparationRule( "N-ACT", "N-STRAP", 0.35 );
    t->addSeparationRule( "N-ACT", "P-IMPLANT", 0.12 );
    t->addSeparationRule( "N-ACT", "PCONT", 0.07 );
    t->addSeparationRule( "N-ACT", "POLY", 0.05 );
    t->addExtensionRule( "N-ACT", "CONT", 0.005 );
    t->addExtensionRule( "N-ACT", "GATE", 0.07 );
    t->addAreaRule( "N-ACT", 0.008125 );

    // N-IMPLANT
    t->addDimensionRule( "N-IMPLANT", 0 );
    t->addSeparationRule( "N-IMPLANT", "N-IMPLANT", 0 );
    t->addSeparationRule( "N-IMPLANT", "P-STRAP", 0 );
    t->addExtensionRule( "N-IMPLANT", "GATE", 0 );
    t->addExtensionRule( "N-IMPLANT", "N-ACT", 0 );
    t->addExtensionRule( "N-IMPLANT", "N-STRAP", 0 );
    t->addAreaRule( "N-IMPLANT", 0.0025 );

    // N-STRAP
    t->addDimensionRule( "N-STRAP", 0.09 );
    t->addSeparationRule( "N-STRAP", "GATE", 0.05 );
    t->addSeparationRule( "N-STRAP", "N-STRAP", 0.08 );
    rule = t->addSeparationRule( "N-STRAP", "P-ACT", 0.08 );
    rule->addCondition( "spannedEdgeToEdge", "vertical", 0.01); 
    t->addSeparationRule( "N-STRAP", "P-STRAP", 0.46 );
    t->addSeparationRule( "N-STRAP", "PCONT", 0.07 );
    t->addSeparationRule( "N-STRAP", "POLY", 0.05 );
    t->addExtensionRule( "N-STRAP", "CONT", 0.005 );
    t->addAreaRule( "N-STRAP", 0.008125 );

    // N-WELL
    t->addDimensionRule( "N-WELL", 0.2 );
    t->addSeparationRule( "N-WELL", "N-ACT", 0.055 );
    t->addSeparationRule( "N-WELL", "N-IMPLANT", 0 );
    t->addSeparationRule( "N-WELL", "N-WELL", 0.135 );
    t->addSeparationRule( "N-WELL", "P-STRAP", 0.19 );
    t->addSeparationRule( "N-WELL", "P-WELL", 0 );
    t->addExtensionRule( "N-WELL", "N-STRAP", 0.055 );
    t->addExtensionRule( "N-WELL", "P-ACT", 0.055 );
    t->addAreaRule( "N-WELL", 0.04 );

    // P-ACT
    t->addDimensionRule( "P-ACT", 0.09 );
    t->addSeparationRule( "P-ACT", "GATE", 0.05 );
    t->addSeparationRule( "P-ACT", "N-ACT", 0.24 );
    t->addSeparationRule( "P-ACT", "N-IMPLANT", 0 );
    t->addSeparationRule( "P-ACT", "P-ACT", 0.08 );
    t->addSeparationRule( "P-ACT", "P-STRAP", 0.35 );
    t->addSeparationRule( "P-ACT", "PCONT", 0.07 );
    t->addSeparationRule( "P-ACT", "POLY", 0.05 );
    t->addExtensionRule( "P-ACT", "CONT", 0.005 );
    t->addExtensionRule( "P-ACT", "GATE", 0.07 );
    t->addAreaRule( "P-ACT", 0.008125 );

    // P-IMPLANT
    t->addDimensionRule( "P-IMPLANT", 0.045 );
    t->addSeparationRule( "P-IMPLANT", "N-IMPLANT", 0 );
    t->addSeparationRule( "P-IMPLANT", "N-STRAP", 0 );
    t->addSeparationRule( "P-IMPLANT", "P-IMPLANT", 0.045 );
    t->addExtensionRule( "P-IMPLANT", "GATE", 0.08 );
    t->addExtensionRule( "P-IMPLANT", "P-ACT", 0.01 );
    t->addExtensionRule( "P-IMPLANT", "P-STRAP", 0 );
    t->addAreaRule( "P-IMPLANT", 0.0025 );

    // P-STRAP
    t->addDimensionRule( "P-STRAP", 0.09 );
    t->addSeparationRule( "P-STRAP", "GATE", 0.05 );
    rule = t->addSeparationRule( "P-STRAP", "N-ACT", 0.08 );
    rule->addCondition( "spannedEdgeToEdge", "vertical", 0.01); 
    t->addSeparationRule( "P-STRAP", "P-STRAP", 0.08 );
    t->addSeparationRule( "P-STRAP", "PCONT", 0.07 );
    t->addSeparationRule( "P-STRAP", "POLY", 0.05 );
    t->addExtensionRule( "P-STRAP", "CONT", 0.005 );
    t->addAreaRule( "P-STRAP", 0.008125 );

    // P-WELL
    t->addDimensionRule( "P-WELL", 0.2 );
    t->addSeparationRule( "P-WELL", "N-STRAP", 0.19 );
    t->addSeparationRule( "P-WELL", "P-ACT", 0.055 );
    t->addSeparationRule( "P-WELL", "P-IMPLANT", 0 );
    t->addSeparationRule( "P-WELL", "P-WELL", 0.135 );
    t->addExtensionRule( "P-WELL", "N-ACT", 0.055 );
    t->addExtensionRule( "P-WELL", "P-STRAP", 0.055 );
    t->addAreaRule( "P-WELL", 0.04 );

    // PCONT
    t->addDimensionRule( "PCONT", 0.065 );
    t->addSeparationRule( "PCONT", "PCONT", 0.075 );
    t->addSeparationRule( "PCONT", "POLY", 0.09 );

    // POLY
    t->addDimensionRule( "POLY", 0.05 );
    t->addSeparationRule( "POLY", "GATE", 0.075 );
    t->addSeparationRule( "POLY", "POLY", 0.075 );
    t->addExtensionRule( "POLY", "N-ACT", 0.055 );
    t->addExtensionRule( "POLY", "P-ACT", 0.055 );
    t->addExtensionRule( "POLY", "PCONT", 0.005 );
    t->addAreaRule( "POLY", 0.0025 );

    // VGHOST
    t->addDimensionRule( "VGHOST", 0.075 );
    t->addSeparationRule( "VGHOST", "VGHOST", 0.075 );

    // VIA1
    t->addDimensionRule( "VIA1", 0.065 );
    t->addSeparationRule( "VIA1", "VIA1", 0.075 );

    // VIA2
    t->addDimensionRule( "VIA2", 0.07 );
    t->addSeparationRule( "VIA2", "VIA2", 0.085 );

    // Connectivity
    t->addConnectivityRule( "@text_VDD Power Rail", "METAL1" );
    t->addConnectivityRule( "@text_VSS Power Rail", "METAL1" );
    t->addConnectivityRule( "CONT", "METAL1" );
    t->addConnectivityRule( "CONT", "N-ACT" );
    t->addConnectivityRule( "CONT", "N-STRAP" );
    t->addConnectivityRule( "CONT", "P-ACT" );
    t->addConnectivityRule( "CONT", "P-STRAP" );
    t->addConnectivityRule( "N-ACT", "P-STRAP" );
    t->addConnectivityRule( "P-ACT", "N-STRAP" );
    t->addConnectivityRule( "PCONT", "METAL1" );
    t->addConnectivityRule( "PCONT", "POLY" );
    t->addConnectivityRule( "POLY", "GATE" );
    t->addConnectivityRule( "VIA1", "METAL1" );
    t->addConnectivityRule( "VIA1", "METAL2" );
    t->addConnectivityRule( "VIA2", "METAL2" );
    t->addConnectivityRule( "VIA2", "METAL3" );

    // Avoidance
    t->addAvoidanceRule( "CONT", "GATE" );
    t->addAvoidanceRule( "GATE", "N-ACT" );
    t->addAvoidanceRule( "GATE", "N-STRAP" );
    t->addAvoidanceRule( "GATE", "P-ACT" );
    t->addAvoidanceRule( "GATE", "P-STRAP" );
    t->addAvoidanceRule( "N-STRAP", "P-ACT" );
    t->addAvoidanceRule( "N-WELL", "N-ACT" );
    t->addAvoidanceRule( "N-WELL", "P-STRAP" );
    t->addAvoidanceRule( "P-ACT", "N-ACT" );
    t->addAvoidanceRule( "P-IMPLANT", "N-IMPLANT" );
    t->addAvoidanceRule( "P-STRAP", "N-ACT" );
    t->addAvoidanceRule( "P-STRAP", "N-STRAP" );
    t->addAvoidanceRule( "P-WELL", "N-STRAP" );
    t->addAvoidanceRule( "P-WELL", "P-ACT" );
    t->addAvoidanceRule( "POLY", "CONT" );
    t->addAvoidanceRule( "POLY", "N-ACT" );
    t->addAvoidanceRule( "POLY", "N-STRAP" );
    t->addAvoidanceRule( "POLY", "P-ACT" );
    t->addAvoidanceRule( "POLY", "P-STRAP" );

    // NetAvoidance

    // NetSeparation
    t->addNetSeparationRule( "N-ACT", "P-STRAP", 0.08 );
    t->addNetSeparationRule( "P-ACT", "N-STRAP", 0.08 );
    t->addNetSeparationRule( "POLY", "GATE", 0 );

    // Rules related to builtin layers

    // Routable Layers
    t->getLayer( "GATE" )->makeRoutable();
    t->getLayer( "METAL1" )->makeRoutable();
    t->getLayer( "METAL2" )->makeRoutable();
    t->getLayer( "METAL3" )->makeRoutable();
    t->getLayer( "N-ACT" )->makeRoutable();
    t->getLayer( "N-STRAP" )->makeRoutable();
    t->getLayer( "P-ACT" )->makeRoutable();
    t->getLayer( "P-STRAP" )->makeRoutable();
    t->getLayer( "POLY" )->makeRoutable();

    // Set Boundary Distance Rules
    t->getLayer( "P-IMPLANT" )->setBoundaryDistances( 0, 0, 0, 0 );

    // Define colors for layers
    t->getLayer( "@text_METAL1 Port" )->setFillColor( 0, 0, 0);
    t->getLayer( "@text_METAL1 Port" )->setOutlineColor( 140, 195, 255);
    t->getLayer( "@text_METAL2" )->setFillColor( 0, 0, 0);
    t->getLayer( "@text_METAL2" )->setOutlineColor( 140, 195, 255);
    t->getLayer( "@text_METAL2 Port" )->setFillColor( 0, 0, 0);
    t->getLayer( "@text_METAL2 Port" )->setOutlineColor( 255, 0, 184);
    t->getLayer( "@text_VDD Power Rail" )->setFillColor( 0, 0, 0);
    t->getLayer( "@text_VDD Power Rail" )->setOutlineColor( 140, 195, 255);
    t->getLayer( "@text_VSS Power Rail" )->setFillColor( 0, 0, 0);
    t->getLayer( "@text_VSS Power Rail" )->setOutlineColor( 140, 195, 255);
    t->getLayer( "@text_cellName" )->setFillColor( 0, 0, 0);
    t->getLayer( "@text_cellName" )->setOutlineColor( 255, 0, 0);
    t->getLayer( "BOUNDARY" )->setFillColor( 0, 0, 0);
    t->getLayer( "BOUNDARY" )->setOutlineColor( 200, 0, 0);
    t->getLayer( "CONT" )->setFillColor( 0, 0, 0);
    t->getLayer( "GATE" )->setFillColor( 200, 0, 0);
    t->getLayer( "METAL1" )->setFillColor( 108, 150, 210);
    t->getLayer( "METAL2" )->setFillColor( 200, 0, 142);
    t->getLayer( "METAL3" )->setFillColor( 0, 200, 200);
    t->getLayer( "N-ACT" )->setFillColor( 0, 255, 0);
    t->getLayer( "N-IMPLANT" )->setFillColor( 0, 255, 0);
    t->getLayer( "N-STRAP" )->setFillColor( 0, 255, 0);
    t->getLayer( "N-WELL" )->setFillColor( 0, 0, 0);
    t->getLayer( "N-WELL" )->setOutlineColor( 0, 200, 200);
    t->getLayer( "P-ACT" )->setFillColor( 255, 255, 0);
    t->getLayer( "P-IMPLANT" )->setFillColor( 255, 255, 0);
    t->getLayer( "P-STRAP" )->setFillColor( 255, 255, 0);
    t->getLayer( "P-WELL" )->setFillColor( 0, 0, 0);
    t->getLayer( "P-WELL" )->setOutlineColor( 255, 128, 0);
    t->getLayer( "PCONT" )->setFillColor( 0, 0, 0);
    t->getLayer( "POLY" )->setFillColor( 200, 0, 0);
    t->getLayer( "VGHOST" )->setFillColor( 200, 200, 200);
    t->getLayer( "VIA1" )->setFillColor( 200, 200, 200);
    t->getLayer( "VIA2" )->setFillColor( 200, 200, 200);

    // Define stipples for layers
    t->getLayer( "@text_METAL1 Port" )->stipple = "";
    t->getLayer( "@text_METAL2" )->stipple = "";
    t->getLayer( "@text_METAL2 Port" )->stipple = "";
    t->getLayer( "@text_VDD Power Rail" )->stipple = "";
    t->getLayer( "@text_VSS Power Rail" )->stipple = "";
    t->getLayer( "@text_cellName" )->stipple = "";
    t->getLayer( "BOUNDARY" )->stipple = "";
    t->getLayer( "CONT" )->stipple = "solid";
    t->getLayer( "GATE" )->stipple = "reallyneardots2";
    t->getLayer( "METAL1" )->stipple = "reallyneardots";
    t->getLayer( "METAL2" )->stipple = "slash";
    t->getLayer( "METAL3" )->stipple = "slash2";
    t->getLayer( "N-ACT" )->stipple = "reallyneardots2";
    t->getLayer( "N-IMPLANT" )->stipple = "fardots2";
    t->getLayer( "N-STRAP" )->stipple = "reallyneardots2";
    t->getLayer( "N-WELL" )->stipple = "";
    t->getLayer( "P-ACT" )->stipple = "reallyneardots2";
    t->getLayer( "P-IMPLANT" )->stipple = "fardots2";
    t->getLayer( "P-STRAP" )->stipple = "reallyneardots2";
    t->getLayer( "P-WELL" )->stipple = "";
    t->getLayer( "PCONT" )->stipple = "solid";
    t->getLayer( "POLY" )->stipple = "reallyneardots2";
    t->getLayer( "VGHOST" )->stipple = "dot1";
    t->getLayer( "VIA1" )->stipple = "nearvstripe";
    t->getLayer( "VIA2" )->stipple = "nearhstripe";

    // Set Drawing Order
    t->raiseLayers( "@annotate", "@error", "@group", "@gateAlign", "@compaction", "N-WELL", "P-WELL", "N-IMPLANT", "P-IMPLANT", "N-ACT", "P-ACT", "N-STRAP", "P-STRAP", "POLY", "GATE", "CONT", "PCONT", "METAL1", "VIA1", "METAL2", "BOUNDARY", "VGHOST", "VIA2", "METAL3", "@text_cellName", "@text_VDD Power Rail", "@text_VSS Power Rail", "@text_METAL1 Port", "@text_METAL2", "@text_METAL2 Port" );

    t->verify();

    t;
}
