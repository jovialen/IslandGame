shader_type spatial;

uniform vec3 albedo : source_color;
uniform vec3 albedo2 : source_color;
uniform float metallic : hint_range(0, 1) = 0;
uniform float roughness : hint_range(0, 1) = 0.02;
uniform sampler2D textureNormal;
uniform sampler2D textureNormal2;

uniform float waveSpeed : hint_range(0.01, 1.0, 0.01) = 0.01;
uniform vec2 waveDirection = vec2(2.0, 0.0);
uniform vec2 waveDirection2 = vec2(0.0, 1.0);
uniform float waveSize = 1.0;

varying vec3 worldPosition;

void vertex() {
	worldPosition = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
}

float fresnel(float amount, vec3 normal, vec3 view) {
	return pow((1.0 - clamp(dot(normalize(normal), normalize(view)), 0.0, 1.0)), amount);
}

void fragment() {
	vec3 normal = texture(textureNormal, worldPosition.xz * (1.0 / waveSize) + waveDirection * waveSpeed * TIME).rgb;
	vec3 normal2 = texture(textureNormal2, worldPosition.xz * (1.0 / waveSize) + waveDirection2 * waveSpeed * TIME).rgb;
	vec3 mixNormal = mix(normal, normal2, 0.5);
	
	float fresnel = fresnel(3.0, NORMAL, VIEW);
	vec3 surfaceColor = mix(albedo, albedo2, fresnel);
	
	ALBEDO = surfaceColor;
	METALLIC = metallic;
	ROUGHNESS = roughness;
	NORMAL_MAP = mixNormal;
}
