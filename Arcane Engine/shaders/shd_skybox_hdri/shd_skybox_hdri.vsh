  attribute vec3 in_Position;
    varying vec3 XYZ;
    void main(){
        gl_Position = vec4( in_Position, 1.0);
        XYZ = (vec4(in_Position.xy / vec2(gm_Matrices[MATRIX_PROJECTION][0][0],gm_Matrices[MATRIX_PROJECTION][1][1]), 1.0,0.0) * gm_Matrices[MATRIX_VIEW]).xyz;
    }