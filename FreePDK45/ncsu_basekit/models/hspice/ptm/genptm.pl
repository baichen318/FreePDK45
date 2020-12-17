#!/usr/bin/perl

  $type = $ARGV[0];
  print " Type $ARGV[0]\n" ;
  
  $sub_type = $ARGV[1];
  print "Sub Type $ARGV[1]\n" ;
  
  $leff_d = $ARGV[2];
  print " leff_d $ARGV[2]\n" ;
  
  $leffvar_d = $ARGV[3];
  print " leffvar_d $ARGV[3]\n" ;
  
  $vth_d = $ARGV[4];
  print " vth_d $ARGV[4]\n" ;
  
  $vthvar_d = $ARGV[5];
  print " vthvar_d $ARGV[5]\n" ;
  
  $vdd_d = $ARGV[6];
  print " vdd_d $ARGV[6]\n" ;
  
  $tox_d = $ARGV[7];
  print " tox_d $ARGV[7]\n" ;
  
  $rdsw_d = $ARGV[8];
  print " rdsw_d $ARGV[8]\n" ;
 
#$type="PMOS"; 
#$leff_d=12.6;
#$leffvar_d=10; 
#$vth_d=0.16; $vthvar_d=30; $vdd_d=0.9; $tox_d=1.0; $rdsw_d=150;

# technology independent constants
$qe=1.60217653*10**(-19); $kb=1.3806505*10**(-23); $ni=1.45*10**16;
$Tr=300; $vt=$kb*$Tr/$qe; $e0=8.854187817*10**(-12);

$esi=11.7; $nsd= 2*10**26; $ng= 2*10**26;
$dsub=0.1; $dvt0=1; $dvt1=2; $cdsc=0; $cdscd=0; $delta=0.01;

$IVrand = int(rand(100000));

    
    #$node =$values{"node"};
    $node = 45;

    $leff_post = ($values{"Leff"} || $leff_d);
    $leffvar_post = ($values{"Leffvar"} || $leffvar_d);
    $vth_post  = ($values{"Vth"} || $vth_d);
    $vthvar_post = ($values{"Vthvar"} || $vthvar_d);
    $vdd_post  = ($values{"Vdd"} || $vdd_d);
    $tox_post = ($values{"Tox"} || $tox_d);
    $rdsw_post = ($values{"Rdsw"} || $rdsw_d);

    $leff = $leff_post*10**(-9);
    $leffvar = $leffvar_post/100;
    if ($type eq "PMOS") { $vth = $vth_post*(-1); }
    else { $vth = $vth_post; }
    $vthvar = $vthvar_post/1000;
    $vdd  = $vdd_post;
    $tox = $tox_post*10**(-9);
    $rdsw = $rdsw_post;

    $leff_f=$leff*(1-$leffvar);
    $leff_s=$leff*(1+$leffvar);
    $vth_f=(-1)*$vthvar;
    $vth_s=(+1)*$vthvar;

    if ($type eq "NMOS") {
       $ua=0.6*10**(-9); $ub=1.2*10**(-18); $va=30; $voff=-0.13; 
       
            $lgate=25*10**(-9); $w=10**(-6); $eox=3.9; $eta0=0.0049; $nfactor=2.1; $dox=0.65*10**(-9);
            $cgso=1.1*10**(-10); $cgdo=1.1*10**(-10); $xl=-20*10**(-9); $wint=5*10**(-9);
            $vsat = 147390;
       }
    elsif ($type eq "PMOS") {
       $ua=2*10**(-9); $ub=0.5*10**(-18); $va=10; $voff=-0.126;
            
           $lgate=25*10**(-9); $w=10**(-6); $eox=3.9; $eta0=0.0049; $nfactor=2.1; $dox=0.75*10**(-9);
            $cgso=1.1*10**(-10); $cgdo=1.1*10**(-10); $xl=-20*10**(-9); $wint=5*10**(-9);
            $vsat = 70000;
      }

                    
    $cox=$eox*$e0/($tox+$dox);
    $nch=&NchCalculation($leff, $vth);
    $nch = int($nch/10**22)*10**22;
    &IVGeneration();

    $vth_s=$vth0+$vth_s;
    $nch_s=&NchCorner($vth_s);
    $nch_s=int($nch_s/10**22)*10**22;
    $vth_f=$vth0+$vth_f;
    $nch_f=&NchCorner($vth_f);
    $nch_f=int($nch_f/10**22)*10**22;

    &ModelGeneration();
   # &IVPlot();
   # &OutputFormat();

