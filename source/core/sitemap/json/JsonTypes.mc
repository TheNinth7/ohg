import Toybox.Lang;

/*
 * Types representing dictionary and array structures used in JSON data
 * exchanged via web requests. These same structures are also persisted
 * to Storage and read back from it.
 */
typedef JsonObject as Dictionary<String,Object?>;
typedef JsonArray as Array<JsonObject>;