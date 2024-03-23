 ///Returns a struct containing x and y
function vec2(x = 0, y = 0) constructor {
	self.x = x;
	self.y = y;

	//Returns the struct type as a string
	static Type = function() {
	gml_pragma("forceinline");
	return "vec2";	
	}
	
	//Returns the vector as a linear array
    static AsLinearArray = function() {
		gml_pragma("forceinline");
        return [self.x, self.y];
    }
	
	//Returns true if the given vector is exactly equal to this vector
	static Equals = function(vec) {
		gml_pragma("forceinline");
		return (self.x == vec.x && self.y == vec.y);
	}
		
	//Returns the length of this vector
	static Magnitude = function() {
		gml_pragma("forceinline");
		var _in = self.x * self.x + self.y * self.y;
		if _in = 0 or is_nan(_in) {return 0;}
		return sqrt(_in);
	}
	
	//Returns the squared length of this vector
	static SqrMagnitude = function() {
		gml_pragma("forceinline");
		return (self.x * self.x + self.y * self.y);
	}
	
	//Returns this vector with a magnitude of 1
	static Normalize = function() {
		gml_pragma("forceinline");
		var l = 1.0 / self.Magnitude();
		if is_numeric(l){
		return new vec2(self.x * l, self.y * l);
		} else {
		return new vec2(0, 0);	
		}
	}
	
	//Returns the vector rotated by the amount supplied in degrees.
	static Rotated = function(new_angle) {
		gml_pragma("forceinline");
		var _sin = dsin(new_angle), _cos = dcos(new_angle);
		return new vec2(self.x*_cos - self.y*_sin, self.x*_sin + self.y*_cos);
	}
	
	//Returns the vector snapped in a grid
	static Snapped = function(vec) {
		gml_pragma("forceinline");
		return new vec2(floor(self.x/vec.x+0.5)*vec.x, floor(self.y/vec.y+0.5)*vec.y);
	}
	
	//Clamps each component of the vector
	static Clamped = function(min_vec, max_vec) {
		gml_pragma("forceinline");
		return new vec2(clamp(self.x, min_vec.x, max_vec.x), clamp(self.y, min_vec.y, max_vec.y));
	};
	
	//Returns a vector with a clamped magnitude
	static ClampedMagnitude = function(max_magnitude) {
		gml_pragma("forceinline");
		var l = self.Magnitude();
		if !is_numeric(l) or l = 0 {return new vec2(0, 0, 0);}
		var vec = self;
		if (l > 0 && max_magnitude < l) {
			vec.x /= l;
			vec.y /= l;
			vec.x *= max_magnitude;
			vec.y *= max_magnitude;
		}
		return vec;
	}
	
	//Returns the angle in degrees of this vector
	static Angle = function() {
		gml_pragma("forceinline");
		return point_direction(0, 0, self.x, self.y);
	}
	
	//Adds two vectors
	static Add = function(vec) {
		gml_pragma("forceinline");
		return new vec2(self.x+vec.x, self.y+vec.y);
	}
	
	//Subtract two vectors
	static Sub = function(vec) {
		gml_pragma("forceinline");
		return new vec2(self.x-vec.x, self.y-vec.y);
	}
	
	//Multiply two vectors
	static Mul = function(vec) {
		gml_pragma("forceinline");
		return new vec2(self.x*vec.x, self.y*vec.y);
	}
	
	//Divide with another vector
	static Div = function(vec) {
		gml_pragma("forceinline");
		return new vec2(self.x/vec.x, self.y/vec.y);
	}
	
	//Negates the vector
	static Negate = function() {
		gml_pragma("forceinline");
		return new vec2(-self.x, -self.y);
	}
	
	//Scales the vector
	static Scale = function(vec) {
		gml_pragma("forceinline");
		return new vec2(self.x*vec.x, self.y*vec.y);
	}
		
	//Get the dot product of two vectors
	static Dot = function(vec) {
		gml_pragma("forceinline");
		return (self.x*vec.x + self.y*vec.y);
	}
	
	//Returns the cross product
	static Cross = function(vec) {
		gml_pragma("forceinline");
		return (self.x*vec.x - self.y*vec.y);
	}
	
	//Returns the vector with all components rounded down
	static Floor = function() {
		gml_pragma("forceinline");
		return new vec2(floor(self.x), floor(self.y));
	}
	
	//Returns the vector with all components rounded up
	static Ceil = function() {
		gml_pragma("forceinline");
		return new vec2(ceil(self.x), ceil(self.y));
	}
	
	//Returns the vector with all components rounded
	static Round = function() {
		gml_pragma("forceinline");
		return new vec2(round(self.x), round(self.y));
	}
	
	//Returns positive, negative, or zero depending on the value of the components
	static Sign = function() {
		gml_pragma("forceinline");
		return new vec2(sign(self.x), sign(self.y));
	}
	
	//Returns a new vector with absolute values
	static Abs = function() {
		gml_pragma("forceinline");
		return new vec2(abs(self.x), abs(self.y));
	}
	
	//Returns a new vector with fractional values
	static Frac = function() {
		gml_pragma("forceinline");
		return new vec2(frac(self.x), frac(self.y));
	}
	
	//Check if the vector is normalized
	static IsNormalized = function() {
		gml_pragma("forceinline");
		var _epsilon = 0.0001;
		var _difference = abs(self.SqrMagnitude() - 1.0);
		return (_difference < _epsilon);
	}
	
	//Lerp from one vector to another by an amount
	static Lerp = function(vec, amt) {
		gml_pragma("forceinline");
		return new vec2(lerp(self.x, vec.x, amt), lerp(self.y, vec.y, amt));
	}
	
	//Returns the distance between the two vectors
	static Distance = function(vec) {
		gml_pragma("forceinline");
		return sqrt(sqr(self.x-vec.x) + sqr(self.y-vec.y));
	}
	
	//Returns the square distance between the two vectors
	static SqrDistance = function(vec) {
		gml_pragma("forceinline");
		return (sqr(self.x-vec.x) + sqr(self.y-vec.y));
	}
	
	//Returns the angle to the given vector
	static Angle = function(vec) {
		gml_pragma("forceinline");
		return point_direction(self.x, self.y, vec.x, vec.y);
	}
	
	//Returns the angle between the line connecting the two points
	static AngleTo = function(vec) {
		gml_pragma("forceinline");
		return -darctan2(self.y-vec.y, self.x-vec.x)+180;
	}
	
	//Returns a vector that is made from the largest components of two vectors
	static Max = function(vec) {
		gml_pragma("forceinline");
		return new vec2(max(self.x, vec.x), max(self.y, vec.y));
	}
	
	//Returns a vector that is made from the smallest components of two vectors
	static Min = function(vec) {
		gml_pragma("forceinline");
		return new vec2(min(self.x, vec.x), min(self.y, vec.y));
	}
	
	//Returns the highest value of the vector
	static MaxComponent = function() {
		gml_pragma("forceinline");
		return max(self.x, self.y);
	}
	
	//Returns the lowest value of the vector
	static MinComponent = function() {
		gml_pragma("forceinline");
		return min(self.x, self.y);
	}

	//Returns the vector as a vec3
	static AsVec3 = function(_z = 0) {
	return new vec3(self.x, self.y, _z);	
	}
	
}