sub NchCorner
{
   local($vth0_local, $vth0i, $nch_local);

   $vth0_local=$_[0];
   $vth0i=0.3;
   $nch_local=5*10**24;
   while ( ($vth0i-$vth0_local)**2 > ($vth0_local*0.0002)**2 )
   {
       $phins_local=2*$vt*log($nch_local/$ni);
       $vfb_local=-0.555-$phins_local/2;
       $vbi_local=$vt*log($nch_local*$nsd/$ni/$ni);
       $qbm_local=-1*(2*$qe*$e0*$esi*$nch_local*$phins_local)**0.5;
       $vth0i=$vfb_local+$phins_local-1*$qbm_local/$cox;

$nch_local = $nch_local*exp((-1)*($vth0i-$vth0_local)/$vth0_local);

   }
   return $nch_local;
}


sub NchCalculation
{
   local($leff_local, $vth_local, $nch_local, $vgs, $vds, $vbs, $Isub, $Isubi);

   $leff_local = $_[0];
   $vth_local  = $_[1];

# reverse nch from vth
$nch_local=5*10**24;
$Isubi=1;
if ( $type eq "NMOS" ) {
    $Isub=10**(-7)*$w/$leff_local;
}
else {
    $Isub=6*10**(-8)*$w/$leff_local;
}
$vgs=$vth_local;
$vds=$vdd;
$vbs=0;

while ( ($Isubi-$Isub)**2 > ($Isub*0.0002)**2 )
{
    $k1=(2*$esi*$e0*$qe*$nch_local)**0.5/$cox;
    $phins=2*$vt*log($nch_local/$ni);
    $vfb=-0.555-$phins/2;
    $vbi=$vt*log($nch_local*$nsd/$ni/$ni);
    $qbm=-1*(2*$qe*$e0*$esi*$nch_local*$phins)**0.5;
    $vth0=$vfb+$phins-1*$qbm/$cox;
    $xdep=(2*$e0*$esi*($phins-$vbseff)/$qe/$nch_local)**0.5;
    $vbc=0.9*($phins-$k1**2/4/0.05**2);
    $vbseff1=$vbc+0.5*($vbs-$vbc-0.001+(($vbs-$vbc-0.001)**2-0.004*$vbc)**0.5);
    $vbseff=0.95*$phins-0.5*(0.95*$phins-$vbseff1-0.001+((0.95*$phins-$vbseff1-0.001)**2+4*0.001*0.95*$phins)**0.5);
    $lt=($esi*$e0*$xdep/$cox)**0.5;
    $xdep0=(2*$e0*$esi*$phins/$qe/$nch_local)**0.5;
    $lt0=($esi*$e0*$xdep0/$cox)**0.5;

    $coshf1=(exp($dvt1*$leff_local/$lt)+exp((-1)*$dvt1*$leff_local/$lt))/2;
    $coshf2=(exp($dsub*$leff_local/$lt0)+exp((-1)*$dsub*$leff_local/$lt0))/2;

    $vth_local=$vth0-$dvt0*(0.5/($coshf1-1))*($vbi-$phins)-$eta0*$vds*(0.5/($coshf2-1));

    $n=1+$nfactor*$e0*$esi/$xdep/$cox+(0.5/($coshf1-1))*($cdsc+$cdscd*$vds)/$cox;

    $a0=1;
    $xj=$leff_local*0.8;
    $abulk=1+$k1/2*$a0*($leff_local/($leff_local+2*($xj*$xdep)**0.5));

# calculate effective mobility
    if ($type eq "NMOS") {
        $u0=0.115*exp(-5.34*10**(-10)*($nch_local/10**6)**0.5);
    }
    else {
        $u0=0.0317*exp(-1.25*10**(-9)*($nch_local/10**6)**0.5);
    }
    $vgse=$vfb+$phins+($qe*$esi*$e0*$ng*($tox+$dox)**2)/($eox**2*$e0**2)*((1+(2*$eox**2*$e0**2*($vgs-$vfb-$phins))/($qe*$esi*$e0*$ng*($tox+$dox)**2))**0.5-1);
    $vgst=$n*$vt*log(1+exp(($vgse-$vth_local)/(2*$n*$vt)))/(0.5+$n*$cox*(2*$phins/($qe*$nch_local*$esi*$e0))**0.5*exp(($vgse-$vth_local-2*$voff)/(-2*$n*$vt)));
    if ($u0 > 0.001)
    {
        $ueff=$u0/(1+$ua*(($vgst+2*$vth_local)/($tox+$dox))+$ub*(($vgst+2*$vth_local)/($tox+$dox))**2);
    }
    else
    {
        $ueff=0.001/(1+$ua*(($vgst+2*$vth_local)/($tox+$dox))+$ub*(($vgst+2*$vth_local)/($tox+$dox))**2);
    }
# calculate rds
    $rds=$rdsw/10**6/$w;

#    $vsat=2.48*10**5*$ueff**0.34+0.13*$ueff*((0.32*10**(-12))*$ueff*$vt)**0.5*$vgst/($leff_local**2);

# calculate vdsat
    $esat=2*$vsat/$ueff;
    $a=$abulk**2*$w*$vsat*$cox*$rds;
    $b=-1*(($vgst+2*$vt)+$abulk*$esat*$leff_local+3*$abulk*($vgst+2*$vt)*$w*$vsat*$cox*$rds);
    $c=($vgst+2*$vt)*$esat*$leff_local+2*(($vgst+2*$vt)**2)*$w*$vsat*$cox*$rds;
    $vdsat=(-1*$b-($b**2-4*$a*$c)**0.5)/(2*$a);

# calculate vdseff
    $vdseff=$vdsat-($vdsat-$vds-$delta+(($vdsat-$vds-$delta)**2+4*$delta*$vdsat)**0.5)/2;

# calculate Ids
    $coxeff=$eox*$e0/($tox);
    $beta=$ueff*$coxeff*$w/$leff_local;
    $Isubi=$beta*$vgst*(1-$vdseff/(2*(($vgst+2*$vt)/$abulk)))*$vdseff/(1+$vdseff/($esat*$leff_local));

$vth0=int($vth0*1000)/1000;

    $diff=($Isubi-$Isub)/$Isub;
    if ( ($nch_local*exp($diff/20)) > 10**26 )
    {
        $nch_local = 10**26;
    }
    elsif ( ($nch_local*exp($diff/20)) < 10**22 )
    {
        $nch_local= 10**22;
    }
    else
    {
        $nch_local = $nch_local*exp($diff/20);
    }
}
return $nch_local;
}

