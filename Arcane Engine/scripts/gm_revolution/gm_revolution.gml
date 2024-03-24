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
		if !is_numeric(l) or l = 0 {return new vec2(0, 0);}
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
	
	//Returns the vector as a quat
	static AsQuat = function() {
		gml_pragma("forceinline");
		return new quat(self.x, self.y, self.z, self.w);	
	}
	
}

//Returns a struct containing x, y, z and w.
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
	
	//Returns the quaternion as Radians stored in a vec3 (assumes the quat is normalized)
	static ToAngleAxis = function() {
		gml_pragma("forceinline");			
		var angles = new vec3(0, 0, 0);
	    var sinr_cosp = 2 * (q.w * q.x + q.y * q.z);
	    var cosr_cosp = 1 - 2 * (q.x * q.x + q.y * q.y);
	    angles.x = arctan2(sinr_cosp, cosr_cosp);
	    var sinp = sqrt(1 + 2 * (q.w * q.y - q.x * q.z));
	    var cosp = sqrt(1 - 2 * (q.w * q.y - q.x * q.z));
	    angles.y = 2 * arctan2(sinp, cosp) - M_PI / 2;
	    var siny_cosp = 2 * (q.w * q.z + q.x * q.y);
	    var cosy_cosp = 1 - 2 * (q.y * q.y + q.z * q.z);
	    angles.z= arctan2(siny_cosp, cosy_cosp);
		return angles;
	}
	
	//Returns the quaternion as Euler angles in Degrees stored in a vec3 (assumes the quat is normalized)
	static ToEulerAngles = function() {
		gml_pragma("forceinline");		
		var euler_conv = self.ToAngleAxis();
		var result = new vec3(radtodeg(euler_conv.x), radtodeg(euler_conv.y), radtodeg(euler_conv.z));
		return result;
	}

	//Returns the quaternion normalized
	static Normalize = function() {
		gml_pragma("forceinline");
		var l = 1 / self.Magnitude();
		return new quat(l*self.x, l*self.y, l*self.z, l*self.w);
	}
	
	//Returns the dot product between two quaternions
	static Dot = function(q) {
		gml_pragma("forceinline");
		return self.x * q.x + self.y * q.y + self.x * q.z + self.w * q.w;	
	}
	
	//Returns the angle between two rotations as radians or degrees
	static Angle = function(q, as_degrees) {
		gml_pragma("forceinline");
		var dot = min(abs(self.Dot(q)), 1.0);
		var result = self.IsEqualUsingDot(q) ? 0.0 : arccos(dot) * 2.0;
		if as_degrees {result = radtodeg(result);}
		return  result;
	}

	//Returns a quaternion representing a rotation around a unit axis by an angle in radians.
    static FromAngleAxis = function(axis, angle) {
		gml_pragma("forceinline");
        var sina = sin(0.5 * angle);
		var cosa = cos(0.5 * angle);
        return new quat(axis.x * sina, axis.y * sina, axis.z * sina, cosa);
    }

	//Returns a quaternion representing the vec3 of rotations in Degrees
	static FromEulerAngles = function(vec)
	{	
		gml_pragma("forceinline");
	    var cr = dcos(vec.x * 0.5);
	    var sr = dsin(vec.x * 0.5);
	    var cp = dcos(vec.y * 0.5);
	    var sp = dsin(vec.y * 0.5);
	    var cy = dcos(vec.z * 0.5);
	    var sy = dsin(vec.z * 0.5);
		var q = new quat();
	    q.x = sr * cp * cy - cr * sp * sy;
	    q.y = cr * sp * cy + sr * cp * sy;
	    q.z = cr * cp * sy - sr * sp * cy;
	    q.w = cr * cp * cy + sr * sp * sy;
	    return q;
	}

    //Is the dot product of two quaternions within tolerance for them to be considered equal?
	static IsEqualUsingDot = function(q) {
		gml_pragma("forceinline");
		var dot = self.Dot(q);
		var kEpsilon = 0.000001;
		return bool(dot > 1.0 - kEpsilon);
	}

    //Compare to the quaternion to another to see if its equal
	static IsEqual = function(q) {
		gml_pragma("forceinline");
		var kEpsilon = 0.000001;
		return bool(self.Dot(q) > 1.0 - kEpsilon);
	}

	//Returns true if the given quaternion is exactly equal to this quaternion
    static Equals = function(q) {
		gml_pragma("forceinline");
        return (self.x == q.x) && (self.y == q.y) && (self.z == q.z) && (self.w == q.w);
    }
	
	//Returns the quaternion rotated towards another quaternion by an amount in radians
	static RotateTowards = function(q, t) {
		gml_pragma("forceinline");
		var num = self.Angle(q, false);
	    if (num == 0)
	    {
	        return q;
	    }
	    var tt = min(1, t / num);
	    return self.SlerpUnclamped(q, tt);
	}	

	//Returns the quaternion spherically interpolated towards another quaternion by the provided unclamped amount.
	static SlerpUnclamped = function(q, t) {
		gml_pragma("forceinline");
        if (self.MagnitudeSquared() == 0.0)
        {
            if (q.MagnitudeSquared() == 0.0)
            {
                return new quat();
            }
            return q;
        }
        else if (q.MagnitudeSquared() == 0.0)
        {
            return self;
        }
		
		var veca = new vec3(self.x, self.y, self.z);
		var vecb = new vec3(q.x, q.y, q.z);
        var cosHalfAngle = self.w * q.w + veca.Dot(vecb);

        if (cosHalfAngle >= 1.0 || cosHalfAngle <= -1.0)
        {
            // angle = 0.0, so just return one input.
            return self;
        }
        else if (cosHalfAngle < 0.0)
        {
			var b = q;
			b.x =  -b.x;
			b.y = -b.y;
			b.z = -b.z;
            b.w = -b.w;
            cosHalfAngle = -cosHalfAngle;
        }

        var blendA;
        var blendB;
        if (cosHalfAngle < 0.99)
        {
            // do proper slerp for big angles
            var halfAngle = arccos(cosHalfAngle);
            var sinHalfAngle = sin(halfAngle);
            var oneOverSinHalfAngle = 1.0 / sinHalfAngle;
            blendA = sin(halfAngle * (1.0 - t)) * oneOverSinHalfAngle;
            blendB = sin(halfAngle * t) * oneOverSinHalfAngle;
        }
        else
        {
            // do lerp if angle is really small.
            blendA = 1.0 - t;
            blendB = t;
        }

		var qx = blendA * self.x + blendB * q.x;
		var qy = blendA * self.y + blendB * q.y;
		var qz = blendA * self.z + blendB * q.z;
		var qw = blendA * self.w + blendB * q.w
		
        var result = new quat(qx, qy, qz, qw);
        if (result.MagnitudeSquared() > 0.0)
            return result.Normalize();
        else
            return new quat();
    }

	//Returns the quaternion spherically interpolated towards another quaternion by the provided amount
	static Slerp = function(q, t) {
		gml_pragma("forceinline");
		var dt = self.dot(q);
		var q2 = q;
		if (dt < 0.0)
		{
		dt = -dt;
		q2 = q2.Conjugate();
		}

		if (dt < 0.9995)
		{
		var angle = acos(dt);
		var s = 1 / sqrt(1.0 - dt * dt);    // 1.0f / sin(angle)
		var w1 = sin(angle * (1.0 - t)) * s;
		var w2 = sin(angle * t) * s;
		var result = self.Scale(w1).Add(q2.Scale(w2));
		return result;
		}
		else
		{
		// if the angle is small, use linear interpolation
		return self.Nlerp(q2, t);
		}	
	}
	
    //Returns the Magnitude of the quaternion
    static Magnitude = function() {
		gml_pragma("forceinline");
        return sqrt(self.x * self.x + self.y * self.y + self.z * self.z + self.w * self.w);
    }

    //Returns the Squared Magnitude of the quaternion
    static MagnitudeSquared = function() {
		gml_pragma("forceinline");
        return self.x * self.x + self.y * self.y + self.z * self.z + self.w * self.w;
    }
	
    //Returns the Inverse of quaternion
    static Inverse = function() {
		gml_pragma("forceinline");
        var lengthSq = self.MagnitudeSquared();
        if (lengthSq != 0.0)
        {
            var i = 1.0 / lengthSq;
			return new quat(self.x * -i, self.y * -i, self.z * -i, self.w * i);
        }
        return self;
    }

	//Returns the Conjugate of the quaternion
	static Conjugate = function() {
		gml_pragma("forceinline");
		return new quat(-self.x, -self.y, -self.z, self.w);
	}
  
	//Returns a quaternion generated from a specified forward and upward vector
	static FromLookRotation = function(forward_vec, up_vec) {
		gml_pragma("forceinline");
		var forward = forward_vec.Normalize();
        var right = up_vec.Cross(forward).Normalize();
        var up = forward.Cross(right);
        var m00 = right.x;
        var m01 = right.y;
        var m02 = right.z;
        var m10 = up.x;
        var m11 = up.y;
        var m12 = up.z;
        var m20 = forward.x;
        var m21 = forward.y;
        var m22 = forward.z;
		
        var num8 = (m00 + m11) + m22;
        var quaternion = new quat();
        if (num8 > 0)
        {
            var num = sqrt(num8 + 1);
            quaternion.w = num * 0.5;
            num = 0.5 / num;
            quaternion.x = (m12 - m21) * num;
            quaternion.y = (m20 - m02) * num;
            quaternion.z = (m01 - m10) * num;
            return quaternion;
        }
        if ((m00 >= m11) && (m00 >= m22))
        {
            var num7 = sqrt(((1 + m00) - m11) - m22);
            var num4 = 0.5 / num7;
            quaternion.x = 0.5 * num7;
            quaternion.y = (m01 + m10) * num4;
            quaternion.z = (m02 + m20) * num4;
            quaternion.w = (m12 - m21) * num4;
            return quaternion;
        }
        if (m11 > m22)
        {
            var num6 = sqrt(((1 + m11) - m00) - m22);
            var num3 = 0.5 / num6;
            quaternion.x = (m10 + m01) * num3;
            quaternion.y = 0.5 * num6;
            quaternion.z = (m21 + m12) * num3;
            quaternion.w = (m20 - m02) * num3;
            return quaternion;
        }
        var num5 = sqrt(((1 + m22) - m00) - m11);
        var num2 = 0.5 / num5;
        quaternion.x = (m20 + m02) * num2;
        quaternion.y = (m21 + m12) * num2;
        quaternion.z = 0.5 * num5;
        quaternion.w = (m01 - m10) * num2;
        return quaternion;
		
	}

    //Returns a quaternion which rotates from one vector to another vector
    static FromToRotation = function(from_vec, to_vec, up_vec) {
		gml_pragma("forceinline");
		var qa = new quat().FromLookRotation(from_vec, up_vec);
		var qb = new quat().FromLookRotation(to_vec, up_vec);
		var t = 100000000;
        return qa.RotateTowards(qb, t);
    }

	//Returns the quaternion lerped toward another by the provided amount
	static Lerp = function (q, t) {
		gml_pragma("forceinline");
		// negate second quat if dot product is negative
		var l2 = self.Dot(q);
		var _q = val;
		if(l2 < 0.0) {
		_q = _q.Negate();
		}
		var c = new quat();
		// c = a + t(b - a)  -->   c = a - t(a - b)
		// the latter is slightly better on x64
		c.x = self.x - t*(self.x - _q.x);
		c.y = self.y - t*(self.y - _q.y);
		c.z = self.z - t*(self.z - _q.z);
		c.w = self.w - t*(self.w - _q.w);
		return c;
	}
	
	//Returns the quaternion scaled up by the provided value
	static Scale = function(val) {
		gml_pragma("forceinline");
		return new quat(self.x * val, self.y * val, self.z * val, self.w * val);	
	}
	
	//Returns the quaternion multiplied with another
	static Mul = function(q) {
		gml_pragma("forceinline");
		var qx =  self.x * q.w + self.y * q.z - self.z * q.y + self.w * q.x;
		var qy = -self.x * q.z + self.y * q.w + self.z * q.x + self.w * q.y;
		var qz =  self.x * q.y - self.y * q.x + self.z * q.w + self.w * q.z;
		var qw = -self.x * q.x - self.y * q.y - self.z * q.z + self.w * q.w;
		return new quat(qx, qy, qz, qw);
	}

	//Returns the sum of the quaternion and another
	static Add = function(q) {
		gml_pragma("forceinline");
		return new quat(self.x + q.x, self.y + q.y, self.z + q.z, self.w + q.w);
	}
	
	//Returns the difference of the quaternion and another
	static Sub = function(q) {
		gml_pragma("forceinline");
		return new quat(self.x - q.x, self.y - q.y, self.z - q.z, self.w - q.w);
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

	//Returns a quaternion normalized and lerped toward another by the provided amount
	static Nlerp = function(val, t) {
		gml_pragma("forceinline");
		var lq = self.Lerp(val, t);
		lq = lq.Normalize();
		return lq;
	}
	
	//Returns a vector rotated by the quaternion
	static TransformVec3 = function(vec) {
		gml_pragma("forceinline");
		var result = vec;
		result.x = self.w*self.w*vec.x + 2*self.y*self.w*vec.z - 2*self.z*self.w*vec.y + self.x*self.x*vec.x + 2*self.y*self.x*vec.y + 2*self.z*self.x*vec.z - self.z*self.z*vec.x - self.y*self.y*vec.x;
		result.y = 2*self.x*self.y*vec.x + self.y*self.y*vec.y + 2*self.z*self.y*vec.z + 2*self.w*self.z*vec.x - self.z*self.z*vec.y + self.w*self.w*vec.y - 2*self.x*self.w*vec.z - self.x*self.x*vec.y;
		result.z = 2*self.x*self.z*vec.x + 2*self.y*self.z*vec.y + self.z*self.z*vec.z - 2*self.w*self.y*vec.x - self.y*self.y*vec.z + 2*self.w*self.x*vec.y - self.x*self.x*vec.z + self.w*self.w*vec.z;
		return result;
	
	}
		
	//Returns the Concatenate of the quaternion and another
	static Concat = function(q) {
	gml_pragma("forceinline");
	var result = new quat();

	// Concatenate rotation is actually q2 * q1 instead of q1 * q2.
	// So that's why value2 goes q1 and value1 goes q2.
	var q1x = q.X;
	var q1y = q.Y;
	var q1z = q.Z;
	var q1w = q.W;

	var q2x = self.X;
	var q2y = self.Y;
	var q2z = self.Z;
	var q2w = self.W;

	// cross(av, bv)
	var cx = q1y * q2z - q1z * q2y;
	var cy = q1z * q2x - q1x * q2z;
	var cz = q1x * q2y - q1y * q2x;

	var dot = q1x * q2x + q1y * q2y + q1z * q2z;

	result.x = q1x * q2w + q2x * q1w + cx;
	result.y = q1y * q2w + q2y * q1w + cy;
	result.z = q1z * q2w + q2z * q1w + cz;
	result.w = q1w * q2w - dot;

	return result;
	}

	//Returns the quaternion, position, and scale as a matrix array
	static AsMatrix = function(pos_vec, scale_vec = new vec3(1, 1, 1)) {
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
	    var acceleration = quat_dif.Scale(stiffness).Sub(vel.Mul(damping));
	    vel = vel.Add(acceleration.Scale(t));
	    q = vel.Scale(t).Add(new quat(0, 0, 0, 1)).Mul(q);
	    q = q.Normalize();
		return [q, vel, quat_dif, acceleration];
	}
	
}
