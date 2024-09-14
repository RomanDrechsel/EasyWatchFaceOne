import Toybox.Lang;

module Helper {
    class String {
        static function stringReplace(str, oldString, newString) as String {
            var result = str;
            var index = result.find(oldString);
            while (index != null) {
                var index2 = index + oldString.length();
                result = result.substring(0, index) + newString + result.substring(index2, result.length());
                index = result.find(oldString);
            }

            return result;
        }
    }
}
