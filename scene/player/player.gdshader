shader_type canvas_item;

// 基础纹理
uniform sampler2D base_texture;

// 生成法线贴图
vec3 generate_normal(vec2 uv) {
    // 获取周围像素的颜色
    float center = texture(base_texture, uv).r;
    float right = texture(base_texture, uv + vec2(1.0 / textureSize(base_texture, 0.0f).x, 0.0)).r;
    float bottom = texture(base_texture, uv + vec2(0.0f, 1.0f / textureSize(base_texture, 0.0f).y)).r;

    // 计算法线
    vec3 normal;
    normal.x = (center - right) * 2.0; // X 方向梯度
    normal.y = (center - bottom) * 2.0; // Y 方向梯度
    normal.z = sqrt(1.0 - normal.x * normal.x - normal.y * normal.y); // Z 方向

    return normalize(normal);
}

void fragment() {
    // 生成法线
    vec3 normal = generate_normal(UV);

    // 将法线从 [-1, 1] 映射到 [0, 1] 范围
    normal = normal * 0.5 + 0.5;

    // 输出法线贴图
    COLOR = vec4(normal, 1.0);
}