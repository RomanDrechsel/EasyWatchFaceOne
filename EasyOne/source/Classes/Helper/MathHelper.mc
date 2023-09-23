import Toybox.Lang;
import Toybox.Math;

module Helper 
{
    class MathHelper
    {
        static function RandomInRange(min as Number, max as Number) as Number
        {
            Math.srand(Toybox.System.getTimer());
            return min + Math.rand() % (max - min);
        }
    }
}