use NativeCall;

our class Color is repr('CStruct') is export { ... };

# TODO maybe give those different names here? strip the TCOD_?

# constructors
our sub TCOD_color_RGB(int8 $r, int8 $g, int8 $b) is native('libtcod.so') returns Color { * };
our sub TCOD_color_HSV(Num $h, Num $s, Num $v) is native('libtcod.so') returns Color { * }; # , , # - for vim syntax highlighting brokenness

# basic operations
our sub TCOD_color_equals(Color $c1, Color $c2) is native('libtcod.so') returns Bool { * };
our sub TCOD_color_add(Color $c1, Color $c2) is native('libtcod.so') returns Color { * };
our sub TCOD_color_subtract(Color $c1, Color $c2) is native('libtcod.so') returns Color { * };
our sub TCOD_color_multiply(Color $c1, Color $c2) is native('libtcod.so') returns Color { * };
our sub TCOD_color_multiply_scalar(Color $c1, num32 $value) is native('libtcod.so') returns Color { * };
our sub TCOD_color_lerp(Color $c1, Color $c2, num32 $coef) is native('libtcod.so') returns Color { * };

# HSV transformations
# TODO this breaks somehow.
#our sub TCOD_color_set_HSV(CArray[Color] $c, num32 $h, num32 $s, num32 $v) is native('libtcod.so') { * }; # , , # vim again.
#our sub TCOD_color_get_HSV(CArray[Color] $c, CArray[num32] $h, CArray[num32] $s, CArray[num32] $v) is native('libtcod.so') { * }; # , , # vim again.

our sub TCOD_color_get_hue(Color $c) is native('libtcod.so') returns num32 { * };
our sub TCOD_color_get_saturation(Color $c) is native('libtcod.so') returns num32 { * };
our sub TCOD_color_get_value(Color $c) is native('libtcod.so') returns num32 { * };

our sub TCOD_color_set_hue($c, num32 $h) is native('libtcod.so') { * };
our sub TCOD_color_set_saturation($c, num32 $s) is native('libtcod.so') { * };
our sub TCOD_color_set_value($c, num32 $v) is native('libtcod.so') { * };

our class Color is repr('CStruct') is export {
    has int8 $.r;
    has int8 $.g;
    has int8 $.b;

    method new-rgb(int8 $r, int8 $g, int8 $b) returns Color {
        TCOD_color_RGB($r, $g, $b);
    }

    method new(int8 $r, int8 $g, int8 $b) returns Color {
        TCOD_color_RGB($r, $g, $b);
    }

    method new-hsv(num32 $h, num32 $s, num32 $v) returns Color {
        TCOD_color_HSV($h, $s, $v);
    }

    method lerp(Color $other, num32 $val --> Color) {
        TCOD_color_lerp(self, $other, $val);
    }

    method hue is rw {
        Proxy.new(
            FETCH => method {
                        return TCOD_color_get_hue(self);
                    },
            STORE => method (num32 $v) {
                        #TCOD_color_set_hue($!sp, $v);
                        die 'NYI';
                    })
    }
    method saturation is rw {
        Proxy.new(
            FETCH => method {
                        return TCOD_color_get_saturation(self)
                    },
            STORE => method (num32 $v) {
                        #TCOD_color_set_saturation($!sp, $v);
                        die 'NYI';
                    })
    }
    method value is rw {
        Proxy.new(
            FETCH => method {
                        return TCOD_color_get_value(self)
                    },
            STORE => method (num32 $v) {
                        #TCOD_color_set_value($!sp, $v);
                        die 'NYI';
                    })
    }
}

multi sub infix:<eqv>(Color $lhs, Color $rhs --> Bool) {
    TCOD_color_equals($lhs, $rhs) ?? True !! False;
}

multi sub infix:<+>(Color $lhs, Color $rhs --> Color) {
    TCOD_color_add($lhs, $rhs);
}

multi sub infix:<->(Color $lhs, Color $rhs --> Color) {
    TCOD_color_subtract($lhs, $rhs);
}

multi sub infix:<*>(Color $lhs, Color $rhs --> Color) {
    TCOD_color_multiply($lhs, $rhs);
}

multi sub infix:<*>(Color $lhs, Num $rhs --> Color) {
    TCOD_color_multiply_scalar($lhs, $rhs);
}

{
    use Test;

    plan 1;

    my Color $c .= new-rgb(250, 0, 0);
    is $c.r, 250, "r got set properly by constructor";
}
