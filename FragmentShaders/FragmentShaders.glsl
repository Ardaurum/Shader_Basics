//Change to one of the method names
#define RUN RotatingDonut

//Definitions of two colors
#define COLOR_ONE vec4(0, 0.1, 0.4, 1)
#define COLOR_TWO vec4(0.4, 0.2, 0, 1)

//UVs calculated from normalized position on screen
#define UV (gl_FragCoord.xy / iResolution.xy)
#define UVH ((gl_FragCoord.xy / iResolution.xy) - 0.5)

//Mathematical formula for ellipse => x^2 / a^2 + y^2 / b^2 = 1.0
// x -> position on x axis
// y -> position on y axis
// a -> size in x axis
// b -> size in y axis
#define ELLIPSE(uv, size) (uv.x * uv.x) / (size.x * size.x) + (uv.y * uv.y) / (size.y * size.y)

//Basic one color
vec4 OneColor()
{
    return COLOR_ONE;
}

//Two colors divided in the middle
vec4 Divided()
{
    return mix(COLOR_ONE, COLOR_TWO, step(0.5, UV.x));
}

//Simple circle
vec4 Circle()
{
    float size = 0.5;
    
    float circle = step(size, length(UVH));
    return mix(COLOR_ONE, COLOR_TWO, circle);
}

//Circle inside a circle
vec4 Donut()
{
    vec2 uvh = UVH;
    float innerSize = 0.2;
    float externalSize = 0.4;
    
    float innerCircle = step(innerSize, length(uvh));
    float externalCircle = (1.0 - step(externalSize, length(uvh)));
    return mix(COLOR_ONE, COLOR_TWO, innerCircle * externalCircle);
}

//Ellipse
vec4 Ellipse()
{
    vec2 uvh = UVH;
    vec2 size = vec2(0.4, 0.2);
    
    float ellipse = step(1.0, ELLIPSE(uvh, size));
    return mix(COLOR_ONE, COLOR_TWO, ellipse);
}

//Scaled ellipse creating a rotating circle
vec4 RotatingCircle()
{
    vec2 uvh = UVH;
    float circleSize = 0.4;
    
    vec2 size = vec2(circleSize * sin(iTime), circleSize);
    float ellipse = step(1.0, ELLIPSE(uvh, size));
    return mix(COLOR_ONE, COLOR_TWO, ellipse);
}

//Two scaled ellipses creating a rotating (flat) donut
vec4 RotatingFlatDonut()
{
    vec2 uvh = UVH;
    float innerCircle = 0.2;
    float externalCircle = 0.4;

    vec2 innerSize = vec2(innerCircle * sin(iTime), innerCircle);
    vec2 externalSize = vec2(externalCircle * sin(iTime), externalCircle);
    float innerEllipse = step(1.0, ELLIPSE(uvh, innerSize));
    float externalEllipse = (1.0 - step(1.0, ELLIPSE(uvh, externalSize)));
    return mix(COLOR_ONE, COLOR_TWO, innerEllipse * externalEllipse);
}

//Two scaled ellipses with some mappings to create a volume
//Also added some fake lighting
vec4 RotatingDonut()
{
    vec2 uvh = UVH;
    float innerCircle = 0.2;
    float externalCircle = 0.4;
    float innerDisappearTime = 0.3;
    float externalMinRange = 0.4;
    float darkestColor = 0.4;

    vec2 innerSize = vec2(innerCircle * max((abs(sin(iTime)) - innerDisappearTime), .0), innerCircle);
    vec2 externalSize = vec2(externalCircle * (abs(sin(iTime)) * (1.0 - externalMinRange) + externalMinRange), externalCircle);
    float innerEllipse = step(1.0, ELLIPSE(uvh, innerSize));
    float externalEllipse = (1.0 - step(1.0, ELLIPSE(uvh, externalSize)));

    vec4 colorTwo = COLOR_TWO;
    colorTwo.rgb *= (1.0 - length(uvh)) * max(abs(sin(iTime)), darkestColor);
    return mix(COLOR_ONE, colorTwo, innerEllipse * externalEllipse);
}

//Main entry point
void main()
{
    gl_FragColor = RUN();
}