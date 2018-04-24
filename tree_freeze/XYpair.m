classdef XYpair
   properties
      x;
      y;
   end
   methods
      function sobj = smooth(obj,w)
         s = smooth_xy(obj.x,obj.y,w);
         sobj=obj;
         sobj.x=s.x;
         sobj.y=s.y;
      end
      function sobj = transpose(obj)
         sobj=obj;
         sobj.x=s.y;
         sobj.y=s.x;
      end
   end
end