///Returns a struct containing x, y, and z
function vec3(x = 0, y = 0, z = 0) constructor {
	self.x = x;
	self.y = y;
	self.z = z;

	//Returns the struct type as a string
	static Type = function() {
		gml_pragma("forceinline");
		return "vec3";	
	}
	
	//Returns the vector as a linear array
	static AsLinearArray = function() {
		gml_pragma("forceinline");	
        return [self.x, self.y, self.z];
    }
	
	//Returns true if the given vector is exactly equal to this vector
	static Equals = function(vec) {
		gml_pragma("forceinline");
		return ( self.x == vec.x && self.y == vec.y && self.z == vec.z);
	}
		
	//Returns the length of this vector
	static Magnitude = function() {
		gml_pragma("forceinline");
		var _in = self.x * self.x + self.y * self.y + self.z * self.z;
		if _in = 0 or is_nan(_in) {return 0;}
		return sqrt(_in);
	}
	
	//Returns the squared length of this vector
	static SqrMagnitude = function() {
		gml_pragma("forceinline");
		return (self.x * self.x + self.y * self.y + self.z * self.z);
	}
	
	//Returns this vector with a magnitude of 1
	static Normalize = function() {
		gml_pragma("forceinline");
		var mag = self.Magnitude();
		if (mag == 0) {
		return self; // Return the original vector if the magnitude is zero
		}
		var l = 1.0 / mag;
		if is_numeric(l){
		return new vec3(self.x * l, self.y * l, self.z * l);
		} else {
		return new vec3(0, 0, 0);	
		}
	}
	
	//Returns the vector snapped in a grid
	static Snapped = function(vec) {
		gml_pragma("forceinline");
		return new vec3(floor(self.x/vec.x+0.5)*vec.x, floor(self.y/vec.y+0.5)*vec.y, floor(self.z/vec.z+0.5)*vec.z);
	}
	
	//Clamps each component of the vector
	static Clamped = function(min_vec, max_vec) {
		gml_pragma("forceinline");
		return new vec3(clamp(self.x, min_vec.x, max_vec.x), clamp(self.y, min_vec.y, max_vec.y), clamp(self.z, min_vec.z, max_vec.z));
	}
	
	//Returns a vector with a clamped magnitude
	static ClampedMagnitude = function(max_magnitude) {
		gml_pragma("forceinline");
		var l = self.Magnitude();
		var vec = self;
		if (l > 0 && max_magnitude < l) {
			vec.x /= l;
			vec.y /= l;
			vec.z /= l;
			vec.x *= max_magnitude;
			vec.y *= max_magnitude;
			vec.z *= max_magnitude;
		}
		return vec;
	}
	
	//Returns the angle in degrees of this vector
	static Angle = function() {
		gml_pragma("forceinline");
		return point_direction(0, 0, self.x, self.y);
	}
	
	//Adds two vectors
	static Add = function(val) {
		gml_pragma("forceinline");
        if (is_numeric(val)) {
            return new vec3(self.x + val, self.y + val, self.z + val);
        }
		return new vec3(self.x+val.x, self.y+val.y, self.z+val.z);
	}
	
	//Subtract two vectors
	static Sub = function(val) {
		gml_pragma("forceinline");
        if (is_numeric(val)) {
            return new vec3(self.x - val, self.y - val, self.z - val);
        }
		return new vec3(self.x-val.x, self.y-val.y, self.z-val.z);
	}
	
	//Multiply two vectors
	static Mul = function(val) {
		gml_pragma("forceinline");
        if (is_numeric(val)) {
            return new vec3(self.x * val, self.y * val, self.z * val);
        }
		return new vec3(self.x*val.x, self.y*val.y, self.z*val.z);
	}
	
	//Divide with another vector
	static Div = function(val) {
		gml_pragma("forceinline");
        if (is_numeric(val)) {
            return new vec3(self.x / val, self.y / val, self.z / val);
        }
		return new vec3(self.x/val.x, self.y/val.y, self.z/val.z);
	}
	
	//Negates the vector
	static Negate = function() {
		gml_pragma("forceinline");
		return new vec3(-self.x, -self.y, -self.z);
	}
	
	//Scales the vector
	static Scale = function(val) {
		gml_pragma("forceinline");
        if (is_numeric(val)) {
            return new vec3(self.x * val, self.y * val, self.z * val);
        }
		return new vec3(self.x*val.x, self.y*val.y, self.z*val.z);
	}
	
	//Get the dot product of two vectors
	static Dot = function(vec) {
		gml_pragma("forceinline");
		return (self.x*vec.x + self.y*vec.y + self.z*vec.z);
	}
	
	//Returns the cross product
	static Cross = function(vec) {
		gml_pragma("forceinline");
		return new vec3(self.y*vec.z - self.z*vec.y, self.z*vec.x - self.x*vec.z, self.x*vec.y - self.y*vec.x);
	}
	
	//Returns the vector with all components rounded down
	static Floor = function() {
		gml_pragma("forceinline");
		return new vec3(floor(self.x), floor(self.y), floor(self.z));
	}
	
	//Returns the vector with all components rounded up
	static Ceil = function() {
		gml_pragma("forceinline");
		return new vec3(ceil(self.x), ceil(self.y), ceil(self.z));
	}
	
	//Returns the vector with all components rounded
	static Round = function() {
		gml_pragma("forceinline");
		return new vec3(round(self.x), round(self.y), round(self.z));
	}
	
	//Returns positive, negative, or zero depending on the value of the components
	static Sign = function() {
		gml_pragma("forceinline");
		return new vec3(sign(self.x), sign(self.y), sign(self.z));
	}
	
	//Returns a new vector with absolute values
	static Abs = function() {
		gml_pragma("forceinline");
		return new vec3(abs(self.x), abs(self.y), abs(self.z));
	}
	
	//Returns a new vector with fractional values
	static Frac = function() {
		gml_pragma("forceinline");
		return new vec3(frac(self.x), frac(self.y), frac(self.z));
	}
	
	//Check if the vector is normalized
	static IsNormalized = function() {
		gml_pragma("forceinline");
		var _epsilon = 0.0001;
		var _difference = abs(self.SqrMagnitude() - 1.0);
		return (_difference < _epsilon);
	}
	
	//Lerps one vector towards another by an amount
	static Lerp = function(vec, amt) {
		gml_pragma("forceinline");
		return new vec3(lerp(self.x, vec.x, amt), lerp(self.y, vec.y, amt), lerp(self.z, vec.z, amt));
	}

	//Slerp function for interpolating between two vectors
	static Slerp = function(vec, t) {
	    var dot = self.Dot(vec);
	    var theta = arccos(clamp(dot, -1, 1)) * t;
	    var v2 = vec.Sub(self.Mul(dot)).Normalize();
	    return self.Mul(cos(theta)).Add(v2.Mul(sin(theta)));
	}
	
	//Returns the distance between the two vectors
	static Distance = function(vec) {
		gml_pragma("forceinline");
		return sqrt(sqr(self.x-vec.x) + sqr(self.y-vec.y) + sqr(self.z-vec.z));
	}
	
	//Returns the square distance between the two vectors
	static SqrDistance = function(vec) {
		gml_pragma("forceinline");
		return (sqr(self.x-vec.x) + sqr(self.y-vec.y) + sqr(self.z-vec.z));
	}
	
	//Returns the angle (z rotation) in degrees to the given vector
	static YawTo = function(vec) {
		gml_pragma("forceinline");
		var dir = vec.Sub(self).Normalize()
		return radtodeg(arctan2(dir.z, dir.x));
	}
	
	//Returns the pitch angle (x rotation) in degrees to the given vector
	static PitchTo = function(vec) {
		gml_pragma("forceinline");
		return radtodeg(arctan2(vec.z-self.z, point_distance(self.x, self.y, vec.x, vec.y)));
	}
	
	//Returns a vector that is made from the largest components of two vectors
	static Max = function(vec) {
		gml_pragma("forceinline");
		return new vec3(max(self.x, vec.x), max(self.y, vec.y), max(self.z, vec.z));
	}
	
	//Returns a vector that is made from the smallest components of two vectors
	static Min = function(vec) {
		gml_pragma("forceinline");
		return new vec3(min(self.x, vec.x), min(self.y, vec.y), min(self.z, vec.z));
	}
	
	//Returns the highest value of the vector
	static MaxComponent = function() {
		gml_pragma("forceinline");
		return max(self.x, self.y, self.z);
	}
	
	//Returns the lowest value of the vector
	static MinComponent = function() {
		gml_pragma("forceinline");
		return min(self.x, self.y, self.z);
	}

	//Projects the vector onto another
    static Project = function(vec) {
		gml_pragma("forceinline");
        var dot = dot_product_3d(self.x, self.y, self.z, vec.x, vec.y, vec.z);
        var mag2 = dot_product_3d(vec.x, vec.y, vec.z, vec.x, vec.y, vec.z);
        var f = dot / mag2;
        return new vec3(vec.x * f, vec.y * f, vec.z * f);
    }
	
	//Returns a matrix from the vector
    static GetTranslationMatrix = function() {
		gml_pragma("forceinline");
        return [
            1, 0, 0, 0,
            0, 1, 0, 0,
            0, 0, 1, 0,
            self.x, self.y, self.z, 1
		];
    }
		
	//Rotates the vector along the axis of a provided vector by an amount in radians
	static Rotate = function(axis3, radians) {
		gml_pragma("forceinline");
		var a = axis3.Normalize();
		var c = cos(radians);
		var s = sin(radians);
		var d = (1 - c) * self.Dot(a);
		return self.Mul(c).Add(a.Mul(d)).Add(a.Cross(self).Mul(s));
	}
	
	//Returns the vector multiplied by a matrix
	static MulMatrix = function(m) {
		gml_pragma("forceinline");
		return new vec3(m[0] * self.x + m[1] * self.y + m[2] * self.z,
						             m[3] * self.x + m[4] * self.y + m[5] * self.z,
						             m[6] * self.x + m[7] * self.y + m[8] * self.z);
	}

	//Returns the vector as a quaternion
	static Quat = function() {
		gml_pragma("forceinline");
		var cr = cos(self.x * 0.5);
	    var sr = sin(self.x * 0.5);
	    var cp = cos(self.y * 0.5);
	    var sp = sin(self.y * 0.5);
	    var cy = cos(self.z * 0.5);
	    var sy = sin(self.z * 0.5);
	
	    var qx = sr * cp * cy - cr * sp * sy;
	    var qy = cr * sp * cy + sr * cp * sy;
	    var qz = cr * cp * sy - sr * sp * cy;
	    var qw = cr * cp * cy + sr * sp * sy;
	
		return new quat(qx, qy, qz, qw);
	}
	
	//Returns the vector with each component remaped and clamped to be between 0 & 1
	static ColortoShader = function() {
		gml_pragma("forceinline");
		var min_vec = new vec3(0.0, 0.0, 0.0);
		var max_vec = new vec3(1.0, 1.0, 1.0);
		return self.Div(255).Clamped(min_vec, max_vec);
	}

	//Returns the vector interpolated towards another 
	static ColorBlend = function(col, amt) {
		gml_pragma("forceinline");
		return self.Lerp(col, amt);
	}
	
	//Returns the vector as a Vec4
	static AsVec4 = function(w) {
	gml_pragma("forceinline");
	return new vec4(self.x, self.y, self.z, w);	
	}
	
}

