import Toybox.Application.Properties;
import Toybox.Lang;

module Helper {
    class Properties {
        typedef ValueType as Lang.Number or Lang.String or Null;

        static function Get(key as Lang.String, def_val as ValueType) as ValueType {
            try {
                return Properties.getValue(key);
            } catch (ex instanceof Lang.Exception) {
                $.Log("Could not read property " + key + ": " + ex.getErrorMessage());
            }
            return def_val;
        }
    }
}
