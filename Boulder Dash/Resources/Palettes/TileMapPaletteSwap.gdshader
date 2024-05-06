shader_type canvas_item;

uniform sampler2D palette;
uniform bool use_palette_alpha = false;
uniform int tile1 = 0;
uniform int tile2 = 0;
uniform int tile3 = 0;
uniform int tile4 = 0;
uniform int tile5 = 0;

void fragment() { //loops through each pixel in the image
	int deviderCount = 1;
	int palette_choice[] = {tile1, tile2, tile3, tile4, tile5};
	int yDeviderPos[5] = int[5];
	yDeviderPos[0] = 0;
	
	
	vec4 original_color = texture(TEXTURE, UV); //color of the pixal at the position of UV in the original texture (0-1)
	ivec3 colori = ivec3(round(original_color.rgb * 255.0)); //original_color in rgb format (0-255)
	
	ivec2 color_count = textureSize(palette, 0); //width of palette image, which also is the amount of colors for each palette
	for (int i = 2; i < color_count.y; i++)
	{
		if (ivec3(round(texture(palette, vec2(0, float(i) / float(color_count.y-1))).rgb * 255.0)) == ivec3(255, 0, 0))
		{
			yDeviderPos[deviderCount] = i+1;
			deviderCount++;
		}
	}
	
	for(int j = 0; j < deviderCount; j++)
	{
		float idx = -1.0; //position in the palette row (start value is oob since it have not found any of the original colors in the first palette row)
		for (int i = 0; i < color_count.x; i++) //loops through each color in the first palette row
		{
			vec3 color2 = texture(palette, vec2(float(i) / float(color_count.x - 1), float(yDeviderPos[j]) / float(color_count.y-1))).rgb; //texture read of palette color, stores rgb (0-1)
			ivec3 colori2 = ivec3(round(color2 * 255.0)); //converts color2's rgb values to 0-255
			
			if (colori == colori2) //checks if it can find and of the original textures colors in the palette
			{
				idx = float(i);
				break;
			}
		}
		
		if (idx >= 0.0) //if it has found any of the original colors in the first palette row
		{
			vec2 uv; //position of the color in palettes png
			uv.x = idx / float(color_count.x - 1); //x pos of color in palette row (0-1)
			uv.y = float(yDeviderPos[j]+palette_choice[j])/float(color_count.y-1); //y pos of palette row (0-1)
			//uv.y = (mod(TIME * fps, max(float(color_count.y - 1 - int(skip_first_row)), 1.0)) + float(skip_first_row))  / float(color_count.y - 1);
			
			vec4 palette_color = texture(palette, uv); //the palette color corresponding to the original texture palette
			COLOR = vec4(palette_color.rgb, mix(original_color.a, palette_color.a, float(use_palette_alpha))); //sets the current pixel to the new color
			
			float grey = .21 * COLOR.r + .71 * COLOR.g + .07 * COLOR.b;
			COLOR.rgb = palette_color.rgb;
		} 
		else //the ob0 remains as the original color
		{
			//COLOR = original_color;
		}
	}
}