sub IVGeneration
{
    local($Vgs, $Vds, $i_vgs, $i_vds, $N_vgs, $N_vds);

    $vbs=0; 
    $k1=(2*$esi*$e0*$qe*$nch)**0.5/$cox;
    $phins=2*$vt*log($nch/$ni);
    $vfb=-0.555-$phins/2;
    $vbi=$vt*log($nch*$nsd/$ni/$ni);
    $qbm=-1*(2*$qe*$e0*$esi*$nch*$phins)**0.5;
    $vth0=$vfb+$phins-1*$qbm/$cox;
    $xdep=(2*$e0*$esi*($phins-$vbseff)/$qe/$nch)**0.5;
    $vbc=0.9*($phins-$k1**2/4/0.05**2);
    $vbseff1=$vbc+0.5*($vbs-$vbc-0.001+(($vbs-$vbc-0.001)**2-0.004*$vbc)**0.5);
    $vbseff=0.95*$phins-0.5*(0.95*$phins-$vbseff1-0.001+((0.95*$phins-$vbseff1-0.001)**2+4*0.001*0.95*$phins)**0.5);
    $lt=($esi*$e0*$xdep/$cox)**0.5;
    $xdep0=(2*$e0*$esi*$phins/$qe/$nch)**0.5;
    $lt0=($esi*$e0*$xdep0/$cox)**0.5;

    $coshf1=(exp($dvt1*$leff/$lt)+exp((-1)*$dvt1*$leff/$lt))/2;
    $coshf2=(exp($dsub*$leff/$lt0)+exp((-1)*$dsub*$leff/$lt0))/2;

    $vth0 = int($vth0*1000)/1000;

    system "/bin/rm ./doc/IVdata.out"; 
    $FileOut = ">./doc/IVdata.out";
    open(IVOut, $FileOut);

    $N_vgs=5; 
    $N_vds=40;
    $Vgs=$vdd/$N_vgs;

    for ($i_vgs=1; $i_vgs<($N_vgs+1); $i_vgs++)
    {
        $Vds=0;
        for ($i_vds=0; $i_vds<($N_vds+1); $i_vds++)
        {
            $vth=$vth0+$k1*(($phins-$vbseff)**0.5-$phins**0.5)-$dvt0*(0.5/($coshf1-1))*($vbi-$phins)-$eta0*$Vds*(0.5/($coshf2-1));
            $vth = int($vth*1000)/1000; 
            
            $n=1+$nfactor*$e0*$esi/$xdep/$cox+(0.5/($coshf1-1))*($cdsc+$cdscd*$Vds)/$cox;

            $a0=1;
            $xj=$leff*0.8;
            $abulk=1+$k1/2*$a0*($leff/($leff+2*($xj*$xdep)**0.5));

# calculate effective mobility
            if ($type eq "NMOS") {
                $u0=0.115*exp(-5.34*10**(-10)*($nch/10**6)**0.5);
            }
            else {
                $u0=0.0317*exp(-1.25*10**(-9)*($nch/10**6)**0.5);
            }
            $vgse=$vfb+$phins+($qe*$esi*$e0*$ng*($tox+$dox)**2)/($eox**2*$e0**2)*((1+(2*$eox**2*$e0**2*($Vgs-$vfb-$phins))/($qe*$esi*$e0*$ng*($tox+$dox)**2))**0.5-1);
            $vgst=$n*$vt*log(1+exp(($vgse-$vth)/(2*$n*$vt)))/(0.5+$n*$cox*(2*$phins/($qe*$nch*$esi*$e0))**0.5*exp(($vgse-$vth-2*$voff)/(-2*$n*$vt)));
            $ueff=$u0/(1+$ua*(($vgst+2*$vth)/($tox+$dox))+$ub*(($vgst+2*$vth)/($tox+$dox))**2);

# calculate rds
            $rds=$rdsw/10**6/$w;

#            $vsat=2.48*10**5*$ueff**0.34+0.13*$ueff*((0.32*10**(-12))*$ueff*$vt)**0.5*$vgst/($leff**2);

# calculate vdsat
            $esat=2*$vsat/$ueff;
            $a=$abulk**2*$w*$vsat*$cox*$rds;
            $b=-1*(($vgst+2*$vt)+$abulk*$esat*$leff+3*$abulk*($vgst+2*$vt)*$w*$vsat*$cox*$rds);
            $c=($vgst+2*$vt)*$esat*$leff+2*(($vgst+2*$vt)**2)*$w*$vsat*$cox*$rds;
            $vdsat=(-1*$b-($b**2-4*$a*$c)**0.5)/(2*$a);

# calculate vdseff
            $vdseff=$vdsat-($vdsat-$Vds-$delta+(($vdsat-$Vds-$delta)**2+4*$delta*$vdsat)**0.5)/2;

# calculate Ids
            $coxeff=$eox*$e0/($tox);
            $beta=$ueff*$coxeff*$w/$leff;
            $Idso=$beta*$vgst*(1-$vdseff/(2*(($vgst+2*$vt)/$abulk)))*$vdseff/(1+$vdseff/($esat*$leff));

            if ($Idso > 0)
            {
                $Ids=($Idso/(1+$rds*$Idso/$vdseff))*(1+($Vds-$vdsat)/$va)*10**6;
            }
            else
            {
                $Ids = 0;
            }

            print IVOut $Vds." ".$Ids."\n";
            $Vds=$Vds+$vdd/$N_vds;
        }
        print IVOut "\n";
        $Vgs=$Vgs+$vdd/$N_vgs;
    }
    close (IVOut);
}