//Returns a struct containing x, y, z, and w
function vec4(x = 0, y = 0, z = 0, w = 0) constructor {
    self.x = x;
    self.y = y;
    self.z = z;
    self.w = w;

	//Returns the struct type as a string
	static Type = function() {
		gml_pragma("forceinline");
		return "vec4";	
	}
	
	//Returns the vector as a linear array
    static AsLinearArray = function() {
		gml_pragma("forceinline");
        return [self.x, self.y, self.z, self.w];
    }
    
	//Adds two vectors
    static Add = function(val) {
		gml_pragma("forceinline");
        if (is_numeric(val)) {
            return new vec4(self.x + val, self.y + val, self.z + val, self.w + val);
        }
        return new vec4(self.x + val.x, self.y + val.y, self.z + val.z, self.w + val.w);
    }

	//Subtract two vectors
    static Sub = function(val) {
		gml_pragma("forceinline");
        if (is_numeric(val)) {
            return new vec4(self.x - val, self.y - val, self.z - val, self.w - val);
        }
        return new vec4(self.x - val.x, self.y - val.y, self.z - val.z, self.w - val.w);
    }

	//Multiply two vectors
    static Mul = function(val) {
		gml_pragma("forceinline");
        if (is_numeric(val)) {
            return new vec4(self.x * val, self.y * val, self.z * val, self.w * val);
        }
        return new vec4(self.x * val.x, self.y * val.y, self.z * val.z, self.w * val.w);
    }

	//Divide with another vector
    static Div = function(val) {
		gml_pragma("forceinline");
        if (is_numeric(val)) {
            return new vec4(self.x / val, self.y / val, self.z / val, self.w / val);
        }
        return new vec4(self.x / val.x, self.y / val.y, self.z / val.z, self.w / val.w);
    }

	//Returns the length of this vector
    static Magnitude = function() {
		gml_pragma("forceinline");
        return sqrt(self.x * self.x + self.y * self.y + self.z * self.z + self.w * self.w);
    }

	//Returns the distance between the two vectors
    static Distance = function(val) {
		gml_pragma("forceinline");
        return sqrt(sqr(self.x - val.x) + sqr(self.y - val.y) + sqrt(self.z - val.z) + sqr(self.w - val.w));
    }

	//Get the dot product of two vectors
    static Dot = function(val) {
		gml_pragma("forceinline");
        return self.x * val.x + self.y * val.y + self.z * val.z + self.w * val.w;
    }

	//Returns true if the given vector is exactly equal to this vector
    static Equals = function(val) {
		gml_pragma("forceinline");
        return (self.x == val.x) && (self.y == val.y) && (self.z == val.z) && (self.w == val.w);
    }

	//Returns this vector with a magnitude of 1
    static Normalize = function() {
		gml_pragma("forceinline");
        var mag = sqrt(self.x * self.x + self.y * self.y + self.z * self.z + self.w * self.w);
        return new vec4(self.x / mag, self.y / mag, self.z / mag, self.w / mag);
    }

	//Returns a new vector with absolute values
    static Abs = function() {
		gml_pragma("forceinline");
        return new vec4(abs(self.x), abs(self.y), abs(self.z), abs(self.w));
    }

	//Projects the vector onto another
    static Project = function(dir) {
		gml_pragma("forceinline");
        var dot = self.x * dir.x + self.y * dir.y + self.z * dir.z + self.w * dir.w;
        var mag2 = dir.x * dir.x + dir.y * dir.y + dir.z * dir.z + dir.w * dir.w;
        var f = dot / mag2;
        return new vec4(dir.x * f, dir.y * f, dir.z * f, dir.w * f)
    }

	//Returns a vector that is made from the smallest components of two vectors
    static Min = function(vec) {
		gml_pragma("forceinline");
        return new vec4(min(self.x, vec.x), min(self.y, vec.y), min(self.z, vec.z), min(self.w, vec.w));
    }

	//Returns a vector that is made from the largest components of two vectors
    static Max = function(vec) {
		gml_pragma("forceinline");
        return new vec4(max(self.x, vec.x), max(self.y, vec.y), max(self.z, vec.z), max(self.w, vec.w));
    }

	//Returns the vector with all components rounded down
    static Floor = function() {
		gml_pragma("forceinline");
        return new vec4(floor(self.x), floor(self.y), floor(self.z), floor(self.w));
    }

	//Returns the vector with all components rounded up
    static Ceil = function() {
		gml_pragma("forceinline");
        return new vec4(ceil(self.x), ceil(self.y), ceil(self.z), ceil(self.w));
    }

	//Returns the vector with all components rounded
    static Round = function() {
		gml_pragma("forceinline");
        return new vec4(round(self.x), round(self.y), round(self.z), round(self.w));
    }

	//Returns a matrix from the vector
    static GetTranslationMatrix = function() {
		gml_pragma("forceinline");
        return [
            1, 0, 0, 0,
            0, 1, 0, 0,
            0, 0, 1, 0,
            self.x, self.y, self.z, 1
        ];
    }

	//Lerps one vector towards another by an amount
	static Lerp = function(vec, amt) {
		gml_pragma("forceinline");
		return new vec4(lerp(self.x, vec.x, amt), lerp(self.y, vec.y, amt), lerp(self.z, vec.z, amt), lerp(self.w, vec.w, amt));
	}
	
}

