
package Train with SPARK_MODE
is
   type key is (absent,present);
   type TrainRunning is (on,off);
   type trainSpeed is range 0..100;
   type TrainDoors is (open,closed);
   type openclose is (open,close);
   type lockunlocked is (locked,unlocked);
   type Watersupply is range 0..100;
   type emergencystop is (on,off);
   type carriages is range 0..5;
   type controlrods is range 0..5;
   type electricitypower is range 0..100;
   type ReactorTemp is range 0..100;
   type ReactorStatus is (off,running,OverHeating);
   type ReactorMaintain is (off,on);


   type train is record
      trainkey : key;
      traingoing: TrainRunning;
      Tspeed : trainSpeed;
      tdoors : TrainDoors;
      doorsopen: openclose;
      doorslocked: lockunlocked;
      WaterS : Watersupply;
      EmergencyS : emergencystop;
      TrainCarriages: carriages;
      ControlR : controlrods;
      Epower : electricitypower;
      ReactorT : ReactorTemp;
      ReactorS : ReactorStatus;
      ReactorM : ReactorMaintain;
   end record;



   Bosttrain : train := (trainkey => absent,traingoing => off, tspeed => 0,
                         tdoors => open, doorsopen => open, doorslocked =>
                         unlocked,WaterS => 0, EmergencyS => off, TrainCarriages => 0,
                         ControlR => 0, Epower => 0, ReactorT => 0, ReactorS => off, ReactorM => off);




   procedure trainon with
     Global => (In_Out => Bosttrain),
     Pre => Bosttrain.trainkey = absent,
     Post => Bosttrain.traingoing = on and Bosttrain.trainkey = present and
     Bosttrain.tdoors = open;


   procedure trainoff with
     Global => (In_out => Bosttrain),
     Pre => Bosttrain.trainkey = present and Bosttrain.Tspeed = 0,
     Post => Bosttrain.traingoing = off and Bosttrain.trainkey =absent and
     Bosttrain.tdoors = closed;


   procedure fillwater with
     Global => (In_Out => Bosttrain),
     Pre => Bosttrain.traingoing = off and Bosttrain.Tspeed = 0,
     Post => Bosttrain.WaterS = 100;


    procedure addcarriage with
     Global => (in_out => Bosttrain),
     Pre => Bosttrain.traingoing = off and Bosttrain.TrainCarriages < 5,
     Post => Bosttrain.TrainCarriages = Bosttrain.TrainCarriages'Old + 1;


   procedure removecarriage with
     Global => (in_out => Bosttrain),
     Pre => Bosttrain.traingoing = off and Bosttrain.TrainCarriages > 1,
     Post => Bosttrain.TrainCarriages = Bosttrain.TrainCarriages'Old - 1;


   procedure addRods with
     Global => (in_out => Bosttrain),
     Pre => Bosttrain.traingoing = off and Bosttrain.ControlR >= 0 and  Bosttrain.ControlR < 5  and
     Bosttrain.ReactorT >= 10 and Bosttrain.ReactorT < 100 and Bosttrain.Epower >= 0 and Bosttrain.Epower <100,
     Post => Bosttrain.ControlR = Bosttrain.ControlR'old + 1;



   procedure removerods with
     Global => (in_out => Bosttrain),
     Pre => Bosttrain.traingoing = off and Bosttrain.ControlR >= 1 and Bosttrain.ControlR <= 5 and Bosttrain.Tspeed = 0 and
      Bosttrain.ReactorT >= 10 and Bosttrain.ReactorT  < 100 and Bosttrain.Epower >= 10 and Bosttrain.Epower <100,
     Post => Bosttrain.ControlR = Bosttrain.ControlR'old - 1;


   procedure LocksDoors with
     Global => (in_out => Bosttrain),
     Pre => Bosttrain.traingoing = on and Bosttrain.Tspeed > 50
     and Bosttrain.doorslocked = unlocked,
     Post => Bosttrain.doorslocked = locked;


   procedure UnlockDoors with
     Global => (in_out => Bosttrain),
     Pre => Bosttrain.traingoing = on and Bosttrain.Tspeed < 50
     and Bosttrain.doorslocked = locked,
     Post => Bosttrain.doorslocked = unlocked;


   procedure Buildspeed with
     Global => (in_out => Bosttrain),
     Pre => Bosttrain.traingoing = on and Bosttrain.ControlR >= 1 and Bosttrain.Tspeed >= 10 and  Bosttrain.Tspeed < 91,
     Post => Bosttrain.Tspeed = Bosttrain.Tspeed'Old  + 10;


   procedure reducespeed with
     Global => (in_out => Bosttrain),
     Pre => Bosttrain.traingoing = on and Bosttrain.ControlR > 1 and Bosttrain.Tspeed >= 10,
     Post => Bosttrain.Tspeed = Bosttrain.Tspeed'Old - 10;



   procedure takingoff with
     Global => (in_out => Bosttrain),
     Pre => Bosttrain.traingoing = on and Bosttrain.ControlR >= 1 and Bosttrain.WaterS >= 1  and Bosttrain.Tspeed = 0,
     Post =>  Bosttrain.ReactorS = running and Bosttrain.Tspeed = + 10;

     procedure reactorT with
     Global => (in_out => Bosttrain),
     Pre => Bosttrain.ReactorT > 70,
     Post => Bosttrain.ReactorS = OverHeating;

   procedure checkRT with
     Global => (in_out => Bosttrain),
     Pre => Bosttrain.traingoing = on and Bosttrain.ControlR = 1 and Bosttrain.ReactorT <= 70,
     Post => Bosttrain.ReactorT < ReactorTemp'last + 30;

     procedure checkEP with
       Global => (in_out => Bosttrain),
     Pre => Bosttrain.traingoing = on and Bosttrain.ControlR = 1 and Bosttrain.Epower <= 90,
     Post => Bosttrain.Epower < electricitypower'last + 10;

     procedure emergencyS with
     Global => (in_out => Bosttrain),
     Pre => Bosttrain.ReactorS = OverHeating or Bosttrain.WaterS < 30,
     Post => Bosttrain.EmergencyS = on and Bosttrain.Tspeed = 0 and Bosttrain.traingoing = off;


     procedure checkspeed with
     Global => (in_out => Bosttrain),
     Pre => Bosttrain.traingoing = on and Bosttrain.TrainCarriages > 3 and Bosttrain.Tspeed >= 15,
     Post => Bosttrain.Tspeed = Bosttrain.Tspeed'old - 15;

     procedure checkWater with
       Global => (in_out => Bosttrain),
     Pre =>Bosttrain.WaterS >= 0 and Bosttrain.WaterS < 50 and Bosttrain.ReactorT >= 1,
     Post => Bosttrain.ReactorT < ReactorTemp'last + 1;


   procedure waterreduce with
     Global => (in_out => Bosttrain),
     Pre => Bosttrain.WaterS > 0 and Bosttrain.WaterS <= 100,
     Post => Bosttrain.WaterS = Bosttrain.WaterS'old - 1;

   procedure TempIn with
     Global => (in_out => Bosttrain),
     Pre => Bosttrain.ReactorT > 0 and Bosttrain.ReactorT < 100,
     Post => Bosttrain.ReactorT = Bosttrain.ReactorT'old + 1;


   procedure ReactorMain with
     Global => (in_out => Bosttrain),
     Pre => Bosttrain.traingoing = off and Bosttrain.Tspeed = 0,
     Post => Bosttrain.ReactorM = on;










end Train;