sub ParGeneration
{

    local($lint_local, $vth0_local, $k1_local, $u0_local, $vsat_local, $xj_local, $leff_local, $nch_local);

    $leff_local=$_[0];
    $nch_local=$_[1];

# generate parameters for the nominal and corner cases, including lint, vth0, k1, u0, vsat, ndep, and xj

    $lint_local=($lgate-$leff_local)/2;

    $phins=2*$vt*log($nch_local/$ni);
    $vfb=-0.555-$phins/2;
    $vbi=$vt*log($nch_local*$nsd/$ni/$ni);
    $qbm=-1*(2*$qe*$e0*$esi*$nch_local*$phins)**0.5;
    $vth0_local=$vfb+$phins-1*$qbm/$cox;

    $vbs=0;
    $k1_local=(2*$esi*$e0*$qe*$nch_local)**0.5/$cox;

    $xdep=(2*$e0*$esi*($phins-$vbseff)/$qe/$nch_local)**0.5;
    $vbc=0.9*($phins-$k1_local**2/4/0.05**2);
    $vbseff1=$vbc+0.5*($vbs-$vbc-0.001+(($vbs-$vbc-0.001)**2-0.004*$vbc)**0.5);
    $vbseff=0.95*$phins-0.5*(0.95*$phins-$vbseff1-0.001+((0.95*$phins-$vbseff1-0.001)**2+4*0.001*0.95*$phins)**0.5);
    $lt=($esi*$e0*$xdep/$cox)**0.5;
    $xdep0=(2*$e0*$esi*$phins/$qe/$nch_local)**0.5;
    $lt0=($esi*$e0*$xdep0/$cox)**0.5;

    $coshf1=(exp($dvt1*$leff_local/$lt)+exp((-1)*$dvt1*$leff_local/$lt))/2;
    $coshf2=(exp($dsub*$leff_local/$lt0)+exp((-1)*$dsub*$leff_local/$lt0))/2;

    $vth0_local = int($vth0_local*1000)/1000;

    $vth=$vth0_local+$k1_local*(($phins-$vbseff)**0.5-$phins**0.5)-$dvt0*(0.5/($coshf1-1))*($vbi-$phins)-$eta0*$vdd*(0.5/($coshf2-1));

    $n=1+$nfactor*$e0*$esi/$xdep/$cox+(0.5/($coshf1-1))*($cdsc+$cdscd*$vdd)/$cox;

    $a0=1;
    $xj_local=$leff_local*0.8;
    $abulk=1+$k1_local/2*$a0*($leff_local/($leff_local+2*($xj_local*$xdep)**0.5));

# calculate effective mobility
    if ($type eq "NMOS") {
        $u0_local=0.115*exp(-5.34*10**(-10)*($nch_local/10**6)**0.5);
    }
    else {
        $u0_local=0.0317*exp(-1.25*10**(-9)*($nch_local/10**6)**0.5);
    }
    $vgse=$vfb+$phins+($qe*$esi*$e0*$ng*($tox+$dox)**2)/($eox**2*$e0**2)*((1+(2*$eox**2*$e0**2*($vdd-$vfb-$phins))/($qe*$esi*$e0*$ng*($tox+$dox)**2))**0.5-1);
    $vgst=$n*$vt*log(1+exp(($vgse-$vth)/(2*$n*$vt)))/(0.5+$n*$cox*(2*$phins/($qe*$nch_local*$esi*$e0))**0.5*exp(($vgse-$vth-2*$voff)/(-2*$n*$vt)));
    $ueff=$u0_local/(1+$ua*(($vgst+2*$vth)/($tox+$dox))+$ub*(($vgst+2*$vth)/($tox+$dox))**2);

#    $vsat_local=2.48*10**5*$ueff**0.34+0.13*$ueff*((0.32*10**(-12))*$ueff*$vt)**0.5*$vgst/($leff_local**2);
    $vsat_local = $vsat;

    return ($lint_local, $vth0_local, $k1_local, $u0_local, $vsat_local, $xj_local);
}

