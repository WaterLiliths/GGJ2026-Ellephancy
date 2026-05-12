shader_type canvas_item;

// Leemos las variables globales que configuramos
global uniform vec2 player_position;
global uniform float radio_onda;

// Varying para pasar la posición del mundo del Vertex al Fragment
varying vec2 world_position;

void vertex() {
    // Calculamos la posición exacta de este vértice en el mundo 2D
    world_position = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
}

void fragment() {
    // Obtenemos el color y textura original de la runa
    vec4 tex_color = texture(TEXTURE, UV);
    
    // Calculamos la distancia entre el pixel de la runa y el centro de la onda
    float dist = distance(world_position, player_position);
    
    // step(a, b) devuelve 0.0 si b < a, y 1.0 si b >= a.
    // Invertimos para que los pixeles DENTRO del radio tengan alpha 1.0
    float alpha_mask = 1.0 - step(radio_onda, dist);
    
    // Opcional: Si quieres que el borde de revelado sea un poco difuminado en lugar de un corte duro, 
    // puedes cambiar la línea anterior por esta:
    // float alpha_mask = 1.0 - smoothstep(radio_onda - 20.0, radio_onda, dist);
    
    COLOR = tex_color;
    COLOR.a *= alpha_mask; // Aplicamos la máscara
}