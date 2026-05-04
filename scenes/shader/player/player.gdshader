shader_type canvas_item;

// Esto crea un control en el Inspector para cambiar el color del gato
uniform vec4 color_tinte : source_color = vec4(1.0);

void fragment() {
    vec4 color = texture(TEXTURE, UV);
    // Esto hace que los colores más claros brillen un poco más
    COLOR = color + (color * 0.2); 
}