sub ModelGeneration
{
    system "/bin/rm ./doc/*bulk*.pm";

    ($lint, $vth0, $k1, $u0, $vsat, $xj)=&ParGeneration($leff, $nch);
    ($lint_s, $vth0_s, $k1_s, $u0_s, $vsat_s, $xj_s)=&ParGeneration($leff_s, $nch_s);
    $vsat_s=$vsat;
    ($lint_f, $vth0_f, $k1_f, $u0_f, $vsat_f, $xj_f)=&ParGeneration($leff_f, $nch_f);
    $vsat_f=$vsat;

    if ($type eq "PMOS") {
        $vth0 = (-1)*$vth0;
        $vth0_s = (-1)*$vth0_s;
        $vth0_f = (-1)*$vth0_f;
        $spicetype = "pmos";
    }
    else { $spicetype = "nmos"; }

    system "/bin/rm ./doc/model_fore*";

    $FileOut=">./doc/model_fore";
    open(Out, $FileOut);

    print Out "* Customized PTM ".$node." ".$type." ".$sub_type."\n\n";
    print Out ".model  ".$sub_type."  ".$spicetype."  level = 54\n\n";
    print Out "+version = 4.0    binunit = 1    paramchk= 1    mobmod  = 0\n";
    print Out "+capmod  = 2      igcmod  = 1    igbmod  = 1    geomod  = 1\n";
    print Out "+diomod  = 1      rdsmod  = 0    rbodymod= 1    rgatemod= 1\n";
    print Out "+permod  = 1      acnqsmod= 0    trnqsmod= 0\n";

    print Out "\n* parameters related to the technology node\n";
    print Out "+tnom = ".($Tr-273)."    epsrox = ".$eox."\n";
    print Out "+eta0 = ".$eta0."    nfactor = ".$nfactor."    wint = ".$wint."\n";
    print Out "+cgso = ".$cgso."    cgdo = ".$cgdo."    xl = ".$xl."\n";

    print Out "\n* parameters customized by the user\n";
    print Out "+toxe = ".($tox+$dox)."    toxp = ".$tox."    toxm = ".($tox+$dox)."    toxref = ".($tox+$dox)."\n";
    print Out "+dtox = ".$dox."    lint = ".$lint."\n";
    print Out "+vth0 = ".$vth0."    k1 = ".(int($k1*1000)/1000)."    u0 = ".(int($u0*10**5)/10**5)."    vsat = ".(int($vsat))."\n";
    print Out "+rdsw = ".$rdsw."    ndep = ".($nch/10**6)."    xj = ".$xj."\n\n";

    close (Out);

    #system "/bin/cat ./doc/model_fore ".$type."_last > ./doc/".$node."_".$type."_bulk".$IVrand.".pm";
    system "/bin/cat ./doc/model_fore ".$type."_last > ./doc/".$sub_type.".inc";

    $FileOut=">./doc/model_fore_ss";
    open(Out, $FileOut);

    print Out "* Customized PTM ".$node." ".$type.": ss\n\n";
    print Out ".model  ".$sub_type."  ".$spicetype."  level = 54\n\n";
    print Out "+version = 4.0    binunit = 1    paramchk= 1    mobmod  = 0\n";
    print Out "+capmod  = 2      igcmod  = 1    igbmod  = 1    geomod  = 1\n";
    print Out "+diomod  = 1      rdsmod  = 0    rbodymod= 1    rgatemod= 1\n";
    print Out "+permod  = 1      acnqsmod= 0    trnqsmod= 0\n";

    print Out "\n* parameters related to the technology node\n";
    print Out "+tnom = ".($Tr-273)."    epsrox = ".$eox."\n";
    print Out "+eta0 = ".$eta0."    nfactor = ".$nfactor."    wint = ".$wint."\n";
    print Out "+cgso = ".$cgso."    cgdo = ".$cgdo."    xl = ".$xl."\n";

    print Out "\n* parameters customized by the user\n";
    print Out "+toxe = ".($tox+$dox)."    toxp = ".$tox."    toxm = ".($tox+$dox)."    toxref = ".($tox+$dox)."\n";
    print Out "+dtox = ".$dox."    lint = ".$lint_s."\n";
    print Out "+vth0 = ".$vth0_s."    k1 = ".(int($k1_s*1000)/1000)."    u0 = ".(int($u0_s*10**5)/10**5)."    vsat = ".(int($vsat_s))."\n";
    print Out "+rdsw = ".$rdsw."    ndep = ".($nch_s/10**6)."    xj = ".$xj_s."\n\n";

    close (Out);

    #system "/bin/cat ./doc/model_fore_ss ".$type."_last > ./doc/".$node."_".$type."_bulk".$IVrand."_ss.pm";
    system "/bin/cat ./doc/model_fore_ss ".$type."_last > ./doc/".$sub_type.".ss.inc";

    $FileOut=">./doc/model_fore_ff";
    open(Out, $FileOut);

    print Out "* Customized PTM ".$node." ".$type.": ff\n\n";
    print Out ".model  ".$sub_type."  ".$spicetype."  level = 54\n\n";
    print Out "+version = 4.0    binunit = 1    paramchk= 1    mobmod  = 0\n";
    print Out "+capmod  = 2      igcmod  = 1    igbmod  = 1    geomod  = 1\n";
    print Out "+diomod  = 1      rdsmod  = 0    rbodymod= 1    rgatemod= 1\n";
    print Out "+permod  = 1      acnqsmod= 0    trnqsmod= 0\n";

    print Out "\n* parameters related to the technology node\n";
    print Out "+tnom = ".($Tr-273)."    epsrox = ".$eox."\n";
    print Out "+eta0 = ".$eta0."    nfactor = ".$nfactor."    wint = ".$wint."\n";
    print Out "+cgso = ".$cgso."    cgdo = ".$cgdo."    xl = ".$xl."\n";

    print Out "\n* parameters customized by the user\n";
    print Out "+toxe = ".($tox+$dox)."    toxp = ".$tox."    toxm = ".($tox+$dox)."    toxref = ".($tox+$dox)."\n";
    print Out "+dtox = ".$dox."    lint = ".$lint_f."\n";
    print Out "+vth0 = ".$vth0_f."    k1 = ".(int($k1_f*1000)/1000)."    u0 = ".(int($u0_f*10**5)/10**5)."    vsat = ".(int($vsat_f))."\n";
    print Out "+rdsw = ".$rdsw."    ndep = ".($nch/10**6)."    xj = ".$xj_f."\n\n";

    close (Out);

    system "/bin/cat ./doc/model_fore_ff ".$type."_last > ./doc/".$sub_type.".ff.inc";
    #system "/bin/cat ./doc/model_fore_ff ".$type."_last > ./doc/".$node."_".$type."_bulk".$IVrand."_ff.pm";
}

