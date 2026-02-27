import Toybox.Lang;

/*
 * Monkey C does not support abstract methods. To enforce overriding in subclasses,
 * base-class implementations of “abstract” methods throw an `AbstractMethodException`,
 * ensuring that derived classes provide their own implementation.
 */
 (:glance)
class AbstractMethodException extends GeneralException {
    function initialize( msg as String ) {
        GeneralException.initialize( msg );
    }
}
