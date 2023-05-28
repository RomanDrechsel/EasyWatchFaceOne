import Toybox.Lang;
import Toybox.Math;

module Helper 
{
    class Math
    {
        static const RAND_MAX = 0x7FFFFFF; 

        static function RandomInRange(min as Number, max as Number) as Number
        {
            Math.srand(Toybox.System.getTimer());
            return max + Math.rand() / (RAND_MAX / (min - max + 1) + 1); 
        }
    }
}