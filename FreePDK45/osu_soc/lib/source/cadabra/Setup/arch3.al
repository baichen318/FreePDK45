{

/* BEGIN DECLARE */
// Creating the PhysicalSpec
auto p = makePhysicalSpec( loadFromPath( "fpdk45nm3.al", 0, "setup" ) );
auto tech = p->technology;
tech->checkSignature( 1713256885 );
auto template;
auto deviceDB = loadFromPath( "modularDeviceDB.al", 0, "devices" )( p->deviceDB );
auto designStepDB = p->designStepDB;
auto callbackDB = p->callbackDB;
auto exporterDB = p->exporterDB;
auto layoutStyleDB = p->layoutStyleDB;
auto defaultsDB = p->defaultsDB;
/* END */

/* BEGIN PROPERTIES */
// Set the IOGrid property
p->ioGrid = list( 0.19, 0.19, 0, 0 );
auto ioGridX = p->ioGrid->at(0);
auto ioGridY = p->ioGrid->at(1);
auto ioGridDX = p->ioGrid->at(2);
auto ioGridDY = p->ioGrid->at(3);
p->maxPMosWidth = 1.03;
p->maxNMosWidth = 0.885;
// Default maximum merging distance during placement
p->placementMaxMergingDistance = 1.06;
p->makeProp( "railWidth" );
p->railWidth = 0.13;
p->makeProp( "targetHeight" );
p->targetHeight = 2.47;
p->makeProp( "wellBottom" );
p->wellBottom = 1.235;
p->makeProp( "maxPMosDrawnWidth" );
p->maxPMosDrawnWidth = 1.03;
p->makeProp( "pMosBottom" );
p->pMosBottom = 1.29;
p->makeProp( "maxNMosDrawnWidth" );
p->maxNMosDrawnWidth = 0.885;
p->makeProp( "nMosTop" );
p->nMosTop = 1.05;

/* END */


//************ REGISTERING DEVICE TEMPLATES ************
/* BEGIN DEVICE Boundary */
template = loadFromPath( "boundary.al", 0, "devices" )( deviceDB );
template->targetHeight = 2.47;
template->layer = "BOUNDARY";
template->leftEdge = 0;
template->bottomEdge = 0;
template->fixedHeight = 1;
template->canAddInteractively = 0;
template->canDeleteInteractively = 0;
template->keepGeometry = 1;
template->setCellOversize( 0.000625, 0.000625 );
/* OTHER TEMPLATE PROPERTIES */
// template->autoReshape;
// template->fixedWidth;
// template->geomDependsOnBoundary;
// template->hasAbsoluteXLocation;
// template->hasAbsoluteYLocation;
// template->hasImplicitConnections;
// template->isAbstract;
// template->isInBackground;
// template->registrationOperations;
// template->targetWidth;
// template->useForBoundaryCalc;
/* BEGIN CUSTOM SETUP */
/* END CUSTOM SETUP DEVICE Boundary */
deviceDB->registerTemplate( template, "Boundary" );
/* END */

/* BEGIN DEVICE pMosfet */
template = loadFromPath( "mosfet.al", 0, "devices" )( deviceDB, "p" );
template->implantLayer = "P-IMPLANT";
template->implantAlignedExtension = 0.01;
template->implantPerpendicularExtension = 0.01;
template->diffusionLayer = "P-ACT";
template->gateLayer = "GATE";
template->endCapLayer = "POLY";
template->percentWidthTolerance = 0;
template->minMosfetWidth = 0.09;
/* OTHER TEMPLATE PROPERTIES */
// template->autoReshape;
// template->canAddInteractively;
// template->canDeleteInteractively;
// template->constrainEndCap;
// template->defaultBendAngle;
// template->gateBendSpacing;
// template->gateConnectionWire;
// template->geomDependsOnBoundary;
// template->hasAbsoluteXLocation;
// template->hasAbsoluteYLocation;
// template->hasImplicitConnections;
// template->isAbstract;
// template->isInBackground;
// template->percentLengthTolerance;
// template->registrationOperations;
// template->useDefaultWireWidth;
// template->useForBoundaryCalc;
// template->widthTolerance;
// template->defaultConfigurationName;
// template->changeConfigurationShapes;
// template->configurationName;
// template->previousConfigurationName;
// template->unlockShapes;
// template->implantPolicy;
// template->hammerHeadLayer;
// template->hammerWidth;
// template->hammerLength;
// template->hammerWidthAligned;
// template->hammerLengthAligned;
// template->hammerWidthPerpendicular;
// template->hammerLengthPerpendicular;
// template->hammerMinGateLengthNoToggle;
// template->hammerWidthPerpendicularForced;
// template->hammerDrawnSize;
// template->hammerOrientation;
// template->minOverlap;
// template->maxOverlap;
// template->keepHammerHeads;
/* BEGIN CUSTOM SETUP */
/* END CUSTOM SETUP DEVICE pMosfet */
deviceDB->registerTemplate( template, "pMosfet" );
/* END */

/* BEGIN DEVICE nMosfet */
template = loadFromPath( "mosfet.al", 0, "devices" )( deviceDB, "n" );
template->implantLayer = "N-IMPLANT";
template->implantAlignedExtension = 0.01;
template->implantPerpendicularExtension = 0.01;
template->diffusionLayer = "N-ACT";
template->gateLayer = "GATE";
template->endCapLayer = "POLY";
template->percentWidthTolerance = 0;
template->minMosfetWidth = 0.09;
/* OTHER TEMPLATE PROPERTIES */
// template->autoReshape;
// template->canAddInteractively;
// template->canDeleteInteractively;
// template->constrainEndCap;
// template->defaultBendAngle;
// template->endCapLayer;
// template->gateBendSpacing;
// template->gateConnectionWire;
// template->geomDependsOnBoundary;
// template->hasAbsoluteXLocation;
// template->hasAbsoluteYLocation;
// template->hasImplicitConnections;
// template->isAbstract;
// template->isInBackground;
// template->minMosfetWidth;
// template->percentLengthTolerance;
// template->percentWidthTolerance;
// template->registrationOperations;
// template->useDefaultWireWidth;
// template->useForBoundaryCalc;
// template->widthTolerance;
// template->defaultConfigurationName;
// template->changeConfigurationShapes;
// template->configurationName;
// template->previousConfigurationName;
// template->unlockShapes;
// template->implantLayer;
// template->implantAlignedExtension;
// template->implantPerpendicularExtension;
// template->implantPolicy;
// template->hammerHeadLayer;
// template->hammerWidth;
// template->hammerLength;
// template->hammerWidthAligned;
// template->hammerLengthAligned;
// template->hammerWidthPerpendicular;
// template->hammerLengthPerpendicular;
// template->hammerMinGateLengthNoToggle;
// template->hammerWidthPerpendicularForced;
// template->hammerDrawnSize;
// template->hammerOrientation;
// template->minOverlap;
// template->maxOverlap;
// template->keepHammerHeads;
/* BEGIN CUSTOM SETUP */
/* END CUSTOM SETUP DEVICE nMosfet */
deviceDB->registerTemplate( template, "nMosfet" );
/* END */

/* BEGIN DEVICE N-Well */
template = loadFromPath( "well.al", 0, "devices" )( deviceDB );
template->layer = "N-WELL";
template->complementaryLayer = "P-WELL";
template->topOverhang = 0.1;
template->bottomOverhang = 0.1;
template->sideOverhang = 0.1;
template->wellBottom = 1.235;
template->keepComplementaryLayer = 1;
template->joggable = 1;
/* OTHER TEMPLATE PROPERTIES */
// template->autoReshape;
// template->canAddInteractively;
// template->canDeleteInteractively;
// template->geomDependsOnBoundary;
// template->hasAbsoluteXLocation;
// template->hasAbsoluteYLocation;
// template->hasImplicitConnections;
// template->isAbstract;
// template->isInBackground;
// template->registrationOperations;
// template->useForBoundaryCalc;
// template->defaultConfigurationName;
// template->changeConfigurationShapes;
// template->configurationName;
// template->previousConfigurationName;
// template->unlockShapes;
// template->drawnWellBottom;
// template->wellSeparation;
// template->containedLayerNames;
// template->excludedLayerNames;
// template->leftOverhang;
// template->rightOverhang;
// template->topOverlap;
// template->bottomOverlap;
// template->sideOverlap;
// template->leftOverlap;
// template->rightOverlap;
// template->hideComplementaryLayer;
/* BEGIN CUSTOM SETUP */
/* END CUSTOM SETUP DEVICE N-Well */
deviceDB->registerTemplate( template, "N-Well" );
/* END */

/* BEGIN DEVICE VDD Power Rail */
template = loadFromPath( "rail.al", 0, "devices" )( deviceDB );
template->layer = "METAL1";
template->width = 0.13;
template->reference = "t";
template->offset = -0.065;
template->overhang = 0;
/* OTHER TEMPLATE PROPERTIES */
// template->autoReshape;
// template->canAddInteractively;
// template->canDeleteInteractively;
// template->geomDependsOnBoundary;
// template->hasAbsoluteXLocation;
// template->hasAbsoluteYLocation;
// template->hasImplicitConnections;
// template->isAbstract;
// template->isInBackground;
// template->registrationOperations;
// template->useForBoundaryCalc;
// template->defaultConfigurationName;
// template->changeConfigurationShapes;
// template->configurationName;
// template->previousConfigurationName;
// template->unlockShapes;
// template->encloseContactsObjective;
// template->keep;
/* BEGIN CUSTOM SETUP */
/* END CUSTOM SETUP DEVICE VDD Power Rail */
deviceDB->registerTemplate( template, "VDD Power Rail" );
/* END */

/* BEGIN DEVICE VSS Power Rail */
template = loadFromPath( "rail.al", 0, "devices" )( deviceDB );
template->layer = "METAL1";
template->width = 0.13;
template->reference = "b";
template->offset = -0.065;
template->overhang = 0;
/* OTHER TEMPLATE PROPERTIES */
// template->autoReshape;
// template->canAddInteractively;
// template->canDeleteInteractively;
// template->geomDependsOnBoundary;
// template->hasAbsoluteXLocation;
// template->hasAbsoluteYLocation;
// template->hasImplicitConnections;
// template->isAbstract;
// template->isInBackground;
// template->layer;
// template->offset;
// template->overhang;
// template->reference;
// template->registrationOperations;
// template->useForBoundaryCalc;
// template->width;
// template->defaultConfigurationName;
// template->changeConfigurationShapes;
// template->configurationName;
// template->previousConfigurationName;
// template->unlockShapes;
// template->encloseContactsObjective;
// template->keep;
/* BEGIN CUSTOM SETUP */
/* END CUSTOM SETUP DEVICE VSS Power Rail */
deviceDB->registerTemplate( template, "VSS Power Rail" );
/* END */

/* BEGIN DEVICE P-ACT Wire */
template = loadFromPath( "wire.al", 0, "devices" )( deviceDB );
template->layer = "P-ACT";
template->minWireWidth = 0.09;
template->width = 0.09;
template->preferredMinWireWidth = 0.09;
template->maxWireWidth = INFINITY;
template->snapUnconditionally = 0;
/* OTHER TEMPLATE PROPERTIES */
// template->allow45;
// template->autoReshape;
// template->canAddInteractively;
// template->canDeleteInteractively;
// template->geomDependsOnBoundary;
// template->hasAbsoluteXLocation;
// template->hasAbsoluteYLocation;
// template->hasImplicitConnections;
// template->isAbstract;
// template->isInBackground;
// template->registrationOperations;
// template->useForBoundaryCalc;
// template->growUnconditionally;
// template->growIfBetweenLongGates;
// template->preferredMinWireWidthPriority;
// template->growWidthObjectiveName;
// template->minLengthObjectiveName;
// template->minWidthObjectiveName;
// template->horizontalLayerCost;
// template->verticalLayerCost;
// template->drawingPolicy;
// template->overSizeByEpsilon;
// template->migrationScalingFactor;
/* BEGIN CUSTOM SETUP */
/* END CUSTOM SETUP DEVICE P-ACT Wire */
deviceDB->registerTemplate( template, "P-ACT Wire" );
/* END */

/* BEGIN DEVICE N-ACT Wire */
template = loadFromPath( "wire.al", 0, "devices" )( deviceDB );
template->layer = "N-ACT";
template->minWireWidth = 0.09;
template->width = 0.09;
template->preferredMinWireWidth = 0.09;
template->maxWireWidth = 0.09;
template->snapUnconditionally = 0;
/* OTHER TEMPLATE PROPERTIES */
// template->allow45;
// template->autoReshape;
// template->canAddInteractively;
// template->canDeleteInteractively;
// template->geomDependsOnBoundary;
// template->hasAbsoluteXLocation;
// template->hasAbsoluteYLocation;
// template->hasImplicitConnections;
// template->isAbstract;
// template->isInBackground;
// template->layer;
// template->registrationOperations;
// template->useForBoundaryCalc;
// template->width;
// template->growUnconditionally;
// template->growIfBetweenLongGates;
// template->snapUnconditionally;
// template->maxWireWidth;
// template->minWireWidth;
// template->preferredMinWireWidth;
// template->preferredMinWireWidthPriority;
// template->growWidthObjectiveName;
// template->minLengthObjectiveName;
// template->minWidthObjectiveName;
// template->horizontalLayerCost;
// template->verticalLayerCost;
// template->drawingPolicy;
// template->overSizeByEpsilon;
// template->migrationScalingFactor;
/* BEGIN CUSTOM SETUP */
/* END CUSTOM SETUP DEVICE N-ACT Wire */
deviceDB->registerTemplate( template, "N-ACT Wire" );
/* END */

/* BEGIN DEVICE POLY Wire */
template = loadFromPath( "wire.al", 0, "devices" )( deviceDB );
template->layer = "POLY";
template->minWireWidth = 0.05;
template->width = 0.05;
template->preferredMinWireWidth = 0.05;
template->maxWireWidth = 0.05;
template->snapUnconditionally = 0;
/* OTHER TEMPLATE PROPERTIES */
// template->allow45;
// template->autoReshape;
// template->canAddInteractively;
// template->canDeleteInteractively;
// template->geomDependsOnBoundary;
// template->hasAbsoluteXLocation;
// template->hasAbsoluteYLocation;
// template->hasImplicitConnections;
// template->isAbstract;
// template->isInBackground;
// template->layer;
// template->registrationOperations;
// template->useForBoundaryCalc;
// template->width;
// template->growUnconditionally;
// template->growIfBetweenLongGates;
// template->snapUnconditionally;
// template->maxWireWidth;
// template->minWireWidth;
// template->preferredMinWireWidth;
// template->preferredMinWireWidthPriority;
// template->growWidthObjectiveName;
// template->minLengthObjectiveName;
// template->minWidthObjectiveName;
// template->horizontalLayerCost;
// template->verticalLayerCost;
// template->drawingPolicy;
// template->overSizeByEpsilon;
// template->migrationScalingFactor;
/* BEGIN CUSTOM SETUP */
/* END CUSTOM SETUP DEVICE POLY Wire */
deviceDB->registerTemplate( template, "POLY Wire" );
/* END */

/* BEGIN DEVICE METAL1 Wire */
template = loadFromPath( "wire.al", 0, "devices" )( deviceDB );
template->layer = "METAL1";
template->minWireWidth = 0.065;
template->width = 0.065;
template->preferredMinWireWidth = 0.065;
template->maxWireWidth = 0.065;
template->snapUnconditionally = 0;
/* OTHER TEMPLATE PROPERTIES */
// template->allow45;
// template->autoReshape;
// template->canAddInteractively;
// template->canDeleteInteractively;
// template->geomDependsOnBoundary;
// template->hasAbsoluteXLocation;
// template->hasAbsoluteYLocation;
// template->hasImplicitConnections;
// template->isAbstract;
// template->isInBackground;
// template->layer;
// template->registrationOperations;
// template->useForBoundaryCalc;
// template->width;
// template->growUnconditionally;
// template->growIfBetweenLongGates;
// template->snapUnconditionally;
// template->maxWireWidth;
// template->minWireWidth;
// template->preferredMinWireWidth;
// template->preferredMinWireWidthPriority;
// template->growWidthObjectiveName;
// template->minLengthObjectiveName;
// template->minWidthObjectiveName;
// template->horizontalLayerCost;
// template->verticalLayerCost;
// template->drawingPolicy;
// template->overSizeByEpsilon;
// template->migrationScalingFactor;
/* BEGIN CUSTOM SETUP */
/* END CUSTOM SETUP DEVICE METAL1 Wire */
deviceDB->registerTemplate( template, "METAL1 Wire" );
/* END */

/* BEGIN DEVICE P-ACT Contact */
template = loadFromPath( "contact.al", 0, "devices" )( deviceDB );
template->contactLayer = "CONT";
template->layer1 = "P-ACT";
template->layer2 = "METAL1";
template->snapX = 0;
template->snapY = 0;
template->minNumCuts = 1;
template->maxNumCuts = INFINITY;
template->snappedGrowth = 1;
template->growContactObjective = "growContacts";
template->growDirection = "dm";
template->orientCover1Direction = "DEFAULT";
template->orientCover2Direction = "DEFAULT";
template->unlockCompactionCovers = list( "P-ACT", "METAL1" );
template->unlockCovers = list( "P-ACT", "METAL1" );
template->layer1AlignmentTargets = list( "pMosfet" );
template->layer1AlignmentObjective = "@alignMosfetDiffusion";
template->growPolicy = "largestMosfet";
template->growLayer1Objective = "growContactDiffusions";
template->shrinkCoverObjective = "shrinkCovers";
template->orientCoverObjective = "orientCovers";
/* OTHER TEMPLATE PROPERTIES */
// template->autoReshape;
// template->canAddInteractively;
// template->canDeleteInteractively;
// template->geomDependsOnBoundary;
// template->hasAbsoluteXLocation;
// template->hasAbsoluteYLocation;
// template->hasImplicitConnections;
// template->isAbstract;
// template->isInBackground;
// template->registrationOperations;
// template->useForBoundaryCalc;
// template->defaultConfigurationName;
// template->changeConfigurationShapes;
// template->configurationName;
// template->previousConfigurationName;
// template->unlockShapes;
// template->contactDistribution;
// template->drawnSize;
// template->layer2AlignmentObjective;
// template->layer2AlignmentTargets;
// template->jogLayer1AtWires;
// template->jogLayer2AtWires;
// template->keepContact;
// template->keepLayer1;
// template->keepLayer2;
// template->layer1WidenCoverObjective;
// template->layer2WidenCoverObjective;
// template->snappingGrid;
// template->evenDistribution;
/* BEGIN CUSTOM SETUP */
/* END CUSTOM SETUP DEVICE P-ACT Contact */
deviceDB->registerTemplate( template, "P-ACT Contact" );
/* END */

/* BEGIN DEVICE N-ACT Contact */
template = loadFromPath( "contact.al", 0, "devices" )( deviceDB );
template->contactLayer = "CONT";
template->layer1 = "N-ACT";
template->layer2 = "METAL1";
template->snapX = 0;
template->snapY = 0;
template->minNumCuts = 1;
template->maxNumCuts = INFINITY;
template->snappedGrowth = 1;
template->growContactObjective = "growContacts";
template->growDirection = "dm";
template->orientCover1Direction = "DEFAULT";
template->orientCover2Direction = "DEFAULT";
template->unlockCompactionCovers = list( "N-ACT", "METAL1" );
template->unlockCovers = list( "N-ACT", "METAL1" );
template->layer1AlignmentTargets = list( "nMosfet" );
template->layer1AlignmentObjective = "@alignMosfetDiffusion";
template->growPolicy = "largestMosfet";
template->growLayer1Objective = "growContactDiffusions";
template->shrinkCoverObjective = "shrinkCovers";
template->orientCoverObjective = "orientCovers";
/* OTHER TEMPLATE PROPERTIES */
// template->autoReshape;
// template->canAddInteractively;
// template->canDeleteInteractively;
// template->contactLayer;
// template->geomDependsOnBoundary;
// template->growDirection;
// template->hasAbsoluteXLocation;
// template->hasAbsoluteYLocation;
// template->hasImplicitConnections;
// template->isAbstract;
// template->isInBackground;
// template->layer1;
// template->layer2;
// template->maxNumCuts;
// template->minNumCuts;
// template->registrationOperations;
// template->useForBoundaryCalc;
// template->defaultConfigurationName;
// template->changeConfigurationShapes;
// template->configurationName;
// template->previousConfigurationName;
// template->unlockShapes;
// template->contactDistribution;
// template->drawnSize;
// template->growContactObjective;
// template->growLayer1Objective;
// template->growPolicy;
// template->layer1AlignmentObjective;
// template->layer1AlignmentTargets;
// template->layer2AlignmentObjective;
// template->layer2AlignmentTargets;
// template->jogLayer1AtWires;
// template->jogLayer2AtWires;
// template->keepContact;
// template->keepLayer1;
// template->keepLayer2;
// template->layer1WidenCoverObjective;
// template->layer2WidenCoverObjective;
// template->orientCover1Direction;
// template->orientCover2Direction;
// template->orientCoverObjective;
// template->shrinkCoverObjective;
// template->snapX;
// template->snapY;
// template->snappedGrowth;
// template->snappingGrid;
// template->evenDistribution;
// template->unlockCompactionCovers;
// template->unlockCovers;
/* BEGIN CUSTOM SETUP */
/* END CUSTOM SETUP DEVICE N-ACT Contact */
deviceDB->registerTemplate( template, "N-ACT Contact" );
/* END */

/* BEGIN DEVICE POLY Contact */
template = loadFromPath( "contact.al", 0, "devices" )( deviceDB );
template->contactLayer = "PCONT";
template->layer1 = "POLY";
template->layer2 = "METAL1";
template->snapX = 0;
template->snapY = 0;
template->minNumCuts = 1;
template->maxNumCuts = 1;
template->snappedGrowth = 1;
template->growContactObjective = "growPorts";
template->growDirection = "d";
template->orientCover1Direction = "DEFAULT";
template->orientCover2Direction = "DEFAULT";
template->unlockCompactionCovers = list( "POLY", "METAL1" );
template->unlockCovers = list( "POLY", "METAL1" );
template->shrinkCoverObjective = "shrinkCovers";
template->orientCoverObjective = "orientCovers";
/* OTHER TEMPLATE PROPERTIES */
// template->autoReshape;
// template->canAddInteractively;
// template->canDeleteInteractively;
// template->contactLayer;
// template->geomDependsOnBoundary;
// template->growDirection;
// template->hasAbsoluteXLocation;
// template->hasAbsoluteYLocation;
// template->hasImplicitConnections;
// template->isAbstract;
// template->isInBackground;
// template->layer1;
// template->layer2;
// template->maxNumCuts;
// template->minNumCuts;
// template->registrationOperations;
// template->useForBoundaryCalc;
// template->defaultConfigurationName;
// template->changeConfigurationShapes;
// template->configurationName;
// template->previousConfigurationName;
// template->unlockShapes;
// template->contactDistribution;
// template->drawnSize;
// template->growContactObjective;
// template->growLayer1Objective;
// template->growPolicy;
// template->layer1AlignmentObjective;
// template->layer1AlignmentTargets;
// template->layer2AlignmentObjective;
// template->layer2AlignmentTargets;
// template->jogLayer1AtWires;
// template->jogLayer2AtWires;
// template->keepContact;
// template->keepLayer1;
// template->keepLayer2;
// template->layer1WidenCoverObjective;
// template->layer2WidenCoverObjective;
// template->orientCover1Direction;
// template->orientCover2Direction;
// template->orientCoverObjective;
// template->shrinkCoverObjective;
// template->snapX;
// template->snapY;
// template->snappedGrowth;
// template->snappingGrid;
// template->evenDistribution;
// template->unlockCompactionCovers;
// template->unlockCovers;
/* BEGIN CUSTOM SETUP */
/* END CUSTOM SETUP DEVICE POLY Contact */
deviceDB->registerTemplate( template, "POLY Contact" );
/* END */

/* BEGIN DEVICE METAL1 Port */
template = loadFromPath( "port.al", 0, "devices" )( deviceDB );
template->cover1LayerName = "METAL1";
template->keepCover1 = 1;
template->keepContact = 1;
template->keepCover2 = 0;
template->minNumGrids = 1;
template->maxNumGrids = 1;
template->growthObjective = "growPorts";
template->growDirection = "d";
template->orientCover1Direction = "DEFAULT";
template->orientCover2Direction = "DEFAULT";
template->unlockCompactionCovers = list( "METAL1" );
template->unlockCovers = list( "METAL1" );
/* OTHER TEMPLATE PROPERTIES */
// template->autoReshape;
// template->canAddInteractively;
// template->canDeleteInteractively;
// template->geomDependsOnBoundary;
// template->hasAbsoluteXLocation;
// template->hasAbsoluteYLocation;
// template->hasImplicitConnections;
// template->isAbstract;
// template->isInBackground;
// template->registrationOperations;
// template->useForBoundaryCalc;
// template->defaultConfigurationName;
// template->changeConfigurationShapes;
// template->configurationName;
// template->previousConfigurationName;
// template->unlockShapes;
// template->contactDistribution;
// template->contactLayerName;
// template->cover2LayerName;
// template->drawnSize;
// template->importContactSize;
// template->hGhostExtension;
// template->hGhostLayerName;
// template->jogLayer1AtWires;
// template->jogLayer2AtWires;
// template->keepHGhost;
// template->keepVGhost;
// template->markerLayerName;
// template->orientCoverObjective;
// template->shrinkCoverObjective;
// template->snapX;
// template->snapY;
// template->snappingGrid;
// template->vGhostExtension;
// template->vGhostLayerName;
// template->lockingLayerNames;
// template->layer1WidenCoverObjective;
// template->layer2WidenCoverObjective;
// template->evenDistribution;
/* BEGIN CUSTOM SETUP */
/* END CUSTOM SETUP DEVICE METAL1 Port */
deviceDB->registerTemplate( template, "METAL1 Port" );
/* END */

/* BEGIN DEVICE Well Tie Rail */
template = loadFromPath( "tieRail.al", 0, "devices" )( deviceDB );
template->tieLayer = "N-STRAP";
template->width = 0.09;
template->overhang = 0;
template->contactLayer = "CONT";
template->routingLayer = "METAL1";
template->boundaryOrigin = "t";
template->boundaryOffset = -0.045;
template->implantLayerName = "N-IMPLANT";
template->implantOverhang = 0.0225;
/* OTHER TEMPLATE PROPERTIES */
// template->autoReshape;
// template->canAddInteractively;
// template->canDeleteInteractively;
// template->diffusionLayer;
// template->forceAbutment;
// template->geomDependsOnBoundary;
// template->hasAbsoluteXLocation;
// template->hasAbsoluteYLocation;
// template->hasImplicitConnections;
// template->isAbstract;
// template->isInBackground;
// template->registrationOperations;
// template->useForBoundaryCalc;
// template->defaultConfigurationName;
// template->changeConfigurationShapes;
// template->configurationName;
// template->previousConfigurationName;
// template->unlockShapes;
// template->keepContact;
// template->keepRouting;
// template->keepTie;
// template->snapContactsToGrid;
// template->snapContactOffset;
// template->snappingGrid;
/* BEGIN CUSTOM SETUP */
/* END CUSTOM SETUP DEVICE Well Tie Rail */
deviceDB->registerTemplate( template, "Well Tie Rail" );
/* END */

/* BEGIN DEVICE Substrate Tie Rail */
template = loadFromPath( "tieRail.al", 0, "devices" )( deviceDB );
template->tieLayer = "P-STRAP";
template->width = 0.09;
template->overhang = 0;
template->contactLayer = "CONT";
template->routingLayer = "METAL1";
template->boundaryOrigin = "b";
template->boundaryOffset = -0.045;
template->implantLayerName = "P-IMPLANT";
template->implantOverhang = 0.0225;
/* OTHER TEMPLATE PROPERTIES */
// template->autoReshape;
// template->canAddInteractively;
// template->canDeleteInteractively;
// template->contactLayer;
// template->diffusionLayer;
// template->forceAbutment;
// template->geomDependsOnBoundary;
// template->hasAbsoluteXLocation;
// template->hasAbsoluteYLocation;
// template->hasImplicitConnections;
// template->isAbstract;
// template->isInBackground;
// template->registrationOperations;
// template->routingLayer;
// template->tieLayer;
// template->useForBoundaryCalc;
// template->defaultConfigurationName;
// template->changeConfigurationShapes;
// template->configurationName;
// template->previousConfigurationName;
// template->unlockShapes;
// template->boundaryOffset;
// template->boundaryOrigin;
// template->implantLayerName;
// template->implantOverhang;
// template->keepContact;
// template->keepRouting;
// template->keepTie;
// template->overhang;
// template->snapContactsToGrid;
// template->snapContactOffset;
// template->snappingGrid;
// template->width;
/* BEGIN CUSTOM SETUP */
/* END CUSTOM SETUP DEVICE Substrate Tie Rail */
deviceDB->registerTemplate( template, "Substrate Tie Rail" );
/* END */

/* BEGIN DEVICE @MinArea Device on METAL1 */
template = loadFromPath( "minAreaDevice.al", 0, "devices" )( deviceDB );
template->layerName = "METAL1";
template->avoidDevices = list(  );
template->ghostLayerName = "@compaction";
/* OTHER TEMPLATE PROPERTIES */
// template->autoReshape;
// template->canAddInteractively;
// template->canDeleteInteractively;
// template->geomDependsOnBoundary;
// template->hasAbsoluteXLocation;
// template->hasAbsoluteYLocation;
// template->hasImplicitConnections;
// template->isAbstract;
// template->isInBackground;
// template->registrationOperations;
// template->useForBoundaryCalc;
// template->representativeLayerNames;
// template->avoidLayerNames;
// template->preferredDevices;
// template->minArea;
// template->useRectangles;
// template->usePolygons;
// template->rectangleEncouragedDevices;
// template->subtractGateAreas;
// template->shrinkObjective;
// template->keepGeometry;
// template->lDimension;
// template->rDimension;
// template->bDimension;
// template->tDimension;
// template->undersizeAmount;
// template->maxNumTerms;
// template->biasDirection;
// template->mode;
// template->modeLayers;
// template->customConstraints;
// template->maxNumCovers;
/* BEGIN CUSTOM SETUP */
/* END CUSTOM SETUP DEVICE @MinArea Device on METAL1 */
deviceDB->registerTemplate( template, "@MinArea Device on METAL1" );
/* END */

/* BEGIN DEVICE @MinArea Device on METAL2 */
template = loadFromPath( "minAreaDevice.al", 0, "devices" )( deviceDB );
template->layerName = "METAL2";
template->avoidDevices = list(  );
template->ghostLayerName = "@compaction";
/* OTHER TEMPLATE PROPERTIES */
// template->autoReshape;
// template->canAddInteractively;
// template->canDeleteInteractively;
// template->geomDependsOnBoundary;
// template->hasAbsoluteXLocation;
// template->hasAbsoluteYLocation;
// template->hasImplicitConnections;
// template->isAbstract;
// template->isInBackground;
// template->registrationOperations;
// template->useForBoundaryCalc;
// template->layerName;
// template->ghostLayerName;
// template->representativeLayerNames;
// template->avoidLayerNames;
// template->avoidDevices;
// template->preferredDevices;
// template->minArea;
// template->useRectangles;
// template->usePolygons;
// template->rectangleEncouragedDevices;
// template->subtractGateAreas;
// template->shrinkObjective;
// template->keepGeometry;
// template->lDimension;
// template->rDimension;
// template->bDimension;
// template->tDimension;
// template->undersizeAmount;
// template->maxNumTerms;
// template->biasDirection;
// template->mode;
// template->modeLayers;
// template->customConstraints;
// template->maxNumCovers;
/* BEGIN CUSTOM SETUP */
/* END CUSTOM SETUP DEVICE @MinArea Device on METAL2 */
deviceDB->registerTemplate( template, "@MinArea Device on METAL2" );
/* END */

/* BEGIN DEVICE @MinArea Device on METAL3 */
template = loadFromPath( "minAreaDevice.al", 0, "devices" )( deviceDB );
template->layerName = "METAL3";
template->avoidDevices = list(  );
template->ghostLayerName = "@compaction";
/* OTHER TEMPLATE PROPERTIES */
// template->autoReshape;
// template->canAddInteractively;
// template->canDeleteInteractively;
// template->geomDependsOnBoundary;
// template->hasAbsoluteXLocation;
// template->hasAbsoluteYLocation;
// template->hasImplicitConnections;
// template->isAbstract;
// template->isInBackground;
// template->registrationOperations;
// template->useForBoundaryCalc;
// template->layerName;
// template->ghostLayerName;
// template->representativeLayerNames;
// template->avoidLayerNames;
// template->avoidDevices;
// template->preferredDevices;
// template->minArea;
// template->useRectangles;
// template->usePolygons;
// template->rectangleEncouragedDevices;
// template->subtractGateAreas;
// template->shrinkObjective;
// template->keepGeometry;
// template->lDimension;
// template->rDimension;
// template->bDimension;
// template->tDimension;
// template->undersizeAmount;
// template->maxNumTerms;
// template->biasDirection;
// template->mode;
// template->modeLayers;
// template->customConstraints;
// template->maxNumCovers;
/* BEGIN CUSTOM SETUP */
/* END CUSTOM SETUP DEVICE @MinArea Device on METAL3 */
deviceDB->registerTemplate( template, "@MinArea Device on METAL3" );
/* END */

/* BEGIN DEVICE @MinArea Device on N-ACT */
template = loadFromPath( "minAreaDevice.al", 0, "devices" )( deviceDB );
template->layerName = "N-ACT";
template->avoidDevices = list(  );
template->ghostLayerName = "@compaction";
/* OTHER TEMPLATE PROPERTIES */
// template->autoReshape;
// template->canAddInteractively;
// template->canDeleteInteractively;
// template->geomDependsOnBoundary;
// template->hasAbsoluteXLocation;
// template->hasAbsoluteYLocation;
// template->hasImplicitConnections;
// template->isAbstract;
// template->isInBackground;
// template->registrationOperations;
// template->useForBoundaryCalc;
// template->layerName;
// template->ghostLayerName;
// template->representativeLayerNames;
// template->avoidLayerNames;
// template->avoidDevices;
// template->preferredDevices;
// template->minArea;
// template->useRectangles;
// template->usePolygons;
// template->rectangleEncouragedDevices;
// template->subtractGateAreas;
// template->shrinkObjective;
// template->keepGeometry;
// template->lDimension;
// template->rDimension;
// template->bDimension;
// template->tDimension;
// template->undersizeAmount;
// template->maxNumTerms;
// template->biasDirection;
// template->mode;
// template->modeLayers;
// template->customConstraints;
// template->maxNumCovers;
/* BEGIN CUSTOM SETUP */
/* END CUSTOM SETUP DEVICE @MinArea Device on N-ACT */
deviceDB->registerTemplate( template, "@MinArea Device on N-ACT" );
/* END */

/* BEGIN DEVICE @MinArea Device on N-IMPLANT */
template = loadFromPath( "minAreaDevice.al", 0, "devices" )( deviceDB );
template->layerName = "N-IMPLANT";
template->avoidDevices = list(  );
template->ghostLayerName = "@compaction";
/* OTHER TEMPLATE PROPERTIES */
// template->autoReshape;
// template->canAddInteractively;
// template->canDeleteInteractively;
// template->geomDependsOnBoundary;
// template->hasAbsoluteXLocation;
// template->hasAbsoluteYLocation;
// template->hasImplicitConnections;
// template->isAbstract;
// template->isInBackground;
// template->registrationOperations;
// template->useForBoundaryCalc;
// template->layerName;
// template->ghostLayerName;
// template->representativeLayerNames;
// template->avoidLayerNames;
// template->avoidDevices;
// template->preferredDevices;
// template->minArea;
// template->useRectangles;
// template->usePolygons;
// template->rectangleEncouragedDevices;
// template->subtractGateAreas;
// template->shrinkObjective;
// template->keepGeometry;
// template->lDimension;
// template->rDimension;
// template->bDimension;
// template->tDimension;
// template->undersizeAmount;
// template->maxNumTerms;
// template->biasDirection;
// template->mode;
// template->modeLayers;
// template->customConstraints;
// template->maxNumCovers;
/* BEGIN CUSTOM SETUP */
/* END CUSTOM SETUP DEVICE @MinArea Device on N-IMPLANT */
deviceDB->registerTemplate( template, "@MinArea Device on N-IMPLANT" );
/* END */

/* BEGIN DEVICE @MinArea Device on N-STRAP */
template = loadFromPath( "minAreaDevice.al", 0, "devices" )( deviceDB );
template->layerName = "N-STRAP";
template->avoidDevices = list(  );
template->ghostLayerName = "@compaction";
/* OTHER TEMPLATE PROPERTIES */
// template->autoReshape;
// template->canAddInteractively;
// template->canDeleteInteractively;
// template->geomDependsOnBoundary;
// template->hasAbsoluteXLocation;
// template->hasAbsoluteYLocation;
// template->hasImplicitConnections;
// template->isAbstract;
// template->isInBackground;
// template->registrationOperations;
// template->useForBoundaryCalc;
// template->layerName;
// template->ghostLayerName;
// template->representativeLayerNames;
// template->avoidLayerNames;
// template->avoidDevices;
// template->preferredDevices;
// template->minArea;
// template->useRectangles;
// template->usePolygons;
// template->rectangleEncouragedDevices;
// template->subtractGateAreas;
// template->shrinkObjective;
// template->keepGeometry;
// template->lDimension;
// template->rDimension;
// template->bDimension;
// template->tDimension;
// template->undersizeAmount;
// template->maxNumTerms;
// template->biasDirection;
// template->mode;
// template->modeLayers;
// template->customConstraints;
// template->maxNumCovers;
/* BEGIN CUSTOM SETUP */
/* END CUSTOM SETUP DEVICE @MinArea Device on N-STRAP */
deviceDB->registerTemplate( template, "@MinArea Device on N-STRAP" );
/* END */

/* BEGIN DEVICE @MinArea Device on N-WELL */
template = loadFromPath( "minAreaDevice.al", 0, "devices" )( deviceDB );
template->layerName = "N-WELL";
template->avoidDevices = list(  );
template->ghostLayerName = "@compaction";
/* OTHER TEMPLATE PROPERTIES */
// template->autoReshape;
// template->canAddInteractively;
// template->canDeleteInteractively;
// template->geomDependsOnBoundary;
// template->hasAbsoluteXLocation;
// template->hasAbsoluteYLocation;
// template->hasImplicitConnections;
// template->isAbstract;
// template->isInBackground;
// template->registrationOperations;
// template->useForBoundaryCalc;
// template->layerName;
// template->ghostLayerName;
// template->representativeLayerNames;
// template->avoidLayerNames;
// template->avoidDevices;
// template->preferredDevices;
// template->minArea;
// template->useRectangles;
// template->usePolygons;
// template->rectangleEncouragedDevices;
// template->subtractGateAreas;
// template->shrinkObjective;
// template->keepGeometry;
// template->lDimension;
// template->rDimension;
// template->bDimension;
// template->tDimension;
// template->undersizeAmount;
// template->maxNumTerms;
// template->biasDirection;
// template->mode;
// template->modeLayers;
// template->customConstraints;
// template->maxNumCovers;
/* BEGIN CUSTOM SETUP */
/* END CUSTOM SETUP DEVICE @MinArea Device on N-WELL */
deviceDB->registerTemplate( template, "@MinArea Device on N-WELL" );
/* END */

/* BEGIN DEVICE @MinArea Device on P-ACT */
template = loadFromPath( "minAreaDevice.al", 0, "devices" )( deviceDB );
template->layerName = "P-ACT";
template->avoidDevices = list(  );
template->ghostLayerName = "@compaction";
/* OTHER TEMPLATE PROPERTIES */
// template->autoReshape;
// template->canAddInteractively;
// template->canDeleteInteractively;
// template->geomDependsOnBoundary;
// template->hasAbsoluteXLocation;
// template->hasAbsoluteYLocation;
// template->hasImplicitConnections;
// template->isAbstract;
// template->isInBackground;
// template->registrationOperations;
// template->useForBoundaryCalc;
// template->layerName;
// template->ghostLayerName;
// template->representativeLayerNames;
// template->avoidLayerNames;
// template->avoidDevices;
// template->preferredDevices;
// template->minArea;
// template->useRectangles;
// template->usePolygons;
// template->rectangleEncouragedDevices;
// template->subtractGateAreas;
// template->shrinkObjective;
// template->keepGeometry;
// template->lDimension;
// template->rDimension;
// template->bDimension;
// template->tDimension;
// template->undersizeAmount;
// template->maxNumTerms;
// template->biasDirection;
// template->mode;
// template->modeLayers;
// template->customConstraints;
// template->maxNumCovers;
/* BEGIN CUSTOM SETUP */
/* END CUSTOM SETUP DEVICE @MinArea Device on P-ACT */
deviceDB->registerTemplate( template, "@MinArea Device on P-ACT" );
/* END */

/* BEGIN DEVICE @MinArea Device on P-IMPLANT */
template = loadFromPath( "minAreaDevice.al", 0, "devices" )( deviceDB );
template->layerName = "P-IMPLANT";
template->avoidDevices = list(  );
template->ghostLayerName = "@compaction";
/* OTHER TEMPLATE PROPERTIES */
// template->autoReshape;
// template->canAddInteractively;
// template->canDeleteInteractively;
// template->geomDependsOnBoundary;
// template->hasAbsoluteXLocation;
// template->hasAbsoluteYLocation;
// template->hasImplicitConnections;
// template->isAbstract;
// template->isInBackground;
// template->registrationOperations;
// template->useForBoundaryCalc;
// template->layerName;
// template->ghostLayerName;
// template->representativeLayerNames;
// template->avoidLayerNames;
// template->avoidDevices;
// template->preferredDevices;
// template->minArea;
// template->useRectangles;
// template->usePolygons;
// template->rectangleEncouragedDevices;
// template->subtractGateAreas;
// template->shrinkObjective;
// template->keepGeometry;
// template->lDimension;
// template->rDimension;
// template->bDimension;
// template->tDimension;
// template->undersizeAmount;
// template->maxNumTerms;
// template->biasDirection;
// template->mode;
// template->modeLayers;
// template->customConstraints;
// template->maxNumCovers;
/* BEGIN CUSTOM SETUP */
/* END CUSTOM SETUP DEVICE @MinArea Device on P-IMPLANT */
deviceDB->registerTemplate( template, "@MinArea Device on P-IMPLANT" );
/* END */

/* BEGIN DEVICE @MinArea Device on P-STRAP */
template = loadFromPath( "minAreaDevice.al", 0, "devices" )( deviceDB );
template->layerName = "P-STRAP";
template->avoidDevices = list(  );
template->ghostLayerName = "@compaction";
/* OTHER TEMPLATE PROPERTIES */
// template->autoReshape;
// template->canAddInteractively;
// template->canDeleteInteractively;
// template->geomDependsOnBoundary;
// template->hasAbsoluteXLocation;
// template->hasAbsoluteYLocation;
// template->hasImplicitConnections;
// template->isAbstract;
// template->isInBackground;
// template->registrationOperations;
// template->useForBoundaryCalc;
// template->layerName;
// template->ghostLayerName;
// template->representativeLayerNames;
// template->avoidLayerNames;
// template->avoidDevices;
// template->preferredDevices;
// template->minArea;
// template->useRectangles;
// template->usePolygons;
// template->rectangleEncouragedDevices;
// template->subtractGateAreas;
// template->shrinkObjective;
// template->keepGeometry;
// template->lDimension;
// template->rDimension;
// template->bDimension;
// template->tDimension;
// template->undersizeAmount;
// template->maxNumTerms;
// template->biasDirection;
// template->mode;
// template->modeLayers;
// template->customConstraints;
// template->maxNumCovers;
/* BEGIN CUSTOM SETUP */
/* END CUSTOM SETUP DEVICE @MinArea Device on P-STRAP */
deviceDB->registerTemplate( template, "@MinArea Device on P-STRAP" );
/* END */

/* BEGIN DEVICE @MinArea Device on P-WELL */
template = loadFromPath( "minAreaDevice.al", 0, "devices" )( deviceDB );
template->layerName = "P-WELL";
template->avoidDevices = list(  );
template->ghostLayerName = "@compaction";
/* OTHER TEMPLATE PROPERTIES */
// template->autoReshape;
// template->canAddInteractively;
// template->canDeleteInteractively;
// template->geomDependsOnBoundary;
// template->hasAbsoluteXLocation;
// template->hasAbsoluteYLocation;
// template->hasImplicitConnections;
// template->isAbstract;
// template->isInBackground;
// template->registrationOperations;
// template->useForBoundaryCalc;
// template->layerName;
// template->ghostLayerName;
// template->representativeLayerNames;
// template->avoidLayerNames;
// template->avoidDevices;
// template->preferredDevices;
// template->minArea;
// template->useRectangles;
// template->usePolygons;
// template->rectangleEncouragedDevices;
// template->subtractGateAreas;
// template->shrinkObjective;
// template->keepGeometry;
// template->lDimension;
// template->rDimension;
// template->bDimension;
// template->tDimension;
// template->undersizeAmount;
// template->maxNumTerms;
// template->biasDirection;
// template->mode;
// template->modeLayers;
// template->customConstraints;
// template->maxNumCovers;
/* BEGIN CUSTOM SETUP */
/* END CUSTOM SETUP DEVICE @MinArea Device on P-WELL */
deviceDB->registerTemplate( template, "@MinArea Device on P-WELL" );
/* END */

/* BEGIN DEVICE @MinArea Device on POLY */
template = loadFromPath( "minAreaDevice.al", 0, "devices" )( deviceDB );
template->layerName = "POLY";
template->representativeLayerNames = list( "GATE" );
template->avoidDevices = list(  );
template->ghostLayerName = "@compaction";
/* OTHER TEMPLATE PROPERTIES */
// template->autoReshape;
// template->canAddInteractively;
// template->canDeleteInteractively;
// template->geomDependsOnBoundary;
// template->hasAbsoluteXLocation;
// template->hasAbsoluteYLocation;
// template->hasImplicitConnections;
// template->isAbstract;
// template->isInBackground;
// template->registrationOperations;
// template->useForBoundaryCalc;
// template->layerName;
// template->ghostLayerName;
// template->representativeLayerNames;
// template->avoidLayerNames;
// template->avoidDevices;
// template->preferredDevices;
// template->minArea;
// template->useRectangles;
// template->usePolygons;
// template->rectangleEncouragedDevices;
// template->subtractGateAreas;
// template->shrinkObjective;
// template->keepGeometry;
// template->lDimension;
// template->rDimension;
// template->bDimension;
// template->tDimension;
// template->undersizeAmount;
// template->maxNumTerms;
// template->biasDirection;
// template->mode;
// template->modeLayers;
// template->customConstraints;
// template->maxNumCovers;
/* BEGIN CUSTOM SETUP */
/* END CUSTOM SETUP DEVICE @MinArea Device on POLY */
deviceDB->registerTemplate( template, "@MinArea Device on POLY" );
/* END */

/* BEGIN DEVICE Gate Aligner */
template = loadFromPath( "gateAligner.al", 0, "devices" )( deviceDB );
/* OTHER TEMPLATE PROPERTIES */
// template->autoReshape;
// template->canAddInteractively;
// template->canDeleteInteractively;
// template->geomDependsOnBoundary;
// template->hasAbsoluteXLocation;
// template->hasAbsoluteYLocation;
// template->hasImplicitConnections;
// template->isAbstract;
// template->isInBackground;
// template->registrationOperations;
// template->useForBoundaryCalc;
// template->layer;
// template->objectiveName;
// template->vObjectiveName;
// template->hide;
// template->multiplier;
// template->crossingGatesConditioning;
// template->protrudingContacts;
// template->gateToBoundaryDistNormal;
// template->gateToBoundaryDistSmall;
// template->gateToBoundaryDistPower;
// template->gateToEndCapDistNormal;
// template->gateToEndCapDistSmall;
// template->gateToGateDistNormal;
// template->gateToGateDistSmall;
// template->gateToGateDistPower;
// template->gateToGateNotchDistNormal;
// template->gateToGateNotchDistSmall;
// template->gateToGateNotchDistPower;
// template->gateToGateDistNoContact;
// template->gateToAcrossChannelGateForShift;
// template->gateToActiveDistInDiffGapStaggeredNormal;
// template->gateToActiveDistInDiffGapStaggeredSmall;
// template->gateToGateDistInDiffGapNormal;
// template->gateToGateDistInDiffGapSmall;
// template->gateToGateDistInDiffGapNormalSmall;
// template->gateToGateAbutmentDist;
// template->gateToBoundaryAbutmentDist;
// template->gateToCloneBoundaryDistMerged;
// template->gateToCloneBoundaryDistUnmerged;
// template->usePolySepToKeepGatesAligned;
/* BEGIN CUSTOM SETUP */
/* END CUSTOM SETUP DEVICE Gate Aligner */
deviceDB->registerTemplate( template, "Gate Aligner" );
/* END */

/* BEGIN DEVICE I and H Control */
template = loadFromPath( "containDevWithinDevs.al", 0, "devices" )( deviceDB );
/* OTHER TEMPLATE PROPERTIES */
// template->autoReshape;
// template->canAddInteractively;
// template->canDeleteInteractively;
// template->geomDependsOnBoundary;
// template->hasAbsoluteXLocation;
// template->hasAbsoluteYLocation;
// template->hasImplicitConnections;
// template->isAbstract;
// template->isInBackground;
// template->registrationOperations;
// template->useForBoundaryCalc;
// template->defaultConfigurationName;
// template->changeConfigurationShapes;
// template->configurationName;
// template->previousConfigurationName;
// template->unlockShapes;
// template->layer;
// template->hide;
/* BEGIN CUSTOM SETUP */
/* END CUSTOM SETUP DEVICE I and H Control */
deviceDB->registerTemplate( template, "I and H Control" );
/* END */

/* BEGIN DEVICE P-STRAP Wire */
template = loadFromPath( "wire.al", 0, "devices" )( deviceDB );
template->layer = "P-STRAP";
template->minWireWidth = 0.09;
template->width = 0.09;
template->preferredMinWireWidth = 0.09;
template->maxWireWidth = 0.09;
template->snapUnconditionally = 0;
/* OTHER TEMPLATE PROPERTIES */
// template->allow45;
// template->autoReshape;
// template->canAddInteractively;
// template->canDeleteInteractively;
// template->geomDependsOnBoundary;
// template->hasAbsoluteXLocation;
// template->hasAbsoluteYLocation;
// template->hasImplicitConnections;
// template->isAbstract;
// template->isInBackground;
// template->layer;
// template->registrationOperations;
// template->useForBoundaryCalc;
// template->width;
// template->growUnconditionally;
// template->growIfBetweenLongGates;
// template->snapUnconditionally;
// template->maxWireWidth;
// template->minWireWidth;
// template->preferredMinWireWidth;
// template->preferredMinWireWidthPriority;
// template->growWidthObjectiveName;
// template->minLengthObjectiveName;
// template->minWidthObjectiveName;
// template->horizontalLayerCost;
// template->verticalLayerCost;
// template->drawingPolicy;
// template->overSizeByEpsilon;
// template->migrationScalingFactor;
/* BEGIN CUSTOM SETUP */
/* END CUSTOM SETUP DEVICE P-STRAP Wire */
deviceDB->registerTemplate( template, "P-STRAP Wire" );
/* END */

/* BEGIN DEVICE N-STRAP Wire */
template = loadFromPath( "wire.al", 0, "devices" )( deviceDB );
template->layer = "N-STRAP";
template->minWireWidth = 0.09;
template->width = 0.09;
template->preferredMinWireWidth = 0.09;
template->maxWireWidth = 0.09;
template->snapUnconditionally = 0;
/* OTHER TEMPLATE PROPERTIES */
// template->allow45;
// template->autoReshape;
// template->canAddInteractively;
// template->canDeleteInteractively;
// template->geomDependsOnBoundary;
// template->hasAbsoluteXLocation;
// template->hasAbsoluteYLocation;
// template->hasImplicitConnections;
// template->isAbstract;
// template->isInBackground;
// template->layer;
// template->registrationOperations;
// template->useForBoundaryCalc;
// template->width;
// template->growUnconditionally;
// template->growIfBetweenLongGates;
// template->snapUnconditionally;
// template->maxWireWidth;
// template->minWireWidth;
// template->preferredMinWireWidth;
// template->preferredMinWireWidthPriority;
// template->growWidthObjectiveName;
// template->minLengthObjectiveName;
// template->minWidthObjectiveName;
// template->horizontalLayerCost;
// template->verticalLayerCost;
// template->drawingPolicy;
// template->overSizeByEpsilon;
// template->migrationScalingFactor;
/* BEGIN CUSTOM SETUP */
/* END CUSTOM SETUP DEVICE N-STRAP Wire */
deviceDB->registerTemplate( template, "N-STRAP Wire" );
/* END */

/* BEGIN DEVICE GATE Wire */
template = loadFromPath( "wire.al", 0, "devices" )( deviceDB );
template->layer = "GATE";
template->minWireWidth = 0.05;
template->width = 0.05;
template->preferredMinWireWidth = 0.05;
template->maxWireWidth = 0.05;
template->snapUnconditionally = 0;
/* OTHER TEMPLATE PROPERTIES */
// template->allow45;
// template->autoReshape;
// template->canAddInteractively;
// template->canDeleteInteractively;
// template->geomDependsOnBoundary;
// template->hasAbsoluteXLocation;
// template->hasAbsoluteYLocation;
// template->hasImplicitConnections;
// template->isAbstract;
// template->isInBackground;
// template->layer;
// template->registrationOperations;
// template->useForBoundaryCalc;
// template->width;
// template->growUnconditionally;
// template->growIfBetweenLongGates;
// template->snapUnconditionally;
// template->maxWireWidth;
// template->minWireWidth;
// template->preferredMinWireWidth;
// template->preferredMinWireWidthPriority;
// template->growWidthObjectiveName;
// template->minLengthObjectiveName;
// template->minWidthObjectiveName;
// template->horizontalLayerCost;
// template->verticalLayerCost;
// template->drawingPolicy;
// template->overSizeByEpsilon;
// template->migrationScalingFactor;
/* BEGIN CUSTOM SETUP */
/* END CUSTOM SETUP DEVICE GATE Wire */
deviceDB->registerTemplate( template, "GATE Wire" );
/* END */

/* BEGIN DEVICE METAL2 Wire */
template = loadFromPath( "wire.al", 0, "devices" )( deviceDB );
template->layer = "METAL2";
template->minWireWidth = 0.07;
template->width = 0.07;
template->preferredMinWireWidth = 0.07;
template->maxWireWidth = 0.07;
template->snapUnconditionally = 0;
/* OTHER TEMPLATE PROPERTIES */
// template->allow45;
// template->autoReshape;
// template->canAddInteractively;
// template->canDeleteInteractively;
// template->geomDependsOnBoundary;
// template->hasAbsoluteXLocation;
// template->hasAbsoluteYLocation;
// template->hasImplicitConnections;
// template->isAbstract;
// template->isInBackground;
// template->layer;
// template->registrationOperations;
// template->useForBoundaryCalc;
// template->width;
// template->growUnconditionally;
// template->growIfBetweenLongGates;
// template->snapUnconditionally;
// template->maxWireWidth;
// template->minWireWidth;
// template->preferredMinWireWidth;
// template->preferredMinWireWidthPriority;
// template->growWidthObjectiveName;
// template->minLengthObjectiveName;
// template->minWidthObjectiveName;
// template->horizontalLayerCost;
// template->verticalLayerCost;
// template->drawingPolicy;
// template->overSizeByEpsilon;
// template->migrationScalingFactor;
/* BEGIN CUSTOM SETUP */
/* END CUSTOM SETUP DEVICE METAL2 Wire */
deviceDB->registerTemplate( template, "METAL2 Wire" );
/* END */

/* BEGIN DEVICE METAL3 Wire */
template = loadFromPath( "wire.al", 0, "devices" )( deviceDB );
template->layer = "METAL3";
template->minWireWidth = 0.07;
template->width = 0.07;
template->preferredMinWireWidth = 0.07;
template->maxWireWidth = 0.07;
template->snapUnconditionally = "hv";
/* OTHER TEMPLATE PROPERTIES */
// template->allow45;
// template->autoReshape;
// template->canAddInteractively;
// template->canDeleteInteractively;
// template->geomDependsOnBoundary;
// template->hasAbsoluteXLocation;
// template->hasAbsoluteYLocation;
// template->hasImplicitConnections;
// template->isAbstract;
// template->isInBackground;
// template->layer;
// template->registrationOperations;
// template->useForBoundaryCalc;
// template->width;
// template->growUnconditionally;
// template->growIfBetweenLongGates;
// template->snapUnconditionally;
// template->maxWireWidth;
// template->minWireWidth;
// template->preferredMinWireWidth;
// template->preferredMinWireWidthPriority;
// template->growWidthObjectiveName;
// template->minLengthObjectiveName;
// template->minWidthObjectiveName;
// template->horizontalLayerCost;
// template->verticalLayerCost;
// template->drawingPolicy;
// template->overSizeByEpsilon;
// template->migrationScalingFactor;
/* BEGIN CUSTOM SETUP */
/* END CUSTOM SETUP DEVICE METAL3 Wire */
deviceDB->registerTemplate( template, "METAL3 Wire" );
/* END */

/* BEGIN DEVICE Boundary Implants */
template = loadFromPath( "boundaryImplants.al", 0, "devices" )( deviceDB );
template->pImplantLayer = "P-IMPLANT";
template->pImplantRegion = list( "l",
                                 -0.0225,
                                 "b",
                                 1.235,
                                 "r",
                                 -0.0225,
                                 "t",
                                 0.07 );
template->nImplantLayer = "N-IMPLANT";
template->nImplantRegion = list( "l",
                                 -0.0225,
                                 "b",
                                 0.07,
                                 "r",
                                 -0.0225,
                                 "t",
                                 1.235 );
/* OTHER TEMPLATE PROPERTIES */
// template->autoReshape;
// template->canAddInteractively;
// template->canDeleteInteractively;
// template->geomDependsOnBoundary;
// template->hasAbsoluteXLocation;
// template->hasAbsoluteYLocation;
// template->hasImplicitConnections;
// template->isAbstract;
// template->isInBackground;
// template->registrationOperations;
// template->useForBoundaryCalc;
// template->defaultConfigurationName;
// template->changeConfigurationShapes;
// template->configurationName;
// template->previousConfigurationName;
// template->unlockShapes;
/* BEGIN CUSTOM SETUP */
/* END CUSTOM SETUP DEVICE Boundary Implants */
deviceDB->registerTemplate( template, "Boundary Implants" );
/* END */

/* BEGIN DEVICE VIA1 */
template = loadFromPath( "via.al", 0, "devices" )( deviceDB );
template->contactLayer = "VIA1";
template->layer1 = "METAL1";
template->layer2 = "METAL2";
template->snapX = 0;
template->snapY = 0;
template->minNumCuts = 1;
template->maxNumCuts = INFINITY;
template->snappedGrowth = 1;
template->growContactObjective = "growContacts";
template->growDirection = "d";
template->orientCover1Direction = "DEFAULT";
template->orientCover2Direction = "DEFAULT";
template->unlockCompactionCovers = list( "METAL1", "METAL2" );
template->unlockCovers = list( "METAL1", "METAL2" );
template->shrinkCoverObjective = "shrinkCovers";
template->orientCoverObjective = "orientCovers";
/* OTHER TEMPLATE PROPERTIES */
// template->autoReshape;
// template->canAddInteractively;
// template->canDeleteInteractively;
// template->geomDependsOnBoundary;
// template->hasAbsoluteXLocation;
// template->hasAbsoluteYLocation;
// template->hasImplicitConnections;
// template->isAbstract;
// template->isInBackground;
// template->registrationOperations;
// template->useForBoundaryCalc;
// template->defaultConfigurationName;
// template->changeConfigurationShapes;
// template->configurationName;
// template->previousConfigurationName;
// template->unlockShapes;
// template->contactDistribution;
// template->drawnSize;
// template->growLayer1Objective;
// template->growPolicy;
// template->jogLayer1AtWires;
// template->jogLayer2AtWires;
// template->layer1AlignmentObjective;
// template->layer1AlignmentTargets;
// template->layer2AlignmentObjective;
// template->layer2AlignmentTargets;
// template->keepContact;
// template->keepLayer1;
// template->keepLayer2;
// template->layer1WidenCoverObjective;
// template->layer2WidenCoverObjective;
// template->snappingGrid;
/* BEGIN CUSTOM SETUP */
/* END CUSTOM SETUP DEVICE VIA1 */
deviceDB->registerTemplate( template, "VIA1" );
/* END */

/* BEGIN DEVICE METAL2 Port */
template = loadFromPath( "port.al", 0, "devices" )( deviceDB );
template->cover1LayerName = "METAL2";
template->keepCover1 = 1;
template->keepContact = 0;
template->keepCover2 = 1;
template->minNumGrids = 1;
template->maxNumGrids = 1;
template->growthObjective = "growPorts";
template->growDirection = "d";
template->orientCover1Direction = "DEFAULT";
template->orientCover2Direction = "DEFAULT";
template->unlockCompactionCovers = list(  );
template->unlockCovers = list(  );
/* OTHER TEMPLATE PROPERTIES */
// template->autoReshape;
// template->canAddInteractively;
// template->canDeleteInteractively;
// template->geomDependsOnBoundary;
// template->growDirection;
// template->hasAbsoluteXLocation;
// template->hasAbsoluteYLocation;
// template->hasImplicitConnections;
// template->isAbstract;
// template->isInBackground;
// template->registrationOperations;
// template->useForBoundaryCalc;
// template->defaultConfigurationName;
// template->changeConfigurationShapes;
// template->configurationName;
// template->previousConfigurationName;
// template->unlockShapes;
// template->contactDistribution;
// template->contactLayerName;
// template->cover1LayerName;
// template->cover2LayerName;
// template->drawnSize;
// template->importContactSize;
// template->growthObjective;
// template->hGhostExtension;
// template->hGhostLayerName;
// template->jogLayer1AtWires;
// template->jogLayer2AtWires;
// template->keepContact;
// template->keepCover1;
// template->keepCover2;
// template->keepHGhost;
// template->keepVGhost;
// template->markerLayerName;
// template->minNumGrids;
// template->maxNumGrids;
// template->orientCover1Direction;
// template->orientCover2Direction;
// template->orientCoverObjective;
// template->shrinkCoverObjective;
// template->snapX;
// template->snapY;
// template->snappingGrid;
// template->vGhostExtension;
// template->vGhostLayerName;
// template->lockingLayerNames;
// template->layer1WidenCoverObjective;
// template->layer2WidenCoverObjective;
// template->evenDistribution;
// template->unlockCompactionCovers;
// template->unlockCovers;
/* BEGIN CUSTOM SETUP */
/* END CUSTOM SETUP DEVICE METAL2 Port */
deviceDB->registerTemplate( template, "METAL2 Port" );
/* END */


//********** #### REGISTER CUSTOM DEVICE TEMPLATES HERE #### **********

/* BEGIN MAPPING */
deviceDB->mapMosfet( "pmos", "pMosfet" );
deviceDB->mapMosfet( "nmos", "nMosfet" );
/* END */


//************ REGISTERING CALLBACK TEMPLATES ************
/* BEGIN CALLBACK AutoPlacer@placeBackgroundDevices */
template = loadFromPath( "placeBackgroundDevices.al", 0, "callbacks" )( callbackDB );
template->deviceList = list( list( "I and H Control" ),
                             list( "N-Well" ),
                             list( "VDD Power Rail", "vdd" ),
                             list( "VSS Power Rail", "vss" ),
                             list( "Well Tie Rail", "vdd" ),
                             list( "Substrate Tie Rail", "vss" ),
                             list( "@MinArea Device on METAL1" ),
                             list( "@MinArea Device on METAL2" ),
                             list( "@MinArea Device on METAL3" ),
                             list( "@MinArea Device on N-ACT" ),
                             list( "@MinArea Device on N-IMPLANT" ),
                             list( "@MinArea Device on N-STRAP" ),
                             list( "@MinArea Device on N-WELL" ),
                             list( "@MinArea Device on P-ACT" ),
                             list( "@MinArea Device on P-IMPLANT" ),
                             list( "@MinArea Device on P-STRAP" ),
                             list( "@MinArea Device on P-WELL" ),
                             list( "@MinArea Device on POLY" ),
                             list( "Boundary Implants" ) );
/* BEGIN CUSTOM SETUP */
/* END CUSTOM SETUP CALLBACK placeBackgroundDevices */
callbackDB->registerTemplate( template, "placeBackgroundDevices", "AutoPlacer" );
/* END */

/* BEGIN CALLBACK SymbolicLayoutMigrator@placeBackgroundDevices */
template = loadFromPath( "placeBackgroundDevices.al", 0, "callbacks" )( callbackDB );
template->deviceList = list( list( "I and H Control" ),
                             list( "N-Well" ),
                             list( "VDD Power Rail", "vdd" ),
                             list( "VSS Power Rail", "vss" ),
                             list( "Well Tie Rail", "vdd" ),
                             list( "Substrate Tie Rail", "vss" ),
                             list( "@MinArea Device on METAL1" ),
                             list( "@MinArea Device on METAL2" ),
                             list( "@MinArea Device on METAL3" ),
                             list( "@MinArea Device on N-ACT" ),
                             list( "@MinArea Device on N-IMPLANT" ),
                             list( "@MinArea Device on N-STRAP" ),
                             list( "@MinArea Device on N-WELL" ),
                             list( "@MinArea Device on P-ACT" ),
                             list( "@MinArea Device on P-IMPLANT" ),
                             list( "@MinArea Device on P-STRAP" ),
                             list( "@MinArea Device on P-WELL" ),
                             list( "@MinArea Device on POLY" ),
                             list( "Boundary Implants" ) );
/* BEGIN CUSTOM SETUP */
/* END CUSTOM SETUP CALLBACK placeBackgroundDevices */
callbackDB->registerTemplate( template, "placeBackgroundDevices", "SymbolicLayoutMigrator" );
/* END */

/* BEGIN CALLBACK LayoutImporter@placeBackgroundDevices */
template = loadFromPath( "placeBackgroundDevices.al", 0, "callbacks" )( callbackDB );
template->deviceList = list( list( "I and H Control" ),
                             list( "N-Well" ),
                             list( "VDD Power Rail", "vdd" ),
                             list( "VSS Power Rail", "vss" ),
                             list( "Well Tie Rail", "vdd" ),
                             list( "Substrate Tie Rail", "vss" ),
                             list( "@MinArea Device on METAL1" ),
                             list( "@MinArea Device on METAL2" ),
                             list( "@MinArea Device on METAL3" ),
                             list( "@MinArea Device on N-ACT" ),
                             list( "@MinArea Device on N-IMPLANT" ),
                             list( "@MinArea Device on N-STRAP" ),
                             list( "@MinArea Device on N-WELL" ),
                             list( "@MinArea Device on P-ACT" ),
                             list( "@MinArea Device on P-IMPLANT" ),
                             list( "@MinArea Device on P-STRAP" ),
                             list( "@MinArea Device on P-WELL" ),
                             list( "@MinArea Device on POLY" ),
                             list( "Boundary Implants" ) );
/* BEGIN CUSTOM SETUP */
/* END CUSTOM SETUP CALLBACK placeBackgroundDevices */
callbackDB->registerTemplate( template, "placeBackgroundDevices", "LayoutImporter" );
/* END */

/* BEGIN CALLBACK LayoutImporter@processImportShapes */
template = loadFromPath( "processImportShapes.al", 0, "callbacks" )( callbackDB );
template->operations = list( list( "@DIFF",
                                   "move",
                                   "P-ACT",
                                   "P-STRAP",
                                   "N-ACT",
                                   "N-STRAP" ),
                             list( "@PDIFF", "intersection", "@DIFF", "P-IMPLANT" ),
                             list( "@NDIFF", "difference", "@DIFF", "P-IMPLANT" ),
                             list( "P-ACT", "intersection", "@PDIFF", "N-WELL" ),
                             list( "N-ACT", "difference", "@NDIFF", "N-WELL" ),
                             list( "P-STRAP", "difference", "@PDIFF", "P-ACT" ),
                             list( "N-STRAP", "difference", "@NDIFF", "N-ACT" ),
                             list( "@POLY", "move", "GATE", "POLY" ),
                             list( "@ACT", "combine", "P-ACT", "N-ACT" ),
                             list( "GATE", "intersection", "@ACT", "@POLY" ),
                             list( "POLY", "difference", "@POLY", "GATE" ),
                             list( "@CONT", "move", "CONT", "PCONT" ),
                             list( "CONT", "intersection", "@CONT", "@DIFF" ),
                             list( "PCONT", "intersection", "@CONT", "POLY" ) );
/* BEGIN CUSTOM SETUP */
/* END CUSTOM SETUP CALLBACK processImportShapes */
callbackDB->registerTemplate( template, "processImportShapes", "LayoutImporter" );
/* END */


//********** #### REGISTER CUSTOM CALLBACK TEMPLATES HERE #### **********


//************ REGISTERING DESIGN STEP TEMPLATES ************
/* BEGIN DESIGNSTEP Update Boundary */
template = loadFromPath( "updateBoundary.al", 0, "designSteps" )( designStepDB );
template->nWellDeviceName = "N-Well";
/* BEGIN CUSTOM SETUP */
/* END CUSTOM SETUP DESIGNSTEP Update Boundary */
designStepDB->registerTemplate( template, 
                                "SymbolicLayout",
                                list( "Edit Design Steps" ),
                                "Update Boundary" );
/* END */

/* BEGIN DESIGNSTEP Set Resizing Policy */
template = loadFromPath( "setResizingPolicy.al", 0, "designSteps" )( designStepDB );
template->growMosfets = list(  );
template->shrinkMosfets = list(  );
template->convergeMosfets = list(  );
/* BEGIN CUSTOM SETUP */
/* END CUSTOM SETUP DESIGNSTEP Set Resizing Policy */
designStepDB->registerTemplate( template, 
                                "SymbolicLayout",
                                list( "Pre-Compaction Steps" ),
                                "Set Resizing Policy" );
/* END */

/* BEGIN DESIGNSTEP Pre-Grow Active Power Wires */
template = loadFromPath( "deviceApply.al", 0, "designSteps" )( designStepDB );
template->deviceList = list( "N-ACT Wire", "N-STRAP Wire", "P-ACT Wire", "P-STRAP Wire" );
template->applyList = list( list( "pregrowPwrWires()" ) );
/* BEGIN CUSTOM SETUP */
/* END CUSTOM SETUP DESIGNSTEP Pre-Grow Active Power Wires */
designStepDB->registerTemplate( template, 
                                "SymbolicLayout",
                                list( "Pre-Compaction Steps" ),
                                "Pre-Grow Active Power Wires" );
/* END */

/* BEGIN DESIGNSTEP Pre-Grow Contact Diffusions */
template = loadFromPath( "deviceApply.al", 0, "designSteps" )( designStepDB );
template->deviceList = list( "P-ACT Contact", "N-ACT Contact" );
template->applyList = list( list( "pregrowLayer1()" ) );
/* BEGIN CUSTOM SETUP */
/* END CUSTOM SETUP DESIGNSTEP Pre-Grow Contact Diffusions */
designStepDB->registerTemplate( template, 
                                "SymbolicLayout",
                                list( "Pre-Compaction Steps" ),
                                "Pre-Grow Contact Diffusions" );
/* END */

/* BEGIN DESIGNSTEP Pre-Grow Contacts */
template = loadFromPath( "deviceApply.al", 0, "designSteps" )( designStepDB );
template->deviceList = list( "P-ACT Contact", "N-ACT Contact" );
template->applyList = list( list( "pregrow()" ) );
/* BEGIN CUSTOM SETUP */
/* END CUSTOM SETUP DESIGNSTEP Pre-Grow Contacts */
designStepDB->registerTemplate( template, 
                                "SymbolicLayout",
                                list( "Pre-Compaction Steps" ),
                                "Pre-Grow Contacts" );
/* END */

/* BEGIN DESIGNSTEP Add Text for METAL1 Port */
template = loadFromPath( "addText.al", 0, "designSteps" )( designStepDB );
template->layerName = "@text_METAL1 Port";
template->shapeLayerName = "METAL1";
template->textType = -1;
template->magnification = 0.1;
template->width = 0.1;
template->onePerNet = 1;
template->net = "@ports";
template->string = "@netName@";
template->alignment = list( "center", "middle" );
/* BEGIN CUSTOM SETUP */
/* END CUSTOM SETUP DESIGNSTEP Add Text for METAL1 Port */
designStepDB->registerTemplate( template, 
                                "Layout",
                                list( "Final Layout Steps", "Add Text" ),
                                "Add Text for METAL1 Port" );
/* END */

/* BEGIN DESIGNSTEP Add Text for METAL2 Port */
template = loadFromPath( "addText.al", 0, "designSteps" )( designStepDB );
template->layerName = "@text_METAL2 Port";
template->shapeLayerName = "METAL2";
template->textType = -1;
template->magnification = 0.1;
template->width = 0.1;
template->onePerNet = 1;
template->net = "@ports";
template->string = "@netName@";
template->alignment = list( "center", "middle" );
/* BEGIN CUSTOM SETUP */
/* END CUSTOM SETUP DESIGNSTEP Add Text for METAL2 Port */
designStepDB->registerTemplate( template, 
                                "Layout",
                                list( "Final Layout Steps", "Add Text" ),
                                "Add Text for METAL2 Port" );
/* END */

/* BEGIN DESIGNSTEP Add Text for VDD Power Rail */
template = loadFromPath( "addText.al", 0, "designSteps" )( designStepDB );
template->layerName = "@text_VDD Power Rail";
template->shapeLayerName = "@boundary";
template->textType = -1;
template->magnification = 1;
template->width = 0.5;
template->net = 0;
template->string = "@vdd@";
template->alignment = list( "center", "middle" );
template->origin = list( "left", "top" );
template->offset = list( 0, 0.065 );
/* BEGIN CUSTOM SETUP */
/* END CUSTOM SETUP DESIGNSTEP Add Text for VDD Power Rail */
designStepDB->registerTemplate( template, 
                                "Layout",
                                list( "Final Layout Steps", "Add Text" ),
                                "Add Text for VDD Power Rail" );
/* END */

/* BEGIN DESIGNSTEP Add Text for VSS Power Rail */
template = loadFromPath( "addText.al", 0, "designSteps" )( designStepDB );
template->layerName = "@text_VSS Power Rail";
template->shapeLayerName = "@boundary";
template->textType = -1;
template->magnification = 1;
template->width = 0.5;
template->net = 0;
template->string = "@vss@";
template->alignment = list( "center", "middle" );
template->origin = list( "left", "bottom" );
template->offset = list( 0, -0.065 );
/* BEGIN CUSTOM SETUP */
/* END CUSTOM SETUP DESIGNSTEP Add Text for VSS Power Rail */
designStepDB->registerTemplate( template, 
                                "Layout",
                                list( "Final Layout Steps", "Add Text" ),
                                "Add Text for VSS Power Rail" );
/* END */

/* BEGIN DESIGNSTEP Add Text for Cell Name */
template = loadFromPath( "addText.al", 0, "designSteps" )( designStepDB );
template->layerName = "@text_cellName";
template->shapeLayerName = "@boundary";
template->textType = -1;
template->magnification = 1;
template->width = 0.5;
template->net = 0;
template->string = "@cellName@";
template->alignment = list( "center", "middle" );
template->origin = list( "left", "bottom" );
template->offset = list( 0, 0 );
/* BEGIN CUSTOM SETUP */
/* END CUSTOM SETUP DESIGNSTEP Add Text for Cell Name */
designStepDB->registerTemplate( template, 
                                "Layout",
                                list( "Final Layout Steps", "Add Text" ),
                                "Add Text for Cell Name" );
/* END */

/* BEGIN DESIGNSTEP Add Implants */
template = loadFromPath( "addImplants.al", 0, "designSteps" )( designStepDB );
template->PSBInfoList = list( list( list( "=addImplantLayer()", "P-IMPLANT" ), list( "->addAvoidanceLayers()", list( "N-IMPLANT", "N-ACT", "N-STRAP" ) ), list( "->addEnclosedLayers()", list( "P-ACT" ) ), list( "->addFillingArea()",
                                          "l",
                                          -0.0225,
                                          "b",
                                          1.235,
                                          "r",
                                          -0.0225,
                                          "t",
                                          0.07 ) ), list( list( "=addImplantLayer()", "N-IMPLANT" ), list( "->addAvoidanceLayers()", list( "P-IMPLANT", "P-ACT", "P-STRAP" ) ), list( "->addEnclosedLayers()", list( "N-ACT" ) ), list( "->addFillingArea()",
                                          "l",
                                          -0.0225,
                                          "b",
                                          0.07,
                                          "r",
                                          -0.0225,
                                          "t",
                                          1.235 ) ) );
/* BEGIN CUSTOM SETUP */
/* END CUSTOM SETUP DESIGNSTEP Add Implants */
designStepDB->registerTemplate( template, 
                                "Layout",
                                list( "Final Layout Steps" ),
                                "Add Implants" );
/* END */

/* BEGIN DESIGNSTEP Fill Notches */
template = loadFromPath( "fillNotches.al", 0, "designSteps" )( designStepDB );
/* BEGIN CUSTOM SETUP */
/* END CUSTOM SETUP DESIGNSTEP Fill Notches */
designStepDB->registerTemplate( template, 
                                "Layout",
                                list( "Final Layout Steps" ),
                                "Fill Notches" );
/* END */

/* BEGIN DESIGNSTEP Merge Shapes */
template = loadFromPath( "mergeShapes.al", 0, "designSteps" )( designStepDB );
/* BEGIN CUSTOM SETUP */
/* END CUSTOM SETUP DESIGNSTEP Merge Shapes */
designStepDB->registerTemplate( template, 
                                "Layout",
                                list( "Final Layout Steps" ),
                                "Merge Shapes" );
/* END */

/* BEGIN DESIGNSTEP Translate For Export */
template = loadFromPath( "translateForExport.al", 0, "designSteps" )( designStepDB );
/* BEGIN CUSTOM SETUP */
/* END CUSTOM SETUP DESIGNSTEP Translate For Export */
designStepDB->registerTemplate( template, 
                                "Layout",
                                list( "Final Layout Steps" ),
                                "Translate For Export" );
/* END */


//********** #### REGISTER CUSTOM DESIGN STEP TEMPLATES HERE #### **********


//************ REGISTERING DEFAULTS ************
/* BEGIN DEFAULTS Place */
defaultsDB->addDefaults( list( "Place" ), list(
list( "allowWellJogging", 1 ),
list( "doStacking", 1 ),
list( "doStaggering", 1 ),
list( "allowStackingOverCrossedGates", "Usual_Way" ),
list( "aggressiveStacking", 0 ),
list( "canRefold", 1 ),
list( "foldingPolicy", "Default" ),
list( "virtualShorts", "NoPreference" ) ) );
/* END */

/* BEGIN DEFAULTS AutoPlacer */
defaultsDB->addDefaults( list( "AutoPlacer" ), list(
list( "postPlacementCallbacks", list( "placeBackgroundDevices" ) ) ) );
/* END */

/* BEGIN DEFAULTS SymbolicLayoutMigrator */
defaultsDB->addDefaults( list( "SymbolicLayoutMigrator" ), list(
list( "postPlacementCallbacks", list( "placeBackgroundDevices" ) ) ) );
/* END */

/* BEGIN DEFAULTS LayoutImporter */
defaultsDB->addDefaults( list( "LayoutImporter" ), list(
list( "postImportCallbacks", list( "placeBackgroundDevices" ) ),
list( "templateRecognitionOrder", list( "N-Well",
            "VDD Power Rail",
            "VSS Power Rail",
            "Well Tie Rail",
            "Substrate Tie Rail",
            "Boundary Implants" ) ),
list( "templateValidationOrder", list( "P-ACT Contact", "N-ACT Contact" ) ),
list( "clusterContacts", 1 ),
list( "vsEqualityTolerance", INFINITY ),
list( "vddNetNames", list( ".*@vdd.*" ) ),
list( "vssNetNames", list( ".*@gnd.*" ) ),
list( "textToPortLayerPolicy", list( list( "METAL1", "METAL1" ),
            list( "@text_METAL1 Port", "METAL1" ),
            list( "METAL2", "METAL2" ),
            list( "@text_VDD Power Rail", "METAL1" ),
            list( "@text_VSS Power Rail", "METAL1" ) ) ),
list( "preImportCallbacks", list( "processImportShapes" ) ) ) );
/* END */

/* BEGIN DEFAULTS TileFolder */
defaultsDB->addDefaults( list( "TileFolder" ), list(
list( "maxPWidth", 1.03 ),
list( "maxNWidth", 0.885 ) ) );
/* END */

/* BEGIN DEFAULTS HierarchyExtractor */
defaultsDB->addDefaults( list( "HierarchyExtractor" ), list(
list( "maxPRegionHeight", 1.03 ),
list( "maxNRegionHeight", 0.885 ),
list( "searchingStopSeconds", 50 ),
list( "chainingStopSeconds", 50 ) ) );
/* END */

/* BEGIN DEFAULTS SymbolicDB */
defaultsDB->addDefaults( list( "SymbolicDB" ), list(
list( "setPMosfetRegion()", 2.32, 1.29 ),
list( "setPMosfetAlignment()", "b", "b" ),
list( "setNMosfetRegion()", 1.05, 0.165 ),
list( "setNMosfetAlignment()", "t", "t" ) ) );
/* END */

/* BEGIN DEFAULTS MosfetFolder */
defaultsDB->addDefaults( list( "MosfetFolder" ), list(
list( "policies", list( list( "@fold", list( "@type", "p" ), 1.03, 0 ), list( "@fold", list( "@type", "n" ), 0.885, 0 ) ) ) ) );
/* END */

/* BEGIN DEFAULTS PreCompactionSteps */
defaultsDB->addDefaults( list( "PreCompactionSteps" ), list(
list( "applySteps", list( "Set Resizing Policy", "Pre-Grow Active Power Wires", "Pre-Grow Contact Diffusions", "Pre-Grow Contacts" ) ) ) );
/* END */

/* BEGIN DEFAULTS TapPlacer */
defaultsDB->addDefaults( list( "TapPlacer" ), list(
list( "spacingToleranceX", 0.3 ),
list( "spacingToleranceY", 0.7 ),
list( "minCellWidthToPlaceTap", 0.19 ) ) );
/* END */

/* BEGIN DEFAULTS VerticalConditioner */
defaultsDB->addDefaults( list( "VerticalConditioner" ), list(
list( "preferExtraSpaceTop", 1 ),
list( "preferExtraSpaceChannel", 0 ),
list( "preferExtraSpaceBottom", 1 ),
list( "registerConstraintDefn()", "" ),
list( "useConstraintDefns()", list( list( "@abutmentContact", 4 ),
            list( "@dualChannelGateRoute", 3 ),
            list( "@crossedGateInChannel", 3 ),
            list( "@crossedGatePartiallyInChannel", 2 ),
            list( "@contactBetweenStackedMosfets", 5 ),
            list( "@manyPortsInChannel", 6 ),
            list( "@polyContactOutsideChannel", 5 ),
            list( "@polyWireOutsideChannel", 4 ),
            list( "@polyContactInChannel", 4 ),
            list( "@polyWireInChannel", 2 ),
            list( "@polyWireInChannelDetached", 6 ),
            list( "@polyWireOutsideChannelAttached", 5 ),
            list( "@maintainStaggering", 1 ) ) ) ) );
/* END */

/* BEGIN DEFAULTS PlacementOptimizer */
defaultsDB->addDefaults( list( "PlacementOptimizer" ), list(
list( "setPStackingThreshold()", 0.065, 0 ),
list( "setNStackingThreshold()", 0, 0.05 ) ) );
/* END */

/* BEGIN DEFAULTS CellCompactor */
defaultsDB->addDefaults( list( "CellCompactor" ), list(
list( "setLayerCosts()", "BOUNDARY", 2, 2 ),
list( "setLayerCosts()", "CONT", 15, 15 ),
list( "setLayerCosts()", "GATE", 15, 15 ),
list( "setLayerCosts()", "METAL1", 8, 8 ),
list( "setLayerCosts()", "METAL2", 8, 8 ),
list( "setLayerCosts()", "METAL3", 8, 8 ),
list( "setLayerCosts()", "N-ACT", 50, 50 ),
list( "setLayerCosts()", "N-IMPLANT", 2, 2 ),
list( "setLayerCosts()", "N-STRAP", 8, 8 ),
list( "setLayerCosts()", "N-WELL", 2, 2 ),
list( "setLayerCosts()", "P-ACT", 50, 50 ),
list( "setLayerCosts()", "P-IMPLANT", 2, 2 ),
list( "setLayerCosts()", "P-STRAP", 8, 8 ),
list( "setLayerCosts()", "PCONT", 2, 2 ),
list( "setLayerCosts()", "POLY", 15, 15 ),
list( "setLayerCosts()", "VGHOST", 2, 2 ),
list( "setLayerCosts()", "VIA1", 2, 2 ),
list( "setLayerCosts()", "VIA2", 2, 2 ),
list( "setLayerCosts()", "P-WELL", 2, 2 ),
list( "registerObjective()", "@minimizeWidth", 1, 0 ),
list( "setNoSolutionStopCondition()", "@minimizeWidth", INFINITY, 30000 ),
list( "setSolutionStopCondition()", "@minimizeWidth", INFINITY, 15000 ),
list( "setNoProgressStopCondition()", "@minimizeWidth", INFINITY, 7500 ),
list( "setProgressThreshold()", "@minimizeWidth", 10 ),
list( "setOptimalityTolerance()", "@minimizeWidth", 0.75 ),
list( "setResolveSnapping()", "@minimizeWidth", 1 ),
list( "setResolveCornerConstraints()", "@minimizeWidth", 1 ),
list( "setResolveConditionalConstraints()", "@minimizeWidth", 1 ),
list( "registerObjective()", "@optimizeMosfetWidth", 1, 0 ),
list( "setNoSolutionStopCondition()", "@optimizeMosfetWidth", INFINITY, 15000 ),
list( "setSolutionStopCondition()", "@optimizeMosfetWidth", INFINITY, 7500 ),
list( "setNoProgressStopCondition()", "@optimizeMosfetWidth", INFINITY, 3750 ),
list( "setProgressThreshold()", "@optimizeMosfetWidth", 6 ),
list( "setOptimalityTolerance()", "@optimizeMosfetWidth", 6 ),
list( "setResolveSnapping()", "@optimizeMosfetWidth", 1 ),
list( "setResolveCornerConstraints()", "@optimizeMosfetWidth", 1 ),
list( "setResolveConditionalConstraints()", "@optimizeMosfetWidth", 1 ),
list( "registerObjective()", "@minimizeGateBends", 1, 0 ),
list( "setNoSolutionStopCondition()", "@minimizeGateBends", INFINITY, 15000 ),
list( "setSolutionStopCondition()", "@minimizeGateBends", INFINITY, 7500 ),
list( "setNoProgressStopCondition()", "@minimizeGateBends", INFINITY, 3750 ),
list( "setProgressThreshold()", "@minimizeGateBends", 6 ),
list( "setOptimalityTolerance()", "@minimizeGateBends", 6 ),
list( "setResolveSnapping()", "@minimizeGateBends", 1 ),
list( "setResolveCornerConstraints()", "@minimizeGateBends", 1 ),
list( "setResolveConditionalConstraints()", "@minimizeGateBends", 1 ),
list( "registerObjective()", "widenWires", 1, 0 ),
list( "setNoSolutionStopCondition()", "widenWires", INFINITY, 15000 ),
list( "setSolutionStopCondition()", "widenWires", INFINITY, 7500 ),
list( "setNoProgressStopCondition()", "widenWires", INFINITY, 3750 ),
list( "setProgressThreshold()", "widenWires", 6 ),
list( "setOptimalityTolerance()", "widenWires", 6 ),
list( "setResolveSnapping()", "widenWires", 1 ),
list( "setResolveCornerConstraints()", "widenWires", 1 ),
list( "setResolveConditionalConstraints()", "widenWires", 1 ),
list( "registerObjective()", "@minimizeSignalDiffusion", 1, 0 ),
list( "setNoSolutionStopCondition()", "@minimizeSignalDiffusion", INFINITY, 15000 ),
list( "setSolutionStopCondition()", "@minimizeSignalDiffusion", INFINITY, 7500 ),
list( "setNoProgressStopCondition()", "@minimizeSignalDiffusion", INFINITY, 3750 ),
list( "setProgressThreshold()", "@minimizeSignalDiffusion", 6 ),
list( "setOptimalityTolerance()", "@minimizeSignalDiffusion", 6 ),
list( "setResolveSnapping()", "@minimizeSignalDiffusion", 1 ),
list( "setResolveCornerConstraints()", "@minimizeSignalDiffusion", 1 ),
list( "setResolveConditionalConstraints()", "@minimizeSignalDiffusion", 1 ),
list( "registerObjective()", "@minimizePowerDiffusion", 1, 0 ),
list( "setNoSolutionStopCondition()", "@minimizePowerDiffusion", INFINITY, 15000 ),
list( "setSolutionStopCondition()", "@minimizePowerDiffusion", INFINITY, 7500 ),
list( "setNoProgressStopCondition()", "@minimizePowerDiffusion", INFINITY, 3750 ),
list( "setProgressThreshold()", "@minimizePowerDiffusion", 6 ),
list( "setOptimalityTolerance()", "@minimizePowerDiffusion", 6 ),
list( "setResolveSnapping()", "@minimizePowerDiffusion", 1 ),
list( "setResolveCornerConstraints()", "@minimizePowerDiffusion", 1 ),
list( "setResolveConditionalConstraints()", "@minimizePowerDiffusion", 1 ),
list( "registerObjective()", "moveContactsInPwrRails", 1, 0 ),
list( "setNoSolutionStopCondition()", "moveContactsInPwrRails", INFINITY, 15000 ),
list( "setSolutionStopCondition()", "moveContactsInPwrRails", INFINITY, 7500 ),
list( "setNoProgressStopCondition()", "moveContactsInPwrRails", INFINITY, 3750 ),
list( "setProgressThreshold()", "moveContactsInPwrRails", 6 ),
list( "setOptimalityTolerance()", "moveContactsInPwrRails", 6 ),
list( "setResolveSnapping()", "moveContactsInPwrRails", 1 ),
list( "setResolveCornerConstraints()", "moveContactsInPwrRails", 1 ),
list( "setResolveConditionalConstraints()", "moveContactsInPwrRails", 1 ),
list( "registerObjective()", "growContactDiffusions", 1, 0 ),
list( "setNoSolutionStopCondition()", "growContactDiffusions", INFINITY, 15000 ),
list( "setSolutionStopCondition()", "growContactDiffusions", INFINITY, 7500 ),
list( "setNoProgressStopCondition()", "growContactDiffusions", INFINITY, 3750 ),
list( "setProgressThreshold()", "growContactDiffusions", 6 ),
list( "setOptimalityTolerance()", "growContactDiffusions", 6 ),
list( "setResolveSnapping()", "growContactDiffusions", 1 ),
list( "setResolveCornerConstraints()", "growContactDiffusions", 1 ),
list( "setResolveConditionalConstraints()", "growContactDiffusions", 1 ),
list( "registerObjective()", "@alignMosfetDiffusion", 1, 0 ),
list( "setNoSolutionStopCondition()", "@alignMosfetDiffusion", INFINITY, 15000 ),
list( "setSolutionStopCondition()", "@alignMosfetDiffusion", INFINITY, 7500 ),
list( "setNoProgressStopCondition()", "@alignMosfetDiffusion", INFINITY, 3750 ),
list( "setProgressThreshold()", "@alignMosfetDiffusion", 6 ),
list( "setOptimalityTolerance()", "@alignMosfetDiffusion", 6 ),
list( "setResolveSnapping()", "@alignMosfetDiffusion", 1 ),
list( "setResolveCornerConstraints()", "@alignMosfetDiffusion", 1 ),
list( "setResolveConditionalConstraints()", "@alignMosfetDiffusion", 1 ),
list( "registerObjective()", "@applyDistributedRuleP1", 1, 0 ),
list( "setNoSolutionStopCondition()", "@applyDistributedRuleP1", INFINITY, 15000 ),
list( "setSolutionStopCondition()", "@applyDistributedRuleP1", INFINITY, 7500 ),
list( "setNoProgressStopCondition()", "@applyDistributedRuleP1", INFINITY, 3750 ),
list( "setProgressThreshold()", "@applyDistributedRuleP1", 6 ),
list( "setOptimalityTolerance()", "@applyDistributedRuleP1", 6 ),
list( "setResolveSnapping()", "@applyDistributedRuleP1", 1 ),
list( "setResolveCornerConstraints()", "@applyDistributedRuleP1", 1 ),
list( "setResolveConditionalConstraints()", "@applyDistributedRuleP1", 1 ),
list( "registerObjective()", "@applyPreferredRuleP1", 1, 0 ),
list( "setNoSolutionStopCondition()", "@applyPreferredRuleP1", INFINITY, 15000 ),
list( "setSolutionStopCondition()", "@applyPreferredRuleP1", INFINITY, 7500 ),
list( "setNoProgressStopCondition()", "@applyPreferredRuleP1", INFINITY, 3750 ),
list( "setProgressThreshold()", "@applyPreferredRuleP1", 6 ),
list( "setOptimalityTolerance()", "@applyPreferredRuleP1", 6 ),
list( "setResolveSnapping()", "@applyPreferredRuleP1", 1 ),
list( "setResolveCornerConstraints()", "@applyPreferredRuleP1", 1 ),
list( "setResolveConditionalConstraints()", "@applyPreferredRuleP1", 1 ),
list( "registerObjective()", "@softPreserveEvenlyP1", 1, 0 ),
list( "setNoSolutionStopCondition()", "@softPreserveEvenlyP1", INFINITY, 15000 ),
list( "setSolutionStopCondition()", "@softPreserveEvenlyP1", INFINITY, 7500 ),
list( "setNoProgressStopCondition()", "@softPreserveEvenlyP1", INFINITY, 3750 ),
list( "setProgressThreshold()", "@softPreserveEvenlyP1", 6 ),
list( "setOptimalityTolerance()", "@softPreserveEvenlyP1", 6 ),
list( "setResolveSnapping()", "@softPreserveEvenlyP1", 1 ),
list( "setResolveCornerConstraints()", "@softPreserveEvenlyP1", 1 ),
list( "setResolveConditionalConstraints()", "@softPreserveEvenlyP1", 1 ),
list( "registerObjective()", "@softPreserveP1", 1, 0 ),
list( "setNoSolutionStopCondition()", "@softPreserveP1", INFINITY, 15000 ),
list( "setSolutionStopCondition()", "@softPreserveP1", INFINITY, 7500 ),
list( "setNoProgressStopCondition()", "@softPreserveP1", INFINITY, 3750 ),
list( "setProgressThreshold()", "@softPreserveP1", 6 ),
list( "setOptimalityTolerance()", "@softPreserveP1", 6 ),
list( "setResolveSnapping()", "@softPreserveP1", 1 ),
list( "setResolveCornerConstraints()", "@softPreserveP1", 1 ),
list( "setResolveConditionalConstraints()", "@softPreserveP1", 1 ),
list( "registerObjective()", "@applyDistributedRuleP2", 1, 0 ),
list( "setNoSolutionStopCondition()", "@applyDistributedRuleP2", INFINITY, 15000 ),
list( "setSolutionStopCondition()", "@applyDistributedRuleP2", INFINITY, 7500 ),
list( "setNoProgressStopCondition()", "@applyDistributedRuleP2", INFINITY, 3750 ),
list( "setProgressThreshold()", "@applyDistributedRuleP2", 6 ),
list( "setOptimalityTolerance()", "@applyDistributedRuleP2", 6 ),
list( "setResolveSnapping()", "@applyDistributedRuleP2", 1 ),
list( "setResolveCornerConstraints()", "@applyDistributedRuleP2", 1 ),
list( "setResolveConditionalConstraints()", "@applyDistributedRuleP2", 1 ),
list( "registerObjective()", "@applyPreferredRuleP2", 1, 0 ),
list( "setNoSolutionStopCondition()", "@applyPreferredRuleP2", INFINITY, 15000 ),
list( "setSolutionStopCondition()", "@applyPreferredRuleP2", INFINITY, 7500 ),
list( "setNoProgressStopCondition()", "@applyPreferredRuleP2", INFINITY, 3750 ),
list( "setProgressThreshold()", "@applyPreferredRuleP2", 6 ),
list( "setOptimalityTolerance()", "@applyPreferredRuleP2", 6 ),
list( "setResolveSnapping()", "@applyPreferredRuleP2", 1 ),
list( "setResolveCornerConstraints()", "@applyPreferredRuleP2", 1 ),
list( "setResolveConditionalConstraints()", "@applyPreferredRuleP2", 1 ),
list( "registerObjective()", "@softPreserveEvenlyP2", 1, 0 ),
list( "setNoSolutionStopCondition()", "@softPreserveEvenlyP2", INFINITY, 15000 ),
list( "setSolutionStopCondition()", "@softPreserveEvenlyP2", INFINITY, 7500 ),
list( "setNoProgressStopCondition()", "@softPreserveEvenlyP2", INFINITY, 3750 ),
list( "setProgressThreshold()", "@softPreserveEvenlyP2", 6 ),
list( "setOptimalityTolerance()", "@softPreserveEvenlyP2", 6 ),
list( "setResolveSnapping()", "@softPreserveEvenlyP2", 1 ),
list( "setResolveCornerConstraints()", "@softPreserveEvenlyP2", 1 ),
list( "setResolveConditionalConstraints()", "@softPreserveEvenlyP2", 1 ),
list( "registerObjective()", "@softPreserveP2", 1, 0 ),
list( "setNoSolutionStopCondition()", "@softPreserveP2", INFINITY, 15000 ),
list( "setSolutionStopCondition()", "@softPreserveP2", INFINITY, 7500 ),
list( "setNoProgressStopCondition()", "@softPreserveP2", INFINITY, 3750 ),
list( "setProgressThreshold()", "@softPreserveP2", 6 ),
list( "setOptimalityTolerance()", "@softPreserveP2", 6 ),
list( "setResolveSnapping()", "@softPreserveP2", 1 ),
list( "setResolveCornerConstraints()", "@softPreserveP2", 1 ),
list( "setResolveConditionalConstraints()", "@softPreserveP2", 1 ),
list( "registerObjective()", "@applyDistributedRuleP3", 1, 0 ),
list( "setNoSolutionStopCondition()", "@applyDistributedRuleP3", INFINITY, 15000 ),
list( "setSolutionStopCondition()", "@applyDistributedRuleP3", INFINITY, 7500 ),
list( "setNoProgressStopCondition()", "@applyDistributedRuleP3", INFINITY, 3750 ),
list( "setProgressThreshold()", "@applyDistributedRuleP3", 6 ),
list( "setOptimalityTolerance()", "@applyDistributedRuleP3", 6 ),
list( "setResolveSnapping()", "@applyDistributedRuleP3", 1 ),
list( "setResolveCornerConstraints()", "@applyDistributedRuleP3", 1 ),
list( "setResolveConditionalConstraints()", "@applyDistributedRuleP3", 1 ),
list( "registerObjective()", "@applyPreferredRuleP3", 1, 0 ),
list( "setNoSolutionStopCondition()", "@applyPreferredRuleP3", INFINITY, 15000 ),
list( "setSolutionStopCondition()", "@applyPreferredRuleP3", INFINITY, 7500 ),
list( "setNoProgressStopCondition()", "@applyPreferredRuleP3", INFINITY, 3750 ),
list( "setProgressThreshold()", "@applyPreferredRuleP3", 6 ),
list( "setOptimalityTolerance()", "@applyPreferredRuleP3", 6 ),
list( "setResolveSnapping()", "@applyPreferredRuleP3", 1 ),
list( "setResolveCornerConstraints()", "@applyPreferredRuleP3", 1 ),
list( "setResolveConditionalConstraints()", "@applyPreferredRuleP3", 1 ),
list( "registerObjective()", "@softPreserveEvenlyP3", 1, 0 ),
list( "setNoSolutionStopCondition()", "@softPreserveEvenlyP3", INFINITY, 15000 ),
list( "setSolutionStopCondition()", "@softPreserveEvenlyP3", INFINITY, 7500 ),
list( "setNoProgressStopCondition()", "@softPreserveEvenlyP3", INFINITY, 3750 ),
list( "setProgressThreshold()", "@softPreserveEvenlyP3", 6 ),
list( "setOptimalityTolerance()", "@softPreserveEvenlyP3", 6 ),
list( "setResolveSnapping()", "@softPreserveEvenlyP3", 1 ),
list( "setResolveCornerConstraints()", "@softPreserveEvenlyP3", 1 ),
list( "setResolveConditionalConstraints()", "@softPreserveEvenlyP3", 1 ),
list( "registerObjective()", "@softPreserveP3", 1, 0 ),
list( "setNoSolutionStopCondition()", "@softPreserveP3", INFINITY, 15000 ),
list( "setSolutionStopCondition()", "@softPreserveP3", INFINITY, 7500 ),
list( "setNoProgressStopCondition()", "@softPreserveP3", INFINITY, 3750 ),
list( "setProgressThreshold()", "@softPreserveP3", 6 ),
list( "setOptimalityTolerance()", "@softPreserveP3", 6 ),
list( "setResolveSnapping()", "@softPreserveP3", 1 ),
list( "setResolveCornerConstraints()", "@softPreserveP3", 1 ),
list( "setResolveConditionalConstraints()", "@softPreserveP3", 1 ),
list( "registerObjective()", "@applyDistributedRuleP4", 1, 0 ),
list( "setNoSolutionStopCondition()", "@applyDistributedRuleP4", INFINITY, 15000 ),
list( "setSolutionStopCondition()", "@applyDistributedRuleP4", INFINITY, 7500 ),
list( "setNoProgressStopCondition()", "@applyDistributedRuleP4", INFINITY, 3750 ),
list( "setProgressThreshold()", "@applyDistributedRuleP4", 6 ),
list( "setOptimalityTolerance()", "@applyDistributedRuleP4", 6 ),
list( "setResolveSnapping()", "@applyDistributedRuleP4", 1 ),
list( "setResolveCornerConstraints()", "@applyDistributedRuleP4", 1 ),
list( "setResolveConditionalConstraints()", "@applyDistributedRuleP4", 1 ),
list( "registerObjective()", "@applyPreferredRuleP4", 1, 0 ),
list( "setNoSolutionStopCondition()", "@applyPreferredRuleP4", INFINITY, 15000 ),
list( "setSolutionStopCondition()", "@applyPreferredRuleP4", INFINITY, 7500 ),
list( "setNoProgressStopCondition()", "@applyPreferredRuleP4", INFINITY, 3750 ),
list( "setProgressThreshold()", "@applyPreferredRuleP4", 6 ),
list( "setOptimalityTolerance()", "@applyPreferredRuleP4", 6 ),
list( "setResolveSnapping()", "@applyPreferredRuleP4", 1 ),
list( "setResolveCornerConstraints()", "@applyPreferredRuleP4", 1 ),
list( "setResolveConditionalConstraints()", "@applyPreferredRuleP4", 1 ),
list( "registerObjective()", "@softPreserveEvenlyP4", 1, 0 ),
list( "setNoSolutionStopCondition()", "@softPreserveEvenlyP4", INFINITY, 15000 ),
list( "setSolutionStopCondition()", "@softPreserveEvenlyP4", INFINITY, 7500 ),
list( "setNoProgressStopCondition()", "@softPreserveEvenlyP4", INFINITY, 3750 ),
list( "setProgressThreshold()", "@softPreserveEvenlyP4", 6 ),
list( "setOptimalityTolerance()", "@softPreserveEvenlyP4", 6 ),
list( "setResolveSnapping()", "@softPreserveEvenlyP4", 1 ),
list( "setResolveCornerConstraints()", "@softPreserveEvenlyP4", 1 ),
list( "setResolveConditionalConstraints()", "@softPreserveEvenlyP4", 1 ),
list( "registerObjective()", "@softPreserveP4", 1, 0 ),
list( "setNoSolutionStopCondition()", "@softPreserveP4", INFINITY, 15000 ),
list( "setSolutionStopCondition()", "@softPreserveP4", INFINITY, 7500 ),
list( "setNoProgressStopCondition()", "@softPreserveP4", INFINITY, 3750 ),
list( "setProgressThreshold()", "@softPreserveP4", 6 ),
list( "setOptimalityTolerance()", "@softPreserveP4", 6 ),
list( "setResolveSnapping()", "@softPreserveP4", 1 ),
list( "setResolveCornerConstraints()", "@softPreserveP4", 1 ),
list( "setResolveConditionalConstraints()", "@softPreserveP4", 1 ),
list( "registerObjective()", "@applyDistributedRuleP5", 1, 0 ),
list( "setNoSolutionStopCondition()", "@applyDistributedRuleP5", INFINITY, 15000 ),
list( "setSolutionStopCondition()", "@applyDistributedRuleP5", INFINITY, 7500 ),
list( "setNoProgressStopCondition()", "@applyDistributedRuleP5", INFINITY, 3750 ),
list( "setProgressThreshold()", "@applyDistributedRuleP5", 6 ),
list( "setOptimalityTolerance()", "@applyDistributedRuleP5", 6 ),
list( "setResolveSnapping()", "@applyDistributedRuleP5", 1 ),
list( "setResolveCornerConstraints()", "@applyDistributedRuleP5", 1 ),
list( "setResolveConditionalConstraints()", "@applyDistributedRuleP5", 1 ),
list( "registerObjective()", "@applyPreferredRuleP5", 1, 0 ),
list( "setNoSolutionStopCondition()", "@applyPreferredRuleP5", INFINITY, 15000 ),
list( "setSolutionStopCondition()", "@applyPreferredRuleP5", INFINITY, 7500 ),
list( "setNoProgressStopCondition()", "@applyPreferredRuleP5", INFINITY, 3750 ),
list( "setProgressThreshold()", "@applyPreferredRuleP5", 6 ),
list( "setOptimalityTolerance()", "@applyPreferredRuleP5", 6 ),
list( "setResolveSnapping()", "@applyPreferredRuleP5", 1 ),
list( "setResolveCornerConstraints()", "@applyPreferredRuleP5", 1 ),
list( "setResolveConditionalConstraints()", "@applyPreferredRuleP5", 1 ),
list( "registerObjective()", "@softPreserveEvenlyP5", 1, 0 ),
list( "setNoSolutionStopCondition()", "@softPreserveEvenlyP5", INFINITY, 15000 ),
list( "setSolutionStopCondition()", "@softPreserveEvenlyP5", INFINITY, 7500 ),
list( "setNoProgressStopCondition()", "@softPreserveEvenlyP5", INFINITY, 3750 ),
list( "setProgressThreshold()", "@softPreserveEvenlyP5", 6 ),
list( "setOptimalityTolerance()", "@softPreserveEvenlyP5", 6 ),
list( "setResolveSnapping()", "@softPreserveEvenlyP5", 1 ),
list( "setResolveCornerConstraints()", "@softPreserveEvenlyP5", 1 ),
list( "setResolveConditionalConstraints()", "@softPreserveEvenlyP5", 1 ),
list( "registerObjective()", "@softPreserveP5", 1, 0 ),
list( "setNoSolutionStopCondition()", "@softPreserveP5", INFINITY, 15000 ),
list( "setSolutionStopCondition()", "@softPreserveP5", INFINITY, 7500 ),
list( "setNoProgressStopCondition()", "@softPreserveP5", INFINITY, 3750 ),
list( "setProgressThreshold()", "@softPreserveP5", 6 ),
list( "setOptimalityTolerance()", "@softPreserveP5", 6 ),
list( "setResolveSnapping()", "@softPreserveP5", 1 ),
list( "setResolveCornerConstraints()", "@softPreserveP5", 1 ),
list( "setResolveConditionalConstraints()", "@softPreserveP5", 1 ),
list( "registerObjective()", "minimizeWellJogs", 1, 0 ),
list( "setNoSolutionStopCondition()", "minimizeWellJogs", INFINITY, 15000 ),
list( "setSolutionStopCondition()", "minimizeWellJogs", INFINITY, 7500 ),
list( "setNoProgressStopCondition()", "minimizeWellJogs", INFINITY, 3750 ),
list( "setProgressThreshold()", "minimizeWellJogs", 6 ),
list( "setOptimalityTolerance()", "minimizeWellJogs", 6 ),
list( "setResolveSnapping()", "minimizeWellJogs", 1 ),
list( "setResolveCornerConstraints()", "minimizeWellJogs", 1 ),
list( "setResolveConditionalConstraints()", "minimizeWellJogs", 1 ),
list( "registerObjective()", "@alignEdges", 1, 0 ),
list( "setNoSolutionStopCondition()", "@alignEdges", INFINITY, 15000 ),
list( "setSolutionStopCondition()", "@alignEdges", INFINITY, 7500 ),
list( "setNoProgressStopCondition()", "@alignEdges", INFINITY, 3750 ),
list( "setProgressThreshold()", "@alignEdges", 6 ),
list( "setOptimalityTolerance()", "@alignEdges", 6 ),
list( "setResolveSnapping()", "@alignEdges", 1 ),
list( "setResolveCornerConstraints()", "@alignEdges", 1 ),
list( "setResolveConditionalConstraints()", "@alignEdges", 1 ),
list( "registerObjective()", "orientCovers", 1, 0 ),
list( "setNoSolutionStopCondition()", "orientCovers", INFINITY, 15000 ),
list( "setSolutionStopCondition()", "orientCovers", INFINITY, 7500 ),
list( "setNoProgressStopCondition()", "orientCovers", INFINITY, 3750 ),
list( "setProgressThreshold()", "orientCovers", 6 ),
list( "setOptimalityTolerance()", "orientCovers", 6 ),
list( "setResolveSnapping()", "orientCovers", 1 ),
list( "setResolveCornerConstraints()", "orientCovers", 1 ),
list( "setResolveConditionalConstraints()", "orientCovers", 1 ),
list( "registerObjective()", "preferredAsymmetricalExtension", 1, 0 ),
list( "setNoSolutionStopCondition()", "preferredAsymmetricalExtension", INFINITY, 15000 ),
list( "setSolutionStopCondition()", "preferredAsymmetricalExtension", INFINITY, 7500 ),
list( "setNoProgressStopCondition()", "preferredAsymmetricalExtension", INFINITY, 3750 ),
list( "setProgressThreshold()", "preferredAsymmetricalExtension", 6 ),
list( "setOptimalityTolerance()", "preferredAsymmetricalExtension", 6 ),
list( "setResolveSnapping()", "preferredAsymmetricalExtension", 1 ),
list( "setResolveCornerConstraints()", "preferredAsymmetricalExtension", 1 ),
list( "setResolveConditionalConstraints()", "preferredAsymmetricalExtension", 1 ),
list( "registerObjective()", "shrinkCovers", 1, 0 ),
list( "setNoSolutionStopCondition()", "shrinkCovers", INFINITY, 15000 ),
list( "setSolutionStopCondition()", "shrinkCovers", INFINITY, 7500 ),
list( "setNoProgressStopCondition()", "shrinkCovers", INFINITY, 3750 ),
list( "setProgressThreshold()", "shrinkCovers", 6 ),
list( "setOptimalityTolerance()", "shrinkCovers", 6 ),
list( "setResolveSnapping()", "shrinkCovers", 1 ),
list( "setResolveCornerConstraints()", "shrinkCovers", 1 ),
list( "setResolveConditionalConstraints()", "shrinkCovers", 1 ),
list( "registerObjective()", "@minimizeWireLength", 1, 0 ),
list( "setNoSolutionStopCondition()", "@minimizeWireLength", INFINITY, 15000 ),
list( "setSolutionStopCondition()", "@minimizeWireLength", INFINITY, 7500 ),
list( "setNoProgressStopCondition()", "@minimizeWireLength", INFINITY, 3750 ),
list( "setProgressThreshold()", "@minimizeWireLength", 6 ),
list( "setOptimalityTolerance()", "@minimizeWireLength", 6 ),
list( "setResolveSnapping()", "@minimizeWireLength", 1 ),
list( "setResolveCornerConstraints()", "@minimizeWireLength", 1 ),
list( "setResolveConditionalConstraints()", "@minimizeWireLength", 1 ),
list( "registerObjective()", "growContacts", 1, 0 ),
list( "setNoSolutionStopCondition()", "growContacts", INFINITY, 15000 ),
list( "setSolutionStopCondition()", "growContacts", INFINITY, 7500 ),
list( "setNoProgressStopCondition()", "growContacts", INFINITY, 3750 ),
list( "setProgressThreshold()", "growContacts", 6 ),
list( "setOptimalityTolerance()", "growContacts", 0 ),
list( "setResolveSnapping()", "growContacts", 1 ),
list( "setResolveCornerConstraints()", "growContacts", 1 ),
list( "setResolveConditionalConstraints()", "growContacts", 1 ),
list( "registerObjective()", "growPorts", 1, 0 ),
list( "setNoSolutionStopCondition()", "growPorts", INFINITY, 15000 ),
list( "setSolutionStopCondition()", "growPorts", INFINITY, 7500 ),
list( "setNoProgressStopCondition()", "growPorts", INFINITY, 3750 ),
list( "setProgressThreshold()", "growPorts", 6 ),
list( "setOptimalityTolerance()", "growPorts", 0 ),
list( "setResolveSnapping()", "growPorts", 1 ),
list( "setResolveCornerConstraints()", "growPorts", 1 ),
list( "setResolveConditionalConstraints()", "growPorts", 1 ),
list( "useObjectives()",
      "@minimizeWidth",
      "@optimizeMosfetWidth",
      "@applyDistributedRuleP1",
      "@applyPreferredRuleP1",
      "@softPreserveEvenlyP1",
      "@softPreserveP1",
      "@applyDistributedRuleP2",
      "@applyPreferredRuleP2",
      "@softPreserveEvenlyP2",
      "@softPreserveP2",
      "@applyDistributedRuleP3",
      "@applyPreferredRuleP3",
      "@softPreserveEvenlyP3",
      "@softPreserveP3",
      "@applyDistributedRuleP4",
      "@applyPreferredRuleP4",
      "@softPreserveEvenlyP4",
      "@softPreserveP4",
      "@applyDistributedRuleP5",
      "@applyPreferredRuleP5",
      "@softPreserveEvenlyP5",
      "@softPreserveP5",
      "@alignMosfetDiffusion",
      "growContacts",
      "growPorts",
      "growPorts",
      "widenWires",
      "@minimizeSignalDiffusion",
      "@minimizePowerDiffusion",
      "moveContactsInPwrRails",
      "growContactDiffusions",
      "minimizeWellJogs",
      "@alignEdges",
      "orientCovers",
      "preferredAsymmetricalExtension",
      "shrinkCovers",
      "@minimizeWireLength" ) ) );
/* END */

/* BEGIN DEFAULTS Compact */
defaultsDB->addDefaults( list( "Compact" ), list(
list( "setObjectiveClass()", "@minimizeWidth", "PrimaryObjective" ),
list( "setObjectiveClass()", "@optimizeMosfetWidth", "PerformanceObjective" ),
list( "setObjectiveClass()", "@minimizeGateBends", "PerformanceObjective" ),
list( "setObjectiveClass()", "widenWires", "PerformanceObjective" ),
list( "setObjectiveClass()", "@minimizeSignalDiffusion", "PerformanceObjective" ),
list( "setObjectiveClass()", "@minimizePowerDiffusion", "PerformanceObjective" ),
list( "setObjectiveClass()", "moveContactsInPwrRails", "PerformanceObjective" ),
list( "setObjectiveClass()", "growContactDiffusions", "PerformanceObjective" ),
list( "setObjectiveClass()", "@alignMosfetDiffusion", "PerformanceObjective" ),
list( "setObjectiveClass()", "@applyDistributedRuleP1", "PerformanceObjective" ),
list( "setObjectiveClass()", "@applyPreferredRuleP1", "PerformanceObjective" ),
list( "setObjectiveClass()", "@softPreserveEvenlyP1", "PerformanceObjective" ),
list( "setObjectiveClass()", "@softPreserveP1", "PerformanceObjective" ),
list( "setObjectiveClass()", "@applyDistributedRuleP2", "PerformanceObjective" ),
list( "setObjectiveClass()", "@applyPreferredRuleP2", "PerformanceObjective" ),
list( "setObjectiveClass()", "@softPreserveEvenlyP2", "PerformanceObjective" ),
list( "setObjectiveClass()", "@softPreserveP2", "PerformanceObjective" ),
list( "setObjectiveClass()", "@applyDistributedRuleP3", "PerformanceObjective" ),
list( "setObjectiveClass()", "@applyPreferredRuleP3", "PerformanceObjective" ),
list( "setObjectiveClass()", "@softPreserveEvenlyP3", "PerformanceObjective" ),
list( "setObjectiveClass()", "@softPreserveP3", "PerformanceObjective" ),
list( "setObjectiveClass()", "@applyDistributedRuleP4", "PerformanceObjective" ),
list( "setObjectiveClass()", "@applyPreferredRuleP4", "PerformanceObjective" ),
list( "setObjectiveClass()", "@softPreserveEvenlyP4", "PerformanceObjective" ),
list( "setObjectiveClass()", "@softPreserveP4", "PerformanceObjective" ),
list( "setObjectiveClass()", "@applyDistributedRuleP5", "PerformanceObjective" ),
list( "setObjectiveClass()", "@applyPreferredRuleP5", "PerformanceObjective" ),
list( "setObjectiveClass()", "@softPreserveEvenlyP5", "PerformanceObjective" ),
list( "setObjectiveClass()", "@softPreserveP5", "PerformanceObjective" ),
list( "setObjectiveClass()", "minimizeWellJogs", "PerformanceObjective" ),
list( "setObjectiveClass()", "@alignEdges", "PerformanceObjective" ),
list( "setObjectiveClass()", "orientCovers", "PerformanceObjective" ),
list( "setObjectiveClass()", "preferredAsymmetricalExtension", "PerformanceObjective" ),
list( "setObjectiveClass()", "shrinkCovers", "PerformanceObjective" ),
list( "setObjectiveClass()", "@minimizeWireLength", "PerformanceObjective" ),
list( "setObjectiveClass()", "growContacts", "PerformanceObjective" ),
list( "setUseLocalPartitioning()", "growContacts" ),
list( "setObjectiveClass()", "growPorts", "PerformanceObjective" ),
list( "setUseLocalPartitioning()", "growPorts" ) ) );
/* END */

/* BEGIN DEFAULTS PostCompactionSteps */
defaultsDB->addDefaults( list( "PostCompactionSteps" ), list(
list( "applySteps", list( "Add Text for METAL1 Port",
            "Add Text for METAL2 Port*",
            "Add Text for VDD Power Rail*",
            "Add Text for VSS Power Rail*",
            "Add Text for Cell Name*",
            "Add Implants",
            "Fill Notches",
            "Merge Shapes",
            "Translate For Export" ) ) ) );
/* END */

/* BEGIN DEFAULTS Measure */
defaultsDB->addDefaults( list( "Measure" ), list(
list( "secondaryQualityMetrics", list(  ) ) ) );
/* END */

/* BEGIN DEFAULTS Migrate-ATL */
defaultsDB->addDefaults( list( "Migrate-ATL" ), list(
list( "cellOptimalityCriteria", list(  ) ),
list( "saveBetweenSteps", 0 ) ) );
/* END */

/* BEGIN DEFAULTS ATL */
defaultsDB->addDefaults( list( "ATL" ), list(
list( "cellOptimalityCriteria", list(  ) ),
list( "saveBetweenSteps", 0 ) ) );
/* END */

/* BEGIN DEFAULTS Export */
defaultsDB->addDefaults( list( "Export" ), list(
list( "exporters", list( list( "GDSII", list( "fileName", "<cellName>" ), list( "fileExtension", "gds" ) ) ) ) ) );
/* END */

/* BEGIN DEFAULTS CellRouter */
defaultsDB->addDefaults( list( "CellRouter" ), list(
list( "setWireCosts()", "P-ACT Wire", 300, 30 ),
list( "setWireCosts()", "N-ACT Wire", 300, 30 ),
list( "setWireCosts()", "POLY Wire", 5, 5 ),
list( "setWireCosts()", "METAL1 Wire", 7, 7 ),
list( "setWireCosts()", "P-STRAP Wire", INFINITY, INFINITY ),
list( "setWireCosts()", "N-STRAP Wire", INFINITY, INFINITY ),
list( "setWireCosts()", "GATE Wire", INFINITY, INFINITY ),
list( "setWireCosts()", "METAL2 Wire", 300, 100 ),
list( "setWireCosts()", "METAL3 Wire", INFINITY, INFINITY ),
list( "setContactCost()", "P-ACT Contact", 40 ),
list( "setContactCost()", "N-ACT Contact", 40 ),
list( "setContactCost()", "POLY Contact", 40 ),
list( "setContactCost()", "VIA1", 5 ),
list( "setPortCost()", "METAL1 Port", 25 ),
list( "setPortCost()", "METAL2 Port", 25 ),
list( "addRoutingStyle()", "cShaped", list( "@internal" ) ),
list( "addRoutingStyle()", "cShaped", list( "@output" ) ),
list( "addPenalty()", list( "Diffusion Jumpers on all nets",
            INFINITY,
            "@allTemplates",
            "@allNets",
            "@allRegions",
            "@diffusionJumper" ) ),
list( "addPenalty()", list( "Gate feedthroughs on all nets",
            50,
            "@allTemplates",
            "@allNets",
            "@allRegions",
            "@gateFeedthrough",
            3 ) ),
list( "addPenalty()", list( "Poly Jumpers on all nets",
            120,
            "@allTemplates",
            "@allNets",
            "@allRegions",
            "@polyJumper" ) ),
list( "addPenalty()", list( "Prevent N-ACT connections to the Substrate Tie Rail",
            INFINITY,
            list( "N-ACT Wire" ),
            list( "@vss" ),
            list( -0.0475, 0.0475 ),
            "@allScenarios" ) ),
list( "addPenalty()", list( "Prevent N-ACT contact connections near the Substrate Tie Rail",
            INFINITY,
            list( "N-ACT Contact" ),
            "@allNets",
            list( -0.045, 0.045 ),
            "@allScenarios" ) ),
list( "addPenalty()", list( "Prevent P-ACT connections to the Well Tie Rail",
            INFINITY,
            list( "P-ACT Wire" ),
            list( "@vdd" ),
            list( 2.4225, 2.5175 ),
            "@allScenarios" ) ),
list( "addPenalty()", list( "Prevent P-ACT contact connections near the Well Tie Rail",
            INFINITY,
            list( "P-ACT Contact" ),
            "@allNets",
            list( 2.425, 2.515 ),
            "@allScenarios" ) ),
list( "addPenalty()", list( "`METAL1 Wire' on horizontal power nets",
            93,
            list( "METAL1 Wire" ),
            list( "@vdd", "@vss" ),
            "@horizontal",
            "@allRegions",
            "@allScenarios" ) ),
list( "addPenalty()", list( "`METAL1 Wire' on vertical power nets",
            3,
            list( "METAL1 Wire" ),
            list( "@vdd", "@vss" ),
            "@vertical",
            "@allRegions",
            "@allScenarios" ) ),
list( "addPenalty()", list( "`METAL2 Wire' on power nets",
            INFINITY,
            list( "METAL2 Wire" ),
            list( "@vdd", "@vss" ),
            "@allRegions",
            "@allScenarios" ) ),
list( "addPenalty()", list( "`N-ACT Wire' on horizontal signal and port nets",
            INFINITY,
            list( "N-ACT Wire" ),
            list( "@port", "@internal" ),
            "@horizontal",
            "@allRegions",
            "@allScenarios" ) ),
list( "addPenalty()", list( "`N-ACT Wire' on vertical signal and port nets",
            25,
            list( "N-ACT Wire" ),
            list( "@port", "@internal" ),
            "@vertical",
            "@allRegions",
            "@allScenarios" ) ),
list( "addPenalty()", list( "`P-ACT Wire' on horizontal signal and port nets",
            INFINITY,
            list( "P-ACT Wire" ),
            list( "@port", "@internal" ),
            "@horizontal",
            "@allRegions",
            "@allScenarios" ) ),
list( "addPenalty()", list( "`P-ACT Wire' on vertical signal and port nets",
            25,
            list( "P-ACT Wire" ),
            list( "@port", "@internal" ),
            "@vertical",
            "@allRegions",
            "@allScenarios" ) ),
list( "addPenalty()", list( "`POLY Wire' on power nets",
            INFINITY,
            list( "POLY Wire" ),
            list( "@vdd", "@vss" ),
            "@allRegions",
            "@allScenarios" ) ) ) );
/* END */

/* BEGIN DEFAULTS MigrateGDS */
defaultsDB->addDefaults( list( "MigrateGDS" ), list(
list( "saveBetweenSteps", 0 ) ) );
/* END */


//********** #### REGISTER CUSTOM DEFAULTS HERE #### **********


//************ REGISTERING EXPORTER TEMPLATES ************
/* BEGIN EXPORTER Layout@GDSII */
template = loadFromPath( "GDSII.al", 0, "exporters" )( exporterDB );
/* BEGIN CUSTOM SETUP */
/* END CUSTOM SETUP EXPORTER GDSII */
exporterDB->registerTemplate( template, "Layout", "GDSII" );
/* END */

/* BEGIN EXPORTER Layout@PLib */
template = loadFromPath( "exportPLibLEF.al", 0, "exporters" )( exporterDB );
/* BEGIN CUSTOM SETUP */
/* END CUSTOM SETUP EXPORTER PLib */
exporterDB->registerTemplate( template, "Layout", "PLib" );
/* END */

/* BEGIN EXPORTER Layout@Netlist */
template = loadFromPath( "exportNetlist.al", 0, "exporters" )( exporterDB );
/* BEGIN CUSTOM SETUP */
/* END CUSTOM SETUP EXPORTER Netlist */
exporterDB->registerTemplate( template, "Layout", "Netlist" );
/* END */

/* BEGIN EXPORTER Layout@Milkyway */
template = loadFromPath( "milkyway.al", 0, "exporters" )( exporterDB );
/* BEGIN CUSTOM SETUP */
/* END CUSTOM SETUP EXPORTER Milkyway */
exporterDB->registerTemplate( template, "Layout", "Milkyway" );
/* END */


//********** #### REGISTER CUSTOM EXPORTER TEMPLATES HERE #### **********


//************ REGISTERING LAYOUTSTYLEDB RULES ************
/* BEGIN RULE P-ACT Contact used on power nets */
layoutStyleDB->addContactRule( "P-ACT Contact used on power nets",
                               "P-ACT Contact",
                               list( list( "unlockCompactionCovers", list(  ) ),
                                     list( "unlockCovers", list( "P-ACT" ) ) ),
                               list( "@netType==@power" ) );
/* END */

/* BEGIN RULE N-ACT Contact used on power nets */
layoutStyleDB->addContactRule( "N-ACT Contact used on power nets",
                               "N-ACT Contact",
                               list( list( "unlockCompactionCovers", list(  ) ),
                                     list( "unlockCovers", list( "N-ACT" ) ) ),
                               list( "@netType==@power" ) );
/* END */

/* BEGIN RULE POLY Contact used on power nets */
layoutStyleDB->addContactRule( "POLY Contact used on power nets",
                               "POLY Contact",
                               list( list( "unlockCompactionCovers", list(  ) ),
                                     list( "unlockCovers", list(  ) ) ),
                               list( "@netType==@power" ) );
/* END */

/* BEGIN RULE VIA1 used on power nets */
layoutStyleDB->addContactRule( "VIA1 used on power nets",
                               "VIA1",
                               list( list( "unlockCompactionCovers", list(  ) ),
                                     list( "unlockCovers", list(  ) ) ),
                               list( "@netType==@power" ) );
/* END */


//********** #### REGISTER CUSTOM LAYOUTSTYLEDB RULES HERE #### **********

/* BEGIN DESIGNPOINTTAGS */
p->addDesignPointTag( "SymbolicLayout", "Candidate Placement", 140, 0, 240 );
p->addDesignPointTag( "SymbolicLayout", "Placement 1", 140, 60, 240 );
p->addDesignPointTag( "SymbolicLayout", "Placement 2", 140, 100, 240 );
p->addDesignPointTag( "SymbolicLayout", "Placement 3", 140, 140, 240 );
p->addDesignPointTag( "SymbolicLayout", "Placement 4", 140, 180, 240 );
p->addDesignPointTag( "SymbolicLayout", "Placement 5", 140, 220, 240 );
p->addDesignPointTag( "SymbolicLayout", "Incomplete Route", 0, 220, 254 );
p->addDesignPointTag( "SymbolicLayout", "Completed Route", 0, 100, 254 );
p->addDesignPointTag( "SymbolicLayout", "Incomplete Compaction", 0, 190, 0 );
p->addDesignPointTag( "SymbolicLayout", "Completed Compaction", 0, 120, 0 );
p->addDesignPointTag( "SymbolicLayout", "Incomplete Import", 255, 0, 255 );
p->addDesignPointTag( "SymbolicLayout", "Completed Import", 220, 0, 220 );
p->addDesignPointTag( "Layout", "Finalized Layout", 255, 128, 0 );
p->addDesignPointTag( "SymbolicLayout", "Alternate Alignment", 196, 196, 16 );
p->addDesignPointTag( "SymbolicLayout", "Clone Reference", 200, 10, 10 );
/* END */

/* BEGIN WRAPUP */
p->verify();
p;
/* END */

}
