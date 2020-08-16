shader_type spatial; 
render_mode skip_vertex_transform, diffuse_lambert_wrap, ambient_light_disabled;

//Albedo texture 
uniform sampler2D albedoTex : hint_albedo;
uniform vec2 uv_scale = vec2(1.0, 1.0);
uniform vec2 uv_offset = vec2(.0, .0);
uniform float cull_distance = 5;

//Geometric resolution for vert snap
uniform float snapRes = 15.0; 

//vec4 for UV recalculation 
varying vec4 vertCoord;

void vertex() {
    UV = UV * uv_scale + uv_offset;
	
	float vertex_distance = length((MODELVIEW_MATRIX * vec4(VERTEX, 1.0)));
	
	VERTEX = (MODELVIEW_MATRIX * vec4(VERTEX, 1.0)).xyz;
	VERTEX.xyz = floor(VERTEX.xyz * snapRes) / snapRes;
	vertCoord = vec4(UV * VERTEX.z, VERTEX.z, 0);
	
	if (vertex_distance > cull_distance)
		VERTEX = vec3(.0);
} 
 
void fragment() {
	ALBEDO = texture(albedoTex, vertCoord.xy / vertCoord.z).rgb;
}