//Returns a struct containing x, y, z and w.


/*
//Returns a struct containing x, y, z, and w
function quat(x = 0, y = 0, z = 0, w = 1) constructor {
    self.x = x;
    self.y = y;
    self.z = z;
	self.w = w;

	//Returns the struct type as a string
	static Type = function() {
		gml_pragma("forceinline");
		return "quat";	
	}
	
	// Multiply two quaternion and combine two rotation together.
    static Mul = function(val) {
		gml_pragma("forceinline");
		if (is_numeric(val)) {
            return new quat(self.x * val, self.y * val, self.z * val, self.w * val);
        }
		var qx = self.w * val.x + self.x * val.w + self.y * val.z - self.z * val.y;
		var qy = self.w * val.y + self.y * val.w + self.z * val.x - self.x * val.z;
		var qz = self.w * val.z + self.z * val.w + self.x * val.y - self.y * val.x;
		var qw = self.w * val.w - self.x * val.x - self.y * val.y - self.z * val.z;
		return new quat(qx, qy, qz, qw);
	}

	// Rotate a vector by a quaternion angle
	// https://www.euclideanspace.com/maths/algebra/realNormedAlgebra/quaternions/transforms/index.html
	static TransformVec3 = function(vec) {
		gml_pragma("forceinline");
		var qx = self.w*self.w*vec.x + 2*self.w*self.w*vec.z - 2*self.z*self.w*vec.y + self.x*self.x*vec.x + 2*self.y*self.x*vec.y + 2*self.z*self.x*vec.z - self.z*self.z*vec.x - self.y*self.y*vec.x;
		var qy = 2*self.x*self.y*vec.x + self.y*self.y*vec.y + 2*self.z*self.y*vec.z + 2*self.w*self.z*vec.x - self.z*self.z*vec.y + self.w*self.w*vec.y - 2*self.x*self.w*vec.z - self.x*self.x*vec.y;
		var qz = 2*self.x*self.z*vec.x + 2*self.y*self.z*vec.y + self.z*self.z*vec.z - 2*self.w*self.y*vec.x - self.y*self.y*vec.z + 2*self.w*self.x*vec.y - self.x*self.x*vec.z + self.w*self.w*vec.z;
		return new vec3(qx, qy, qz);
		//var uv, uuv;
		//var qvec = new vec3(self.x, self.y, self.z);
		//uv = qvec.Cross(vec);
		//uuv = qvec.Cross(uv);
		//uv = uv.Mul(2.0 * self.w);
		//uuv = uuv.Mul(2.0);
		//return vec.Add(uv).Add(uuv);
	}

	// Rotate a quaternion around it's local axis.
	static RotateVec3 = function(vec) {
	    gml_pragma("forceinline");
	    var vec_quat = new quat(vec.x, vec.y, vec.z, 0); // Convert vector to quaternion
	    var result_quat = self.Mul(vec_quat).Mul(self.Conjugate()); // Rotate and then apply conjugate
	    return new vec3(result_quat.x, result_quat.y, result_quat.z); // Return the resulting vector
	}

	//	Return the conjugate of a quaternion 
	static Conjugate = function () {
		gml_pragma("forceinline");
		return new quat(-self.x, -self.y, -self.z, self.w);
	}

	//	Same thing as quaternion conjugate, in case you don't know...
	static Inverse = function () {
		gml_pragma("forceinline");
		return self.Conjugate();
	}
	
	//Returns the dot product of two quaternions
	static Dot = function(val) {
		gml_pragma("forceinline");
		 return self.x*val.x + self.y*val.y + self.z*val.z + self.w*val.w;
	}

	//Add two quaternions 
	static Add = function(val) {
	    gml_pragma("forceinline");
	    return new quat(self.x + val.x, self.y + val.y, self.z + val.z, self.w + val.w);
	}

	//Subtract two quaternions 
	static Sub = function(val) {
	    gml_pragma("forceinline");
	    return new quat(self.x - val.x, self.y - val.y, self.z - val.z, self.w - val.w);
	}

	//Returns the quaternion negated
	static Negate = function() {
		gml_pragma("forceinline");
		return new quat(-self.x, -self.y, -self.z, -self.w);
	}

	//Returns the quaternion normalized
	static Normalize = function() {
		gml_pragma("forceinline");
		var l = 1 / sqrt(self.Dot(self));
		return new quat(l*self.x, l*self.y, l*self.z, l*self.w);
	}

	//Regular Quaternion Lerp
	static Lerp = function (val, t) {
		gml_pragma("forceinline");
		// negate second quat if dot product is negative
		var l2 = self.Dot(val);
		var q = val;
		if(l2 < 0.0) {
		q = q.Negate();
		}
		var c = new quat();
		// c = a + t(b - a)  -->   c = a - t(a - b)
		// the latter is slightly better on x64
		c.x = self.x - t*(self.x - q.x);
		c.y = self.y - t*(self.y - q.y);
		c.z = self.z - t*(self.z - q.z);
		c.w = self.w - t*(self.w - q.w);
		return c;
	}

	//Normalized Quaternion Lerp (you generally want to use this)
	static Nlerp = function(val, t) {
		gml_pragma("forceinline");
		var lq = self.Lerp(val, t);
		lq = lq.Normalize();
		return lq;
	}

	//Returns the quaternion, position, and scale as a matrix array
	static AsMatrix = function(pos_vec, scale_vec) {
	    gml_pragma("forceinline");
	    var mat = array_create(16,0);
	    var sqw = self.w*self.w;
	    var sqx = self.x*self.x;
	    var sqy = self.y*self.y;
	    var sqz = self.z*self.z;
	    mat[@0] = (sqx - sqy - sqz + sqw) * scale_vec.x; // since sqw + sqx + sqy + sqz =1
	    mat[@5] = (-sqx + sqy - sqz + sqw) * scale_vec.y;
	    mat[@10] = (-sqx - sqy + sqz + sqw) * scale_vec.z;

	    var tmp1 = self.x*self.y;
	    var tmp2 = self.z*self.w;
	    mat[@1] = 2.0 * (tmp1 + tmp2) * scale_vec.y;
	    mat[@4] = 2.0 * (tmp1 - tmp2) * scale_vec.x;

	    tmp1 = self.x*self.z;
	    tmp2 = self.y*self.w;
	    mat[@2] = 2.0 * (tmp1 - tmp2) * scale_vec.z;
	    mat[@8] = 2.0 * (tmp1 + tmp2) * scale_vec.x;

	    tmp1 = self.y*self.z;
	    tmp2 = self.x*self.w;
	    mat[@6] = 2.0 * (tmp1 + tmp2) * scale_vec.z;
	    mat[@9] = 2.0 * (tmp1 - tmp2) * scale_vec.y;

	    mat[@12] = pos_vec.x;
	    mat[@13] = pos_vec.y;
	    mat[@14] = pos_vec.z;
	    mat[@15] = 1.0;
	    return mat;
	}



	//Interpolates the quaternion towards another with spring-like motion and velocity
	//Returns updated values as linear array: [rotation_quat, velocity_quat, difference_quat, acceleration_quat];
	//The updated rotation and velocity quaternions need to be stored to allow for continuity in the next update.
	static UpdateSpring = function(goal_quat, velocity_quat, stiffness, damping, t) {
		gml_pragma("forceinline");
	    var q = self;
	    var goal = goal_quat;
	    var vel = velocity_quat;
	    var quat_dif = goal.Mul(q.Conjugate());
	    var acceleration = quat_dif.Mul(stiffness).Sub(vel.Mul(damping));
	    vel = vel.Add(acceleration.Mul(t));
	    q = vel.Mul(t).Add(new quat(0, 0, 0, 1)).Mul(q);
	    q = q.Normalize();
		return [q, vel, quat_dif, acceleration];
	}

	//Returns the x, y, and z components as a vec3
	static AsVec3 = function() {
		gml_pragma("forceinline");
		return new vec3(self.x, self.y, self.z);
	}

	//Returns the x, y, z, and w compents as a vec4
	static AsVec4 = function() {
		gml_pragma("forceinline");
		return new vec4(self.x, self.y, self.z, self.w);
	}
	
	//Spherical Linear Interpolation that maintains constant angular velocity, where Nlerp does not.
	static Slerp = function(q, t) {
		gml_pragma("forceinline");
		var qm = new quat();
		var cosHalfTheta = self.w * q.w + self.x * q.x + self.y * q.y + self.z * q.z;
		if (abs(cosHalfTheta) >= 1.0) {
			qm.w = self.w;
			qm.x = self.x;
			qm.y = self.y;
			qm.z = self.z;
			return qm;
		}
		var halfTheta = arccos(cosHalfTheta);
		var sinHalfTheta = sqrt(1.0 - cosHalfTheta*cosHalfTheta);
		if (abs(sinHalfTheta) < 0.001) {
			qm.w = (self.w * 0.5 + q.w * 0.5);
			qm.x = (self.x * 0.5 + q.x * 0.5);
			qm.y = (self.y * 0.5 + q.y * 0.5);
			qm.z = (self.z * 0.5 + q.z * 0.5);
			return qm;
		}
		var ratioA = sin((1 - t) * halfTheta) / sinHalfTheta;
		var ratioB = sin(t * halfTheta) / sinHalfTheta; 
		qm.w = (self.w * ratioA + q.w * ratioB);
		qm.x = (self.x * ratioA + q.x * ratioB);
		qm.y = (self.y * ratioA + q.y * ratioB);
		qm.z = (self.z * ratioA + q.z * ratioB);
		return qm;
	}

	//Returns true if the given quaternion is exactly equal to this quaternion
    static Equals = function(q) {
		gml_pragma("forceinline");
        return (self.x == q.x) && (self.y == q.y) && (self.z == q.z) && (self.w == q.w);
    }

	//Overwrites the quaternion with a new one generated from angle axis
	static FromAngleAxis = function(angle, axis) {
	    gml_pragma("forceinline");
	    var halfAngle = angle * 0.5;
	    var s = sin(halfAngle);
	    return new quat(axis.x * s, axis.y * s, axis.z * s, cos(halfAngle));
	}
}
