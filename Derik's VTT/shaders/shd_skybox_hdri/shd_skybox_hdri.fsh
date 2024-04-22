    varying vec3 XYZ;
    void main(){
       vec2 UV = 0.5 + vec2( ( atan( XYZ.x, -XYZ.y ) ) * 0.15915494309, (- asin( XYZ.z/length(XYZ) ) ) * 0.31830988618 );
        gl_FragColor = texture2D( gm_BaseTexture, UV );
    }