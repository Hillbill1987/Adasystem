with Ada.Text_IO; use Ada.Text_IO;


package body Train with SPARK_MODE
is

   procedure trainon is
   begin
      if (Bosttrain.trainkey = absent) then
         Bosttrain.traingoing := on; Bosttrain.trainkey := present;
         Bosttrain.tdoors := open;
         end if;

   end trainon;

   procedure trainoff is
   begin
      if (Bosttrain.trainkey = present and Bosttrain.Tspeed = 0) then
         Bosttrain.traingoing := off; Bosttrain.trainkey := absent;
         Bosttrain.tdoors := closed;
         end if;
   end trainoff;

   procedure fillwater is
   begin
      if (Bosttrain.traingoing = off and Bosttrain.Tspeed = 0)then
         Bosttrain.WaterS := 100;
      end if;
   end fillwater;

   procedure addcarriage is
   begin
      if(Bosttrain.traingoing = off and Bosttrain.TrainCarriages < 5) then
         Bosttrain.TrainCarriages := Bosttrain.TrainCarriages + 1;
      end if;
   end addcarriage;

   procedure removecarriage is
   begin
      if(Bosttrain.traingoing = off and Bosttrain.TrainCarriages > 0) then
         Bosttrain.TrainCarriages := Bosttrain.TrainCarriages - 1;
      end if;
   end removecarriage;

   procedure addrods is
   begin
      if(Bosttrain.traingoing = off and Bosttrain.ControlR >= 0 and  Bosttrain.ControlR < 5 and Bosttrain.ReactorT >= 0
         and Bosttrain.ReactorT < 100 and Bosttrain.Epower >= 0 and Bosttrain.Epower <100) then
         Bosttrain.ControlR := Bosttrain.ControlR + 1;
      end if;
   end addrods;

   procedure removerods is
   begin
      if(Bosttrain.traingoing = off and Bosttrain.ControlR >= 1) then
         Bosttrain.ControlR := Bosttrain.ControlR - 1;
      end if;
   end removerods;


   procedure LocksDoors is
   begin
      if(Bosttrain.traingoing = on and Bosttrain.Tspeed > 50) then
         Bosttrain.doorslocked := locked;
      end if;
   end LocksDoors;


   procedure UnlockDoors is
   begin
      if(Bosttrain.traingoing = on and Bosttrain.Tspeed < 50) then
         Bosttrain.doorslocked := unlocked;
      end if;
      end UnlockDoors;
   -- procedures works --
   procedure Buildspeed is
   begin
      if(Bosttrain.traingoing = on and Bosttrain.ControlR >= 1  and Bosttrain.Tspeed >= 10 and Bosttrain.Tspeed < 91) then
         Bosttrain.Tspeed := Bosttrain.Tspeed + 10;
      end if;
   end Buildspeed;


   -- procedures works --
   procedure takingoff is
   begin
      if(Bosttrain.traingoing = on and Bosttrain.ControlR >= 1
         and Bosttrain.WaterS >= 1 and Bosttrain.Tspeed = 0) then
         Bosttrain.ReactorS := running; Bosttrain.Tspeed := Bosttrain.Tspeed + 10;
      end if;
      end takingoff;

   procedure reducespeed is
   begin
      if(Bosttrain.traingoing = on and Bosttrain.ControlR >= 1 and Bosttrain.Tspeed >= 10)
      then
         Bosttrain.Tspeed := Bosttrain.Tspeed  - 10;
      end if;
   end reducespeed;

   procedure emergencyS is
   begin
      if(Bosttrain.ReactorS = OverHeating or Bosttrain.WaterS <30) then
         Bosttrain.EmergencyS := on ; Bosttrain.Tspeed := 0; Bosttrain.traingoing := off;
      end if;
      end emergencyS;

   procedure checkRT is
   begin
      if(Bosttrain.ControlR >= 1 and Bosttrain.ControlR <= 2 and Bosttrain.ReactorT <= 70) then
         Bosttrain.ReactorT := Bosttrain.ReactorT + 30;
      else
         if(Bosttrain.ControlR >= 3 and Bosttrain.ControlR <= 4 and Bosttrain.ReactorT <= 70) then
            Bosttrain.ReactorT := Bosttrain.ReactorT + 20;
         else
              if (Bosttrain.ControlR = 5 and Bosttrain.ReactorT <= 70 ) then
               Bosttrain.ReactorT := Bosttrain.ReactorT + 10;
            end if;
         end if;
         end if;
   end checkRT;


   procedure checkEP is
   begin
      if(Bosttrain.ControlR >= 1 and Bosttrain.ControlR <= 2 and Bosttrain.Epower <= 60) then
         Bosttrain.Epower := Bosttrain.Epower + 10;
      else
         if(Bosttrain.ControlR >= 3 and Bosttrain.ControlR <= 2 and Bosttrain.Epower <= 60)then
            Bosttrain.Epower := Bosttrain.Epower + 20;
         else
            if(Bosttrain.ControlR = 5 and Bosttrain.Epower <=60) then
               Bosttrain.Epower := Bosttrain.Epower + 30;
            end if;
            end if;
      end if;
   end checkEP;

   procedure checkspeed is
   begin
      if(Bosttrain.traingoing = on and Bosttrain.TrainCarriages > 3 and Bosttrain.Tspeed >=15)then
         Bosttrain.Tspeed := Bosttrain.Tspeed - 15;
      end if;
   end checkspeed;

   procedure checkWater is
   begin
      if(Bosttrain.WaterS >= 0 and Bosttrain.WaterS < 50 and Bosttrain.ReactorT >  ReactorTemp'Last) then
         Bosttrain.ReactorT := Bosttrain.ReactorT + 1;
      end if;
   end checkWater;

   procedure reactorT is
   begin
      if(Bosttrain.ReactorT = 0 )then
         Bosttrain.ReactorS := off;
      else
         if(Bosttrain.ReactorT >=1 and Bosttrain.ReactorT <= 65) then
            Bosttrain.ReactorS := running;
         else
            if(Bosttrain.ReactorT >= 65) then
               Bosttrain.ReactorS := OverHeating;
            end if;
         end if;
      end if;
   end reactorT;


   procedure waterreduce is
   begin
      if(Bosttrain.WaterS > 0 and Bosttrain.WaterS <= 100) then
         Bosttrain.WaterS := Bosttrain.WaterS - 1;
      end if;
   end waterreduce;


   procedure TempIn is
   begin
      if(Bosttrain.ReactorT > 0 and Bosttrain.ReactorT < 100) then
         Bosttrain.ReactorT := Bosttrain.ReactorT + 1;
      end if;
   end TempIn;

   procedure ReactorMain is
   begin
      if(Bosttrain.traingoing = off and Bosttrain.Tspeed = 0) then
         Bosttrain.ReactorM := on;
      end if;
        end ReactorMain;


end Train;
