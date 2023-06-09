import Toybox.Lang;
import Toybox.Math;

module Helper 
{
    class MathHelper
    {
        static const RAND_MAX = 0x7FFFFFF; 

        static function RandomInRange(min as Number, max as Number) as Number
        {
            Math.srand(Toybox.System.getTimer());
            return (Math.rand() % max - min) + min;
        }
    }
}