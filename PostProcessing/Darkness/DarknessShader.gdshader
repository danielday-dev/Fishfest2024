shader_type spatial;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform sampler2D depth_texture : source_color, hint_depth_texture, repeat_disable, filter_nearest;

uniform float darknessStart = 5.0;
uniform float darknessDistance = 10.0;
uniform float darknessAngleFactor = 7.5;
uniform sampler2D darknessTexture : filter_linear, repeat_enable;

void fragment() {
	// Get depth.
	float depth = texture(depth_texture, SCREEN_UV).x;
  	vec3 ndc = vec3(SCREEN_UV * 2.0 - 1.0, depth);
	vec4 view = INV_PROJECTION_MATRIX * vec4(ndc, 1.0);
  	view.xyz /= view.w;
	
	vec2 centerChange = vec2(0.5f - SCREEN_UV.x, 0.5f - SCREEN_UV.y) * 2.0f;
	float centerDist =  sqrt((centerChange.x * centerChange.x) + (centerChange.y * centerChange.y));
  	float linearDepth = (-view.z) + (centerDist * darknessAngleFactor);
	
	// Put depth into range 0.0 - 1.0 with basis on darkness start and distance.
	float darkDepth = clamp(linearDepth - darknessStart, 0.0, darknessDistance) / darknessDistance;
	float darknessFactor = 1.0 - darkDepth;
	
	// Blend screen and darkness texture based on darkness.
	vec4 screenColor = textureLod(screen_texture, SCREEN_UV, 0.0);
	vec4 darknessColor = textureLod(darknessTexture, SCREEN_UV, 0.0);
    ALBEDO = mix(darknessColor.rgb, mix(screenColor.rgb, darknessColor.rgb, 0), darknessFactor);
}
