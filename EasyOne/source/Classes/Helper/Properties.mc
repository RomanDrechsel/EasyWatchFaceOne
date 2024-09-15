import Toybox.Application.Properties;
import Toybox.Lang;

module Helper {
    class Properties {
        typedef ValueType as Number or String or Null;

        static function Get(key as String, def_val as ValueType) as ValueType {
            try {
                return Properties.getValue(key);
            } catch (ex instanceof Lang.Exception) {
                $.Log("Could not read property " + key + ": " + ex.getErrorMessage());
            }
            return def_val;
        }
    }
}
