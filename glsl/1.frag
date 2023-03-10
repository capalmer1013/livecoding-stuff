uniform float time;
uniform vec2 resolution;

void main( void ) {

    vec2 uv = ( gl_FragCoord.xy / resolution.xy );
    uv *= 2.5;
    
    
    float f = 5.;
    for (int i = 0; i < 3; i++) {
        float d = distance(uv.x, uv.y);
        uv.x = mix(uv.x + tan(uv.x*d) - cos(time-uv.x*d), cos(d/uv.x-fract(time/10.)), .5);
        uv.y = mix(uv.y + tan(uv.y*d) - sin(time-uv.y*d), sin(d/uv.y+fract(time/10.)), .5);
        f = min(dot(f, d), f) ;
    }
    
    vec3 color = vec3(f, f*2.0, f*3.0);   

    gl_FragColor = vec4(color, 1.0 );

}