sub IVPlot
{
    system "/bin/rm ./doc/plotlast";
    system "/bin/rm ./doc/plotspecs";

    $FileOut = ">./doc/plotlast";
    open(Plot, $FileOut);
    print Plot "plot \"./doc/IVdata\.out\" title '|Vgs|=".($vdd*5/5)."V,".($vdd*4/5)."V,".($vdd*3/5)."V,".($vdd*2/5)."V,".($vdd*1/5)."V' with lines\n";
    close (Plot);
    
    system "/bin/cat plotfore ./doc/plotlast > ./doc/plotspecs"; 
    system "/usr/local/bin/gnuplot < ./doc/plotspecs";
    system "/bin/rm ./doc/IV*.gif";

    $FileOut="> ./doc/ppmrunlast";
    open(OUT, $FileOut);
    print OUT "(/usr/local/netpbm/bin/ppmtogif /ud2/groups/ptm/www/cgi-bin/test/doc/IV.pbm > ./doc/IV".$IVrand.".gif) >& /dev/null\n";
    close (OUT); 
    system "/bin/cat ppmrunfore ./doc/ppmrunlast > ./doc/ppmrun";
    system "/usr/bin/csh ./doc/ppmrun";
}

sub CheckRange {
    if ( ($leff < 10*10**(-9)) || ($leff > 100*10**(-9)) ) { $check = 1; }
    elsif ( ($vth < 0.05) || ($vth > 0.6) ) { $check = 1; }
    elsif ( ($vdd < 0.3) || ($vdd > 1.8) ) { $check = 1; }
    else { $check = 0; }
}
